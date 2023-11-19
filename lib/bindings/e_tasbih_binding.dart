import 'package:get/get.dart';
import 'package:tawakkal/controllers/e_tasbih_controller.dart';

class ElectronicTasbihBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ElectronicTasbihController>(
      () => ElectronicTasbihController(),
    );
  }
}
