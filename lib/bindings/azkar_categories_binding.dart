import 'package:get/get.dart';

import '../controllers/azkar_categories_controller.dart';

class AzkarCategoriesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AzkarCategoriesController>(
      () => AzkarCategoriesController(),
    );
  }
}
