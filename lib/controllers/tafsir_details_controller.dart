import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';
import 'package:share_plus/share_plus.dart';
import 'package:path_provider/path_provider.dart';
import '../../../../../data/models/tafsir_data.dart';

class TafsirDetailsController extends GetxController {
  RxInt surahNumber = RxInt(Get.arguments['surahNumber']);

  RxInt verseNumber = RxInt(Get.arguments['verseNumber']);
  RxList<FileSystemEntity> tafsirsUrls = RxList<FileSystemEntity>();
  RxList<TafsirData> tafsirsData = RxList<TafsirData>();
  RxBool isDataLoaded = RxBool(false);

  Future<void> getTafsirsUrls() async {
    tafsirsUrls.value = [];
    tafsirsData.value = [];
    final appDocumentsDirectory = await getApplicationDocumentsDirectory();
    final downloadPath =
        '${appDocumentsDirectory.path}/downloaded_content/tafsirs';
    try {
      tafsirsUrls.addAll(
        Directory("$downloadPath/").listSync().where(
              (element) => element.path.endsWith(".json"),
            ),
      );
      await Future.delayed(const Duration(milliseconds: 1500));

      tafsirsUrls.forEach((element) async {
        await loadTafsirData(element);
      });
    } catch (e) {
      print(e);
    }
  }

  Future<void> loadTafsirData(FileSystemEntity tafsirFile) async {
    final file = File(tafsirFile.path);

    // Read the JSON data from the file.
    final jsonString = await file.readAsString();
    // You can now work with the jsonData, which is a Map<String, dynamic>.
    tafsirsData.add(TafsirData.fromJson(json.decode(jsonString)));
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
    await Clipboard.setData(ClipboardData(
        text:
            "${getSurahNameArabic(surahNumber.value)} - تفسير الآية ${verseNumber.value} \n${tafsirData.tafsirLists[surahNumber.value - 1][verseNumber.value - 1]} \n ${tafsirData.edition.name}"));
  }

  void shareTafsir(TafsirData tafsirData) async {
    await Share.share(
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
    await getTafsirsUrls();
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
}
