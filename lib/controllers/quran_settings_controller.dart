import 'dart:developer';

import 'package:get/get.dart';
import '../data/cache/quran_settings_cache.dart';
import '../data/models/quran_settings_model.dart';
import 'quran_reading_controller.dart';

class QuranSettingsController extends GetxController {
  late final QuranSettingsModel settingsModel;
  QuranReadingController? quranReadingController;

  // Method to handle the switch for marker color
  void onMarkerColorSwitched(bool value) async {
    settingsModel.isMarkerColored = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  void onWordByWordSwitched(bool value) async {
    settingsModel.wordByWordListen = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to handle the change in display font size
  void onDisplayFontSizeChanged(double value) async {
    settingsModel.displayFontSize = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to handle the change in page display option
  void onDisplayOptionChanged(bool isAdaptive) async {
    settingsModel.isAdaptiveView = isAdaptive;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to update the settings cache
  Future<void> _updateSettingsCache() async {
    QuranSettingsCache.setMarkerColor(value: settingsModel.isMarkerColored);

    QuranSettingsCache.setQuranFontSize(
        fontSize: settingsModel.displayFontSize);
    QuranSettingsCache.setQuranAdaptiveView(
        isAdaptiveView: settingsModel.isAdaptiveView);
    QuranSettingsCache.setWordByWordListen(
        isWordByWord: settingsModel.wordByWordListen);

    try {
      quranReadingController = Get.find<QuranReadingController>();

      quranReadingController!.displaySettings = settingsModel;
      quranReadingController!.update();
    } catch (e) {
      log(e.toString());
    }
    update();
  }

  // Method to initialize the controller
  Future<void> init() async {
    settingsModel = QuranSettingsModel();
    settingsModel.isMarkerColored = QuranSettingsCache.isQuranColored();
    settingsModel.isAdaptiveView = QuranSettingsCache.isQuranAdaptiveView();
    settingsModel.displayFontSize = QuranSettingsCache.getQuranFontSize();
    settingsModel.wordByWordListen = QuranSettingsCache.isWordByWordListen();
    update(); // Manually trigger UI update after initialization
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}
