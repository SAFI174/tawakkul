import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tawakkal/constants/json_path.dart';
import 'package:tawakkal/constants/save_locations.dart';
import 'package:tawakkal/data/models/tafsir.dart';

class TafsirRepository {
  Future<List<Tafsir>> getTafsirs() async {
    final filePath = await rootBundle.loadString(JsonPaths.tafsirs);
    final List<dynamic> jsonData = await json.decode(filePath);
    final tafsirData = jsonData.map((e) => Tafsir.fromJson(e)).toList();
    return await checkDownlaodedTafsirs(tafsirData);
  }

  Future<List<Tafsir>> checkDownlaodedTafsirs(List<Tafsir> tafsirs) async {
    for (var element in tafsirs) {
      final fullPath =
          '${await SaveLocationsPaths.getTafsirSaveLocationUrl()}${element.identifier!}.json';
      if (await File(fullPath).exists()) {
        element.isDownloaded.value = true;
      }
    }
    return tafsirs;
  }
}
