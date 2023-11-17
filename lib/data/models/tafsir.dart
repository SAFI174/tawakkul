
import 'package:get/get.dart';

class Tafsir {
  String? identifier;
  String? name;
  String? englishName;
  RxBool isDownloaded = false.obs;
  RxBool isDownloading = false.obs;
  RxInt downloadProgress = 0.obs;
  String? url;

  Tafsir({this.identifier, this.name, this.englishName, this.url});

  Tafsir.fromJson(Map<String, dynamic> json) {
    identifier = json['identifier'];
    name = json['name'];
    englishName = json['englishName'];
    url = json['url'];
  }
}
