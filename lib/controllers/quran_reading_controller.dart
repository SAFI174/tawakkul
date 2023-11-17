import 'dart:convert';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import 'package:status_bar_control/status_bar_control.dart';
import 'package:tawakkal/constants/json_path.dart';
import 'package:tawakkal/data/models/quran_play_range_model.dart';

import '../data/cache/audio_settings_cache.dart';
import '../../../../data/cache/bookmark_cache.dart';
import '../data/cache/quran_settings.dart';
import '../../../../data/models/quran_page.dart';
import '../../../../routes/app_pages.dart';
import '../../Views/quran_bookmarks_view.dart';
import '../../Views/quran_search_view.dart';
import '../../constants/enum.dart';
import '../../utils/sheets/quran_fadl_sheet.dart';
import '../../utils/sheets/sheet_methods.dart';
import '../bindings/quran_audio_player_settings_binding.dart';
import '../pages/quran_audio_player_settings_page.dart';

class QuranReadingController extends GetxController {
  // Prop
  RxBool blockScroll = false.obs;
  final RxBool isFullScreen = false.obs;
  final RxInt surahNumber = 1.obs;
  final RxBool isPageLoaded = false.obs;
  final RxInt currentPage = RxInt(1);
  final RxList<QuranPage?> pages = List<QuranPage?>.filled(604, null).obs;
  PageController? pageController;
  final Rx<QuranPage> currentPageData = QuranPage().obs;
  final RxDouble statusBarHeight = RxDouble(0);
  late final BookmarkCache bookmarkCache;
  late final isMarkerColored = false.obs;
  late final QuranSettingsCache settingsCache;
  final Rx<QuranDisplayEnum> quranDisplayEnum = QuranDisplayEnum.mushaf.obs;
  final RxDouble quranFontSize = 25.0.obs;
  final AutoScrollController autoScrollController = AutoScrollController();
  @override
  void onInit() async {
    super.onInit();
    init();
    initPageViewData();
  }

  // handle loading page data from other pages or sheets
  Future<void> goTo({required pageIndex}) async {
    currentPage.value = pageIndex;
    pageController!.jumpToPage(pageIndex - 1);

    await loadQuranPages(pageIndex - 1);
    Get.back();
  }

  Future<void> initPageViewData() async {
    isPageLoaded.value = false;
    var invokedFrom = Get.parameters['invokedFrom'] ?? '';
    switch (invokedFrom) {
      case 'surah':
        // If invoked from a specific Surah, set the initial Surah number and page.
        surahNumber.value = int.parse(Get.parameters['surahNumber']!);
        currentPage.value = getSurahPages(surahNumber.value)[0];
        break;
      default:
        currentPage.value = int.parse(Get.parameters['pageNumber']!);
        surahNumber.value = getPageData(currentPage.value).first['surah'];
    }
    await Future.delayed(const Duration(milliseconds: 250));
    await loadQuranPages(currentPage.value - 1);
    currentPageData.value = pages[currentPage.value - 1]!;
    setPlayerPlayRange();
    
    isPageLoaded.value = true;
    pageController = PageController(
      viewportFraction: 1,
      initialPage: currentPage.value - 1,
    );
  }

  void init() async {
    // Set the status bar height.
    statusBarHeight.value = (await StatusBarControl.getHeight) + 5;
    bookmarkCache = BookmarkCache();
    settingsCache = QuranSettingsCache();
    isMarkerColored.value = await settingsCache.getMarkerColor();
    quranDisplayEnum.value = await settingsCache.getQuranDisplayType();
    quranFontSize.value = await settingsCache.getQuranFontSize();
  }

  // Toggle full-screen mode and set the status bar visibility.
  void toggleFullScreenMode() async {
    isFullScreen.value = !isFullScreen.value;
    isFullScreen.value
        ? await StatusBarControl.setHidden(true)
        : await StatusBarControl.setHidden(false);
  }

  // Load Quran pages for the given range of pages.
  Future<void> loadQuranPages(int initialPage) async {
    for (int i = initialPage - 5; i <= initialPage + 5; i++) {
      if (i < 1 || i > 604) {
        continue; // Skip invalid page numbers.
      }
      if (pages[i - 1] != null) {
        continue; // Skip adding if the page is already in the list.
      }
      final jsonString =
          await rootBundle.loadString('${JsonPaths.quranPage}page_$i.json');
      final page = QuranPage.fromJson(json.decode(jsonString));
      pages[i - 1] = page;
    }
    update();
  }

  // Called when the page is changed.
  void onPageChanged(int pageIndex) async {
    currentPage.value = pageIndex + 1;
    await loadQuranPages(pageIndex);
    currentPageData.value = pages[pageIndex]!;
    surahNumber.value = currentPageData.value.verses!.first.surahNumber!;
    setPlayerPlayRange();
  }

  // Set the Quran play range for the player.
  void setPlayerPlayRange() async {
    if (!await AudioSettingsCache().getPlayRangeValidState()) {
      final startSurah = surahNumber.value;
      await AudioSettingsCache().saveQuranPlayRange(
        playRange: QuranPlayRangeModel(
          startSurah: startSurah,
          startVerse: 1,
          endsSurah: startSurah,
          endsVerse: getVerseCount(startSurah),
        ),
      );
    }
  }

  // Get the Juz number as a string.
  String getJuzNumberSTR(int pageIndex) {
    return pages[pageIndex - 1]?.verses == null
        ? ''
        : 'جزء ${ArabicNumbers().convert(pages[pageIndex - 1]!.verses!.last.juzNumber!)}';
  }

  // Get the Juz number as an integer.
  int getJuzNumber(int pageIndex) {
    return pages[pageIndex - 1]?.verses == null
        ? 1
        : pages[pageIndex - 1]!.verses!.last.juzNumber!;
  }

  // Highlight a specific Ayah.
  void highlightAyah(int surahNumber, int verseNumber) {
    try {
      pages[getPageNumber(surahNumber, verseNumber) - 1]!
          .verses!
          .forEach((element) async {
        if (element.verseNumber == verseNumber &&
            element.surahNumber == surahNumber) {
          element.isHighlighted.value = true;
          await Future.delayed(const Duration(seconds: 5));
          element.isHighlighted.value = false;
        }
      });
    } catch (e) {
      print(e);
    }
  }

  // Highlight a specific word within an Ayah.
  void highlightWordAudio(
      {required surahID, required verseId, required wordIndex}) {
    for (var page in pages.whereType<QuranPage>()) {
      for (var verse in page.verses!) {
        verse.isHighlighted.value = false;
        for (var word in verse.words!) {
          word.isHighlighted.value = false;
        }
      }
      if (wordIndex == null) {
        return;
      }
      for (var verse in page.verses!) {
        if (verse.verseNumber == verseId && surahID == verse.surahNumber) {
          if (!verse.words![wordIndex].isHighlighted.value) {
            verse.words![wordIndex].isHighlighted.value = true;
            break;
          }
        }
      }
    }
  }

  void onCloseView() async {
    await QuranSettingsCache().setLastPage(pageIndex: currentPage.value);
    await StatusBarControl.setHidden(false);
  }

  // Get the names of Surahs on the current page.
  String getSurahNamePerPage(int pageIndex) {
    return getPageData(pageIndex)
        .map((element) => getSurahNameOnlyArabicSimple(element['surah']))
        .join(' | ');
  }

  // Get the Surah numbers on the current page.
  String getSurahNumPerPage(int pageIndex) {
    return '${surahNumber.value.toString().padLeft(3, '0')}surah';
  }

  // Get the current Surah number.
  int getCurrentSurahNumber(int pageIndex) {
    return getPageData(pageIndex).first['surah'];
  }

  // Get the Hizb number of the current page.
  int getHizbNumber(int pageIndex) {
    return pages[pageIndex - 1]?.verses == null
        ? -1
        : pages[pageIndex - 1]!.verses!.first.hizbNumber!;
  }

  // Get the Hizb description for the current page.
  String getHizbOfPage(int pageIndex) {
    if (currentPageData.value.verses == null) {
      return '';
    }
    final rubElHizbNumber =
        currentPageData.value.verses!.first.rubElHizbNumber!;
    final quarterWithinHizb = rubElHizbNumber / 4.0;
    final hizbNumber = currentPageData.value.verses!.first.hizbNumber!;
    final quarterFraction = quarterWithinHizb - (hizbNumber - 1).toDouble();
    String quarterDescription = '';
    if (quarterFraction <= 0.25) {
      quarterDescription = "";
    } else if (quarterFraction <= 0.5) {
      quarterDescription = "1/4";
    } else if (quarterFraction <= 0.75) {
      quarterDescription = "1/2";
    } else if (quarterFraction == 1) {
      quarterDescription = '3/4';
    }
    return "${ArabicNumbers().convert(quarterDescription)} حزب ${ArabicNumbers().convert(hizbNumber)} ";
  }

  // Handle PopUpMenu items
  void onMenuItemSelected(dynamic item) {
    switch (item) {
      case 'search':
        Get.to(() => QuranSearchView(), fullscreenDialog: true);
        break;
      case 'fadl':
        showFadlSheet();
        break;
      case 'dua':
        // Handle the 'دعاء ختم القرآن' item.
        break;
      case 'page':
        showGoToPageSheet(currentPage: currentPage.value);
        break;
      case 'surah':
        // Handle the 'إنتقال الى سورة' item.
        showGoToSurahSheet(currentSurah: surahNumber.value);

        break;
      case 'juz':
        // Handle the 'إنتقال الى جزء' item.
        showGoToJuzSheet(currentJuz: getJuzNumber(currentPage.value));

        break;
      case 'bookmark':
        // Handle the 'العلامات المرجعية' item.

        Get.to(QuranBookmarksView(), fullscreenDialog: true);
        break;
      case 'audio':
        // Handle the 'إعدادت التشغيل الصوتي' item.
        Get.to(() => const QuranAudioSettingsPage(),
            binding: QuranAudioPlayerSettingsBinding(),
            arguments: currentPageData.value,
            fullscreenDialog: true);
        break;
      case 'screen':
        // Handle the 'إعدادت العرض' item.
        Get.toNamed(Routes.QURAN_DISPLAY_SETTINGS);
        break;
      default:
        // Handle unknown items or provide a default action.
        break;
    }
  }
}
