import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:quran/quran.dart';
import '../../../../../data/models/quran_page.dart';
import '../../../../../data/models/quran_reader.dart';
import '../../../../../data/repository/readers_repository.dart';
import '../data/cache/audio_settings_cache.dart';
import '../data/models/quran_play_range_model.dart';

class QuranAudioSettingsController extends GetxController {
  late final AudioSettingsCache cacheManager;
  late final QuranPageModel currentPageData;
  late QuranReader quranReader;
  late QuranPlayRangeModel playRange;

  String selectedRange = '';

  List<String> rangeSpeedChoice = [
    'صفحة',
    'سورة',
    'جزء',
    'الكل',
  ];
  String selectedSpeed = '';

  Map<double, String> speedChoice = {
    0.5: '0.5x',
    0.75: '0.75x',
    1: '1x',
    1.25: '1,25x',
    1.5: '1,5x',
    1.75: '1,75x',
  };
  String selectedRepeat = '';

  Map<int, String> repeatChoice = {
    1: 'مرة',
    2: 'مرتين',
    3: '3 مرات',
    4: '4 مرات',
    5: '5 مرات',
  };

  @override
  void onInit() async {
    super.onInit();
    quranReader = QuranReader();
    playRange = QuranPlayRangeModel();
    quranReader = await ReadersRepository().getSelectedReaderFromCache();
    playRange = await AudioSettingsCache().getQuranPlayRange();

    cacheManager = AudioSettingsCache();
    initSettings();
    currentPageData = Get.arguments!;

    update();
  }

  @override
  void onReady() async {
    super.onReady();
    // Get the selected reader from cache and listen for changes
    listenForReaderChanges();
  }

  // Init settings data
  void initSettings() async {
    playRange = await AudioSettingsCache().getQuranPlayRange();
    selectedRepeat = repeatChoice[await cacheManager.getRepeat()].toString();
    selectedSpeed = speedChoice[await cacheManager.getSpeed()].toString();
  }

  // save all settings and exit
  void onSaveAllPressed() async {
    // Get the selected speed and repeat values
    double speed = speedChoice.keys
        .firstWhere((element) => speedChoice[element] == selectedSpeed);
    int repeat = repeatChoice.keys
        .firstWhere((element) => repeatChoice[element] == selectedRepeat);

    // Save the Quran play range, speed, and repeat to cache
    // await cacheManager.setQuranPlayRange(playRange: playRange);
    await cacheManager.saveSpeed(speed: speed);
    await cacheManager.saveRepeat(repeatTimes: repeat);
    await cacheManager.saveQuranPlayRange(playRange: playRange);
    // Close the settings page
    Get.back();
  }

  //keep listen if the reader changed
  void listenForReaderChanges() {
    // Listen for changes to the selected reader
    GetStorage('audio_settings').listenKey(ReadersRepository.readerKey,
        (value) {
      quranReader = value;
      update();
    });
  }

  // Reset all settings to default
  void onResetSettingsPressed() async {
    await cacheManager.resetSettings();
    initSettings();
    update();
  }

// Handle range choice changes
  void onRangeChoiceChanged(String? value) {
    selectedRange = value ?? '';

    // Set the Quran play range based on the selected range
    switch (selectedRange) {
      case 'صفحة':
        setQuranPlayRangeForPage();
        update();
        break;
      case 'سورة':
        setQuranPlayRangeForSurah();
        update();

        break;
      case 'جزء':
        setQuranPlayRangeForJuz();
        update();

        break;
      default:
        setQuranPlayRangeForAll();
        update();
    }
  }

// Set the play range for a specific page
  void setQuranPlayRangeForPage() {
    final startVerse = currentPageData.verses.first.verseNumber;
    final lastVerse = currentPageData.verses.last.verseNumber;
    final startSurah = currentPageData.verses.first.surahNumber;
    final lastSurah = currentPageData.verses.last.surahNumber;

    setQuranPlayRange(
        playRange: QuranPlayRangeModel(
      startSurah: startSurah,
      startVerse: startVerse,
      endsSurah: lastSurah,
      endsVerse: lastVerse,
    ));
    update();
  }

// Set the play range for a specific surah
  void setQuranPlayRangeForSurah() {
    final startSurah = currentPageData.verses.first.surahNumber;

    setQuranPlayRange(
        playRange: QuranPlayRangeModel(
      startSurah: startSurah,
      startVerse: 1,
      endsSurah: startSurah,
      endsVerse: getVerseCount(startSurah),
    ));
  }

// Set the play range for a specific juz
  void setQuranPlayRangeForJuz() {
    final juzNumber = currentPageData.verses!.first.juzNumber;
    final juzData = getSurahAndVersesFromJuz(juzNumber);
    final startSurah = juzData.keys.first;
    final startVerse = juzData.values.first[0];
    final lastVerse = juzData.values.last[1];
    final lastSurah = juzData.keys.last;

    setQuranPlayRange(
        playRange: QuranPlayRangeModel(
      startSurah: startSurah,
      startVerse: startVerse,
      endsSurah: lastSurah,
      endsVerse: lastVerse,
    ));
  }

// Set the play range for the entire Quran
  void setQuranPlayRangeForAll() {
    setQuranPlayRange(
        playRange: QuranPlayRangeModel(
      startSurah: 1,
      startVerse: 1,
      endsSurah: 114,
      endsVerse: 6,
    ));
  }

// Set the play range based on the provided parameters
  void setQuranPlayRange(
      {required QuranPlayRangeModel playRange, isBegin}) async {
    this.playRange = playRange;
    adjustPlayRangeToNearestValid(isBegin: isBegin);
    update();
  }

// Adjust the play range to ensure it is valid
  void adjustPlayRangeToNearestValid({isBegin}) {
    final startSurah = playRange.startSurah;
    final startVerse = playRange.startVerse;
    final endSurah = playRange.endsSurah;
    final endVerse = playRange.endsVerse;

    if (startSurah > endSurah ||
        (startSurah == endSurah && startVerse > endVerse)) {
      // Swap values if the "from" range is greater than the "to" range.
      if (isBegin) {
        playRange = playRange.copyWith(
          startSurah: startSurah,
          startVerse: startVerse,
          endsSurah: startSurah,
          endsVerse: startVerse,
        );
      } else {
        playRange = playRange.copyWith(
          startSurah: endSurah,
          startVerse: endVerse,
          endsSurah: endSurah,
          endsVerse: endVerse,
        );
      }
    }
  }
}
