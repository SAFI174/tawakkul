import 'dart:developer';

import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/data/models/quran_play_range_model.dart';
import 'package:tawakkal/data/models/quran_verse_model.dart';
import 'package:tawakkal/utils/quran_utils.dart';
import 'package:tawakkal/utils/utils.dart';
import '../../bindings/tafsir_details_binding.dart';
import '../../controllers/quran_audio_player_controller.dart';
import '../../controllers/tafsir_details_controller.dart';
import '../../data/cache/bookmark_cache.dart';
import '../../data/models/quran_bookmark.dart';
import '../../pages/tafisr_details_page.dart';
import '../../widgets/surah_verse.dart';
import '../dialogs/dialogs.dart';

class AyahBottomSheetController extends GetxController {
  // Observable boolean to track bookmark status
  RxBool isBookmarked = false.obs;

  // BookmarkCache instance
  late final BookmarkCache bookmarkCache;

  // Bookmark instance the init value is set before openeing by SheetsMetnods
  late Bookmark bookmark;

  // Audio player for word pronounce using internet
  AudioPlayer? audioPlayer;

  @override
  void onInit() async {
    super.onInit();
    // init the BookmarkCache instance
    bookmarkCache = BookmarkCache();
    // load the bookmarks from the cache
    await bookmarkCache.loadBookmarks();
    // check if the bookmark exists in the cache
    isBookmarked.value = bookmarkCache.checkBookmark(bookmark);
  }

  void onBookmarkPressed() {
    if (isBookmarked.value) {
      // remove the bookmark from the cache
      bookmarkCache.deleteBookmark(bookmark);
      // update the observable boolean
      isBookmarked.value = false;
    } else {
      // add the bookmark to the cache
      bookmarkCache.addBookmark(bookmark);
      // update the observable boolean
      isBookmarked.value = true;
    }
  }

  /// Plays the audio for a specific word in the Quran.
  ///
  /// Parameters:
  /// - surahNumber: The number of the surah.
  /// - verseNumber: The number of the verse.
  /// - wordPosition: The position of the word within the verse.
  void playWordAudio({
    required int surahNumber,
    required int verseNumber,
    required int wordPosition,
  }) async {
    // Ensure that the audioPlayer is initialized
    audioPlayer ??= AudioPlayer();

    try {
      // Set the audio source using a caching audio source
      await audioPlayer!.setAudioSource(
        LockCachingAudioSource(
          Uri.parse(
            // Build the URL for pronouncing the specific word
            QuranUtils.buildWordPronounceAudioUrl(
              surahNumber: surahNumber,
              verseNumber: verseNumber,
              wordPosition: wordPosition,
            ),
          ),
        ),
      );

      // Start playing the audio
      audioPlayer!.play();
    } catch (e) {
      // Handle exceptions, for example, show a dialog for no internet connection
      showNoInternetDialog();
    }
  }
}

class AyahBottomSheet extends GetView<AyahBottomSheetController> {
  const AyahBottomSheet(this.verse, this.word, {super.key});

  final QuranVerseModel verse;
  final Word word;

  @override
  Widget build(BuildContext context) {
    // Build the text for sharing
    final shareText =
        '${getSurahNameArabic(verse.surahNumber)} (الآية ${verse.verseNumber})\n ${getVerse(verse.surahNumber, verse.verseNumber)}';
    return Material(
      child: Directionality(
        textDirection: TextDirection.rtl,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            // Header Section
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Row(
                    children: [
                      SurahVerseWidget(
                          surah: verse.surahNumber, verse: verse.verseNumber),
                      Text(
                          ' -  الآية ${verse.verseNumber} -  ${word.textUthmani}'),
                    ],
                  ),
                ),
                IconButton(
                  onPressed: () {
                    // Reset highlighting and close the bottom sheet
                    verse.isHighlighted.value = false;
                    Get.back();
                  },
                  icon: const Icon(
                    Icons.close,
                  ),
                ),
              ],
            ),
            const Divider(
              height: 0.5,
            ),
            // Audio Section
            ListTile(
              dense: true,
              trailing: const Text('(تحتاج إنترنت)'),
              title: Row(
                children: [
                  const Text('إستمع للفظ الكلمة'),
                  Text(
                    ' ( ${word.textUthmani} )',
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                  )
                ],
              ),
              leading: const Icon(FluentIcons.play_16_regular),
              onTap: () => controller.playWordAudio(
                surahNumber: verse.surahNumber,
                verseNumber: verse.verseNumber,
                wordPosition: word.position,
              ),
            ),
            const Divider(
              height: 0.5,
            ),
            // Play From Verse Section
            ListTile(
              dense: true,
              title: const Text('تشغيل التلاوة بدأً من هذه الآية'),
              leading: const Icon(FluentIcons.play_circle_48_regular),
              onTap: () {
                // Play the audio from the current verse
                QuranAudioPlayerBottomBarController controller = Get.find();
                controller.onMainPlayPressed(
                  playRangeModel: QuranPlayRangeModel(
                      startSurah: verse.surahNumber,
                      endsSurah: verse.surahNumber,
                      startVerse: verse.verseNumber,
                      endsVerse: getVerseCount(verse.surahNumber)),
                );
                Get.back();
              },
            ),
            const Divider(
              height: 0.5,
            ),
            // Tafsir Section
            ListTile(
              dense: true,
              title: const Text('تفسير'),
              leading: const Icon(FluentIcons.book_question_mark_24_regular),
              onTap: () {
                try {
                  // Try to get the TafsirDetailsController instance
                  final controller = Get.find<TafsirDetailsController>();
                  controller.surahNumber.value = verse.surahNumber;
                  controller.verseNumber.value = verse.verseNumber;
                  Get.to(() => const TafsirDetailsPage(),
                      fullscreenDialog: true);
                } catch (e, stackTrace) {
                  log(e.toString(), stackTrace: stackTrace);
                }
                // Navigate to TafsirDetailsPage
                Get.to(
                  () => const TafsirDetailsPage(),
                  arguments: {
                    'surahNumber': verse.surahNumber,
                    'verseNumber': verse.verseNumber
                  },
                  binding: TafsirDetailsBinding(),
                  fullscreenDialog: true,
                );
              },
            ),
            const Divider(
              height: 0.5,
            ),
            // Bookmark Section
            Obx(() {
              return ListTile(
                dense: true,
                title: controller.isBookmarked.value
                    ? const Text('إزالة الإشارة المرجعية')
                    : const Text('أضف إشارة مرجعية'),
                leading: controller.isBookmarked.value
                    ? const Icon(FluentIcons.bookmark_off_20_regular)
                    : const Icon(FluentIcons.bookmark_add_20_regular),
                onTap: controller.onBookmarkPressed,
              );
            }),
            const Divider(
              height: 0.5,
            ),
            // Copy Section
            ListTile(
              dense: true,
              title: const Text('نسخ'),
              leading: const Icon(FluentIcons.copy_16_regular),
              onTap: () => Utils.copyToClipboard(text: shareText),
            ),
            const Divider(
              height: 0.5,
            ),
            // Share Section
            ListTile(
              dense: true,
              title: const Text('مشاركة'),
              leading: const Icon(FluentIcons.share_16_regular),
              onTap: () => Utils.shareText(text: shareText),
            ),
          ],
        ),
      ),
    );
  }
}
