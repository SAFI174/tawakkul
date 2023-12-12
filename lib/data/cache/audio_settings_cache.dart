import 'dart:convert';
import 'package:quran/quran.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/cache_keys.dart';
import '../../services/shared_preferences_service.dart';
import '../models/quran_play_range_model.dart';

class AudioSettingsCache {
  static final SharedPreferences prefs =
      SharedPreferencesService.instance.prefs;
  // Method to save the Quran play range to cache for Range Selector
  // Future<void> setQuranPlayRange(
  //     {required QuranPlayRangeModel playRange}) async {
  //   setPlayRangeValidState(isValid: true);
  //   prefs.setString(quranPlayRangeKey, jsonEncode(playRange.toJson()));
  // }

  static Future<void> resetSettings() async {
    saveQuranPlayRange(
      playRange: QuranPlayRangeModel(
        startSurah: 1,
        endsSurah: 1,
        startVerse: 1,
        endsVerse: 7,
      ),
    );
    saveSpeed(speed: 1.0);
    saveRepeat(repeatTimes: 1);
    setPlayRangeValidState(isValid: false);
  }

  static void saveQuranPlayRange({required QuranPlayRangeModel playRange}) {
    prefs.setString(quranPlayRangeKey, jsonEncode(playRange.toJson()));
  }

  static void saveSpeed({required double speed}) {
    prefs.setDouble(quranSpeedKey, speed);
  }

  static void setPlayRangeValidState({required bool isValid}) async {
    prefs.setBool(playRangeValidKey, isValid);
  }

  static bool getPlayRangeValidState() {
    var validState = prefs.getBool(playRangeValidKey);
    if (validState == null) {
      validState = false;
      setPlayRangeValidState(isValid: false);
    }
    return validState;
  }

  static void saveRepeat({required int repeatTimes}) async {
    prefs.setInt(quranRepeatKey, repeatTimes);
  }

  static double getSpeed() {
    var speed = prefs.getDouble(quranSpeedKey);
    if (speed == null) {
      speed = 1.0;
      saveSpeed(speed: 1.0);
    }
    return speed;
  }

  static int getRepeat() {
    var repeat = prefs.getInt(quranRepeatKey);
    if (repeat == null) {
      repeat = 1;
      saveRepeat(repeatTimes: 1);
    }
    return repeat;
  }

  // Method to retrieve the Quran play range from cache
  static QuranPlayRangeModel getQuranPlayRange() {
    final playRangeJson = prefs.getString(quranPlayRangeKey);
    if (playRangeJson != null) {
      return QuranPlayRangeModel.fromJson(jsonDecode(playRangeJson));
    } else {
      final playRange = QuranPlayRangeModel(
        startSurah: 1,
        endsSurah: 1,
        startVerse: 1,
        endsVerse: 7,
      );
      saveQuranPlayRange(playRange: playRange);
      return playRange;
    }
  }

  // Method to clear the Quran play range from cache
  static void clearQuranPlayRange() async {
    await prefs.remove(quranPlayRangeKey);
  }

  /// Sets the play range when the page changes and there is no user-selected play range.
  ///
  /// This method checks the validity of the play range stored in the cache.
  /// If the play range is not valid, it sets a default play range based on the [surahNumber].
  static void setPlayerPlayRange({required int surahNumber}) async {
    // Check if the stored play range is not valid
    if (!getPlayRangeValidState()) {
      // Set a default play range based on the current surahNumber
      final startSurah = surahNumber;
      saveQuranPlayRange(
        playRange: QuranPlayRangeModel(
          startSurah: startSurah,
          startVerse: 1,
          endsSurah: startSurah,
          endsVerse: getVerseCount(startSurah),
        ),
      );
    }
  }
}
