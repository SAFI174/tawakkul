import 'dart:io';

import 'package:dio/dio.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/constants/urls.dart';

class AudioDownloadService {
  final Dio _dio = Dio();

  Future<void> deleteSurah(
      {required int surahId, required String reader}) async {
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final surahFolder =
        '${appDocumentsDirectory.path}/downloaded_content/audio/$reader/$surahId/';
    final dir = Directory(surahFolder);
    if (dir.existsSync()) {
      dir.deleteSync(recursive: true);
    }
  }

  Future<void> deleteFile({required filePath}) async {
    final dir = Directory(filePath);
    if (await dir.exists()) {
      await dir.delete();
    }
  }

  Future<bool> downloadFile(
      {required url, required String saveLocation}) async {
    // check if file exist first
    if (await File(saveLocation).exists()) {
      // return file is downloaded before
      return true;
    }
    saveLocation += '.tmp';
    try {
      await _dio.download(url, saveLocation);
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

  // Start downloading a specific chapter
  Future<bool> startSurahDownload({
    required int chapterId,
    required Function(int totalVersesProgress)? onReceiveProgress,
    required String readerName,
  }) async {
    try {
      // Get the application's document directory for storing downloaded files
      final appDocumentsDirectory = await getApplicationDocumentsDirectory();
      final surahFolder =
          '${appDocumentsDirectory.path}/downloaded_content/audio/$readerName/$chapterId/';

      int downloadedVerses = 0;
      final totalVerses = getVerseCount(chapterId);

      for (var verseId = 1; verseId <= totalVerses; verseId++) {
        final url =
            '${Urls.audioUrl}$readerName/${chapterId.toString().padLeft(3, '0')}${verseId.toString().padLeft(3, '0')}.mp3';
        final savePath =
            '$surahFolder${path.basenameWithoutExtension(url)}.mp3';

        final existFile = File(savePath);
        if (await existFile.exists()) {
          // File already exists and is complete, skip downloading
          downloadedVerses++;
          onReceiveProgress!((downloadedVerses / totalVerses * 100).toInt());
          continue;
        }
        // Download the MP3 file using the Dio library
        await downloadFile(url: url, saveLocation: savePath);

        // Update download progress
        downloadedVerses++;
        onReceiveProgress!((downloadedVerses / totalVerses * 100).toInt());
      }
      // surah downloaded sucessfully
      return true;
    } catch (e) {
      print(e);
      return false;
    }
  }
}
