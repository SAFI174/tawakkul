import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/data/cache/quran_reader_cache.dart';
import 'package:tawakkal/data/models/quran_bookmark.dart';
import 'package:tawakkal/data/models/quran_verse_model.dart';
import 'package:tawakkal/utils/extension.dart';
import 'package:tawakkal/widgets/custom_progress_indicator.dart';
import '../../controllers/quran_reading_controller.dart';
import '../../data/repository/readers_repository.dart';
import 'ayah_bottom_sheet.dart';
import 'default_go_to_picker_sheet.dart';

Future<void> selectReaderSheet() async {
  await showMaterialModalBottomSheet(
    context: Get.context!,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    builder: (context) => Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        height: 250,
        child: FutureBuilder(
          future: Future.wait([
            ReadersRepository().getQuranReaders(),
          ]),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomCircularProgressIndicator();
            } else {
              var readersList = snapshot.data![0];
              var selectedReader =
              QuranReaderCache.getSelectedReaderFromCache();
              var selectedIndex = readersList.indexWhere(
                      (element) => element.identifier == selectedReader.identifier);
              int? selectedReaderIndex;

              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: CupertinoPicker.builder(
                      scrollController: FixedExtentScrollController(
                          initialItem: selectedIndex),
                      childCount: readersList.length,
                      itemExtent: 50,
                      onSelectedItemChanged: (value) {
                        selectedReaderIndex = value;
                      },
                      itemBuilder: (context, index) {
                        return Center(
                          child: Text(
                            '${index + 1} - ${readersList[index].name}',
                            style: Theme.of(context).textTheme.bodyMedium,
                          ),
                        );
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FilledButton(
                      onPressed: () async {
                        if (selectedReaderIndex != null) {
                          QuranReaderCache.saveSelectedReaderToCache(
                              readersList[selectedReaderIndex!]);
                          Get.back();
                        }
                      },
                      child: const Text('موافق'),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    ),
  );
}

/// Function to show a bottom sheet for navigating to a specific page in the Quran.
///
/// Parameters:
/// - currentPage: The current page number to be set as the initial value in the picker.
void showGoToPageSheet({required currentPage}) {
  showMaterialModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    context: Get.context!, // Get the current context
    builder: (context) => DefaultGoToSheet(
      initValue: currentPage, // Initial value for the picker
      childCount: 604, // Total number of pages in the Quran
      title: 'إختر الصفحة', // Title of the bottom sheet
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            'الصفحة  ${ArabicNumbers().convert(index + 1)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
      onPressed: (selectedValue) async {
        // Find the QuranReadingController using Get
        QuranReadingController controller = Get.find();

        // Start loading the page and then scroll to the page
        controller.fetchQuranPageData(
            pageNumber: selectedValue, scrollToPage: true);

        // Close the bottom sheet
        Get.back();
      },
    ),
  );
}

/// Function to show a bottom sheet for navigating to a specific surah in the Quran.
///
/// Parameters:
/// - currentSurah: The current surah number to be set as the initial value in the picker.
void showGoToSurahSheet({required currentSurah}) {
  showMaterialModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    context: Get.context!, // Get the current context
    builder: (context) => DefaultGoToSheet(
      initValue: currentSurah, // Initial value for the picker
      childCount: 114, // Total number of surahs in the Quran
      title: 'إختر السورة', // Title of the bottom sheet
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            '${ArabicNumbers().convert(index + 1)} - ${(index + 1).getSurahNameArabicSimple}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
      onPressed: (selectedValue) {
        // Find the QuranReadingController using Get
        QuranReadingController controller = Get.find();

        // Start loading the page and then scroll to the page
        controller.fetchQuranPageData(
            pageNumber: getSurahPages(selectedValue)[0], scrollToPage: true);

        // Close the bottom sheet
        Get.back();
      },
    ),
  );
}

/// Function to show a bottom sheet for navigating to a specific juz in the Quran.
///
/// Parameters:
/// - currentJuz: The current juz number to be set as the initial value in the picker.
void showGoToJuzSheet({required currentJuz}) {
  showMaterialModalBottomSheet(
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    context: Get.context!, // Get the current context
    builder: (context) => DefaultGoToSheet(
      initValue: currentJuz, // Initial value for the picker
      childCount: 30, // Total number of juz in the Quran
      title: 'إختر الجزء', // Title of the bottom sheet
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            'الجزء  ${ArabicNumbers().convert(index + 1)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
      onPressed: (selectedValue) {
        // Find the QuranReadingController using Get
        QuranReadingController controller = Get.find();

        // Get the surah and verse information from the selected juz
        final surahAndVerses = getSurahAndVersesFromJuz(selectedValue);

        // Get the page number and navigate to it
        final pageNumber = getPageNumber(
            surahAndVerses.keys.first, surahAndVerses.values.first.first);

        // Start loading the page and then scroll to the page
        controller.fetchQuranPageData(
            pageNumber: pageNumber, scrollToPage: true);

        // Close the bottom sheet
        Get.back();
      },
    ),
  );
}

/// Displays a bottom sheet with information about a Quran verse.
///
/// Parameters:
/// - verse: The QuranVerseModel representing the verse to display information about.
/// - word: The Word representing the specific word in the verse.
/// - context: The BuildContext for displaying the bottom sheet.
void showVerseInfoBottomSheet({
  required QuranVerseModel verse,
  required Word word,
  required BuildContext context,
}) async {
  // Highlight the verse and word
  verse.isHighlighted.value = true;

  // Adjust the word if it is of type 'end'
  if (word.wordType == 'end') {
    word = verse.words[verse.words.indexOf(word) - 1];
  }

  // Highlight the adjusted word
  word.isHighlighted.value = true;

  // Create and initialize AyahBottomSheetController
  var controller = Get.put(AyahBottomSheetController());
  controller.bookmark =
      Bookmark(surah: verse.surahNumber, verse: verse.verseNumber);

  // Show the material modal bottom sheet
  await showMaterialModalBottomSheet(
    duration: const Duration(milliseconds: 250),
    enableDrag: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    context: context,
    builder: (context) => AyahBottomSheet(verse, word),
  );

  // Reset highlighting and delete the controller after the bottom sheet is closed
  word.isHighlighted.value = false;
  verse.isHighlighted.value = false;
  Get.delete<AyahBottomSheetController>();
}
