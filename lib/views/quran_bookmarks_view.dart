import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:intl/intl.dart' as intl;
import 'package:quran/quran.dart';
import 'package:tawakkal/data/models/quran_navigation_data_model.dart';

import '../../../data/cache/bookmark_cache.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_progress_indicator.dart';
import '../widgets/surah_verse.dart';

class QuranBookmarksView extends GetView {
  QuranBookmarksView({Key? key}) : super(key: key);
  final BookmarkCache _bookmarkCache = BookmarkCache();
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: theme.shadowColor,
          scrolledUnderElevation: 1,
          titleTextStyle: theme.textTheme.titleMedium,
          title: const Text(
            'العلامات المرجعية',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: FutureBuilder<void>(
          future: _bookmarkCache.loadBookmarks(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomCircularProgressIndicator();
            } else if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            } else {
              return Obx(() {
                final bookmarks = _bookmarkCache.bookmarks;
                if (bookmarks.isEmpty) {
                  return const Center(
                    child: Text('لم تتم إضافة أية إشارات مرجعية'),
                  );
                } else {
                  return ListView.builder(
                    itemCount: bookmarks.length,
                    itemBuilder: (context, index) {
                      final bookmark = bookmarks[index];
                      return Column(
                        children: [
                          ListTile(
                            onTap: () async {
                              final pageNumber =
                                  getPageNumber(bookmark.surah, bookmark.verse);
                              var navigationDetails =
                                  QuranNavigationArgumentModel(
                                surahNumber: bookmark.surah,
                                pageNumber: pageNumber,
                                verseNumber: bookmark.verse,
                                highlightVerse: true,
                              );
                              if (Get.previousRoute.contains('quran-reading')) {
                                Get.back(result: navigationDetails);
                              } else {
                                print('asd');
                                Get.toNamed(Routes.QURAN_READING_PAGE,
                                    arguments: navigationDetails);
                              }
                            },
                            horizontalTitleGap: 30,
                            isThreeLine: true,
                            title: Padding(
                              padding: const EdgeInsets.only(top: 8),
                              child: Text(
                                getVerse(bookmark.surah, bookmark.verse),
                                maxLines: 5,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                            subtitle: Row(
                              children: [
                                SurahVerseWidget(
                                    surah: bookmark.surah,
                                    verse: bookmark.verse),
                                const SizedBox(
                                  width: 5,
                                ),
                                Text(
                                  '( ${ArabicNumbers().convert(intl.DateFormat('HH:mm yyyy/MM/d ').format(bookmark.addedDate!))} )',
                                )
                              ],
                            ),
                            trailing: IconButton(
                              icon: Icon(
                                Iconsax.minus_cirlce,
                                color: theme.colorScheme.error,
                              ),
                              onPressed: () {
                                _bookmarkCache.deleteBookmark(bookmark);
                              },
                              padding: const EdgeInsets.all(8),
                            ),
                          ),
                          const Divider(
                            height: 1,
                          ),
                        ],
                      );
                    },
                  );
                }
              });
            }
          },
        ),
      ),
    );
  }
}
