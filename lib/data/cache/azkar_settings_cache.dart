import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/cache_keys.dart';
import '../../services/shared_preferences_service.dart';

class AzkarSettingsCache {
  static final SharedPreferences prefs =
      SharedPreferencesService.instance.prefs;

  // Setters
  static void setFontSize(double fontSize) {
    prefs.setDouble(azkarFontSizeKey, fontSize);
  }

  static void setShowExitConfirmDialog(bool showExitConfirmDialog) {
    prefs.setBool(exitConfirmDialogKey, showExitConfirmDialog);
  }

  static void setShowNotification(bool showNotification) {
    prefs.setBool(showNotificationKey, showNotification);
  }

  static void setMorningTime(TimeOfDay morningTime) {
    prefs.setString(morningTimeKey, _timeOfDayToString(morningTime));
  }

  static void setNightTime(TimeOfDay nightTime) {
    prefs.setString(nightTimeKey, _timeOfDayToString(nightTime));
  }

  static void setSleepTime(TimeOfDay sleepTime) {
    prefs.setString(sleepTimeKey, _timeOfDayToString(sleepTime));
  }

  // Getters
  static double getFontSize() {
    return prefs.getDouble(azkarFontSizeKey) ?? 16;
  }

  static bool getShowExitConfirmDialog() {
    return prefs.getBool(exitConfirmDialogKey) ?? true;
  }

  static bool getShowNotification() {
    return prefs.getBool(showNotificationKey) ?? true;
  }

  static TimeOfDay getMorningTime() {
    final timeAsString = prefs.getString(morningTimeKey);
    return _stringToTimeOfDay(timeAsString) ??
        const TimeOfDay(hour: 8, minute: 0);
  }

  static TimeOfDay getNightTime() {
    final timeAsString = prefs.getString(nightTimeKey);
    return _stringToTimeOfDay(timeAsString) ??
        const TimeOfDay(hour: 20, minute: 0);
  }

  static TimeOfDay getSleepTime() {
    final timeAsString = prefs.getString(sleepTimeKey);
    return _stringToTimeOfDay(timeAsString) ??
        const TimeOfDay(hour: 23, minute: 0);
  }

  // Helper methods
  static String _timeOfDayToString(TimeOfDay timeOfDay) {
    return '${timeOfDay.hour}:${timeOfDay.minute}';
  }

  static TimeOfDay? _stringToTimeOfDay(String? timeAsString) {
    if (timeAsString != null) {
      final List<String> parts = timeAsString.split(':');
      return TimeOfDay(hour: int.parse(parts[0]), minute: int.parse(parts[1]));
    }
    return null;
  }
}
