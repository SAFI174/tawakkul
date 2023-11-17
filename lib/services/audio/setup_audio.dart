import 'package:audio_service/audio_service.dart';
import 'package:get/get.dart';
import '../../data/repository/segmets_repository.dart';

import 'audio_manager.dart';
import 'package:get_it/get_it.dart';

GetIt getIt = GetIt.instance;

Future<void> setupAudioPlayer() async {
  try {
    getIt<AudioPlayerHandlerImpl>();
  } catch (e) {
    getIt.registerLazySingleton<AudioPlayerHandlerImpl>(
        () => AudioPlayerHandlerImpl());
    // services
    getIt.registerSingleton<AudioHandler>(await initAudioService());
    Get.lazyPut(() => SegmentsRepository());
  }
}

Future<AudioHandler> initAudioService() async {
  return await AudioService.init(
    builder: () {
      return getIt<AudioPlayerHandlerImpl>();
    },
    config: const AudioServiceConfig(
      androidNotificationChannelId: 'com.tawakkal.audio',
      androidNotificationChannelName: 'Tawakkal Audio Service',
      androidNotificationOngoing: true,
      androidStopForegroundOnPause: true,
    ),
  );
}
