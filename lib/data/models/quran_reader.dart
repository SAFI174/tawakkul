import 'package:tawakkal/data/models/download_surah_model.dart';

class QuranReader {
  late String identifier;
  late String name;
  late String englishName;
  late String timingDataUrl;
  List<DownloadSurahModel>? surahs;
  QuranReader({
    this.identifier = '',
    this.name = '',
    this.englishName = '',
    this.surahs,
  });

  QuranReader.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    name = json['name'];
    englishName = json['englishName'];
    timingDataUrl = json['timingDataUrl'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['identifier'] = identifier;
    data['name'] = name;
    data['englishName'] = englishName;
    data['timingDataUrl'] = timingDataUrl;
    return data;
  }
}
