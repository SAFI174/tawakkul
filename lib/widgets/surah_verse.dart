import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart';

class SurahVerseWidget extends StatelessWidget {
  const SurahVerseWidget({
    super.key,
    required this.surah,
    required this.verse,
  });

  final int surah;
  final int verse;

  @override
  Widget build(BuildContext context) {
    return Row(
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
                  "${surah}:${verse}",
                ),
              ),
            ),
          ),
        ),
        Text(
          getSurahNameOnlyArabicSimple(surah),
        ),
        const SizedBox(
          width: 3,
        ),
      ],
    );
  }
}
