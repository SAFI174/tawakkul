import 'package:get/get.dart';

import '../controllers/qibla_page_controller.dart';

class QiblaPageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QiblaController>(
      () => QiblaController(),
    );
  }
}
