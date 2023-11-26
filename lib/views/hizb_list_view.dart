import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';

import '../../../routes/app_pages.dart';
import '../Widgets/hizb_item.dart';
import '../data/models/quran_navigation_data_model.dart';

class HizbListView extends GetView {
  const HizbListView({Key? key, this.searchText = '', this.currentHizb = -1})
      : super(key: key);
  final String searchText;
  final int currentHizb;
  @override
  Widget build(BuildContext context) {
    final hizbNumbers = List.generate(60, (index) => index + 1)
        .where((hizbNumber) => hizbNumber.toString().contains(searchText))
        .toList();
    return ListView.builder(
      itemCount: hizbNumbers.length,
      itemExtent: 70,
      controller: currentHizb != -1
          ? ScrollController(initialScrollOffset: (currentHizb - 1) * 70)
          : null,
      itemBuilder: (BuildContext context, int index) {
        final hizbNumber = hizbNumbers[index];
        return Container(
          color: hizbNumber == currentHizb
              ? Theme.of(context).hoverColor
              : Colors.transparent,
          child: Column(
            children: [
              buildHizbItem(context, hizbNumber),
              const Divider(height: 1)
            ],
          ),
        );
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
