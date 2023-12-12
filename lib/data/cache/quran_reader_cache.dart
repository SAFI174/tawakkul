import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../services/shared_preferences_service.dart';
import '../models/quran_reader.dart';

class QuranReaderCache {
  // Access SharedPreferences from SharedPreferencesService
  static final SharedPreferences prefs =
      SharedPreferencesService.instance.prefs;

  // Default Quran reader with Abdul Basit (Mujawwad) as the initial if no Reader Selected
  static final defaultReader = QuranReader(
    identifier: "Abdul_Basit_Mujawwad_128kbps",
    englishName: "Abdul Basit (Mujawwad)",
    name: "عبدالباسط عبدالصمد (مجود)",
    timingDataUrl:
        "https://gitea.com/mostafamasri/quran_timing_data/raw/branch/main/Abdul_Basit_Mujawwad_128kbps.json",
  );

  // Key for storing the selected Quran reader in local cache
  static const String readerKey = 'selectedQuranReader';

  // Save the selected Quran reader to local cache
  static Future<void> saveSelectedReaderToCache(QuranReader reader) async {
    prefs.setString(readerKey, jsonEncode(reader.toJson()));
  }

  // Get the selected Quran reader from local cache; set default if not present
  static QuranReader getSelectedReaderFromCache() {
    var selectedReader = prefs.getString(readerKey);

    // If selected reader is not present, set default and save to cache
    if (selectedReader == null) {
      saveSelectedReaderToCache(defaultReader);
      selectedReader = jsonEncode(defaultReader.toJson());
    }

    // Decode the JSON string and create a QuranReader object
    final quranReader = QuranReader.fromJson(jsonDecode(selectedReader));
    return quranReader;
  }
}
