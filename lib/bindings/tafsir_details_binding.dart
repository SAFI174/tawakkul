import 'package:get/get.dart';
import '../controllers/tafsir_details_controller.dart';

class TafsirDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<TafsirDetailsController>(
      TafsirDetailsController(),
      permanent: true,
    );
  }
}
