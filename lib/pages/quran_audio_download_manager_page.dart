import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/data/models/download_surah_model.dart';
import '../../../../../data/repository/readers_repository.dart';
import '../../../../../widgets/custom_progress_indicator.dart';
import '../controllers/quran_audio_download_manager_controller.dart';

class QuranAudioDownloadManagerPage
    extends GetView<QuranAudioDownloadManagerController> {
  const QuranAudioDownloadManagerPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Configure text direction for right-to-left content
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Theme.of(context).shadowColor,
          elevation: 1,
          titleTextStyle: Theme.of(context).textTheme.titleMedium,
          title: const Text(
            'إدارات الملفات الصوتية',
            style: TextStyle(color: Colors.white),
          ),
          centerTitle: false,
        ),
        body: FutureBuilder(
          future: ReadersRepository().getQuranReaders(),
          builder: (context, readerData) {
            if (readerData.connectionState == ConnectionState.waiting) {
              return CustomCircularProgressIndicator();
            } else {
              if (controller.readers.isEmpty) {
                controller.readers = readerData.data!;
              }
              return CustomScrollView(
                slivers: [
                  SliverList.builder(
                    itemCount: controller.readers.length,
                    itemBuilder: (context, readerIndex) {
                      return _buildReaderContainer(context, readerIndex);
                    },
                  )
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Widget _buildReaderContainer(BuildContext context, int readerIndex) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        // Container for each reader
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: Theme.of(context).dividerColor,
          ),
        ),
        child: ExpandableNotifier(
          child: ExpandablePanel(
            theme: const ExpandableThemeData(hasIcon: false),
            header: _buildReaderHeader(context, readerIndex),
            collapsed: _buildCollapsedContent(context, readerIndex),
            expanded: _buildExpandedContent(context, readerIndex),
          ),
        ),
      ),
    );
  }

  Widget _buildReaderHeader(BuildContext context, int readerIndex) {
    return Material(
      type: MaterialType.card,
      color: Colors.transparent,
      borderRadius: const BorderRadius.only(
        topRight: Radius.circular(9),
        topLeft: Radius.circular(9),
      ),
      surfaceTintColor: Theme.of(context).primaryColor,
      shadowColor: Colors.transparent,
      elevation: 1,
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 5.0, right: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.keyboard_arrow_down),
                    const SizedBox(width: 5),
                    Text(
                      controller.readers[readerIndex].name,
                      style: Theme.of(context).textTheme.labelLarge,
                    ),
                  ],
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                  ),
                  onPressed: () {
                    controller.onDownloadAllPressed(
                        reader: controller.readers[readerIndex]);
                  },
                  child: Text(
                    'تحميل الكل', // Updated button text for English
                    style: Theme.of(context).textTheme.labelMedium,
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1),
        ],
      ),
    );
  }

  Widget _buildCollapsedContent(BuildContext context, int readerIndex) {
    // Collapsed content for each reader
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Text(
        controller
            .readers[readerIndex].englishName, // Updated label for English
        style: Theme.of(context).textTheme.labelMedium,
      ),
    );
  }

  Widget _buildExpandedContent(BuildContext context, int readerIndex) {
    // Expanded content for each reader

    return Builder(builder: (context) {
      var controllers = ExpandableController.of(context, required: true)!;
      return controllers.expanded
          ? FutureBuilder(
              future: ReadersRepository().getSurahDownloadData(
                  reader: controller.readers[readerIndex]),
              builder: (context, surahData) {
                if (surahData.connectionState == ConnectionState.waiting) {
                  // Show a loading indicator while data is being fetched
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CustomCircularProgressIndicator(),
                  );
                } else {
                  if (controller.readers[readerIndex].surahs == null) {
                    controller.readers[readerIndex].surahs = surahData.data!;
                  }
                  return CustomScrollView(
                    primary: false,
                    shrinkWrap: true,
                    slivers: [
                      SliverList.builder(
                        itemCount: 114,
                        itemBuilder: (context, chapterId) {
                          var surah = controller
                              .readers[readerIndex].surahs![chapterId];
                          return _buildChapterContent(
                              context, surah, readerIndex);
                        },
                      ),
                    ],
                  );
                }
              },
            )
          : const SizedBox();
    });
  }

  Widget _buildChapterContent(
      BuildContext context, DownloadSurahModel surah, int readerIndex) {
    // Content for each chapter (Surah)
    return Column(
      children: [
        if (surah.id != 0) const SizedBox(height: 5),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              border: Border.all(
                width: 1,
                color: Theme.of(context).dividerColor,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(right: 8.0),
                  child: Text(
                    '${surah.id} - ${getSurahNameOnlyArabicSimple(surah.id)}',
                  ),
                ),
                Obx(() {
                  return !surah.isDownloaded.value
                      ? !surah.isDownloading.value
                          ? surah.isPending.value
                              ? const Padding(
                                  padding: EdgeInsets.all(10.0),
                                  child: Text('قيد الانتظار'),
                                )
                              : IconButton(
                                  style: IconButton.styleFrom(
                                      visualDensity: VisualDensity.compact),
                                  onPressed: () async {
                                    controller.onSurahDownloadPressed(
                                        readerIndex: readerIndex, surah: surah);
                                  },
                                  icon: Icon(
                                    Iconsax.arrow_down_2,
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                )
                          : Padding(
                              padding: const EdgeInsets.all(10.0),
                              child: Text(
                                '% ${ArabicNumbers().convert(surah.downloadProgress.value)}',
                              ),
                            )
                      : IconButton(
                          style: IconButton.styleFrom(
                              visualDensity: VisualDensity.compact),
                          onPressed: () async {
                            controller.onDeleteSurah(
                                surah: surah,
                                reader: controller.readers[readerIndex]);
                          },
                          icon: Icon(
                            Iconsax.minus_cirlce,
                            color: Theme.of(context).colorScheme.error,
                          ),
                        );
                }),
              ],
            ),
          ),
        ),
        if (surah.id == 114) const SizedBox(height: 5),
      ],
    );
  }
}
