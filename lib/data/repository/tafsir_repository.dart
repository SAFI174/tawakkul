// Import the required libraries
import 'dart:convert';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:tawakkal/constants/json_path.dart';
import 'package:tawakkal/constants/save_locations.dart';
import 'package:tawakkal/data/models/tafsir.dart';

// Define a class for the Tafsir repository
class TafsirRepository {
  // Define a method to get the list of Tafsirs from a JSON file
  Future<List<Tafsir>> getTafsirs() async {
    // Load the JSON file from the asset bundle
    final filePath = await rootBundle.loadString(JsonPaths.tafsirs);
    // Decode the JSON data into a list of dynamic objects
    final List<dynamic> jsonData = await json.decode(filePath);
    // Map each dynamic object to a Tafsir object using the fromJson constructor
    final tafsirData = jsonData.map((e) => Tafsir.fromJson(e)).toList();
    // Check if the Tafsirs are downloaded and return the list
    return await checkDownlaodedTafsirs(tafsirData);
  }

  // Define a method to check if the Tafsirs are downloaded
  Future<List<Tafsir>> checkDownlaodedTafsirs(List<Tafsir> tafsirs) async {
    // Loop through each Tafsir in the list
    for (var element in tafsirs) {
      // Construct the full path of the Tafsir JSON file using the identifier
      final fullPath =
          '${await SaveLocationsPaths.getTafsirSaveLocationUrl()}${element.identifier!}.json';
      // Check if the file exists in the local storage
      if (await File(fullPath).exists()) {
        // Set the isDownloaded value of the Tafsir to true
        element.isDownloaded.value = true;
      }
    }
    // Return the updated list of Tafsirs
    return tafsirs;
  }
}
