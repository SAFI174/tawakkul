import 'package:get/get.dart';

import '../controllers/quran_audio_download_manager_controller.dart';

class QuranAudioDownloadManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<QuranAudioDownloadManagerController>(
      QuranAudioDownloadManagerController(),
      permanent: true,
    );
  }
}
