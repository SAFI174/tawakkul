import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../constants/cache_keys.dart';
import '../../constants/enum.dart';

// A class for managing and caching Quran display settings using GetStorage.
class QuranSettingsCache {
  final GetStorage _box = GetStorage('app_settings');

  // Set the theme mode in the cache.
  Future<void> setThemeMode({required ThemeMode themeMode}) async {
    Get.changeThemeMode(themeMode);
    await _box.write(themeKey, EnumToString.convertToString(themeMode));
  }

  // Get the theme mode from the cache, default to system theme mode if not set.
  Future<ThemeMode> getThemeMode() async {
    if (_box.read(themeKey) == null) {
      await setThemeMode(themeMode: ThemeMode.light);
    }
    return EnumToString.fromString(
      ThemeMode.values,
      await _box.read(themeKey),
    )!;
  }

  // Set the last page index in the cache.
  Future<void> setLastPage({required int pageIndex}) async {
    await _box.write(lastPageKey, pageIndex);
  }

  // Get the last page index from the cache, default to 1 if not set.
  Future<int> getLastPage() async {
    if (await _box.read(lastPageKey) == null) {
      await setLastPage(pageIndex: 1);
    }
    return await _box.read(lastPageKey);
  }

  // Set the Quran font size in the cache.
  Future<void> setQuranFontSize({required double fontSize}) async {
    await _box.write(quranFontSizeKey, fontSize);
  }

  // Get the Quran font size from the cache, default to 25.0 if not set.
  Future<double> getQuranFontSize() async {
    if (await _box.read(quranFontSizeKey) == null) {
      await setQuranFontSize(fontSize: 25.0);
    }
    return await _box.read(quranFontSizeKey);
  }

  // Set the Quran display type in the cache.
  Future<void> setQuranDisplayType(
      {required QuranDisplayEnum quranDisplay}) async {
    final type = EnumToString.convertToString(quranDisplay);
    await _box.write(quranDisplayTypeKey, type);
  }

  // Get the Quran display type from the cache, default to Mushaf if not set.
  Future<QuranDisplayEnum> getQuranDisplayType() async {
    if (await _box.read(quranDisplayTypeKey) == null) {
      await setQuranDisplayType(quranDisplay: QuranDisplayEnum.mushaf);
    }
    final type = EnumToString.fromString(
        QuranDisplayEnum.values, await _box.read(quranDisplayTypeKey));
    return type ?? QuranDisplayEnum.mushaf;
  }

  // Get the marker color setting from the cache, default to true if not set.
  Future<bool> getMarkerColor() async {
    if (await _box.read(isMarkerColoredKey) == null) {
      await setMarkerColor(value: true);
    }
    return await _box.read(isMarkerColoredKey);
  }

  // Set the marker color setting in the cache.
  Future<void> setMarkerColor({required bool value}) async {
    await _box.write(isMarkerColoredKey, value);
  }
}
