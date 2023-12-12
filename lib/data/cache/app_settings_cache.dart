import 'package:enum_to_string/enum_to_string.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawakkal/constants/cache_keys.dart';

import '../../services/shared_preferences_service.dart';

class AppSettingsCache {
  static final SharedPreferences prefs =
      SharedPreferencesService.instance.prefs;

  static void setThemeMode({required ThemeMode themeMode}) {
    Get.changeThemeMode(themeMode);
    prefs.setString(themeKey, themeMode.name);
  }

  static ThemeMode getThemeMode() {
    var theme = prefs.getString(themeKey);
    if (theme == null) {
      theme = "system";
      setThemeMode(themeMode: ThemeMode.system);
    }
    return EnumToString.fromString(ThemeMode.values, theme)!;
  }
}
