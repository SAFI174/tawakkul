import 'package:get/get.dart';

import '../controllers/azkar_details_controller.dart';

class AzkarDetailsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AzkarDetailsController>(
      () => AzkarDetailsController(),
    );
  }
}
