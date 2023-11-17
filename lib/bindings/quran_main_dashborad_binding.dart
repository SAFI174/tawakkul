import 'package:get/get.dart';
import '../controllers/quran_main_dashborad_controller.dart';

class QuranMainDashboradBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranMainDashboradController>(
      () => QuranMainDashboradController(),
    );
  }
}
