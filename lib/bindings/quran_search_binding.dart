import 'package:get/get.dart';

import '../controllers/quran_search_controller.dart';

class QuranSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<QuranSearchController>(
      () => QuranSearchController(),
    );
  }
}
