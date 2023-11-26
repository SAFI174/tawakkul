import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/constants/enum.dart';
import 'package:tawakkal/constants/strings.dart';
import 'package:tawakkal/utils/quran_utils.dart';
import 'package:tawakkal/utils/sheets/sheet_methods.dart';
import 'package:tawakkal/widgets/custom_pop_menu_item.dart';
import 'package:tawakkal/widgets/custom_scroll_behavior.dart';
import '../../../../data/models/quran_page.dart';
import '../../Views/quran_search_view.dart';
import '../../../../routes/app_pages.dart';
import 'package:iconsax/iconsax.dart';
import '../controllers/quran_reading_controller.dart';
import '../data/models/quran_verse_model.dart';
import '../views/quran_bookmarks_view.dart';
import '../widgets/quran_reading_page_widgets.dart';
import 'quran_audio_player_page.dart';

class QuranReadingPage extends GetView<QuranReadingController> {
  const QuranReadingPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      bottomNavigationBar: buildQuranAudioPlayer(),
      extendBody: true,
      extendBodyBehindAppBar: true,
      appBar: buildAppBar(theme: theme),
      // toggle fullscreen when tap on body
      body: WillPopScope(
        // save the last page and exit fullscreen mode
        onWillPop: controller.onCloseView,
        child: GestureDetector(
          onTap: () => QuranUtils.toggleFullscreen(
              isFullScreen: controller.isFullScreenMode),
          child: GetBuilder<QuranReadingController>(
            // PageView for handling the 604 Quran Page
            builder: (controller) => PageView.builder(
              controller: controller.quranPageController,
              itemCount: 604,
              onPageChanged: controller.onPageChanged,
              itemBuilder: (context, index) {
                // current page data might be null
                QuranPageModel? currentPage = controller.quranPages[index];
                // if null return loading text
                if (currentPage == null) {
                  return const Center(child: Text(loadingText));
                }
                // return the page data of requseted page
                return Row(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // if page is odd view page strokes
                    if (currentPage.pageNumber.isOdd) buildPageStrokes(false),
                    // the page view handler
                    Expanded(child: QuranPageView(currentPage)),
                    // if page is even view page strokes
                    if (currentPage.pageNumber.isEven) buildPageStrokes(true),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  // build the appbar
  PreferredSize buildAppBar({required ThemeData theme}) {
    return PreferredSize(
      preferredSize: const Size(0, kToolbarHeight),
      child: Obx(
        () {
          return IgnorePointer(
            ignoring: controller.isFullScreenMode.value ? true : false,
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 200),
              opacity: controller.isFullScreenMode.value ? 0 : 1,
              child: AppBar(
                shadowColor: theme.colorScheme.shadow,
                titleSpacing: 0,
                elevation: 1,
                leading: buildAppBarMenuButton(),
                actions: buildAppBarActions(),
                title: buildAppBarTitle(),
              ),
            ),
          );
        },
      ),
    );
  }

  // build the app bar that contains the current surah,juz,pageNumber
  GetBuilder<QuranReadingController> buildAppBarTitle() {
    var theme = Theme.of(Get.context!);
    return GetBuilder<QuranReadingController>(
      builder: (context) {
        if (controller.currentPageData != null) {
          var page = controller.currentPageData!;
          var textStyle = theme.primaryTextTheme.labelSmall;
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // surah name of code qcf
              surahNameInQcf(
                surahNumber: page.surahNumber,
                fontSize: 25,
              ),
              // current page juz, pagenumber
              Row(
                children: [
                  Text('الجزء ${ArabicNumbers().convert(page.juzNumber)}',
                      style: textStyle),
                  Text(
                    ' | ',
                    style: textStyle,
                  ),
                  Text(
                    'الصفحة ${ArabicNumbers().convert(page.pageNumber)}',
                    style: textStyle,
                  ),
                ],
              )
            ],
          );
        } else {
          // if page is not loaded yet view empty size box
          return const SizedBox();
        }
      },
    );
  }

  // bottom nav bar that handle the audio controls and audio settings
  Widget buildQuranAudioPlayer() {
    return Obx(
      () {
        return IgnorePointer(
          ignoring: controller.isFullScreenMode.value ? true : false,
          child: AnimatedOpacity(
            opacity: controller.isFullScreenMode.value ? 0 : 1,
            duration: const Duration(milliseconds: 200),
            child: const QuranAudioPlayerBottomBar(),
          ),
        );
      },
    );
  }

  // pop up menu that contains quick actions
  PopupMenuButton<dynamic> buildAppBarMenuButton() {
    return PopupMenuButton(
      itemBuilder: (context) {
        return [
          CustomPopupMenuItem.build(
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
          CustomPopupMenuItem.build(
              index: 'page',
              iconData: FluentIcons.book_number_16_regular,
              text: 'إنتقال الى صفحة'),
          CustomPopupMenuItem.build(
              index: 'surah',
              iconData: Iconsax.book_1,
              text: 'إنتقال الى سورة'),
          CustomPopupMenuItem.build(
              index: 'juz',
              iconData: Iconsax.book_square,
              text: 'إنتقال الى جزء'),
          CustomPopupMenuItem.build(
              index: 'bookmark',
              iconData: FluentIcons.bookmark_search_20_regular,
              text: 'العلامات المرجعية'),
          CustomPopupMenuItem.build(
              index: 'audio',
              iconData: FluentIcons.play_settings_20_regular,
              text: 'إعدادت التشغيل الصوتي'),
          CustomPopupMenuItem.build(
              index: 'screen',
              iconData: FluentIcons.settings_16_regular,
              text: 'إعدادت القرآن '),
        ];
      },
      onSelected: controller.onMenuItemSelected,
    );
  }

  //build the AppBar actions
  List<Widget> buildAppBarActions() {
    return [
      // bookmarks
      IconButton(
        onPressed: controller.handleBookmarkPage,
        icon: const Icon(FluentIcons.bookmark_search_20_regular),
      ),
      // search quran
      IconButton(
        onPressed: controller.handleSearchPage,
        icon: const Icon(FluentIcons.book_search_20_regular),
      ),
      // quran settinigs
      IconButton(
        onPressed: () => Get.toNamed(Routes.QURAN_DISPLAY_SETTINGS),
        icon: const Icon(FluentIcons.settings_16_regular),
      ),
      // back button
      IconButton(
        onPressed: () async {
          // await controller.onCloseView();
          Get.back();
        },
        icon: const Icon(Icons.arrow_forward_rounded),
      ),
    ];
  }
}

/// The [QuranPageHeader] widget represents the header of a Quranic page.
/// It displays the names of the Surahs present on the page and information about the Juz, Hizb,
/// and Rub El Hizb details.
class QuranPageHeader extends StatelessWidget {
  const QuranPageHeader({Key? key, required this.page}) : super(key: key);

  final QuranPageModel page;

  @override
  Widget build(BuildContext context) {
    var textStyle = Theme.of(context).textTheme.labelSmall;

    return FutureBuilder(
      future: QuranUtils.getQuranPageHeaderHeight(),
      builder: (context, snapshot) {
        return SizedBox(
          height: snapshot.data ?? 79,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  // Display Surah names of the page
                  getPageData(page.pageNumber)
                      .map((element) =>
                          getSurahNameOnlyArabicSimple(element['surah']))
                      .join(' | '),
                  style: textStyle,
                ),
                // Display Juz number and Hizb details of the page
                Row(
                  children: [
                    Text('الجزء ${ArabicNumbers().convert(page.juzNumber)}',
                        style: textStyle),
                    const Gap(8),
                    Text(
                      ArabicNumbers().convert(
                        getHizbText(
                          hizbNumber: page.hizbNumber,
                          rubElHizbNumber: page.rubElHizbNumber,
                        ),
                      ),
                      style: textStyle,
                    ),
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}

/// The [QuranPageView] widget to handle the quran page view options.
/// this will handl all senarios of the view [QuranAdaptiveView], [QuranExpandedPageView], [QuranNormalPageView] d.
class QuranPageView extends GetView<QuranReadingController> {
  final QuranPageModel page;

  const QuranPageView(this.page, {super.key});
  @override
  Widget build(BuildContext context) {
    List<Word> allWords = page.verses.expand((verse) => verse.words).toList();
    controller.currentPageWords = allWords;
    return GetBuilder<QuranReadingController>(
      builder: (controller) {
        if (controller.displaySettings.displayOption ==
            QuranDisplayOption.adaptive) {
          return QuranAdaptiveView(
              words: allWords,
              page: page,
              fontSize: controller.displaySettings.displayFontSize);
        } else {
          return context.orientation == Orientation.landscape ||
                  Get.height < 750
              // enable scroll if the orientation is landscape or screen is small
              ? QuranExpandedPageView(
                  page: page,
                  allWords: allWords,
                )
              : QuranNormalPageView(
                  page: page,
                  allWords: allWords,
                );
        }
      },
    );
  }
}

/// The [QuranExpandedPageView] widget is for displaying the Quranic page with scroll
/// with an expanded [SingleChildScrollView] this will make page fit on all available width with scroll view.
/// It displays a Quranic page, including a header
/// with Surah names, Quranic verses represented by [QuranLines], and a footer for navigation.
class QuranExpandedPageView extends StatelessWidget {
  const QuranExpandedPageView({
    Key? key,
    required this.page,
    required this.allWords,
  }) : super(key: key);

  final QuranPageModel page;

  final List<Word> allWords;

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              QuranPageHeader(page: page),
              QuranLines(words: allWords, page: page),
              PageNumberButtonWidget(
                pageNumber: page.pageNumber,
                height: QuranUtils.getQuranPageFooterHeight(),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// The [QuranNormalPageView] widget is for displaying the Quranic page with normal view
/// this will make page fit on height - footer_height && - navigation_height.
/// It displays a Quranic page, including a header
/// with Surah names, Quranic verses represented by [QuranLines], and a footer for navigation.
class QuranNormalPageView extends StatelessWidget {
  const QuranNormalPageView({
    super.key,
    required this.page,
    required this.allWords,
  });

  final QuranPageModel page;
  final List<Word> allWords;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        QuranPageHeader(page: page),
        Expanded(
          child: QuranLines(
            words: allWords,
            page: page,
          ),
        ),
        PageNumberButtonWidget(
          pageNumber: page.pageNumber,
          height: QuranUtils.getQuranPageFooterHeight(),
        ),
      ],
    );
  }
}

/// The [QuranLines] widget represents a column of 15 [QuranLine] widgets, each displaying a line
/// of Quranic text. It utilizes a [FittedBox] to maintain the aspect ratio and a [Column] to organize
/// the lines. The widget generates each line using the [QuranLine] widget, considering line-related
/// properties such as line number, words, and empty line conditions.
class QuranLines extends StatelessWidget {
  // list of all words of this page
  final List<Word> words;
  // the page data where we in
  final QuranPageModel page;
  const QuranLines({
    super.key,
    required this.words,
    required this.page,
  });

  @override
  Widget build(BuildContext context) {
    return FittedBox(
      fit: BoxFit.fitHeight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: List.generate(
          15,
          (index) {
            int lineNumber = index + 1;
            // filter the words of this line
            List<Word> lineWords =
                QuranUtils.getWordsForLine(words, lineNumber);
            return QuranLine(
              lineNumber: lineNumber,
              words: lineWords,
              page: page,
              surahNumber: QuranUtils.getSurahNumberOfLine(words, lineNumber),
              isNextLineEmpty: QuranUtils.isNextLineEmpty(words, lineNumber),
              isPrevLineEmpty: QuranUtils.isPrevLineEmpty(words, lineNumber),
            );
          },
        ),
      ),
    );
  }
}

/// The [QuranLine] widget displays a line of Quranic text, Surah titles, words, verses
/// and Bismillah display based on specific conditions based on previous and next lines.
/// the RichText representation of the Quranic words, applying styles with [QuranUtils] methods for handling the highlights.
class QuranLine extends StatelessWidget {
  // the words of the line
  final List<Word> words;
  // the line number of which the line is
  final int lineNumber;
  // this parameter to check to print the surah box and bismillah
  final bool isNextLineEmpty;
  final bool isPrevLineEmpty;
  // the page where we in
  final QuranPageModel page;
  // the surah number of this line
  final int surahNumber;
  const QuranLine({
    Key? key,
    required this.words,
    required this.lineNumber,
    required this.page,
    required this.surahNumber,
    required this.isNextLineEmpty,
    required this.isPrevLineEmpty,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // if words of the line are empty then show surah box and bismillah
        if (words.isEmpty) ...[
          // if pageNumber = 1 or pageNumber = 187 skip bismillah
          if (isNextLineEmpty ||
              page.pageNumber == 1 ||
              page.pageNumber == 187) ...[
            if ((page.pageNumber == 1 || page.pageNumber == 2) &&
                lineNumber > 8) ...[
              // first 2 pages has only 7 lines
              const SizedBox(height: 25),
            ] else ...[
              // Display Surah title when the line is empty and specific conditions are met.
              surahTitleWidget(theme, surahNumber)
            ]
          ] else if (page.pageNumber != 1 && page.pageNumber != 187) ...[
            // Display Bismillah when the line is empty and specific conditions are met.
            bismillahTextWidget(),
          ]
        ] else
          // Build the line using the buildLine method.
          buildLine(words, page)
      ],
    );
  }

  Widget buildLine(List<Word> words, QuranPageModel page) {
    var theme = Theme.of(Get.context!);
    return Obx(
      () {
        return RichText(
          text: TextSpan(
            // Set the line height based on the calculated height of a Quranic line.
            style: TextStyle(height: QuranUtils.calcHeightOfQuranLine()),
            children: words.map(
              (word) {
                // this handle of which verse we are
                var verse = page.verses
                    .firstWhere((element) => element.id == word.verseId);
                // Build the Quranic word TextSpan using the buildQuranWordTextSpan method.
                return buildQuranWordTextSpan(
                  onLongPress: () => showVerseInfoBottomSheet(
                    verse: verse,
                    word: word,
                    context: Get.context!,
                  ),
                  text: word.textV1,
                  // color the word for highlighting
                  wordColor: QuranUtils.getQuranWordColor(
                    isHighlighted: word.isHighlighted,
                    isMarker: word.wordType == 'end',
                    theme: theme,
                  ),
                  // color the verse for highlighting
                  verseColor: QuranUtils.getVerseBackgroundColor(
                    isVerseHighlighted: verse.isHighlighted,
                    isWordHighlighted: word.isHighlighted,
                    backgroundColor: theme.colorScheme.surfaceVariant,
                  ),
                  // fontFamily of the word
                  fontFamily: QuranUtils.getFontNameOfQuranPage(
                    pageNumber: page.pageNumber,
                  ),
                );
              },
            ).toList(),
          ),
        );
      },
    );
  }
}

/// The [QuranAdaptiveView] widget is responsible for displaying the Quran in adaptive mode,
/// allowing users to adjust the font size dynamically. It includes a scroll view with rich text
/// for verses, surah names, and page header information.
class QuranAdaptiveView extends StatelessWidget {
  final List<Word> words;
  final QuranPageModel page;
  final double fontSize;

  const QuranAdaptiveView({
    Key? key,
    required this.words,
    required this.page,
    required this.fontSize,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return ScrollConfiguration(
      behavior: CustomScrollBehavior(),
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: Column(
            children: [
              QuranPageHeader(page: page),
              buildQuranText(theme),
              PageNumberButtonWidget(
                height: QuranUtils.getQuranPageFooterHeight(),
                pageNumber: page.pageNumber,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildQuranText(ThemeData theme) {
    return Obx(() {
      return RichText(
        textAlign: TextAlign.center,
        text: TextSpan(
          children: page.verses
              .expand(
                (verse) => [
                  if (verse.verseNumber == 1) ...[
                    const TextSpan(text: '\n'),
                    WidgetSpan(
                      child: surahNameInQcf(
                        surahNumber: verse.surahNumber,
                        fontSize: 50,
                        textColor: theme.primaryColor,
                      ),
                    ),
                    const TextSpan(text: '\n'),
                    if ((page.pageNumber != 1 && page.pageNumber != 187)) ...[
                      TextSpan(
                        text: '$bismillahText\n',
                        style: TextStyle(
                          fontFamily: 'QCFBSML',
                          fontSize: 30,
                          color: theme.colorScheme.onBackground,
                        ),
                      ),
                    ]
                  ],
                  ...verse.words.map(
                    (word) => buildQuranWordTextSpan(
                      onLongPress: () => showVerseInfoBottomSheet(
                          verse: verse, word: word, context: Get.context!),
                      text: word.textV1,
                      fontSize: fontSize,
                      wordColor: QuranUtils.getQuranWordColor(
                          isHighlighted: word.isHighlighted,
                          isMarker: word.wordType == 'end',
                          theme: theme),
                      verseColor: QuranUtils.getVerseBackgroundColor(
                          isVerseHighlighted: verse.isHighlighted,
                          isWordHighlighted: word.isHighlighted,
                          backgroundColor: theme.colorScheme.surfaceVariant),
                      fontFamily: QuranUtils.getFontNameOfQuranPage(
                          pageNumber: page.pageNumber),
                    ),
                  ),
                ],
              )
              .toList(),
        ),
      );
    });
  }
}
