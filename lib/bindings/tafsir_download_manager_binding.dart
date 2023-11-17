import 'package:get/get.dart';
import '../controllers/tafsir_download_manager_controller.dart';

class TafsirDownloadManagerBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TafsirDownloadManagerController>(TafsirDownloadManagerController(),
        permanent: true);
  }
}
