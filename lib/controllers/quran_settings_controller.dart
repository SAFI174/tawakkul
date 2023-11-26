import 'package:get/get.dart';
import '../../constants/enum.dart';
import '../data/cache/quran_settings.dart';
import '../data/models/quran_settings_model.dart';
import 'quran_reading_controller.dart';

class QuranSettingsController extends GetxController {
  late final QuranSettingsModel settingsModel;
  late final QuranSettingsCache settingsCache;
  QuranReadingController? quranReadingController;

  // Method to handle the switch for marker color
  void onMarkerColorSwitched(bool value) async {
    settingsModel.isMarkerColored = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to handle the switch for dark mode
  // void onThemeSwitched(bool value) async {
  //   settingsModel.isDarkMode = value;
  //   await _updateSettingsCache(); // Update settings cache
  //   update(); // Manually trigger UI update
  // }

  // Method to handle the change in display font size
  void onDisplayFontSizeChanged(double value) async {
    settingsModel.displayFontSize = value;
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to handle the change in page display option
  void onDisplayOptionChanged(int value) async {
    settingsModel.displayOption = QuranDisplayOption.values[value];
    await _updateSettingsCache(); // Update settings cache
    update(); // Manually trigger UI update
  }

  // Method to update the settings cache
  Future<void> _updateSettingsCache() async {
    await settingsCache.setMarkerColor(value: settingsModel.isMarkerColored);

    await settingsCache.setQuranFontSize(
        fontSize: settingsModel.displayFontSize);
    await settingsCache.setQuranDisplayType(
        quranDisplay: settingsModel.displayOption);
    if (quranReadingController != null) {
      quranReadingController!.displaySettings = settingsModel;
      quranReadingController!.update();
    }
    update();
  }

  // Method to initialize the controller
  Future<void> init() async {
    settingsModel = QuranSettingsModel();
    settingsCache = QuranSettingsCache();
    settingsModel.isMarkerColored = await settingsCache.getMarkerColor();
    settingsModel.displayOption = await settingsCache.getQuranDisplayType();
    settingsModel.displayFontSize = await settingsCache.getQuranFontSize();
    quranReadingController = Get.find<QuranReadingController>();
    update(); // Manually trigger UI update after initialization
  }

  @override
  void onInit() {
    super.onInit();
    init();
  }
}
