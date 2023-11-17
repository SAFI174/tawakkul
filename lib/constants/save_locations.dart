import 'package:path_provider/path_provider.dart';

import '../utils/utils.dart';

class SaveLocationsPaths {
  // function to handle audio url for saving location

  static Future<String> getAudioSaveLocationUrl(
      {required surahId, required readerIdentifier}) async {
    // check if permisson granted for external storage
    if (await Utils.getStoragePermission()) {
      final appFolder = await getExternalStorageDirectory();
      return '${appFolder!.path}/downloaded_content/audio/$readerIdentifier/$surahId/';
    }
    final appFolder = await getApplicationDocumentsDirectory();
    return '${appFolder.path}/downloaded_content/audio/$readerIdentifier/$surahId/';
  }

  static Future<String> getTafsirSaveLocationUrl() async {
    final appFolder = await getApplicationDocumentsDirectory();
    return '${appFolder.path}/downloaded_content/tafsirs/';
  }
}
