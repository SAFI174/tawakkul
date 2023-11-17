import 'package:get/get.dart';

class DownloadSurahModel {
  final int id;
  RxBool isDownloaded;
  RxInt downloadProgress;
  RxBool isDownloading;
  RxBool isPending;

  DownloadSurahModel({
    required this.id,
    required this.isDownloaded,
    required this.downloadProgress,
    required this.isDownloading,
    required this.isPending,
  });
}