import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../../../data/models/quran_reader.dart';
import '../../../../../data/repository/readers_repository.dart';
import '../../../../../services/audio/audio_manager.dart';
import '../../../../../services/audio/setup_audio.dart';
import '../data/cache/audio_settings_cache.dart';
import '../../data/repository/quran_audio_playlist_repository.dart';
import 'quran_reading_controller.dart';

class QuranAudioPlayerBottomBarController extends GetxController {
  AudioPlayerHandlerImpl? audioHandler;

  final isControlsVisible = false.obs;
  final QuranReadingController quranPageViewController = Get.find();
  final RxString selectedReader = ''.obs;
  var playbackSpeed = 1.0.obs;

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

  Future<void> onMainPlayPressed(
      {startSurah, startVerse, endSurah, endVerse}) async {
    var playRange = await AudioSettingsCache().getQuranPlayRange();
    final int startS = startSurah ?? playRange.startSurah;
    final int startV = startVerse ?? playRange.startVerse;
    final int endS = endSurah ?? playRange.endsSurah;
    final int endV = endVerse ?? playRange.endsVerse;
    final playerSpeed = await AudioSettingsCache().getSpeed();
    playbackSpeed.value = await AudioSettingsCache().getSpeed();
    await setupAudioPlayer();
    audioHandler = getIt<AudioPlayerHandlerImpl>();
    await audioHandler!.prepare();
    isControlsVisible.value = true;
    await audioHandler!.addQueueItems(
        await createPlaylistFromRange(startS, startV, endS, endV));
    await audioHandler!.setSpeed(playerSpeed);
    await audioHandler!.play();
  }

  void listenForReaderChanges() {
    GetStorage('audio_settings').listenKey(ReadersRepository.readerKey,
        (value) {
      selectedReader.value = (value as QuranReader).name;
    });
  }

  @override
  void onInit() async {
    super.onInit();
    selectedReader.value =
        (await ReadersRepository().getSelectedReaderFromCache()).name;
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
