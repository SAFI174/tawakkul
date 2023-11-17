// Import necessary packages
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quran/quran.dart';
import '../../controllers/quran_reading_controller.dart';
import '../../data/models/quran_page.dart';
import 'ayah_bottom_sheet.dart';
import 'default_go_to_picker_sheet.dart';

// Function to show a bottom sheet for navigating to a specific page in the Quran
void showGoToPageSheet({required currentPage}) {
  showModalBottomSheet(
    context: Get.context!, // Get the current context
    builder: (context) => DefaultGoToSheet(
      initValue: currentPage, // Initial value for the picker
      childCount: 604, // Total number of pages
      title: 'إختر الصفحة', // Title of the sheet
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            'الصفحة  ${ArabicNumbers().convert(index + 1)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
      onPressed: (selectedValue) {
        try {
          // Find the QuranReadingController using Get
          QuranReadingController controller = Get.find();
          // Navigate to the selected page
          controller.goTo(pageIndex: selectedValue);
        } catch (e) {
          // Close the sheet in case of an error
          Get.back();
        }
      },
    ),
  );
}

// Function to show a bottom sheet for navigating to a specific surah in the Quran
void showGoToSurahSheet({required currentSurah}) {
  showModalBottomSheet(
    context: Get.context!, // Get the current context
    builder: (context) => DefaultGoToSheet(
      initValue: currentSurah, // Initial value for the picker
      childCount: 114, // Total number of surahs
      title: 'إختر السورة', // Title of the sheet
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            '${ArabicNumbers().convert(index + 1)} - ${getSurahNameArabicSimple(index + 1)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
      onPressed: (selectedValue) {
        try {
          // Find the QuranReadingController using Get
          QuranReadingController controller = Get.find();
          // Get the page number of the selected surah and navigate to it
          controller.goTo(pageIndex: getSurahPages(selectedValue)[0]);
        } catch (e) {
          // Close the sheet in case of an error
          Get.back();
        }
      },
    ),
  );
}

// Function to show a bottom sheet for navigating to a specific juz in the Quran
void showGoToJuzSheet({required currentJuz}) {
  showModalBottomSheet(
    context: Get.context!, // Get the current context
    builder: (context) => DefaultGoToSheet(
      initValue: currentJuz, // Initial value for the picker
      childCount: 30, // Total number of juz
      title: 'إختر الجزء', // Title of the sheet
      itemBuilder: (context, index) {
        return Center(
          child: Text(
            'الجزء  ${ArabicNumbers().convert(index + 1)}',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        );
      },
      onPressed: (selectedValue) {
        try {
          // Find the QuranReadingController using Get
          QuranReadingController controller = Get.find();
          // Get the surah and verse information from the selected juz
          final surahAndVerses = getSurahAndVersesFromJuz(selectedValue);
          // Get the page number and navigate to it
          final currentPage = getPageNumber(
              surahAndVerses.keys.first, surahAndVerses.values.first.first);
          controller.goTo(pageIndex: currentPage);
        } catch (e) {
          // Close the sheet in case of an error
          Get.back();
        }
      },
    ),
  );
}

void onLongPressAyah(Verse verse, Words words, BuildContext context,
    QuranReadingController controller) async {
  verse.isHighlighted.value = true;
  words.isHighlighted.value = true;

  await showMaterialModalBottomSheet(
    duration: const Duration(milliseconds: 250),
    enableDrag: false,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
    context: context,
    builder: (context) =>
        AyahBottomSheet(verse, words, controller.bookmarkCache),
  );
  words.isHighlighted.value = false;
}
