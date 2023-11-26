import 'package:tawakkal/constants/enum.dart';

class QuranSettingsModel {
  bool isMarkerColored;
  double displayFontSize;
  QuranDisplayOption displayOption;

  QuranSettingsModel({
    this.isMarkerColored = true,
    this.displayFontSize = 16.0,
    this.displayOption = QuranDisplayOption.mushaf,
  });
}
