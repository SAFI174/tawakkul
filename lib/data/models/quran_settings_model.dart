class QuranSettingsModel {
  bool isMarkerColored;
  bool isDarkMode;
  double displayFontSize;
  int pageDisplayOption;

  QuranSettingsModel({
    this.isMarkerColored = true,
    this.isDarkMode = false,
    this.displayFontSize = 16.0,
    this.pageDisplayOption = 0,
  });
}
