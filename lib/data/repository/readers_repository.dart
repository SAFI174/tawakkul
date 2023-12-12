import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/constants/json_path.dart';
import 'package:tawakkal/constants/save_locations.dart';
import 'package:tawakkal/data/models/download_surah_model.dart';
import '../models/quran_reader.dart';

class ReadersRepository {


  // Fetch Quran readers from JSON file
  Future<List<QuranReader>> getQuranReaders() async {
    final jsonFile = await rootBundle.loadString(JsonPaths.quranReaders);
    final List<dynamic> jsonData = json.decode(jsonFile);
    return jsonData.map((e) => QuranReader.fromJson(e)).toList();
  }

 
  // Get download data for all Surahs of the selected Quran reader
  Future<List<DownloadSurahModel>> getSurahDownloadData(
      {required QuranReader reader}) async {
    await Future.delayed(const Duration(milliseconds: 500));

    List<DownloadSurahModel> surah = [];
    for (var i = 1; i <= 114; i++) {
      final isSurahDownloaded =
          await checkSurahFilesIfDownloaded(reader: reader, surahId: i);
      surah.add(
        DownloadSurahModel(
          id: i,
          isDownloaded: isSurahDownloaded.obs,
          downloadProgress: 0.obs,
          isDownloading: false.obs,
          isPending: false.obs,
        ),
      );
    }

    return surah;
  }

  // Check if files for a specific Surah of the selected Quran reader are downloaded
  Future<bool> checkSurahFilesIfDownloaded(
      {required QuranReader reader, required int surahId}) async {
    final surahFolder = await SaveLocationsPaths.getAudioSaveLocationUrl(
        surahId: surahId, readerIdentifier: reader.identifier);
    Directory directory = Directory(surahFolder);

    if (directory.existsSync()) {
      List<FileSystemEntity> files = directory.listSync();

      int mp3FileCount = 0;
      for (FileSystemEntity file in files) {
        if (file is File && file.path.toLowerCase().endsWith('.mp3')) {
          mp3FileCount++;
        }
      }
      return mp3FileCount == getVerseCount(surahId);
    }

    return false;
  }

}
