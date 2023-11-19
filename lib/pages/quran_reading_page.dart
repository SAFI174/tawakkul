import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinch_zoom_release_unzoom/pinch_zoom_release_unzoom.dart';
import 'package:scroll_to_index/scroll_to_index.dart';
import '../../../../data/models/quran_page.dart';

import '../../Views/quran_bookmarks_view.dart';
import '../../Views/quran_search_view.dart';
import '../../Widgets/quran_view_widgets.dart';
import '../../../../routes/app_pages.dart';

import '../../../../widgets/custom_scroll_behavior.dart';
import 'package:iconsax/iconsax.dart';

import '../../constants/enum.dart';
import '../../utils/sheets/sheet_methods.dart';
import '../controllers/quran_reading_controller.dart';
import 'quran_audio_player_page.dart';

class QuranReadingPage extends GetView<QuranReadingController> {
  const QuranReadingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(
      () {
        return !controller.isPageLoaded.value
            ? const Scaffold(
                body: Center(
                  child: Text(
                    '... جاري التحميل',
                    textDirection: TextDirection.ltr,
                  ),
                ),
              )
            : buildQuranScaffold(context);
      },
    );
  }

  Widget buildQuranScaffold(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: buildBottomNavigationBar(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(context),
      body: WillPopScope(
          onWillPop: () async {
            await controller.onCloseView();

            return Future.value(true);
          },
          child: buildQuranPageView(context)),
    );
  }

  Widget buildBottomNavigationBar() {
    return Obx(() {
      return IgnorePointer(
        ignoring: controller.isFullScreen.value ? true : false,
        child: AnimatedOpacity(
          opacity: controller.isFullScreen.value ? 0 : 1,
          duration: const Duration(milliseconds: 200),
          child: QuranAudioPlayerBottomBar(),
        ),
      );
    });
  }

  PreferredSizeWidget buildAppBar(BuildContext context) {
    return PreferredSize(
      preferredSize: const Size.fromHeight(kToolbarHeight),
      child: Obx(() {
        return IgnorePointer(
          ignoring: controller.isFullScreen.value ? true : false,
          child: AnimatedOpacity(
            duration: const Duration(milliseconds: 200),
            opacity: controller.isFullScreen.value ? 0 : 1,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(
                      color: Theme.of(context).shadowColor.withAlpha(85),
                      spreadRadius: 0,
                      blurRadius: 3,
                      blurStyle: BlurStyle.outer)
                ],
              ),
              child: AppBar(
                titleSpacing: 0,
                leading: PopupMenuButton(
                  // offset: Offset(0, 0),
                  itemBuilder: (context) {
                    return [
                      customMenuItem(
                          index: 'search',
                          iconData: FluentIcons.book_search_24_regular,
                          text: 'بحث'),
                      // customMenuItem(
                      //     index: 'fadl',
                      //     iconData: FlutterIslamicIcons.quran,
                      //     text: 'فضل قراءة القرآن'),
                      // customMenuItem(
                      //     index: 'dua',
                      //     iconData: FlutterIslamicIcons.prayer,
                      //     text: 'دعاء ختم القرآن'),
                      customMenuItem(
                          index: 'page',
                          iconData: FluentIcons.book_number_16_regular,
                          text: 'إنتقال الى صفحة'),
                      customMenuItem(
                          index: 'surah',
                          iconData: Iconsax.book_1,
                          text: 'إنتقال الى سورة'),
                      customMenuItem(
                          index: 'juz',
                          iconData: Iconsax.book_square,
                          text: 'إنتقال الى جزء'),
                      customMenuItem(
                          index: 'bookmark',
                          iconData: FluentIcons.bookmark_search_20_regular,
                          text: 'العلامات المرجعية'),
                      customMenuItem(
                          index: 'audio',
                          iconData: FluentIcons.play_settings_20_regular,
                          text: 'إعدادت التشغيل الصوتي'),
                      customMenuItem(
                          index: 'screen',
                          iconData: FluentIcons.settings_16_regular,
                          text: 'إعدادت القرآن '),
                    ];
                  },
                  onSelected: controller.onMenuItemSelected,
                ),
                shadowColor: Theme.of(context).shadowColor,
                actions: buildAppBarActions(context),
                elevation: 1,
                title: buildAppBarTitle(),
              ),
            ),
          ),
        );
      }),
    );
  }

  PopupMenuEntry<dynamic> customMenuItem(
      {required index, required iconData, required text}) {
    return PopupMenuItem(
      value: index,
      child: Directionality(
        textDirection: TextDirection.ltr,
        child: ListTile(
          contentPadding: const EdgeInsets.all(0),
          minVerticalPadding: 0,
          dense: true,
          visualDensity: VisualDensity.compact,
          titleAlignment: ListTileTitleAlignment.center,
          trailing: Icon(
            iconData,
            size: 20,
          ),
          title: Text(
            text,
            textAlign: TextAlign.right,
          ),
        ),
      ),
    );
  }

  List<Widget> buildAppBarActions(BuildContext context) {
    return [
      IconButton(
        onPressed: () {
          Get.to(QuranBookmarksView(), fullscreenDialog: true)!
              .whenComplete(() => controller.bookmarkCache.loadBookmarks());
        },
        icon: const Icon(FluentIcons.bookmark_search_20_regular),
      ),
      IconButton(
        onPressed: () {
          Get.to(() => QuranSearchView(), fullscreenDialog: true);
        },
        icon: const Icon(FluentIcons.book_search_20_regular),
      ),
      IconButton(
        onPressed: () {
          Get.toNamed(Routes.QURAN_DISPLAY_SETTINGS);
        },
        icon: const Icon(FluentIcons.settings_16_regular),
      ),
      IconButton(
        onPressed: () async {
          await controller.onCloseView();
          Get.back();
        },
        icon: const Icon(Icons.arrow_forward_rounded),
      ),
    ];
  }

  Widget buildAppBarTitle() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          children: [
            Text(
              controller.getSurahNumPerPage(controller.currentPage.value),
              style: const TextStyle(
                fontFamily: 'SURAHNAMES',
                fontSize: 26,
                height: 1,
              ),
            ),
          ],
        ),
        Row(
          children: [
            Text(
              controller.getJuzNumberSTR(controller.currentPage.value),
              style: const TextStyle(fontSize: 11),
            ),
            const SizedBox(
              width: 5,
            ),
            Text(
              controller.getHizbOfPage(controller.currentPage.value).toString(),
              style: const TextStyle(fontSize: 11),
            ),
          ],
        )
      ],
    );
  }

  Widget buildQuranPageView(BuildContext context) {
    return GestureDetector(
        onTap: controller.toggleFullScreenMode,
        child: GetBuilder<QuranReadingController>(
          builder: (controller) {
            return PageView.builder(
              itemCount: 604,
              physics: controller.blockScroll.value
                  ? const NeverScrollableScrollPhysics()
                  : const ScrollPhysics(),
              controller: controller.pageController,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, pageIndex) {
                if (controller.pages[pageIndex] != null) {
                  final page = controller.pages[pageIndex]!;
                  pageIndex++;
                  bool isEvenPage = pageIndex.isEven;

                  return Obx(() {
                    if (controller.quranDisplayEnum.value ==
                        QuranDisplayEnum.auto) {
                      return buildQuranPageResponsive(
                          page, pageIndex, isEvenPage, context);
                    }
                    return OrientationBuilder(builder: (context, orientation) {
                      if (MediaQuery.of(context).size.height < 600) {
                        return buildQuranPageFittedOnScreenWidth(
                            page, pageIndex, isEvenPage, context);
                      }
                      if (orientation == Orientation.portrait) {
                        return buildQuranPageFittedOnScreenHeight(
                            page, pageIndex, isEvenPage, context);
                      }
                      return buildQuranPageFittedOnScreenWidth(
                          page, pageIndex, isEvenPage, context);
                    });
                  });
                }
                return const Center(
                  child: Text(
                    '... جاري التحميل',
                  ),
                );
              },
            );
          },
        ));
  }

  Widget buildQuranPageFittedOnScreenHeight(
      QuranPage page, int pageIndex, bool isEvenPage, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isEvenPage && pageIndex != 1) ...[bookStrokeOdd()],
        Expanded(
          child: Column(
            children: [
              buildQuranPageHeader(context, pageIndex),
              Expanded(
                  child: PinchZoomReleaseUnzoomWidget(
                      minScale: 0.8,
                      zoomChild: const Text('data'),
                      maxScale: 4,
                      resetDuration: const Duration(seconds: 1),
                      boundaryMargin: const EdgeInsets.only(bottom: 0),
                      clipBehavior: Clip.none,
                      resetCurve: Curves.bounceIn,
                      useOverlay: false,
                      twoFingersOn: () {
                        controller.blockScroll.value = true;
                        controller.update();
                      },
                      twoFingersOff: () => Future.delayed(
                            PinchZoomReleaseUnzoomWidget.defaultResetDuration,
                            () {
                              controller.blockScroll.value = false;
                              controller.update();
                            },
                          ),
                      maxOverlayOpacity: 0,
                      overlayColor: Colors.black,
                      fingersRequiredToPinch: 2,
                      child: buildQuranPageContent(page, pageIndex, context))),
              buildQuranPageFooter(pageIndex, 80, context),
            ],
          ),
        ),
        if (isEvenPage) ...[bookStrokeEven()],
      ],
    );
  }

  Widget buildQuranPageResponsive(
      QuranPage page, int pageIndex, bool isEvenPage, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isEvenPage && pageIndex != 1) ...[bookStrokeOdd()],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: CustomScrollBehavior(),
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildQuranPageHeader(context, pageIndex),
                          buildQuranPageContentResponsive(
                              page, context, controller),
                          buildQuranPageFooter(pageIndex, null, context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isEvenPage) ...[bookStrokeEven()],
      ],
    );
  }

  Widget buildQuranPageFittedOnScreenWidth(
      QuranPage page, int pageIndex, bool isEvenPage, BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (!isEvenPage && pageIndex != 1) ...[bookStrokeOdd()],
        Expanded(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Column(
              children: [
                Expanded(
                  child: ScrollConfiguration(
                    behavior: CustomScrollBehavior(),
                    child: SingleChildScrollView(
                      controller: page.scrollController,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          buildQuranPageHeader(context, pageIndex),
                          buildQuranPageContent(page, pageIndex, context),
                          buildQuranPageFooter(pageIndex, null, context),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (isEvenPage) ...[bookStrokeEven()],
      ],
    );
  }

  Widget buildQuranPageHeader(BuildContext context, int pageIndex) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 10),
      height: kToolbarHeight + controller.statusBarHeight.value,
      child: Obx(() {
        return Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              controller.getSurahNamePerPage(pageIndex),
              style: Theme.of(context).textTheme.labelSmall,
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  controller.getJuzNumberSTR(pageIndex),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
                const SizedBox(
                  width: 5,
                ),
                Text(
                  controller.getHizbOfPage(pageIndex).toString(),
                  style: Theme.of(context).textTheme.labelSmall,
                ),
              ],
            ),
          ],
        );
      }),
    );
  }

  Widget buildQuranPageContent(
      QuranPage page, int pageIndex, BuildContext context) {
    return (pageIndex == 1 || pageIndex == 2)
        ? buildQuranPageContentFirstTwoPages(page, pageIndex, context)
        : buildQuranPageContentOtherPages(page, pageIndex, context);
  }

  Widget buildQuranPageContentFirstTwoPages(
      QuranPage page, int pageIndex, BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 5),
      child: FittedBox(
        alignment: Alignment.topCenter,
        child: Column(
          children: [
            for (var lineNumber = 1; lineNumber <= 8; lineNumber++) ...[
              AutoScrollTag(
                index: lineNumber,
                key: ValueKey(lineNumber),
                controller: page.scrollController,
                child: buildQuranPageLine(
                    lineNumber, page.verses!, context, pageIndex, controller),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget buildQuranPageContentOtherPages(
      QuranPage page, int pageIndex, BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Column(
        children: [
          for (var lineNumber = 1; lineNumber <= 15; lineNumber++) ...[
            AutoScrollTag(
              index: lineNumber,
              key: ValueKey(lineNumber),
              controller: page.scrollController,
              child: buildQuranPageLine(
                  lineNumber, page.verses!, context, pageIndex, controller),
            ),
          ],
        ],
      ),
    );
  }

  Widget buildQuranPageFooter(
      int pageIndex, double? height, BuildContext context) {
    return SizedBox(
      height: height,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 5.0),
        child: Align(
          alignment: Alignment.bottomCenter,
          child: Tooltip(
            message: 'أضغط هنا للأنتقال بسرعة بين الصفحات',
            child: ElevatedButton(
              style: ButtonStyle(
                  backgroundColor: MaterialStatePropertyAll(
                    Theme.of(context).colorScheme.surfaceVariant,
                  ),
                  foregroundColor: MaterialStatePropertyAll(
                      Theme.of(context).colorScheme.onBackground),
                  padding: const MaterialStatePropertyAll(EdgeInsets.zero),
                  visualDensity: VisualDensity.compact),
              onPressed: () {
                showGoToPageSheet(currentPage: controller.currentPage.value);
              },
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Iconsax.arrow_up_2,
                    size: 17,
                  ),
                  const SizedBox(
                    width: 5,
                  ),
                  Text(
                    ArabicNumbers().convert(pageIndex),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

double calculateLineHeight(BuildContext context) {
  double xReference = 850.90909090;
  double yReference = 1.82;
  double y = ((MediaQuery.of(context).size.height) / xReference) * yReference;
  if ((MediaQuery.of(context).size.width) < 300) {
    return 2;
  }
  y = y > 1.88
      ? 1.88
      : y < 1.7
          ? 1.75
          : y;
  return y;
}

Widget buildQuranPageContentResponsive(
    QuranPage page, BuildContext context, QuranReadingController controller) {
  return Obx(() {
    return RichText(
      textAlign: TextAlign.center,
      text: TextSpan(
        children: [
          for (var verse in page.verses!) ...[
            if (verse.verseNumber == 1) ...[
              surahTitleSpanResponsive(
                  context, controller.isMarkerColored.value, verse),
              const TextSpan(text: '\n'),
              if (page.verses!.first.pageNumber != 187) ...[
                bismillahTextSpanResponsive(context),
                const TextSpan(text: '\n'),
              ]
            ],
            for (var word in verse.words!) ...[
              TextSpan(
                recognizer: LongPressGestureRecognizer()
                  ..onLongPress = () {
                    onLongPressAyah(verse, word, context, controller);
                  },
                text: word.codeV1,
                style: TextStyle(
                  fontSize: controller.quranFontSize.value,
                  letterSpacing: 2,
                  fontFamily: 'QCF_P${word.v1Page.toString().padLeft(3, '0')}',
                  color: word.charTypeName == 'end'
                      ? controller.isMarkerColored.value
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground
                      : word.isHighlighted.value
                          ? Theme.of(context).colorScheme.primary
                          : Theme.of(context).colorScheme.onBackground,
                  backgroundColor:
                      word.isHighlighted.value || verse.isHighlighted.value
                          ? Theme.of(context).colorScheme.surfaceVariant
                          : Colors.transparent,
                ),
              ),
            ]
          ],
        ],
      ),
    );
  });
}

Widget buildQuranPageLine(
    int lineNumber,
    RxList<Verse> surahVerseList,
    BuildContext context,
    int currentPageIndex,
    QuranReadingController controller) {
  return Obx(() {
    return RichText(
      textAlign: TextAlign.center,
      textScaleFactor: 1,
      text: TextSpan(
        children: [
          for (var verse in surahVerseList) ...[
            if (verse.verseNumber == 1 &&
                lineNumber == 1 &&
                verse.verseKey!.split(":")[0] == "1")
              surahTitleSpan(context, controller.isMarkerColored.value, verse),
            if (verse.verseNumber == 1 &&
                    (verse.words![0].lineNumber! - 2) == lineNumber ||
                (lineNumber == 1 &&
                    verse.pageNumber == 187 &&
                    (verse.words!.first.lineNumber! - 1) == 1))
              surahTitleSpan(context, controller.isMarkerColored.value, verse),
            if (verse.verseNumber == 1 &&
                ((verse.words![0].lineNumber! - 1) == lineNumber) &&
                (verse.pageNumber != 187 && currentPageIndex != 1))
              bismillahTextSpan(context),
            for (var word in verse.words!) ...[
              if (word.lineNumber == lineNumber)
                TextSpan(
                  recognizer: LongPressGestureRecognizer()
                    ..onLongPress = () {
                      onLongPressAyah(verse, word, context, controller);
                    },
                  text: word.codeV1,
                  style: TextStyle(
                    height: calculateLineHeight(context),
                    fontFamily:
                        'QCF_P${currentPageIndex.toString().padLeft(3, '0')}',
                    color: word.charTypeName == 'end'
                        ? controller.isMarkerColored.value
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onBackground
                        : word.isHighlighted.value
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.onBackground,
                    backgroundColor:
                        word.isHighlighted.value || verse.isHighlighted.value
                            ? Theme.of(context).colorScheme.surfaceVariant
                            : Colors.transparent,
                  ),
                ),
            ]
          ],
          if (surahVerseList.last.words!.last.lineNumber! != 15 &&
              lineNumber == 15 &&
              currentPageIndex != 1 &&
              currentPageIndex != 2)
            WidgetSpan(
              child: Stack(
                children: [
                  SvgPicture.asset(
                    'assets/svg/surah_title.svg',
                    alignment: Alignment.bottomCenter,
                    height: 25.5,
                    // ignore: deprecated_member_use
                    color: controller.isMarkerColored.value
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.onBackground,
                  ),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    top: 0,
                    right: 0,
                    child: Align(
                      alignment: Alignment.center,
                      child: Text(
                        '${(int.parse(surahVerseList[0].verseKey!.split(":")[0]) + 1).toString().padLeft(3, '0')}surah',
                        style: TextStyle(
                            fontSize: 16,
                            fontFamily: 'SURAHNAMES',
                            color: Theme.of(context).colorScheme.onBackground),
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  });
}
