import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawakkal/data/models/quran_navigation_data_model.dart';

import '../data/cache/quran_settings_cache.dart';
import '../../../../routes/app_pages.dart';
import '../../Views/quran_bookmarks_view.dart';

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
    Get.toNamed(
      Routes.QURAN_READING_PAGE,
      arguments: QuranNavigationArgumentModel(
        surahNumber: 0,
        pageNumber:  QuranSettingsCache.getLastPage(),
        verseNumber: 0,
        highlightVerse: false,
      ),
    );
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
}
