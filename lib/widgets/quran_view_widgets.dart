import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../data/models/quran_page.dart';

WidgetSpan bismillahTextSpan(BuildContext context) {
  return WidgetSpan(
    child: Text(
      'ﰡ',
      style: TextStyle(
        fontFamily: 'QCFBSML',
        fontSize: 23,
        height: 1.1,
        color: Theme.of(context).colorScheme.onBackground,
      ),
    ),
  );
}

WidgetSpan bismillahTextSpanResponsive(BuildContext context) {
  return WidgetSpan(
    child: OrientationBuilder(builder: (context, orientation) {
      return orientation == Orientation.portrait
          ? Text(
              'ﰡ',
              style: TextStyle(
                fontFamily: 'QCFBSML',
                fontSize: (50.w * 0.2),
                height: 1.1,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            )
          : Text(
              'ﰡ',
              style: TextStyle(
                fontFamily: 'QCFBSML',
                fontSize: (50.w * 0.2),
                height: 1.1,
                color: Theme.of(context).colorScheme.onBackground,
              ),
            );
    }),
  );
}

WidgetSpan surahTitleSpanResponsive(
    BuildContext context, bool isColored, Verse verse) {
  return WidgetSpan(
    child: Stack(
      children: [
        ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 80.w),
          child: SvgPicture.asset(
            'assets/svg/surah_title.svg',
            width: MediaQuery.of(context).size.width - 20,
            color: isColored
                ? Theme.of(context).primaryColor
                : Theme.of(context).colorScheme.onBackground,
          ),
        ),
        Positioned(
          bottom: 0,
          left: 0,
          top: 2,
          right: 0,
          child: Align(
            alignment: Alignment.center,
            child: AutoSizeText(
              '${verse.verseKey!.split(":")[0].padLeft(3, '0')}surah',
              textScaleFactor: 1,
              maxFontSize: 60,
              style: TextStyle(
                  fontSize: MediaQuery.of(context).size.width * 0.1,
                  fontFamily: 'SURAHNAMES',
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ),
      ],
    ),
  );
}

WidgetSpan surahTitleSpan(BuildContext context, bool isColored, Verse verse) {
  return WidgetSpan(
    child: Stack(
      children: [
        SvgPicture.asset(
          'assets/svg/surah_title.svg',
          height: 25.5,
          color: isColored
              ? Theme.of(context).primaryColor
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
              '${verse.verseKey!.split(":")[0].padLeft(3, '0')}surah',
              textScaleFactor: 1,
              style: TextStyle(
                  fontSize: 18,
                  fontFamily: 'SURAHNAMES',
                  color: Theme.of(context).colorScheme.onBackground),
            ),
          ),
        ),
      ],
    ),
  );
}

Widget bookStrokeOdd() {
  return const Row(
    children: [
      VerticalDivider(
        width: 1.5,
        thickness: 1.5,
      ),
      VerticalDivider(
        width: 1,
      ),
      VerticalDivider(
        thickness: 1.5,
        width: 4,
      ),
      VerticalDivider(
        width: 1,
      ),
    ],
  );
}

Widget bookStrokeEven() {
  return const Row(
    children: [
      VerticalDivider(
        width: 1,
      ),
      VerticalDivider(
        thickness: 1.5,
        width: 4,
      ),
      VerticalDivider(
        width: 1,
      ),
      VerticalDivider(
        width: 1.5,
        thickness: 1.5,
      ),
    ],
  );
}
