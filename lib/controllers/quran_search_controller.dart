import 'package:get/get.dart';
import 'package:tawakkal/data/models/quran_navigation_data_model.dart';
import 'package:tawakkal/routes/app_pages.dart';

import '../data/models/quran_verse_model.dart';
import '../data/repository/quran_repository.dart';

class QuranSearchController extends GetxController {
  var searchText = ''.obs;
  var searchResults = <QuranVerseModel>[].obs;
  var quranVersesSimple = <QuranVerseModel>[].obs;

  @override
  void onInit() async {
    super.onInit();
    // Get Quran data from the repository when the controller is initialized
    quranVersesSimple.value = await QuranRepository().getQuranAllVersesData();
  }

  void onVersePressed(QuranVerseModel verse) {
    var navigationDetails = QuranNavigationArgumentModel(
        surahNumber: verse.surahNumber,
        pageNumber: verse.pageNumber,
        verseNumber: verse.verseNumber,
        highlightVerse: true);
    if (Get.previousRoute.contains('quran-reading')) {
      Get.back(
        result: navigationDetails,
      );
    } else {
      Get.toNamed(Routes.QURAN_READING_PAGE, arguments: navigationDetails);
    }
  }

  // Method to handle text changes in the search bar
  void onSearchTextChanged(String value) async {
    searchText.value = value;
    if (searchText.isEmpty) {
      searchResults.clear();
      return;
    }
    // Filter the Quran verses based on the search text
    final filteredResults = quranVersesSimple
        .where((quran) => quran.textUthmaniSimple.contains(searchText))
        .toList();

    searchResults.assignAll(filteredResults);
  }
}
