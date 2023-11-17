import 'dart:io';
import 'package:path/path.dart' as path;
import 'package:dio/dio.dart';

class DownloadService {
  late final Dio _dio;
  DownloadService() {
    _dio = Dio();
  }

  Future<bool> downloadFile(
      {required url,
      required String saveLocation,
      required String fileName,
      Function(int count, int total)? onReceiveProgress}) async {

    // check if file exist first
    if (await File(saveLocation + fileName).exists()) {
      // return file is downloaded before
      return true;
    }
    saveLocation += '$fileName.tmp';
    try {
      await _dio.download(url, saveLocation,
          onReceiveProgress: onReceiveProgress);
      // Rename the temporary file to the final destination
      File(saveLocation)
          .renameSync('${path.dirname(saveLocation)}/${path.basename(url)}');
      // return the file successfully downloaded
      return true;
    } catch (e) {
      // return somthing happend and download failed
      return false;
    }
  }
}
