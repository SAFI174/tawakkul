import 'dart:io';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/foundation.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/constants/save_locations.dart';
import 'package:tawakkal/constants/urls.dart';
import 'package:tawakkal/data/models/quran_play_range_model.dart';
import 'package:tawakkal/utils/extension.dart';
import '../cache/quran_reader_cache.dart';
// Create a playlist of MediaItems from a specified range of verses
Future<List<MediaItem>> createPlaylistFromRange(
    QuranPlayRangeModel playRangeModel) async {
  final reader = QuranReaderCache.getSelectedReaderFromCache();
  List<MediaItem> mediaItemList = [];

  // Iterate through the specified range of surahs and verses
  for (int surahId = playRangeModel.startSurah;
  surahId <= playRangeModel.endsSurah;
  surahId++) {
    for (int verseId = (surahId == playRangeModel.startSurah
        ? playRangeModel.startVerse
        : 1);
    verseId <=
        (surahId == playRangeModel.endsSurah
            ? playRangeModel.endsVerse
            : getVerseCount(surahId));
    verseId++) {
      if (kIsWeb) {
        // Create MediaItem for web platform
        final audioUrl = await getAudioFileUrl(surahId, verseId);
        mediaItemList.add(
          MediaItem(
            id: audioUrl,
            title: '${surahId.getSurahNameOnlyArabicSimple} - $verseId',
            album: surahId.getSurahNameOnlyArabicSimple,
            artist: reader.name,
            extras: {
              'surah': surahId,
              'verse': verseId,
              'source': 'network',
            },
          ),
        );
      } else {
        // Create MediaItem for non-web platforms
        final audioFilePath = await getLocalAudioFilePath(surahId, verseId);

        // Check if the local audio file exists
        if (await localAudioFileExists(audioFilePath)) {
          mediaItemList.add(
            MediaItem(
              id: audioFilePath,
              title: '${surahId.getSurahNameOnlyArabicSimple} - $verseId',
              album: surahId.getSurahNameOnlyArabicSimple,
              artist: reader.name,
              extras: {
                'surah': surahId,
                'verse': verseId,
                'source': 'local',
              },
            ),
          );
        } else {
          // Use network audio URL if local file doesn't exist
          final audioUrl = await getAudioFileUrl(surahId, verseId);
          mediaItemList.add(
            MediaItem(
              id: audioUrl,
              title: '${surahId.getSurahNameOnlyArabicSimple} - $verseId',
              album: surahId.getSurahNameOnlyArabicSimple,
              artist: reader.name,
              extras: {
                'surah': surahId,
                'verse': verseId,
                'source': 'network',
              },
            ),
          );
        }
      }
    }
  }

  return mediaItemList;
}

// Check if a local audio file exists
Future<bool> localAudioFileExists(String filePath) async {
  return await File(filePath).exists();
}

// Get the local path for the audio file based on surah and verse IDs
Future<String> getLocalAudioFilePath(int surahId, int verseId) async {
  final reader = QuranReaderCache.getSelectedReaderFromCache();

  final audioContent =
      '${await SaveLocationsPaths.getAudioSaveLocationUrl(surahId: surahId, readerIdentifier: reader.identifier)}${surahId.toString().padLeft(3, '0')}${verseId.toString().padLeft(3, '0')}.mp3';
  return audioContent;
}

// Get the audio file URL based on surah and verse IDs
Future<String> getAudioFileUrl(int surahId, int verseId) async {
  final reader = QuranReaderCache.getSelectedReaderFromCache();

  // Implement logic to generate the download URL based on surah and verse IDs
  return '${Urls.audioUrl}${reader.identifier}/${surahId.toString().padLeft(3, '0')}${verseId.toString().padLeft(3, '0')}.mp3';
}
