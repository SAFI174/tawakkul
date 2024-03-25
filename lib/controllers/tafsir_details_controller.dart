import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:path_provider/path_provider.dart';
import 'package:tawakkal/utils/utils.dart';
import '../../../../../data/models/tafsir_data.dart';

class TafsirDetailsController extends GetxController {
  RxInt surahNumber = RxInt(Get.arguments['surahNumber']);

  RxInt verseNumber = RxInt(Get.arguments['verseNumber']);
  RxList<FileSystemEntity> tafsirsUrls = RxList<FileSystemEntity>();
  RxList<TafsirData> tafsirsData = RxList<TafsirData>();
  RxBool isDataLoaded = RxBool(false);

  Future<void> loadTafsirDate() async {
    tafsirsUrls.clear();
    tafsirsData.clear();
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final downloadPath =
        '${appDocumentsDirectory.path}/downloaded_content/tafsirs';

    try {
      tafsirsUrls.value = Directory("$downloadPath/")
          .listSync()
          .where((element) => element.path.endsWith(".json"))
          .toList();

      await Future.wait(
          tafsirsUrls.map((element) => loadTafsirDataFromFile(element)));
    } catch (e) {
      log(e.toString());
    }
  }

  Future<void> loadTafsirDataFromFile(FileSystemEntity tafsirFile) async {
    final file = File(tafsirFile.path);

    try {
      final jsonString = await file.readAsString();
      tafsirsData.add(TafsirData.fromJson(json.decode(jsonString)));
    } catch (e) {
      log(e.toString());
    }
  }

  void goToNextAyah() {
    if (tafsirsData.isNotEmpty) {
      if (verseNumber.value <
          tafsirsData.first.tafsirLists[surahNumber.value - 1].length) {
        // If there's a next Ayah in the current Surah, go to it.
        verseNumber.value++;
      } else if (surahNumber.value < tafsirsData.first.tafsirLists.length) {
        // If there's a next Surah, go to its first Ayah.
        surahNumber.value++;
        verseNumber.value = 1;
      }
    }
  }

  void copyTafsir(TafsirData tafsirData) async {
    Utils.copyToClipboard(
        text:
            "${getSurahNameArabic(surahNumber.value)} - تفسير الآية ${verseNumber.value} \n${tafsirData.tafsirLists[surahNumber.value - 1][verseNumber.value - 1]} \n ${tafsirData.edition.name}");
  }

  void shareTafsir(TafsirData tafsirData) async {
    Utils.shareText(
        text:
            "${getSurahNameArabic(surahNumber.value)} - تفسير الآية ${verseNumber.value} \n${tafsirData.tafsirLists[surahNumber.value - 1][verseNumber.value - 1]} \n ${tafsirData.edition.name}");
  }

  void goToPreviousAyah() {
    if (tafsirsData.isNotEmpty) {
      if (verseNumber.value > 1) {
        // If there's a previous Ayah in the current Surah, go to it.
        verseNumber.value--;
      } else if (surahNumber.value > 1) {
        // If there's a previous Surah, go to its last Ayah.
        surahNumber.value--;
        verseNumber.value =
            tafsirsData.first.tafsirLists[surahNumber.value - 1].length;
      }
    }
  }

  @override
  void onInit() async {
    await loadTafsirDate();
    super.onInit();
  }
}
