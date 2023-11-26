import 'dart:io';
import 'package:get/get.dart';
import 'package:tawakkal/constants/save_locations.dart';
import 'package:tawakkal/data/models/quran_reader.dart';
import 'package:tawakkal/utils/dialogs/dialogs.dart';
import 'package:tawakkal/utils/dialogs/timing_data_download_dialog.dart';
import 'package:tawakkal/utils/utils.dart';
import 'package:path/path.dart' as path;
import '../services/download_service.dart';

class ReaderTimingDataDownloadHandler {
  static Future<bool> checkIfDataExists({
    required QuranReader reader,
  }) async {
    final saveLocation =
        await SaveLocationsPaths.getReaderTimingDataLocationUrl();
    final fileName = '${reader.identifier}.json';
    // check if file exist first
    if (await File(saveLocation + fileName).exists()) {
      // return file is downloaded before
      return true;
    }
    if (await showAskUserForDownloadTimingData()) {
      return await Get.dialog(
        TimingDataDownloadDialog(reader: reader),
        barrierDismissible: false,
      );
    } else {
      return false;
    }
  }

  static Future<bool> downloadData({
    required QuranReader reader,
    Function(int count, int total)? onReceiveProgress,
  }) async {
    if (await Utils.checkForInternetConnection()) {
      final saveLocation =
          await SaveLocationsPaths.getReaderTimingDataLocationUrl();
      final fileName = '${reader.identifier}.json';
      return await DownloadService().downloadFile(
        url: reader.timingDataUrl,
        saveLocation: saveLocation,
        fileName: fileName,
        onReceiveProgress: onReceiveProgress,
      );
    }
    await showNoInternetDialog();
    return false;
  }
}
