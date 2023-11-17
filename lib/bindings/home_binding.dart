import 'package:get/get.dart';

import '../controllers/home_controller.dart';
import '../controllers/main_controller.dart';
import '../controllers/more_activities_controller.dart';
import '../controllers/quran_main_dashborad_controller.dart';

class HomeBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HomeController>(
      () => HomeController(),
    );
    Get.lazyPut<QuranMainDashboradController>(
      () => QuranMainDashboradController(),
    );
    Get.lazyPut<MainController>(
      () => MainController(),
    );
    Get.lazyPut<MoreActivitiesController>(
      () => MoreActivitiesController(),
    );
  }
}
