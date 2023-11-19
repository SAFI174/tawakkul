import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:tawakkal/constants/json_path.dart';

import '../models/quran_audio_segments.dart';
import 'readers_repository.dart';

class SegmentsRepository extends GetxController {
  List<QuranAudioSegments> segmentsList = [];
  @override
  void onInit() async {
    WidgetsFlutterBinding.ensureInitialized();
    super.onInit();
  }

  Future<void> loadQuranDataFromAsset() async {
    segmentsList.clear();
    final reader = await ReadersRepository().getSelectedReaderFromCache();

    await Future.delayed(const Duration(milliseconds: 500));
    final String jsonString = await rootBundle
        .loadString('${JsonPaths.audioSegments}${reader.identifier}.json');
    final List<dynamic> jsonData = await jsonDecode(jsonString);
    segmentsList = jsonData.map((e) => QuranAudioSegments.fromJson(e)).toList();
  }

  Future<int?> getCurrentSegmentWord(
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
