import 'dart:convert';

import 'package:adhan/adhan.dart';
import 'package:enum_to_string/enum_to_string.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../constants/cache_keys.dart';
import '../../services/shared_preferences_service.dart';

class PrayerTimeCache {
  static final SharedPreferences prefs =
      SharedPreferencesService.instance.prefs;

  /// Save the selected Madhab to cache.
  static void saveMadhabToCache(Madhab madhab) {
    prefs.setString(madhabKey, madhab.name);
  }

  /// Get the selected Madhab from cache, or save the default and return it.
  static Madhab getMadhabFromCache() {
    var madhab = prefs.getString(madhabKey);
    if (madhab == null) {
      madhab = Madhab.shafi.name;
      saveMadhabToCache(Madhab.shafi);
      return Madhab.shafi;
    }
    return EnumToString.fromString(Madhab.values, madhab)!;
  }

  /// Save the selected calculation method to cache.
  static void saveCalculationMethodToCache(
      CalculationMethod calculationMethod) {
    prefs.setString(calculationMethodKey, calculationMethod.name);
  }

  /// Get the selected calculation method from cache, or save the default and return it.
  static CalculationMethod getCalculationMethodFromCache() {
    var calculationMethod = prefs.getString(calculationMethodKey);
    if (calculationMethod == null) {
      saveCalculationMethodToCache(CalculationMethod.karachi);
      return CalculationMethod.karachi;
    }
    return EnumToString.fromString(
      CalculationMethod.values,
      calculationMethod,
    )!;
  }

  /// Save the current coordinates to cache.
  static void saveCoordinatesToCache(Coordinates coordinates) {
    prefs.setString(coordinatesKey, jsonEncode(toJson(coordinates)));
  }

  /// Get the coordinates from cache or fetch from location if not available.
  static Coordinates? getCoordinatesFromCache() {
    var coordinates = prefs.getString(coordinatesKey);
    if (coordinates == null) {
      return null;
    }
    return fromJson(jsonDecode(coordinates));
  }

  static void savePrayerNotificationMode(
      {required Prayer prayer, required bool notificationMode}) async {
    prefs.setBool(prayer.name, notificationMode);
  }

  static RxBool getPrayerNotificationMode({
    required Prayer prayer,
  }) {
    var notifyMode = prefs.getBool(prayer.name);
    if (notifyMode == null) {
      notifyMode = true;
      savePrayerNotificationMode(prayer: prayer, notificationMode: notifyMode);
    }
    return notifyMode.obs;
  }

  static Map<String, dynamic> toJson(Coordinates coordinates) {
    return {
      'latitude': coordinates.latitude,
      'longitude': coordinates.longitude,
    };
  }

  static Coordinates fromJson(Map<String, dynamic> json) {
    return Coordinates(
      json['latitude']?.toDouble() ?? 0.0,
      json['longitude']?.toDouble() ?? 0.0,
    );
  }
}
