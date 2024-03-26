import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:quran/quran.dart' as quran;
import 'package:tawakkal/widgets/custom_container.dart';

class SurahItem extends StatelessWidget {
  final int surahNumber;
  final Function()? onTap;

  const SurahItem({
    Key? key,
    required this.surahNumber,
    this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
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
              _buildSurahNumber(context),
              _buildVerseInfo(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSurahNumber(BuildContext context) {
    return FittedBox(
      alignment: Alignment.centerRight,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          _buildSurahNumberDecoration(context),
          const SizedBox(width: 10),
          Text(
            surahNumber.toString().padLeft(3, '0'),
            maxLines: 1,
            style: const TextStyle(
              fontFamily: 'SURAHNAMES',
              fontSize: 35,
            ),
            textScaler: TextScaler.noScaling,
          ),
        ],
      ),
    );
  }

  Widget _buildSurahNumberDecoration(BuildContext context) {
    return Stack(
      children: [
        Transform.rotate(
          angle: 40,
          child: Padding(
            padding: const EdgeInsets.all(5.0),
            child: CustomContainer(
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: const SizedBox(
                  width: 40,
                  height: 40,
                ),
              ),
            ),
          ),
        ),
        Positioned.fill(
          child: Center(
            child: Text(
              ArabicNumbers().convert(surahNumber.toString()),
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildVerseInfo() {
    return FittedBox(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '${_getArabicVerseCount()} ${_getVerseCountSuffix()}',
            style: const TextStyle(fontSize: 13),
          ),
          Text(
            '(${quran.getPlaceOfRevelation(surahNumber)})',
            style: const TextStyle(fontSize: 13),
          ),
        ],
      ),
    );
  }

  String _getArabicVerseCount() {
    return ArabicNumbers().convert(quran.getVerseCount(surahNumber));
  }

  String _getVerseCountSuffix() {
    return quran.getVerseCount(surahNumber) < 10 ? ' آيات' : ' آية';
  }
}
