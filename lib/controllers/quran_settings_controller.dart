import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../constants/enum.dart';
import '../data/cache/quran_settings.dart';
import '../data/models/quran_settings_model.dart';
import 'quran_reading_controller.dart';

class QuranSettingsController extends GetxController {
  late final QuranSettingsModel settingsModel;
  late final QuranSettingsCache settingsCache;
  late final QuranReadingController quranPageViewController;

  // Method to handle the switch for marker color
  void onMarkerColorSwitched(bool value) async {
    settingsModel.isMarkerColored = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to handle the switch for dark mode
  void onThemeSwitched(bool value) async {
    settingsModel.isDarkMode = value;
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
  void onDisplayOptionChanged(int value) async {
    settingsModel.pageDisplayOption = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to update the settings cache
  Future<void> _updateSettingsCache() async {
    await settingsCache.setMarkerColor(value: settingsModel.isMarkerColored);
    await settingsCache.setThemeMode(
        themeMode: settingsModel.isDarkMode ? ThemeMode.dark : ThemeMode.light);
    await settingsCache.setQuranFontSize(
        fontSize: settingsModel.displayFontSize);
    await settingsCache.setQuranDisplayType(
        quranDisplay: QuranDisplayEnum.values[settingsModel.pageDisplayOption]);
    quranPageViewController.isMarkerColored.value =
        settingsModel.isMarkerColored;
    quranPageViewController.quranDisplayEnum.value =
        QuranDisplayEnum.values[settingsModel.pageDisplayOption];
    quranPageViewController.quranFontSize.value = settingsModel.displayFontSize;
  }

  // Method to initialize the controller
  Future<void> init() async {
    settingsModel = QuranSettingsModel();
    settingsCache = QuranSettingsCache();
    settingsModel.isMarkerColored = await settingsCache.getMarkerColor();
    settingsModel.isDarkMode =
        (await settingsCache.getThemeMode()) == ThemeMode.dark;
    settingsModel.pageDisplayOption =
        (await settingsCache.getQuranDisplayType()).index;
    settingsModel.displayFontSize = await settingsCache.getQuranFontSize();
    quranPageViewController = Get.find();
    update(); // Manually trigger UI update after initialization
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}
