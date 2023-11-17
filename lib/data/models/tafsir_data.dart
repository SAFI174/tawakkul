import 'package:get/get.dart';

class Edition {
  String identifier;
  String name;
  String englishName;

  Edition({
    required this.identifier,
    required this.name,
    required this.englishName,
  });

  factory Edition.fromJson(Map<String, dynamic> json) {
    return Edition(
      identifier: json['identifier'],
      name: json['name'],
      englishName: json['englishName'],
    );
  }
}

class TafsirData {
  RxList<List<String>> tafsirLists;
  Edition edition;

  TafsirData({
    required this.tafsirLists,
    required this.edition,
  });

  factory TafsirData.fromJson(Map<String, dynamic> json) {
    List<RxList<String>> tafsirLists = [];
    if (json['tafsir'] != null) {
      for (var item in json['tafsir']) {
        RxList<String> surahTexts = RxList<String>.from(item);
        tafsirLists.add(surahTexts);
      }
    }
    return TafsirData(
      tafsirLists: tafsirLists.obs,
      edition: Edition.fromJson(json['edition']),
    );
  }
}
