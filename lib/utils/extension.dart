import 'package:flutter/cupertino.dart';
import 'package:quran/surah_data.dart';
import 'package:tawakkal/utils/custom_juz_data.dart';
import 'hizb_data.dart';

const String _hizb = "حزب";

extension IntExtension on int {
  String get getSurahNameOnlyArabicSimple {
    if (this > 114 || this <= 0) {
      throw "No Surah found with given surahNumber";
    }
    return surah[this - 1]['arabic'].toString().replaceAll('سورة', '').trim();
  }

  String get getSurahNameArabicSimple {
    if (this > 114 || this <= 0) {
      throw "No Surah found with given surahNumber";
    }
    return surah[this - 1]['arabic'].toString();
  }

  Map<String, int> get getHizbData {
    if (this > 60 || this < 0) {
      throw "No Hizb found with given hizbNumber";
    }
    return hizbs[this - 1];
  }

  String get getJuzNameQCF {
    return customJuz[this - 1]["qcf_name"];
  }

  String get getJuzName {
    return customJuz[this - 1]["name"];
  }

  String placeRevelation({bool arabic = true}) {
    if (this > 114 || this <= 0) {
      throw "No Surah found with given surahNumber";
    }

    if (arabic) {
      return surah[this - 1]['place'].toString() == 'Madinah'
          ? 'مدنية'
          : 'مكية';
    }

    return surah[this - 1]['place'].toString();
  }
}

extension ContextExtension on BuildContext {
  String getHizbText({required int rubElHizbNumber, required int hizbNumber}) {
    // Calculate the quarter within the Hizb.
    final quarterWithinHizb = rubElHizbNumber / 4.0;

    // Calculate the fraction of the current Hizb.
    final quarterFraction = quarterWithinHizb - (hizbNumber - 1).toDouble();

    // Initialize the quarter description string.
    String quarterDescription = '';

    // Determine the quarter description based on the fraction.
    if (quarterFraction <= 0.25) {
      quarterDescription = "";
    } else if (quarterFraction <= 0.5) {
      quarterDescription = "1/4";
    } else if (quarterFraction <= 0.75) {
      quarterDescription = "1/2";
    } else if (quarterFraction == 1) {
      quarterDescription = '3/4';
    }

    // Construct and return the formatted Hizb text.
    return "$quarterDescription $_hizb $hizbNumber";
  }
}
