import 'dart:io';
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_qiblah_update/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:jhijri/jHijri.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
import 'package:share_plus/share_plus.dart';

class Utils {
  // Check for internet connection
  static Future<bool> checkForInternetConnection() async {
    final isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      return true;
    } else {
      return false;
    }
  }

  static DateTime scheduleDateTime(TimeOfDay time) {
    final now = DateTime.now();
    DateTime scheduledDateTime =
        DateTime(now.year, now.month, now.day, time.hour, time.minute);

    if (scheduledDateTime.isBefore(now)) {
      // If the scheduled time is in the past, add one day
      scheduledDateTime = scheduledDateTime.add(Duration(days: 1));
    }

    return scheduledDateTime;
  }

  static String themeModeToArabicText(ThemeMode theme) {
    switch (theme) {
      case ThemeMode.dark:
        return 'داكن';
      case ThemeMode.light:
        return 'فاتح';
      default:
        return 'السمة الإفتراضية للجهاز';
    }
  }

  static String getCurrentDate() {
    var now = DateTime.now();
    var formatter = DateFormat.yMMMd('ar_SA');

    return formatter.format(now);
  }

  static String getCurrentDateHijri() {
    return ArabicNumbers().convert(
      HijriDate.now().toString(),
    );
  }

  static Future<bool> requestLocationPermission() async {
    var status = await Geolocator.requestPermission();

    if (status == LocationPermission.whileInUse) {
      return true;
    } else if (status == LocationPermission.always) {
      return true;
    } else if (status == LocationPermission.denied) {
      // The permission was denied.
      return false;
    } else if (status == LocationPermission.deniedForever) {
      // The permission was permanently denied.
      openAppSettings();
      return false;
    }

    return false;
  }

  /// get location status: GPS enabled and the permission status with GeolocationStatus
  static Future<LocationStatus> checkLocationStatus() async {
    final status = await Geolocator.checkPermission();
    final enabled = await Geolocator.isLocationServiceEnabled();
    return LocationStatus(enabled, status);
  }

  // Method to check and handle location status
  static Future<LocationStatus> handleLocationStatus() async {
    // Check current location status
    final locationStatus = await Utils.checkLocationStatus();

    // If location is not enabled, open location settings and update status
    if (!locationStatus.enabled) {
      await Geolocator.openLocationSettings();
      final updatedStatus = await Utils.checkLocationStatus();
      return updatedStatus;
    }

    // If location is enabled but permission is denied, request permission and handle accordingly
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await Geolocator.requestPermission();
      var updatedStatus = await Utils.checkLocationStatus();

      if (updatedStatus.status == LocationPermission.denied) {
        // If permission is still denied, open app settings
        await Geolocator.openAppSettings();
      }

      // Check location status again and update the stream
      updatedStatus = await Utils.checkLocationStatus();
      return updatedStatus;
    } else {
      // If location is enabled and permission is granted, update the stream
      return locationStatus;
    }
  }

  static String formatDurationToArabic(Duration duration) {
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;

    String hoursText = (hours > 0) ? '$hours ساعة' : '';
    String minutesText = (minutes > 0) ? '$minutes دقيقة' : '';

    if (hours > 0 && minutes > 0) {
      return '$hoursText و $minutesText';
    } else {
      return '$hoursText$minutesText';
    }
  }

  static Future<Position?> getCurrentLocation() async {
    bool hasPermission = await requestLocationPermission();

    if (hasPermission) {
      try {
        return await Geolocator.getCurrentPosition();
      } catch (e) {
        print('Error getting location: $e');
        return null;
      }
    } else {
      return null;
    }
  }

  // Delete a directory
  static Future<void> deleteDirectory({required filePath}) async {
    final dir = Directory(filePath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  // Copy text to clipboard
  static Future<void> copyToClipboard({required text}) async {
    await Clipboard.setData(
      ClipboardData(text: text),
    );
  }

  // Share text
  static Future<void> shareText({required text}) async {
    await Share.share(text);
  }

  // Get storage permission
  static Future<bool> getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;

    // Check the Android version for different permission request approaches
    if (android.version.sdkInt < 33) {
      // For Android versions below 33
      if (await Permission.storage.request().isGranted) {
        return true;
      } else if (await Permission.storage.request().isPermanentlyDenied) {
        await openAppSettings();
        if (await Permission.storage.status.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    } else {
      // For Android versions 33 and above
      if (await Permission.photos.request().isGranted) {
        return true;
      } else if (await Permission.photos.request().isPermanentlyDenied) {
        await openAppSettings();
        if (await Permission.photos.status.isGranted) {
          return true;
        } else {
          return false;
        }
      } else {
        return false;
      }
    }
  }
}
