import 'dart:async';

import 'package:audio_service/audio_service.dart';
import 'package:audio_session/audio_session.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart';
import 'package:rxdart/rxdart.dart' as rx;
import 'package:tawakkal/data/cache/quran_settings_cache.dart';
import '../../controllers/quran_reading_controller.dart';
import '../../data/cache/audio_settings_cache.dart';
import '../../data/repository/segmets_repository.dart';

class QueueState {
  static const QueueState empty =
      QueueState([], 0, [], AudioServiceRepeatMode.none);

  final List<MediaItem> queue;
  final int? queueIndex;
  final List<int>? shuffleIndices;
  final AudioServiceRepeatMode repeatMode;

  const QueueState(
      this.queue, this.queueIndex, this.shuffleIndices, this.repeatMode);

  bool get hasPrevious =>
      repeatMode != AudioServiceRepeatMode.none || (queueIndex ?? 0) > 0;
  bool get hasNext =>
      repeatMode != AudioServiceRepeatMode.none ||
      (queueIndex ?? 0) + 1 < queue.length;

  List<int> get indices =>
      shuffleIndices ?? List.generate(queue.length, (i) => i);
}

class AudioPlayerHandlerImpl extends BaseAudioHandler {
  // ignore: close_sinks

  final _player = AudioPlayer();
  final _playlist = ConcatenatingAudioSource(children: []);
  StreamSubscription<Duration>? positionStream;
  StreamSubscription<int?>? indexStream;
  bool isWordByWord = false;
  final _mediaItemExpando = Expando<MediaItem>();

  /// A stream of the current effective sequence from just_audio.
  Stream<List<IndexedAudioSource>> get _effectiveSequence =>
      rx.Rx.combineLatest3<List<IndexedAudioSource>?, List<int>?, bool,
              List<IndexedAudioSource>?>(_player.sequenceStream,
          _player.shuffleIndicesStream, _player.shuffleModeEnabledStream,
          (sequence, shuffleIndices, shuffleModeEnabled) {
        if (sequence == null) return [];
        if (!shuffleModeEnabled) return sequence;
        if (shuffleIndices == null) return null;
        if (shuffleIndices.length != sequence.length) return null;
        return shuffleIndices.map((i) => sequence[i]).toList();
      }).whereType<List<IndexedAudioSource>>();

  /// Computes the effective queue index taking shuffle mode into account.
  int? getQueueIndex(
      int? currentIndex, bool shuffleModeEnabled, List<int>? shuffleIndices) {
    final effectiveIndices = _player.effectiveIndices ?? [];
    final shuffleIndicesInv = List.filled(effectiveIndices.length, 0);
    for (var i = 0; i < effectiveIndices.length; i++) {
      shuffleIndicesInv[effectiveIndices[i]] = i;
    }
    return (shuffleModeEnabled &&
            ((currentIndex ?? 0) < shuffleIndicesInv.length))
        ? shuffleIndicesInv[currentIndex ?? 0]
        : currentIndex;
  }

  @override
  Future<void> onTaskRemoved() => _player.stop();

  Future<void> clearQueueitems() async {
    await _playlist.clear();
  }

  /// A stream reporting the combined state of the current queue and the current
  /// media item within that queue.
  Stream<QueueState> get queueState => rx.Rx.combineLatest3<List<MediaItem>,
          PlaybackState, List<int>, QueueState>(
      queue,
      playbackState,
      _player.shuffleIndicesStream.whereType<List<int>>(),
      (queue, playbackState, shuffleIndices) => QueueState(
            queue,
            playbackState.queueIndex,
            playbackState.shuffleMode == AudioServiceShuffleMode.all
                ? shuffleIndices
                : null,
            playbackState.repeatMode,
          )).where((state) =>
      state.shuffleIndices == null ||
      state.queue.length == state.shuffleIndices!.length);

  @override
  Future<void> setSpeed(double speed) async {
    await _player.setSpeed(speed);
  }

// Highlight the current word and verse based on the player's position
  void _highlightWordAndVerse() {
    final controller = Get.find<QuranReadingController>();

    // Scroll to the current playing page
    _scrollToPlayingPage(controller);
    if (isWordByWord) {
      // Load Quran data from the asset
      SegmentsRepository.readSegmentData();

      // Listen to the player's position and highlight the corresponding word
      positionStream = _player.positionStream.listen((duration) async {
        // Skip highlighting under certain conditions
        if (_shouldSkipHighlightingAndScrolling()) return;

        final currentIndex = _player.currentIndex ?? 1;
        final currentVerseID = queue.value[currentIndex].extras!['verse'];
        final currentSurahID = queue.value[currentIndex].extras!['surah'];

        // Get the word index based on the player's current position
        final wordIndex = await SegmentsRepository.getCurrentSegmentWord(
          surahId: currentSurahID,
          verseID: currentVerseID,
          currentPosition: duration.inMilliseconds,
        );
        // Highlight the word
        controller.highlightWordAudioHandler(
          surahNumber: currentSurahID,
          verseNumber: currentVerseID,
          wordIndex: wordIndex,
        );
      });
    }
  }

// Scroll to the page corresponding to the currently playing verse
  void _scrollToPlayingPage(QuranReadingController controller) {
    indexStream = _player.currentIndexStream.listen((currentIndex) async {
      if (!_player.playing) {
        return;
      }
      final currentVerseID = queue.value[currentIndex!].extras!['verse'];
      final currentSurahID = queue.value[currentIndex].extras!['surah'];

      // Get the page number corresponding to the current playing verse
      final pageNumber = getPageNumber(currentSurahID, currentVerseID);
      if (!isWordByWord) {
        controller.highlightVerseAudioHandler(
            surahNumber: currentSurahID, verseNumber: currentVerseID);
      }
      // Scroll to the page
      if (pageNumber != controller.pageNumber) {
        await controller.quranPageController.animateToPage(
          pageNumber - 1,
          curve: Curves.easeOutCubic,
          duration: const Duration(milliseconds: 800),
        );
      }
    });
  }

// Check conditions to determine whether to skip highlighting
  bool _shouldSkipHighlightingAndScrolling() {
    return _player.currentIndex == null ||
        _player.currentIndex! >= queue.value.length ||
        !Get.currentRoute.contains('quran-reading');
  }

  AudioPlayerHandlerImpl() {
    _player.setAudioSource(_playlist);
    _init();
  }

  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());

    // Broadcast media item changes.
    rx.Rx.combineLatest4<int?, List<MediaItem>, bool, List<int>?, MediaItem?>(
        _player.currentIndexStream,
        queue,
        _player.shuffleModeEnabledStream,
        _player.shuffleIndicesStream,
        (index, queue, shuffleModeEnabled, shuffleIndices) {
      final queueIndex =
          getQueueIndex(index, shuffleModeEnabled, shuffleIndices);
      return (queueIndex != null && queueIndex < queue.length)
          ? queue[queueIndex]
          : null;
    }).whereType<MediaItem>().distinct().listen(mediaItem.add);
    // Propagate all events from the audio player to AudioService clients.
    _player.playbackEventStream.listen(_broadcastState);
    _player.shuffleModeEnabledStream
        .listen((enabled) => _broadcastState(_player.playbackEvent));
    // In this example, the service stops when reaching the end.
    _player.processingStateStream.listen((state) async {
      if (state == ProcessingState.completed) {
        stop();
        _player.seek(Duration.zero, index: 0);
      }
    });
    // Broadcast the current queue.
    _effectiveSequence
        .map((sequence) =>
            sequence.map((source) => _mediaItemExpando[source]!).toList())
        .pipe(queue);
    // Load the playlist.
    // _scrollToPlayingPage();
  }

  AudioSource _itemToSource(MediaItem mediaItem) {
    final UriAudioSource audioSource;
    if (mediaItem.extras?['source'] == 'local') {
      audioSource = AudioSource.file((mediaItem.id));
    } else {
      audioSource = AudioSource.uri(Uri.parse(mediaItem.id));
    }
    _mediaItemExpando[audioSource] = mediaItem;
    return audioSource;
  }

  List<AudioSource> _itemsToSources(List<MediaItem> mediaItems) {
    return mediaItems.map(_itemToSource).toList();
  }

  @override
  Future<void> addQueueItem(MediaItem mediaItem) async {
    await _playlist.add(_itemToSource(mediaItem));
  }

  @override
  Future<void> addQueueItems(List<MediaItem> mediaItems) async {
    if (_playlist.children.isNotEmpty) {
      await _playlist.clear();
    }
    final tempPlayList = _itemsToSources(mediaItems);
    for (var element in tempPlayList) {
      final repeatCount = AudioSettingsCache.getRepeat();

      for (var i = 0; i < repeatCount; i++) {
        await _playlist.add(element);
      }
    }
  }

  @override
  Future<void> insertQueueItem(int index, MediaItem mediaItem) async {
    await clearQueueitems();
    await _playlist.insert(index, _itemToSource(mediaItem));
  }

  @override
  Future<void> updateQueue(List<MediaItem> queue) async {
    await _playlist.addAll(_itemsToSources(queue));
  }

  @override
  Future<void> updateMediaItem(MediaItem mediaItem) async {
    final index = queue.value.indexWhere((item) => item.id == mediaItem.id);
    _mediaItemExpando[_player.sequence![index]] = mediaItem;
  }

  @override
  Future<void> removeQueueItem(MediaItem mediaItem) async {
    final index = queue.value.indexOf(mediaItem);
    await _playlist.removeAt(index);
  }

  Future<void> moveQueueItem(int currentIndex, int newIndex) async {
    await _playlist.move(currentIndex, newIndex);
  }

  @override
  Future<void> skipToNext() => _player.seekToNext();

  @override
  Future<void> skipToPrevious() => _player.seekToPrevious();

  @override
  Future<void> skipToQueueItem(int index) async {
    if (index < 0 || index >= _playlist.children.length) return;
    // This jumps to the beginning of the queue item at [index].
    _player.seek(Duration.zero,
        index: _player.shuffleModeEnabled
            ? _player.shuffleIndices![index]
            : index);
  }

  @override
  Future<void> play() async {
    positionStream?.cancel();
    _highlightWordAndVerse();

    await _player.play();
  }

  @override
  Future<void> pause() => _player.pause();

  @override
  Future<void> seek(Duration position) => _player.seek(position);

  @override
  Future<void> stop() async {
    positionStream?.cancel();
    indexStream?.cancel();
    await _player.stop();
    isWordByWord = QuranSettingsCache.isWordByWordListen();
    skipToQueueItem(0);
  }

  /// Broadcasts the current state to all clients.
  void _broadcastState(PlaybackEvent event) {
    final playing = _player.playing;
    final queueIndex = getQueueIndex(
        event.currentIndex, _player.shuffleModeEnabled, _player.shuffleIndices);
    playbackState.add(
      playbackState.value.copyWith(
        controls: [
          if (playing) MediaControl.pause else MediaControl.play,
          MediaControl.skipToPrevious,
          MediaControl.skipToNext,
        ],
        androidCompactActionIndices: const [0, 1, 2],
        processingState: const {
          ProcessingState.idle: AudioProcessingState.idle,
          ProcessingState.loading: AudioProcessingState.loading,
          ProcessingState.buffering: AudioProcessingState.buffering,
          ProcessingState.ready: AudioProcessingState.ready,
          ProcessingState.completed: AudioProcessingState.completed,
        }[_player.processingState]!,
        playing: playing,
        updatePosition: _player.position,
        bufferedPosition: _player.bufferedPosition,
        speed: _player.speed,
        queueIndex: queueIndex,
      ),
    );
  }
}
