import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:tawakkal/utils/extension.dart';

class SurahVerseWidget extends StatelessWidget {
  const SurahVerseWidget({
    super.key,
    required this.surah,
    required this.verse,
    this.showSurahName = true,
  });

  final int surah;
  final int verse;
  final bool showSurahName;
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(3),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5), // if you need this
              border: Border.all(
                color:
                Theme.of(context).colorScheme.onBackground.withAlpha(100),
                width: 1,
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(5.0),
              child: Text(
                ArabicNumbers().convert(
                  "$surah:$verse",
                ),
              ),
            ),
          ),
        ),
        if (showSurahName) ...{
          Text(surah.getSurahNameOnlyArabicSimple),
          const SizedBox(width: 3),
        }
      ],
    );
  }
}
