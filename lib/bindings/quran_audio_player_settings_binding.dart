import 'package:get/get.dart';

import '../controllers/quran_audio_player_settings_controller.dart';

class QuranAudioPlayerSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranAudioSettingsController>(
      () => QuranAudioSettingsController(),
    );
  }
}
