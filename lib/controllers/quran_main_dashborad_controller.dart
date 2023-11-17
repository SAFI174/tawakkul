import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/cache/quran_settings.dart';
import '../../../../routes/app_pages.dart';
import '../../Views/quran_bookmarks_view.dart';
import 'quran_reading_controller.dart';

class QuranMainDashboradController extends GetxController
    with GetTickerProviderStateMixin {
  late RxString hintTextSearchBar = hintTexts.first.obs;
  late final TabController tabController;
  RxString surahSearchText = "".obs;
  RxString juzSearchText = "".obs;
  RxString hizbSearchText = "".obs;
  List<String> hintTexts = [
    'ابحث عن سورة',
    'ابحث عن جزء',
    'ابحث عن حزب',
  ];
  void updatehintText(int index) {
    hintTextSearchBar.value = hintTexts[index];
  }

  void onBookmarksPressed() async {
    Get.to(QuranBookmarksView());
  }

  void onLastPagePressed() async {
    try {
      final quranPageViewController = Get.find<QuranReadingController>();
      if (!Get.currentRoute.contains('quran-view')) {
        Get.toNamed(
          Routes.QURAN_VIEW,
          parameters: {
            'pageNumber': (await QuranSettingsCache().getLastPage()).toString(),
          },
        );
        quranPageViewController.initPageViewData();
      }
    } catch (e) {
      final pageIndex = await QuranSettingsCache().getLastPage();
      Get.toNamed(
        Routes.QURAN_VIEW,
        parameters: {
          'pageNumber': pageIndex.toString(),
        },
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 3, vsync: this, initialIndex: 0);
    tabController.addListener(() {
      updatehintText(tabController.index);
      surahSearchText.value = '';
      juzSearchText.value = '';
      hizbSearchText.value = '';
    });
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
