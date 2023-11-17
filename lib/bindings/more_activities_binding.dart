import 'package:get/get.dart';

import '../controllers/more_activities_controller.dart';
class MoreActivitiesBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MoreActivitiesController>(
      () => MoreActivitiesController(),
    );
  }
}
