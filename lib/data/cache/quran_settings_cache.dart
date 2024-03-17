import 'package:shared_preferences/shared_preferences.dart';
import 'package:tawakkal/utils/quran_utils.dart';
import '../../constants/cache_keys.dart';
import '../../services/shared_preferences_service.dart';

// A class for managing and caching Quran display settings using GetStorage.
class QuranSettingsCache {
  static final SharedPreferences prefs =
      SharedPreferencesService.instance.prefs;

  // Set the last page index in the cache.
  static void setLastPage({required int pageIndex}) {
    prefs.setInt(lastPageKey, pageIndex);
  }

  static void setWordByWordListen({required bool isWordByWord}) {
    prefs.setBool(isWordByWordKey, isWordByWord);
  }

  static bool isWordByWordListen() {
    var isWordByWord = prefs.getBool(isWordByWordKey);
    if (isWordByWord == null) {
      isWordByWord = true;
      setWordByWordListen(isWordByWord: isWordByWord);
    }
    return isWordByWord;
  }

  // Get the last page index from the cache, default to 1 if not set.
  static int getLastPage() {
    var lastPage = prefs.getInt(lastPageKey);
    if (lastPage == null) {
      lastPage = 1;
      setLastPage(pageIndex: 1);
    }
    return lastPage;
  }

  // Set the Quran font size in the cache.
  static void setQuranFontSize({required double fontSize}) {
    prefs.setDouble(quranFontSizeKey, fontSize);
  }

  // Get the Quran font size from the cache, default to 25.0 if not set.
  static double getQuranFontSize() {
    var fontSize = prefs.getDouble(quranFontSizeKey);
    if (fontSize == null) {
      fontSize = 25.0;
      setQuranFontSize(fontSize: 25.0);
    }
    return fontSize;
  }

  // Set the Quran display type in the cache.
  static void setQuranAdaptiveView({required bool isAdaptiveView}) {
    prefs.setBool(adaptiveViewKey, isAdaptiveView);
  }

  // Get the Quran display type from the cache, default to Mushaf if not set.
  static bool isQuranAdaptiveView() {
    var isAdaptiveView = prefs.getBool(adaptiveViewKey);
    if (isAdaptiveView == null) {
      isAdaptiveView = false;
      setQuranAdaptiveView(isAdaptiveView: isAdaptiveView);
    }
    return isAdaptiveView;
  }

  // Get the marker color setting from the cache, default to true if not set.
  static bool isQuranColored() {
    var isColored = prefs.getBool(isQuranColoredKey);
    if (isColored == null) {
      isColored = true;
      setMarkerColor(value: true);
    }
    return isColored;
  }

  // Set the marker color setting in the cache.
  static void setMarkerColor({required bool value}) {
    prefs.setBool(isQuranColoredKey, value);
  }

  // Set the marker color setting in the cache.
  static Future<void> setQuranPageHeaderHeight() async {
    if (prefs.getDouble(headerHeightKey) != null) {
      return;
    }
    double height = await QuranUtils.getQuranPageHeaderHeight();
    prefs.setDouble(headerHeightKey, height);
  }

  static double getStatusBarHeight() {
    return prefs.getDouble(headerHeightKey)!;
  }
}
