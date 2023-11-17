import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:quran/quran.dart';
import 'package:share_plus/share_plus.dart';

import '../../bindings/tafsir_details_binding.dart';
import '../../controllers/quran_audio_player_controller.dart';
import '../../controllers/tafsir_details_controller.dart';
import '../../data/cache/bookmark_cache.dart';
import '../../data/models/quran_bookmark.dart';
import '../../data/models/quran_page.dart';
import '../../pages/tafisr_details_page.dart';
import '../../widgets/surah_verse.dart';
import '../dialogs/dialogs.dart';

// ignore: must_be_immutable
class AyahBottomSheet extends StatelessWidget {
  AyahBottomSheet(this.verse, this.currentWord, this._bookmarkCache, {Key? key})
      : super(key: key);
  final Verse verse;
  final BookmarkCache _bookmarkCache;
  Words currentWord;
  @override
  Widget build(BuildContext context) {
    final Bookmark bookmark =
        Bookmark(chapter: verse.surahNumber!, verse: verse.verseNumber!);
    final AudioPlayer audioPlayer = AudioPlayer();

    _bookmarkCache.checkBookmark(bookmark);
    if (currentWord.charTypeName == 'end') {
      currentWord = verse.words![verse.words!.indexOf(currentWord) - 1];
    }

    return WillPopScope(
      onWillPop: () {
        verse.isHighlighted.value = false;
        currentWord.isHighlighted.value = false;
        return Future(() => true);
      },
      child: Material(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10),
                    child: Row(
                      children: [
                        SurahVerseWidget(
                            surah: verse.surahNumber!,
                            verse: verse.verseNumber!),
                        Text(
                            ' -  الآية ${verse.verseNumber} -  ${currentWord.textUthmani}'),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
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
              ListTile(
                dense: true,
                trailing: const Text('(تحتاج إنترنت)'),
                title: Row(
                  children: [
                    const Text('إستمع لتهجئة الكلمة'),
                    Text(
                      ' ( ${currentWord.textUthmani} )',
                      style: const TextStyle(
                        fontSize: 14,
                      ),
                    )
                  ],
                ),
                leading: const Icon(FluentIcons.play_16_regular),
                onTap: () async {
                  final surahNumber =
                      verse.surahNumber.toString().padLeft(3, '0');
                  final verseNumber =
                      verse.verseNumber.toString().padLeft(3, '0');
                  final wordNumber =
                      currentWord.position.toString().padLeft(3, '0');
                  try {
                    await audioPlayer.setAudioSource(
                      LockCachingAudioSource(
                        Uri.parse(
                            'https://words.audios.quranwbw.com/${verse.surahNumber}/${surahNumber}_${verseNumber}_$wordNumber.mp3'),
                      ),
                    );
                    await audioPlayer.play();
                  } catch (e) {
                    showNoInternetDialog();
                  }
                },
              ),
              const Divider(
                height: 0.5,
              ),
              ListTile(
                dense: true,
                title: const Text('تشغيل التلاوة بدأً من هذه الآية'),
                leading: const Icon(FluentIcons.play_circle_48_regular),
                onTap: () {
                  QuranAudioPlayerBottomBarController controller = Get.find();
                  controller.onMainPlayPressed(
                      startSurah: verse.surahNumber,
                      endSurah: verse.surahNumber,
                      startVerse: verse.verseNumber,
                      endVerse: getVerseCount(verse.surahNumber!));
                  Get.back();
                },
              ),
              const Divider(
                height: 0.5,
              ),
              ListTile(
                dense: true,
                title: const Text('تفسير'),
                leading: const Icon(FluentIcons.book_question_mark_24_regular),
                onTap: () {
                  try {
                    final controller = Get.find<TafsirDetailsController>();
                    controller.surahNumber.value = verse.surahNumber!;
                    controller.verseNumber.value = verse.verseNumber!;
                    Get.to(() => const TafsirDetailsPage(),
                        fullscreenDialog: true);
                  } catch (e) {}
                  Get.to(
                    () => const TafsirDetailsPage(),
                    arguments: {
                      'surahNumber': verse.surahNumber!,
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
              Obx(() {
                return ListTile(
                  dense: true,
                  title: _bookmarkCache.isBookmarked.value
                      ? const Text('إزالة الإشارة المرجعية')
                      : const Text('أضف إشارة مرجعية'),
                  leading: _bookmarkCache.isBookmarked.value
                      ? const Icon(FluentIcons.bookmark_off_20_regular)
                      : const Icon(FluentIcons.bookmark_add_20_regular),
                  onTap: () {
                    _bookmarkCache.isBookmarked.value
                        ? _bookmarkCache.deleteBookmark(bookmark)
                        : _bookmarkCache.addBookmark(bookmark);

                    _bookmarkCache.checkBookmark(bookmark);
                  },
                );
              }),
              const Divider(
                height: 0.5,
              ),
              ListTile(
                dense: true,
                title: const Text('نسخ'),
                leading: const Icon(FluentIcons.copy_16_regular),
                onTap: () => Clipboard.setData(
                  ClipboardData(
                      text:
                          '${getSurahNameArabic(verse.surahNumber!)} (الآية ${verse.verseNumber})\n ${verse.textUthmani}'),
                ),
              ),
              const Divider(
                height: 0.5,
              ),
              ListTile(
                dense: true,
                title: const Text('مشاركة'),
                leading: const Icon(FluentIcons.share_16_regular),
                onTap: () => Share.share(
                    '${getSurahNameArabic(verse.surahNumber!)} (الآية ${verse.verseNumber})\n ${verse.textUthmani}'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
