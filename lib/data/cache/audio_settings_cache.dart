import 'package:get_storage/get_storage.dart';

import '../../constants/cache_keys.dart';
import '../models/quran_play_range_model.dart';

class AudioSettingsCache {
  static final GetStorage _box = GetStorage('audio_settings');

  // Method to save the Quran play range to cache for Range Selector
  Future<void> setQuranPlayRange(
      {required QuranPlayRangeModel playRange}) async {
    setPlayRangeValidState(isValid: true);
    await _box.write(quranPlayRangeKey, playRange.toJson());
  }

  Future<void> resetSettings() async {
    await saveQuranPlayRange(
      playRange: QuranPlayRangeModel(
        startSurah: 1,
        endsSurah: 1,
        startVerse: 1,
        endsVerse: 7,
      ),
    );
    await saveSpeed(speed: 1.0);
    await saveRepeat(repeatTimes: 1);
    await setPlayRangeValidState(isValid: false);
  }

  Future<void> saveQuranPlayRange(
      {required QuranPlayRangeModel playRange}) async {
    await _box.write(quranPlayRangeKey, playRange.toJson());
  }

  Future<void> saveSpeed({required double speed}) async {
    await _box.write(quranSpeedKey, speed);
  }

  Future<void> setPlayRangeValidState({required bool isValid}) async {
    await _box.write(playRangeValidKey, isValid);
  }

  Future<bool> getPlayRangeValidState() async {
    if (await _box.read(playRangeValidKey) == null) {
      setPlayRangeValidState(isValid: false);
    }
    return await _box.read(playRangeValidKey);
  }

  Future<void> saveRepeat({required int repeatTimes}) async {
    await _box.write(quranRepeatKey, repeatTimes);
  }

  Future<double> getSpeed() async {
    final speed = await _box.read(quranSpeedKey);
    if (speed == null) {
      saveSpeed(speed: 1.0);
    }
    return await _box.read(quranSpeedKey);
  }

  Future<int> getRepeat() async {
    final repeat = await _box.read(quranRepeatKey);
    if (repeat == null) {
      saveRepeat(repeatTimes: 1);
    }
    return await _box.read(quranRepeatKey);
  }

  // Method to retrieve the Quran play range from cache
  Future<QuranPlayRangeModel> getQuranPlayRange() async {
    final playRangeJson = await _box.read(quranPlayRangeKey);
    if (playRangeJson is Map<String, dynamic>) {
      return QuranPlayRangeModel.fromJson(playRangeJson);
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
  Future<void> clearQuranPlayRange() async {
    await _box.remove(quranPlayRangeKey);
  }
}
