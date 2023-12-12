import 'package:get/get.dart';
import 'package:tawakkal/controllers/tafsir_details_controller.dart';
import 'package:tawakkal/data/repository/tafsir_repository.dart';
import 'package:tawakkal/handlers/tafsir_download_handler.dart';

import '../../../../../data/models/tafsir.dart';

class TafsirDownloadManagerController extends GetxController {
  late final Future<List<Tafsir>> tafsirFuture;
  late final TafsirDownloadHandler downloadHandler;

  @override
  void onInit() async {
    super.onInit();

    // Initialize the TafsirDownloadHandler and fetch the list of Tafsirs
    downloadHandler = TafsirDownloadHandler();
    tafsirFuture = TafsirRepository().getTafsirs();
  }

  // Start downloading a Tafsir file.
  Future<void> onDownloadButtonPressed(Tafsir tafsir) async {
    // Set downloading flag to true
    tafsir.isDownloading.value = true;

    // Download the Tafsir file
    tafsir.isDownloaded.value = await downloadHandler.downloadTafsir(
      tafsir: tafsir,
      onReceiveProgress: (count, total) {
        // Update the download progress
        tafsir.downloadProgress.value = ((count / total) * 100).toInt();
      },
    );
    // load data if coming from TafsirDetails
    try {
      var tafsirDetailsController = Get.find<TafsirDetailsController>();
      tafsirDetailsController.loadTafsirDate();
    } catch (e) {}
    // Reset flags and progress after download completion
    tafsir.isDownloading.value = false;
    tafsir.downloadProgress.value = 0;
  }

  // Delete a downloaded Tafsir file.
  void deleteTafsir(Tafsir tafsir) async {
    downloadHandler.deleteDownloadedTafsir(tafsirIdentifier: tafsir.identifier);
  }
}
