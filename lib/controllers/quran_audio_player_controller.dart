import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tawakkal/handlers/reader_timing_data_download_handler.dart';

import '../../../../../data/models/quran_reader.dart';
import '../../../../../data/repository/readers_repository.dart';
import '../../../../../services/audio/audio_manager.dart';
import '../../../../../services/audio/setup_audio.dart';
import '../data/cache/audio_settings_cache.dart';
import '../../data/repository/quran_audio_playlist_repository.dart';
import 'quran_reading_controller.dart';

class QuranAudioPlayerBottomBarController extends GetxController {
  // Instance of the audio handler
  AudioPlayerHandlerImpl? audioHandler;

  // Observable to track visibility of controls
  final isControlsVisible = false.obs;

  // Instance of the QuranReadingController to interact with Quran reading view
  final QuranReadingController quranPageViewController = Get.find();

  // Observable to track the selected Quran reader
  final Rx<QuranReader> selectedReader = QuranReader().obs;

  // Observable to track playback speed
  var playbackSpeed = 1.0.obs;

  // Method to change playback speed
  void changeSpeed() async {
    final availableSpeeds = [0.5, 0.75, 1.0, 1.25, 1.5, 1.75];
    final currentSpeed = playbackSpeed.value;
    final currentIndex = availableSpeeds.indexOf(currentSpeed);

    // Cycle to the next speed or wrap back to the first speed
    final nextIndex = (currentIndex + 1) % availableSpeeds.length;
    final nextSpeed = availableSpeeds[nextIndex];

    playbackSpeed.value = nextSpeed;
    await audioHandler!.setSpeed(playbackSpeed.value);
  }

  // Method to handle the main play button press
  Future<void> onMainPlayPressed(
      {startSurah, startVerse, endSurah, endVerse}) async {
    // Check if timing data is available
    if (await checkIfTimingDataAvailable()) {
      // Retrieve the saved play range or use default values
      var playRange = await AudioSettingsCache().getQuranPlayRange();
      final int startS = startSurah ?? playRange.startSurah;
      final int startV = startVerse ?? playRange.startVerse;
      final int endS = endSurah ?? playRange.endsSurah;
      final int endV = endVerse ?? playRange.endsVerse;

      // Retrieve player speed settings
      final playerSpeed = await AudioSettingsCache().getSpeed();
      playbackSpeed.value = await AudioSettingsCache().getSpeed();

      // Setup and prepare the audio player
      await setupAudioPlayer();
      audioHandler = getIt<AudioPlayerHandlerImpl>();
      await audioHandler!.prepare();

      // Show controls
      isControlsVisible.value = true;

      // Add queue items and play
      await audioHandler!.addQueueItems(
          await createPlaylistFromRange(startS, startV, endS, endV));
      await audioHandler!.setSpeed(playerSpeed);
      await audioHandler!.play();
    }
  }

  // Method to check if timing data is available
  Future<bool> checkIfTimingDataAvailable() async {
    return await ReaderTimingDataDownloadHandler.checkIfDataExists(
        reader: selectedReader.value);
  }

  // Method to listen for changes in the selected Quran reader
  void listenForReaderChanges() {
    GetStorage('audio_settings').listenKey(ReadersRepository.readerKey,
        (value) {
      selectedReader.value = (value as QuranReader);
    });
  }

  @override
  void onInit() async {
    super.onInit();
    selectedReader.value =
        (await ReadersRepository().getSelectedReaderFromCache());

    // Start listening for changes in the selected reader
    listenForReaderChanges();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
