import 'package:expandable/expandable.dart';
import 'package:get/get.dart';
import 'package:tawakkal/data/models/download_surah_model.dart';
import 'package:tawakkal/data/models/quran_reader.dart';
import 'package:tawakkal/handlers/quran_audio_download_handler.dart';
import '../../../../../data/repository/readers_repository.dart';

class QuranAudioDownloadManagerController extends GetxController {
  List<QuranReader> readers = [];
  late final QuranAudioDownloadHandler downloadHandler;
  final ExpandableController expandableController = ExpandableController();

  // Delete downloaded surah for a specific reader
  void onDeleteSurah({required DownloadSurahModel surah, required QuranReader reader}) async {
    downloadHandler.deleteDownloadedSurah(
        surahId: surah.id, readerIdentifier: reader.identifier);
    surah.isDownloaded.value = false;
  }

  // Download all surahs for a specific reader
  void onDownloadAllPressed({required QuranReader reader}) async {
    // Retrieve surah download data if not already available
    reader.surahs ??= await ReadersRepository().getSurahDownloadData(reader: reader);

    // Initialize surah download status for UI
    for (var i = 0; i < 114; i++) {
      reader.surahs![i].isPending.value = true;
    }

    // Start downloading all surahs
    downloadHandler.downloadAllSurah(
      readerIdentifier: reader.identifier,
      onSurahStartDownloading: (surah) {
        reader.surahs![surah].downloadProgress.value = 0;
        reader.surahs![surah].isDownloading.value = true;
        reader.surahs![surah].isPending.value = false;
      },
      surahProgress: (int surahId, int progress) {
        reader.surahs![surahId - 1].downloadProgress.value = progress;
      },
    );
  }

  // Download a single surah for a specific reader
  Future<void> onSurahDownloadPressed(
      {required int readerIndex, required DownloadSurahModel surah}) async {
    surah.isDownloading.value = true;
    surah.isPending.value = false;

    // Start downloading the single surah
    surah.isDownloaded.value = await downloadHandler.downloadSingleSurah(
      surahId: surah.id - 1,
      readerIdentifier: readers[readerIndex].identifier,
      surahProgress: (surahId, progress) {
        surah.downloadProgress.value = progress;
      },
    );

    surah.isDownloading.value = false;
    surah.downloadProgress.value = 0;
  }

  @override
  void onInit() async {
    super.onInit();
    downloadHandler = QuranAudioDownloadHandler();
  }
}
