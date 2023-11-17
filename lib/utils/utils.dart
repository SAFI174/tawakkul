import 'dart:io';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';
class Utils {
  static Future<bool> checkForInternetConnection() async {
    final isConnected = await InternetConnection().hasInternetAccess;
    if (isConnected) {
      return true;
    } else {
      return false;
    }
  }

  static Future<void> deleteDirectory({required filePath}) async {
    final dir = Directory(filePath);
    if (await dir.exists()) {
      await dir.delete(recursive: true);
    }
  }

  static Future<bool> getStoragePermission() async {
    DeviceInfoPlugin plugin = DeviceInfoPlugin();
    AndroidDeviceInfo android = await plugin.androidInfo;
    if (android.version.sdkInt < 33) {
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
