import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/bindings/quran_search_binding.dart';
import 'package:tawakkal/data/cache/quran_settings_cache.dart';
import 'package:tawakkal/data/models/quran_page.dart';
import 'package:tawakkal/data/models/quran_settings_model.dart';
import 'package:tawakkal/data/models/quran_verse_model.dart';
import 'package:tawakkal/utils/quran_utils.dart';
import '../bindings/quran_audio_player_settings_binding.dart';
import '../data/cache/audio_settings_cache.dart';
import '../data/models/quran_navigation_data_model.dart';
import '../data/repository/quran_repository.dart';
import '../pages/quran_audio_player_settings_page.dart';
import '../routes/app_pages.dart';
import '../utils/sheets/quran_fadl_sheet.dart';
import '../utils/sheets/sheet_methods.dart';
import '../views/quran_bookmarks_view.dart';
import '../views/quran_search_view.dart';

class QuranReadingController extends GetxController {
  // List to store Quran page models
  RxList<QuranPageModel?> quranPages =
      List<QuranPageModel?>.filled(604, null).obs;

  // Current page number
  int pageNumber = 1;

  // Controller for managing Quran page navigation
  final PageController quranPageController = PageController();

  // Flag to indicate fullscreen mode
  final RxBool isFullScreenMode = RxBool(false);

  // Current data for the visible Quran page
  QuranPageModel? currentPageData;

  // display settings model
  late QuranSettingsModel displaySettings;

  // Current words data for the visible Quran page
  List<Word>? currentPageWords;

  /// Fetches Quran page data for the specified page number and updates the state.
  ///
  /// Parameters:
  /// - pageNumber: The page number to fetch Quran data for.
  /// - scrollToPage: A flag indicating whether to scroll to the specified page after fetching the data.
  Future<void> fetchQuranPageData(
      {required int pageNumber, required bool scrollToPage}) async {
    // Calculate the index for the current page number.
    var pageIndex = pageNumber - 1;

    // Scroll to the specified page if requested.
    if (scrollToPage) {
      // Scroll to the specified page index after the widget tree has built.
      WidgetsBinding.instance.addPostFrameCallback(
        (_) {
          quranPageController.jumpToPage(pageIndex);
        },
      );
    }

    // Define the range of pages to fetch around the specified pageNumber.
    final int startPage = pageNumber - 2;
    final int endPage = pageNumber + 2;

    // Iterate through the range of pages.
    for (int currentPageNumber = startPage;
        currentPageNumber <= endPage;
        currentPageNumber++) {
      // Check if the page number is within valid bounds (1 to 604).
      if (currentPageNumber < 1 || currentPageNumber > 604) {
        continue; // Skip invalid page numbers.
      }

      // Calculate the index for the current page number.
      var currentPageIndex = currentPageNumber - 1;

      // Check if the page is already fetched and stored in the list.
      if (quranPages[currentPageIndex] != null) {
        continue; // Skip adding if the page is already in the list.
      }

      // Fetch the Quran page data using the repository for the current page number.
      quranPages[currentPageIndex] = await QuranRepository()
          .getQuranPageData(pageNumber: currentPageNumber);
    }

    // Set the current page data to the last fetched page.
    currentPageData = quranPages[pageIndex];

    // Set the player play range for the audio player based on the current page data
    AudioSettingsCache.setPlayerPlayRange(
        surahNumber: currentPageData!.surahNumber);

    // Notify listeners that the data has been updated.
    update();
  }

  /// Initializes the page data for Quran navigation.
  ///
  /// Parameters:
  /// - navigationDetails: The details for Quran navigation, including the page number,
  ///   verse number, surah number, and whether to highlight the verse.
  Future<void> initPageData(
      {QuranNavigationArgumentModel? navigationDetails}) async {
    // If navigationDetails is null, use Get.arguments
    navigationDetails ??= Get.arguments;

    // Start loading the page data and then scroll to the required page
    await fetchQuranPageData(
        pageNumber: navigationDetails!.pageNumber, scrollToPage: true);

    // If highlight verse is requested, then highlight the verse
    if (navigationDetails.highlightVerse) {
      final targetVerse =
          quranPages[navigationDetails.pageNumber - 1]!.verses.firstWhere(
                (element) =>
                    element.verseNumber == navigationDetails!.verseNumber &&
                    navigationDetails.surahNumber == element.surahNumber,
              );
      QuranUtils.highlightVerse(isHighlighted: targetVerse.isHighlighted);
    }

    // Toggle fullscreen mode if applicable
    QuranUtils.toggleFullscreen(isFullScreen: isFullScreenMode, force: true);
  }

  @override
  void onInit() async {
    super.onInit();
    initDisplaySettings();
    await QuranSettingsCache.setQuranPageHeaderHeight();
    initPageData();
  }

  /// Initializes the display settings for Quran, such as font size, marker color, and display option.
  /// Fetches values from the cache using [QuranSettingsCache].
  void initDisplaySettings() async {
    // Create a new instance of QuranSettingsModel
    displaySettings = QuranSettingsModel();

    // Fetch Quran font size from the cache and assign it to displaySettings
    displaySettings.displayFontSize = QuranSettingsCache.getQuranFontSize();

    // Fetch marker color setting from the cache and assign it to displaySettings
    displaySettings.isMarkerColored = QuranSettingsCache.isQuranColored();

    // Fetch Quran display type from the cache and assign it to displaySettings
    displaySettings.isAdaptiveView = QuranSettingsCache.isQuranAdaptiveView();
  }

  /// Handles the page change event when the user flips to a new page.
  /// Fetches Quran page data for the new page number and updates the state.
  /// Also sets the play range for the audio player based on the current page data.
  ///
  /// Parameters:
  /// - pageIndex: The index of the new page.
  void onPageChanged(int pageIndex) async {
    // Calculate the corresponding page number based on the index
    var pageNumber = pageIndex + 1;

    // Update the current page number
    this.pageNumber = pageNumber;

    // Fetch Quran page data for the new page number without scrolling to the page
    fetchQuranPageData(pageNumber: pageNumber, scrollToPage: false);
  }

  /// Handles navigation to the Quran bookmarks view.
  /// Waits for the user to select a bookmark, and if a bookmark is selected,
  /// initializes the page data for the selected bookmark.
  void handleBookmarkPage() async {
    // Navigate to the QuranBookmarksView and wait for the result
    var navigationDetails =
        await Get.to(QuranBookmarksView(), fullscreenDialog: true);

    // Check if the result is of type QuranNavigationArgumentModel
    if (navigationDetails is QuranNavigationArgumentModel) {
      // Initialize page data for the selected bookmark
      initPageData(navigationDetails: navigationDetails);
    }
  }

  /// Handles navigation to the Quran search view.
  /// Waits for the user to perform a search, and if a search result is selected,
  /// initializes the page data for the selected search result.
  void handleSearchPage() async {
    // Navigate to the QuranSearchView and wait for the result
    var navigationDetails = await Get.to(() => const QuranSearchView(),
        fullscreenDialog: true, binding: QuranSearchBinding());

    // Check if the result is of type QuranNavigationArgumentModel
    if (navigationDetails is QuranNavigationArgumentModel) {
      // Initialize page data for the selected search result
      initPageData(navigationDetails: navigationDetails);
    }
  }

  /// Handles highlighting a Verse in response to audio player events.
  ///
  /// The method takes the [surahNumber], [verseNumber]
  /// as parameters to identify and highlight the corresponding Verse.
  void highlightVerseAudioHandler({
    required int surahNumber,
    required int verseNumber,
  }) {
    // Calculate the page index based on surah and verse numbers
    var pageIndex = getPageNumber(surahNumber, verseNumber) - 1;

    // Get the current page
    final currentPage = quranPages[pageIndex];

    // Check if the current page is not null
    if (currentPage != null) {
      // Clear highlights for the all pages
      QuranUtils.clearHighlightedVersesAndWords(
          pages: quranPages.whereType<QuranPageModel>().toList());

      // Set the new word to be highlighted
      final currentVerse = currentPage.verses.firstWhere(
        (verse) =>
            verse.verseNumber == verseNumber &&
            verse.surahNumber == surahNumber,
      );

      // Check if the word is not already highlighted before setting it
      if (!currentVerse.isHighlighted.value) {
        currentVerse.isHighlighted.value = true;
      }
    }
  }

  /// Handles highlighting a word in response to audio player events.
  ///
  /// The method takes the [surahNumber], [verseNumber], and [wordIndex]
  /// as parameters to identify and highlight the corresponding word.
  void highlightWordAudioHandler({
    required int surahNumber,
    required int verseNumber,
    required int? wordIndex,
  }) {
    // if there is no word index provided, then exit function
    if (wordIndex == null) {
      return;
    }
    // Calculate the page index based on surah and verse numbers
    var pageIndex = getPageNumber(surahNumber, verseNumber) - 1;
    // Get the current page
    final currentPage = quranPages[pageIndex];

    // Check if the current page is not null
    if (currentPage != null) {
      // Clear highlights for the all pages
      QuranUtils.clearHighlightedVersesAndWords(
          pages: quranPages.whereType<QuranPageModel>().toList());

      // Set the new word to be highlighted
      final currentVerse = currentPage.verses.firstWhere(
        (verse) =>
            verse.verseNumber == verseNumber &&
            verse.surahNumber == surahNumber,
      );
      final wordToHighlight = currentVerse.words[wordIndex];

      // Check if the word is not already highlighted before setting it
      if (!wordToHighlight.isHighlighted.value) {
        wordToHighlight.isHighlighted.value = true;
      }
    }
  }

  /// Handles the view closure event.
  /// Saves the last viewed page index to the cache, exit fullscreen mode, and returns `true` for WillPopUp Widget.
  /// remove the user-selected player range from cache
  Future<bool> onCloseView() async {
    // Save the last viewed page index to the cache
    QuranSettingsCache.setLastPage(pageIndex: pageNumber);

    // Toggle fullscreen mode using QuranUtils, forcing it to true
    await QuranUtils.toggleFullscreen(
        isFullScreen: isFullScreenMode, force: true);

    // clear the user-selected player range
    AudioSettingsCache.setPlayRangeValidState(isValid: false);

    // Return true to indicate the success of the view closure
    return true;
  }

  void onMenuItemSelected(dynamic item) {
    if (currentPageData != null) {
      final Map<String, Function> menuActions = {
        'search': () => handleSearchPage(),
        'fadl': () => showFadlSheet(),
        'dua': () {
          // Handle the 'دعاء ختم القرآن' item.
        },
        'page': () => showGoToPageSheet(currentPage: pageNumber),
        'surah': () =>
            showGoToSurahSheet(currentSurah: currentPageData!.surahNumber),
        'juz': () => showGoToJuzSheet(currentJuz: currentPageData!.juzNumber),
        'bookmark': () => handleBookmarkPage(),
        'audio': () => Get.to(
              () => const QuranAudioSettingsPage(),
              binding: QuranAudioPlayerSettingsBinding(),
              arguments: currentPageData,
              fullscreenDialog: true,
            ),
        'screen': () => Get.toNamed(Routes.QURAN_DISPLAY_SETTINGS),
      };

      // Execute the corresponding action for the selected item.
      menuActions[item]?.call();
    }
  }
}
