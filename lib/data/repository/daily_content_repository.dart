import 'dart:convert';
import 'dart:math';

import 'package:flutter/services.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tawakkal/constants/cache_keys.dart';
import 'package:tawakkal/constants/json_path.dart';
import 'package:tawakkal/data/models/asmaullah_model.dart';
import 'package:tawakkal/data/repository/asmaullah_repository.dart';

import '../models/daily_content_model.dart';

class DailyContentRepository {
  final GetStorage _box = GetStorage('daily_content');

  // Check if the stored daily content has expired
  Future<bool> isDailyContentExpired() async {
    final contentDateValue = await _box.read(dateAddedKey);

    if (contentDateValue != null) {
      final contentDate = DateTime.parse(contentDateValue);
      final currentDate = DateTime.now();
      return currentDate.day != contentDate.day ||
          currentDate.month != contentDate.month ||
          currentDate.year != contentDate.year;
    }

    // Treat as expired if date is not available
    return true;
  }

  // Save the current date when storing daily content
  Future<void> saveDateOfContent() async {
    _box.write(dateAddedKey, DateTime.now().toIso8601String());
  }

  // Save the provided daily content and update the date
  Future<void> saveDailyContent(DailyContentModel dailyContent) async {
    _box.write(dailyContentKey, dailyContent.toJson());
    await saveDateOfContent();
  }

  // Get the daily content, fetch new data if expired or not available
  Future<DailyContentModel> getDailyContent() async {
    final dynamic json = _box.read(dailyContentKey);

    if (json != null) {
      // Parse the stored content
      final DailyContentModel storedContent =
          DailyContentModel.fromJson(json);

      if (await isDailyContentExpired()) {
        // If the content is expired, fetch new data
        final newContent = await generateNewDailyContent();
        return newContent;
      } else {
        // Return the stored content if it's still valid
        return storedContent;
      }
    }

    // If no content is stored, fetch new data
    return await generateNewDailyContent();
  }

  // Generate new daily content with random data
  Future<DailyContentModel> generateNewDailyContent() async {
    final asmOfAllah = await getRandomAsmOfAllahFromAssets();
    final dua = await getRandomDuaFromAssets();
    final verse = await getRandomVerseFromAssets();
    final generalInfo = await getRandomGeneralDataFromAssets();
    final hadith = await getRandomHadithFromAssets();

    // Create a new DailyContentModel with the generated data
    final newContent = DailyContentModel(
      date: DateTime.now().toIso8601String(),
      asmOfAllah: asmOfAllah,
      dua: dua,
      verse: verse,
      generalInfo: generalInfo,
      hadith: hadith,
    );

    // Save the new content and return it
    await saveDailyContent(newContent);
    return newContent;
  }

  // Fetch a random AsmaullahModel from assets
  Future<AsmaullahModel> getRandomAsmOfAllahFromAssets() async {
    return AsmaullahRepository().getRandomAsmOfAllah();
  }

  // Fetch a random Dua from assets
  Future<String> getRandomDuaFromAssets() async {
    return (await _getRandomContentFromAssets(JsonPaths.dua))['text'];
  }

  // Fetch a random verse from assets
  Future<Map<String, dynamic>> getRandomVerseFromAssets() async {
    return await _getRandomContentFromAssets(JsonPaths.randomVerse);
  }

  // Fetch random general data from assets
  Future<Map<String, dynamic>> getRandomGeneralDataFromAssets() async {
    return await _getRandomContentFromAssets(JsonPaths.generalData);
  }

  // Fetch random Hadith from assets
  Future<Map<String, dynamic>> getRandomHadithFromAssets() async {
    return await _getRandomContentFromAssets(JsonPaths.hadith);
  }

  // Helper method to fetch random content from assets
  Future<Map<String, dynamic>> _getRandomContentFromAssets(
      String jsonPath) async {
    final jsonFile = await rootBundle.loadString(jsonPath);
    final List<dynamic> jsonData = await json.decode(jsonFile);
    final randomNumber = Random().nextInt(jsonData.length - 1);
    return jsonData[randomNumber];
  }
}
