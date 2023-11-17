import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart' as intl;
import 'package:quran/quran.dart';

import '../../../data/cache/bookmark_cache.dart';
import '../../../routes/app_pages.dart';
import '../../../widgets/custom_progress_indicator.dart';
import '../controllers/quran_reading_controller.dart';
import '../widgets/surah_verse.dart';

class QuranBookmarksView extends GetView {
  QuranBookmarksView({Key? key}) : super(key: key);
  final BookmarkCache _bookmarkCache = BookmarkCache();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: Theme.of(context).shadowColor,
          scrolledUnderElevation: 1,
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
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
              return Obx(
                () {
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
                                final pageDestinationIndex = getPageNumber(
                                    bookmark.chapter, bookmark.verse);
                                try {
                                  final controller =
                                      Get.find<QuranReadingController>();
                                  if (Get.previousRoute
                                      .contains('quran-view')) {
                                    final controller =
                                        Get.find<QuranReadingController>();
                                    await controller.goTo(
                                        pageIndex: pageDestinationIndex);
                                    controller.highlightAyah(
                                        bookmark.chapter, bookmark.verse);
                                  } else {
                                    // Get.back();
                                    Get.toNamed(
                                      Routes.QURAN_VIEW,
                                      parameters: {
                                        'pageNumber':
                                            pageDestinationIndex.toString(),
                                      },
                                    );
                                    await controller.initPageViewData();
                                    controller.highlightAyah(
                                        bookmark.chapter, bookmark.verse);
                                  }
                                } catch (e) {
                                  Get.toNamed(
                                    Routes.QURAN_VIEW,
                                    parameters: {
                                      'pageNumber':
                                          pageDestinationIndex.toString(),
                                    },
                                    arguments: {
                                      'highlightInfo': {
                                        'surah': bookmark.chapter,
                                        'ayah': bookmark.verse
                                      }
                                    },
                                  );
                                }
                              },
                              horizontalTitleGap: 50,
                              isThreeLine: true,
                              title: Padding(
                                padding: const EdgeInsets.only(top: 8),
                                child: Text(
                                  getVerse(bookmark.chapter, bookmark.verse),
                                  maxLines: 5,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              subtitle: Row(
                                children: [
                                  SurahVerseWidget(
                                      surah: bookmark.chapter,
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
                                icon: const Icon(
                                    Icons.remove_circle_outline_outlined),
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
                },
              );
            }
          },
        ),
      ),
    );
  }
}
