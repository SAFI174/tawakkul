import 'package:quran/quran.dart';
import 'package:tawakkal/constants/save_locations.dart';
import 'package:tawakkal/constants/urls.dart';
import 'package:tawakkal/data/models/quran_reader.dart';
import 'package:tawakkal/handlers/reader_timing_data_download_handler.dart';
import 'package:tawakkal/services/download_service.dart';
import 'package:tawakkal/utils/dialogs/dialogs.dart';
import 'package:tawakkal/utils/utils.dart';

class QuranAudioDownloadHandler {
  // Delete the downloaded folder for a specific surah
  static Future<void> deleteDownloadedSurah(
      {required int surahId, required String readerIdentifier}) async {
    Utils.deleteDirectory(
      filePath: await SaveLocationsPaths.getAudioSaveLocationUrl(
        surahId: surahId,
        readerIdentifier: readerIdentifier,
      ),
    );
  }

  // Download all surahs one by one
  static Future<void> downloadAllSurah({
    required QuranReader reader,
    required Function(int surah, int progress) surahProgress,
    required Function(int surah) onSurahStartDownloading,
  }) async {
    for (var surahId = 0; surahId < 114; surahId++) {
      onSurahStartDownloading(surahId);
      await downloadSingleSurah(
          surahId: surahId, reader: reader, surahProgress: surahProgress);
    }
  }

  // Download a single surah, verse by verse
  static Future<bool> downloadSingleSurah(
      {required int surahId,
      required QuranReader reader,
      required Function(int surah, int progress) surahProgress}) async {
    if (await ReaderTimingDataDownloadHandler.checkIfDataExists(
        reader: reader)) {
      if (await Utils.checkForInternetConnection()) {
        // Increment surahId to match the Quran numbering
        surahId++;
        int downloadedVerses = 0;
        int totalVerseToDownload = getVerseCount(surahId);

        for (var verse = 1; verse <= totalVerseToDownload; verse++) {
          // Get the save location for the audio file
          final audioSaveFolder =
              await SaveLocationsPaths.getAudioSaveLocationUrl(
            readerIdentifier: reader.identifier,
            surahId: surahId,
          );

          // Generate the file name based on surah and verse numbers
          var fileName =
              '${surahId.toString().padLeft(3, '0')}${verse.toString().padLeft(3, '0')}.mp3';

          // Construct the download URL for the current verse
          final downloadUrl = '${Urls.audioUrl}${reader.identifier}/$fileName';

          // Start downloading the verse
          await DownloadService().downloadFile(
            url: downloadUrl,
            saveLocation: audioSaveFolder,
            fileName: fileName,
          );

          downloadedVerses++;

          // Report progress for the current surah
          surahProgress(surahId,
              ((downloadedVerses / totalVerseToDownload) * 100).toInt());
        }

        return true;
      } else {
        // Show a dialog if there is no internet connection
        showNoInternetDialog();
        return false;
      }
    } else {
      return false;
    }
  }
}
