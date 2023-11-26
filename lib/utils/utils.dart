import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/services.dart';
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
