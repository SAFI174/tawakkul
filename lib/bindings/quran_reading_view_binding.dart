import 'package:get/get.dart';

import '../controllers/quran_audio_player_controller.dart';
import '../controllers/quran_reading_controller.dart';


class QuranReadingPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<QuranReadingController>(QuranReadingController(), permanent: true);
    Get.put<QuranAudioPlayerBottomBarController>(
        QuranAudioPlayerBottomBarController(),
        permanent: true);
  }
}
