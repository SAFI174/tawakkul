import 'package:get/get.dart';

import '../controllers/quran_settings_controller.dart';

class QuranSettingsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranSettingsController>(
      () => QuranSettingsController(),
    );
  }
}
