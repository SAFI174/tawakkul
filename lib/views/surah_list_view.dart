import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;
import 'package:tawakkal/data/models/quran_navigation_data_model.dart';
import 'package:tawakkal/utils/extension.dart';

import '../../../routes/app_pages.dart';
import '../Widgets/surah_item.dart';

class SurahListView extends GetView {
  const SurahListView({super.key, this.searchText = ''});

  final String searchText;

  @override
  Widget build(BuildContext context) {
    final surahNumbers = List.generate(114, (index) => index + 1)
        .where((surahNumber) =>
        surahNumber.getSurahNameArabicSimple.contains(searchText))
        .toList();
    return ListView.separated(
      padding: EdgeInsets.zero,
      itemCount: surahNumbers.length,
      separatorBuilder: (context, index) {
        return const Divider(height: 1);
      },
      itemBuilder: (BuildContext context, int index) {
        final surahNumber = surahNumbers[index];
        return buildSurahItem(context, surahNumber);
      },
    );
  }

  Widget buildSurahItem(BuildContext context, int surahNumber) {
    return SurahItem(
      surahNumber: surahNumber,
      onTap: () async {
        Get.toNamed(
          Routes.QURAN_READING_PAGE,
          arguments: QuranNavigationArgumentModel(
            surahNumber: surahNumber,
            pageNumber: quran.getPageNumber(surahNumber, 1),
            verseNumber: 1,
            highlightVerse: true,
          ),
        );
      },
    );
  }
}
