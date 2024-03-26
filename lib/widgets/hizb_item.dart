import 'package:flutter/material.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/utils/extension.dart';
import 'surah_verse.dart';

class HizbItem extends StatelessWidget {
  const HizbItem({super.key, required this.hizbNumber, required this.onTap});
  final int hizbNumber;
  final Function()? onTap;
  @override
  Widget build(BuildContext context) {
    final hizbData = hizbNumber.getHizbData;
    return SizedBox(
      height: 70,
      child: InkWell(
        borderRadius: BorderRadius.circular(0),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              FittedBox(
                alignment: Alignment.centerRight,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          ' حزب $hizbNumber',
                          maxLines: 1,
                          style: const TextStyle(fontSize: 18),
                        ),
                        SurahVerseWidget(
                            surah: (hizbData['surah'] as int),
                            verse: (hizbData['verse'] as int))
                      ],
                    ),
                  ],
                ),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    getVerse(hizbData['surah']!.toInt(),
                        hizbData['verse']!.toInt())
                        .split(' ')
                        .take(4)
                        .toList()
                        .join(' ')
                        .replaceAll('۞', ''),
                    style: const TextStyle(
                        fontFamily: 'Uthmanic_Script',
                        fontWeight: FontWeight.bold),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
