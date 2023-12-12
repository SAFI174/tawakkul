import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart' as quran;

import '../../../routes/app_pages.dart';
import '../data/models/quran_navigation_data_model.dart';
import 'surah_item.dart';

class JuzItem extends StatelessWidget {
  final int juzNumber;

  const JuzItem({Key? key, required this.juzNumber}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final surahAndVerses = quran.getSurahAndVersesFromJuz(juzNumber);
    final currentPage = quran.getPageNumber(
        surahAndVerses.keys.first, surahAndVerses.values.first.first);

    void goToPage(int page, int? surahNumber, int? verseNumber) async {
      Get.toNamed(
        Routes.QURAN_READING_PAGE,
        arguments: QuranNavigationArgumentModel(
          surahNumber: surahNumber ?? surahAndVerses.keys.first,
          pageNumber: page,
          verseNumber: verseNumber ?? surahAndVerses.values.first.first,
          highlightVerse: true,
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 0.8,
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: Column(
          children: [
            Material(
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(9),
                topLeft: Radius.circular(9),
              ),
              shadowColor: Colors.transparent,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(right: 5),
                      child: AutoSizeText(
                        quran.getJuzNameQCF(juzNumber),
                        style: const TextStyle(
                          fontFamily: 'QCFBSML',
                          fontSize: 30,
                        ),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        goToPage(currentPage, null, null);
                      },
                      child: Text('اقرأ الجزء'),
                    ),
                  ],
                ),
              ),
            ),
            const Divider(height: 1),
            Column(
              children: [
                for (var surahNumber in surahAndVerses.keys) ...[
                  SurahItem(
                    surahNumber: surahNumber,
                    onTap: () async {
                      goToPage(
                          quran.getPageNumber(
                              surahNumber, surahAndVerses[surahNumber]![0]),
                          surahNumber,
                          surahAndVerses[surahNumber]![0]);
                    },
                  ),
                  if (surahAndVerses.keys.last != surahNumber)
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Theme.of(context).dividerColor,
                    ),
                ]
              ],
            ),
          ],
        ),
      ),
    );
  }
}
