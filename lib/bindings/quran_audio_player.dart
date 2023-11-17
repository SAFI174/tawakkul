import 'package:get/get.dart';

import '../controllers/quran_audio_player_controller.dart';

class QuranAudioPlayerBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranAudioPlayerBottomBarController>(
      () => QuranAudioPlayerBottomBarController(),
    );
  }
}
