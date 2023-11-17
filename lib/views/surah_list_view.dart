import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;

import '../../../routes/app_pages.dart';
import '../Widgets/surah_item.dart';
import '../controllers/quran_reading_controller.dart';

class SurahListView extends GetView {
  const SurahListView({Key? key, this.searchText = ''}) : super(key: key);

  final String searchText;

  @override
  Widget build(BuildContext context) {
    final surahNumbers = List.generate(114, (index) => index + 1)
        .where((surahNumber) =>
            quran.getSurahNameArabicSimple(surahNumber).contains(searchText))
        .toList();
    return ListView.builder(
      itemCount: surahNumbers.length,
      itemExtent: 70,
      itemBuilder: (BuildContext context, int index) {
        final surahNumber = surahNumbers[index];
        return Column(
          children: [
            buildSurahItem(context, surahNumber),
            const Divider(height: 1)
          ],
        );
      },
    );
  }

  Widget buildSurahItem(BuildContext context, int surahNumber) {
    return SurahItem(
      surahNumber: surahNumber,
      onTap: () async {
        try {
          final quranPageViewController = Get.find<QuranReadingController>();
          if (!Get.currentRoute.contains('quran-view')) {
            Get.toNamed(
              Routes.QURAN_VIEW,
              parameters: {
                'surahNumber': surahNumber.toString(),
                'invokedFrom': 'surah',
              },
            );
            quranPageViewController.initPageViewData();
          }
        } catch (e) {
          Get.toNamed(
            Routes.QURAN_VIEW,
            parameters: {
              'surahNumber': surahNumber.toString(),
              'invokedFrom': 'surah',
            },
          );
        }
      },
    );
  }
}
