import 'dart:convert';
import 'dart:io';
import 'package:tawakkal/data/cache/quran_reader_cache.dart';

import '../../constants/save_locations.dart';
import '../models/quran_audio_segments.dart';
import '../models/quran_reader.dart';
class SegmentsRepository {
  static List<QuranAudioSegments> segmentsList = [];

  static Future<void> readSegmentData() async {
    segmentsList.clear();
    final QuranReader reader =
         QuranReaderCache.getSelectedReaderFromCache();
    final jsonPath =
        '${await SaveLocationsPaths.getReaderTimingDataLocationUrl()}${reader.identifier}.json';
    final jsonString = await File(jsonPath).readAsString();
    final List<dynamic> jsonData = await jsonDecode(jsonString);
    segmentsList = jsonData.map((e) => QuranAudioSegments.fromJson(e)).toList();
  }

  static Future<int?> getCurrentSegmentWord(
      {required int surahId,
      required verseID,
      required currentPosition}) async {
    List<List<int>> currentVerseSegmet = segmentsList
        .firstWhere(
            (element) => element.surah == surahId && element.ayah == verseID,
            orElse: () => QuranAudioSegments(ayah: 1, segments: [], surah: 1))
        .segments;

    for (var element in currentVerseSegmet) {
      if (element[2] < currentPosition && element[3] > currentPosition) {
        return element[0];
      }
    }
    return null;
  }
}
