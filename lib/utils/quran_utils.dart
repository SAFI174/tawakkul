import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:status_bar_control/status_bar_control.dart';

import 'package:tawakkal/constants/urls.dart';
import 'package:tawakkal/controllers/quran_reading_controller.dart';

import '../data/models/quran_page.dart';
import '../data/models/quran_verse_model.dart';

class QuranUtils {
  // Calculate the height of a line in the Quran based on screen dimensions
  static double calcHeightOfQuranLine() {
    const double xReference = 850.90909090;
    const double yReference = 1.83;

    double screenHeight = 100.h;
    double screenWidth = 100.w;

    double y = (screenHeight / xReference) * yReference;

    // Adjust height for smaller screens
    if (screenWidth < 350) {
      return 2;
    }

    // Ensure y is within the desired range
    y = y.clamp(1.75, 1.88);
    return y;
  }

  // Get the height of the Quran page header, including status bar and toolbar
  static Future<double> getQuranPageHeaderHeight() async {
    return kToolbarHeight + await StatusBarControl.getHeight + 5;
  }

  // Get the height of the Quran page footer
  static double getQuranPageFooterHeight() {
    return 79;
  }

  // Get the font name of a Quran page based on the page number
  static String getFontNameOfQuranPage({required int pageNumber}) {
    return 'QCF_P${pageNumber.toString().padLeft(3, '0')}';
  }

  // Get the surah number associated with a particular line in the Quran
  static int getSurahNumberOfLine(List<Word> words, int lineNumber) {
    // Handle special cases for the first and second lines
    if (words.first.pageNumber == 1) {
      return 1;
    } else if (words.first.pageNumber == 2) {
      return 2;
    }

    // If it's the last line, get the previous line's surah number and add 1
    if (lineNumber == 15) {
      var lineWords = getWordsForLine(words, lineNumber - 1);
      return lineWords.first.surahNumber! + 1;
    }

    // Get words for the current line
    var lineWords = getWordsForLine(words, lineNumber);

    // Check if the line words are empty
    if (lineWords.isEmpty) {
      // Get the next line's words
      lineWords = getWordsForLine(words, lineNumber + 1);

      // Check if the next line words are empty
      if (lineWords.isEmpty) {
        // If empty, get the words for the third line
        lineWords = getWordsForLine(words, lineNumber + 2);
        // Return the surah number of the new line words because it must not be empty
        return lineWords.first.surahNumber!;
      }
      // Return the surah number of the second line words
      return lineWords.first.surahNumber!;
    } else {
      // If not empty, return the surah number of the line
      return lineWords.first.surahNumber!;
    }
  }

  static String buildWordPronounceAudioUrl(
      {required int surahNumber,
      required int verseNumber,
      required int wordPosition}) {
    final surahUrlIndex = surahNumber.toString().padLeft(3, '0');
    final verseUrlIndex = verseNumber.toString().padLeft(3, '0');
    final wordUrlIndex = wordPosition.toString().padLeft(3, '0');
    return '${Urls.wordPronounceUrl}$surahNumber/${surahUrlIndex}_${verseUrlIndex}_$wordUrlIndex.mp3';
  }

  // Handle the Quran word color for highlighting
  static Color getQuranWordColor({
    required RxBool isHighlighted,
    required bool isMarker,
    required ThemeData theme,
  }) {
    // If the word is a Marker, set the color to primary
    bool isMarkerColored = true;
    try {
      QuranReadingController controller = Get.find();
      isMarkerColored = controller.displaySettings.isMarkerColored;
    } catch (e) {}
    if (isMarker && isMarkerColored) {
      return theme.primaryColor;
    } else {
      // Check if the word is highlighted, then set the color
      // If highlighted, set color to primary; otherwise, use the background color
      return isHighlighted.value
          ? Get.isDarkMode
              ? theme.primaryColor
              : theme.primaryColor
          : theme.colorScheme.onBackground;
    }
  }

  // Handle the Quran word and verse background color for highlighting
  static Color getVerseBackgroundColor({
    required RxBool isVerseHighlighted,
    required RxBool isWordHighlighted,
    required Color backgroundColor,
  }) {
    // If the verse or word is highlighted, change the background color; otherwise, make it transparent
    return (isVerseHighlighted.value || isWordHighlighted.value)
        ? backgroundColor
        : Colors.transparent;
  }

  // Check if the next line in the Quran is empty
  static bool isNextLineEmpty(List<Word> words, int lineNumber) {
    return getWordsForLine(words, lineNumber + 1).isEmpty;
  }

  // Check if the previous line in the Quran is empty
  static bool isPrevLineEmpty(List<Word> words, int lineNumber) {
    return getWordsForLine(words, lineNumber - 1).isEmpty;
  }

  // Get the words for a specific line in the Quran
  static List<Word> getWordsForLine(List<Word> words, int lineNumber) {
    return words.where((word) => word.lineNumber == lineNumber).toList();
  }

  // Toggle fullscreen mode and control status bar visibility
  static Future<void> toggleFullscreen({
    required RxBool isFullScreen,
    bool? force,
  }) async {
    if (force != null && force == true) {
      isFullScreen.value = false;
      await StatusBarControl.setHidden(false);
      return;
    }
    isFullScreen.value = !isFullScreen.value;
    await StatusBarControl.setHidden(isFullScreen.value);
  }

  // Highlight a Quran verse for a short duration
  static Future<void> highlightVerse({required RxBool isHighlighted}) async {
    if (isHighlighted.value) {
      return;
    } else {
      isHighlighted.value = true;
      await Future.delayed(const Duration(seconds: 5));
      isHighlighted.value = false;
    }
  }

  // Method to clear highlights for all words
  static void clearHighlightedVersesAndWords({required List<QuranPageModel> pages}) async {
    for (var page in pages) {
      for (final verse in page.verses) {
        verse.isHighlighted.value = false;

        for (final word
            in verse.words.where((word) => word.isHighlighted.value)) {
          word.isHighlighted.value = false;
        }
      }
    }
  }
}
