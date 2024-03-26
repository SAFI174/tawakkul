import 'dart:developer';

import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

import '../controllers/quran_reading_controller.dart';
import '../utils/sheets/sheet_methods.dart';

// Widget for displaying the Bismillah text
Text bismillahTextWidget({double? fontsize}) {
  return Text(
    'ﰡ',
    style: TextStyle(
      fontFamily: 'QCFBSML',
      fontSize: fontsize ?? 23,
      height: 1.1,
      color: Theme.of(Get.context!).colorScheme.onBackground,
    ),
  );
}

/// Span for building the word of quran
/// Word color for highlighting
/// Verse Color for highlighting hole verse
/// onLongPress for verse info and quick tools
TextSpan buildQuranWordTextSpan(
    {required String text,
    required Color wordColor,
    required Color verseColor,
    Function()? onLongPress,
    double? fontSize,
    required String fontFamily}) {
  return TextSpan(
    text: '$text ',
    recognizer: LongPressGestureRecognizer()..onLongPress = onLongPress,
    style: TextStyle(
      fontFamily: fontFamily,
      color: wordColor,
      fontSize: fontSize,
      backgroundColor: verseColor,
    ),
  );
}

// Widget for displaying the Surah title with its name
Stack surahTitleWidget(
  ThemeData theme,
  int surahNumber,
) {
  bool isMarkerColored = true;
  try {
    QuranReadingController controller = Get.find();
    isMarkerColored = controller.displaySettings.isMarkerColored;
  } catch (e) {
    log(e.toString());
  }
  return Stack(
    children: [
      SvgPicture.asset(
        'assets/svg/surah_title.svg',
        height: 26.5,
        theme: SvgTheme(
          currentColor: isMarkerColored
              ? theme.primaryColor
              : theme.colorScheme.onBackground,
        ),
      ),
      Positioned(
        bottom: 0,
        left: 0,
        top: 0,
        right: 0,
        child: Align(
          alignment: Alignment.center,
          child: surahNameInQcf(
              surahNumber: surahNumber,
              textColor: theme.colorScheme.onBackground),
        ),
      ),
    ],
  );
}

// surah Text widget to show the Surah title in qcf style
Text surahNameInQcf(
    {required int surahNumber, double? fontSize, Color? textColor}) {
  return Text(
    '${surahNumber.toString().padLeft(3, '0')}surah',
    textScaler: TextScaler.noScaling,
    style: TextStyle(
      height: 1,
      color: textColor,
      fontSize: fontSize ?? 18,
      fontFamily: 'SURAHNAMES',
    ),
  );
}

// Widget for building the visual representation of page strokes
Row buildPageStrokes(bool isEven) {
  Widget verticalDivider(double thickness, double width) {
    return VerticalDivider(
      thickness: thickness,
      width: width,
    );
  }

  List<Widget> strokes = [
    verticalDivider(1.5, 3),
    verticalDivider(1.5, 3),
    verticalDivider(0, 1),
    verticalDivider(2, 2),
  ];
  return Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: isEven ? strokes : strokes.reversed.toList(),
  );
}

// Widget for a button that displays the page number and allows quick navigation
class PageNumberButtonWidget extends StatelessWidget {
  const PageNumberButtonWidget({
    super.key,
    required this.pageNumber,
    required this.height,
  });

  final int pageNumber;
  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: Align(
        alignment: Alignment.center,
        child: Tooltip(
          message: 'أضغط هنا للأنتقال بسرعة بين الصفحات',
          child: FilledButton.icon(
            style: ButtonStyle(
              backgroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.surfaceVariant,
              ),
              elevation: const MaterialStatePropertyAll(1),
              foregroundColor: MaterialStatePropertyAll(
                Theme.of(context).colorScheme.onBackground,
              ),
              padding: const MaterialStatePropertyAll(EdgeInsets.zero),
              visualDensity: VisualDensity.compact,
            ),
            onPressed: () => showGoToPageSheet(currentPage: pageNumber),
            icon: const Icon(
              Iconsax.arrow_up_2,
              size: 17,
            ),
            label: Text(
              ArabicNumbers().convert(pageNumber),
            ),
          ),
        ),
      ),
    );
  }
}
