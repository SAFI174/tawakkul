import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';

import '../../../routes/app_pages.dart';
import '../Widgets/hizb_item.dart';
import '../data/models/quran_navigation_data_model.dart';

class HizbListView extends GetView {
  const HizbListView({Key? key, this.searchText = ''}) : super(key: key);
  final String searchText;
  @override
  Widget build(BuildContext context) {
    final hizbNumbers = List.generate(60, (index) => index + 1)
        .where((hizbNumber) => hizbNumber.toString().contains(searchText))
        .toList();
    return ListView.separated(
      itemCount: hizbNumbers.length,
      padding: EdgeInsets.zero,
      separatorBuilder: (context, index) {
        return const Divider(height: 1);
      },
      itemBuilder: (BuildContext context, int index) {
        final hizbNumber = hizbNumbers[index];
        return buildHizbItem(context, hizbNumber);
      },
    );
  }

  Widget buildHizbItem(BuildContext context, int hizbNumber) {
    final hizbData = getHizbData(hizbNumber);
    final pageNumber =
        getPageNumber(hizbData['surah']!.toInt(), hizbData['verse']!.toInt());
    return HizbItem(
      hizbNumber: hizbNumber,
      onTap: () async {
        Get.toNamed(
          Routes.QURAN_READING_PAGE,
          arguments: QuranNavigationArgumentModel(
            surahNumber: hizbData['surah']!.toInt(),
            pageNumber: pageNumber,
            verseNumber: hizbData['verse']!.toInt(),
            highlightVerse: true,
          ),
        );
      },
    );
  }
}
