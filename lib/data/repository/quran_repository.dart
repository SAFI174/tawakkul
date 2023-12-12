import 'package:tawakkal/data/models/quran_page.dart';
import '../../services/database_service.dart';
import '../models/quran_verse_model.dart';

// This class represents a repository for accessing Quran data from a database.
class QuranRepository {
  // DatabaseService instance for interacting with the Quran database.
  final DatabaseService _dbService = DatabaseService('quran.db');

  // Retrieves Quran page data for a given page number from the database.
  Future<QuranPageModel> getQuranPageData({required int pageNumber}) async {
    // Execute a SQL query to fetch data related to the specified page number.
    final List<Map<String, dynamic>> result = await _dbService.queryData(
      query: '''
        SELECT *, Words.id as w_id FROM Words
        LEFT JOIN Verses on Words.verse_id = Verses.id
        WHERE Verses.page_number = $pageNumber
      ''',
    );

    // List to store QuranVerseModel instances.
    List<QuranVerseModel> verses = [];

    // Iterate through the result to organize data into QuranVerseModel instances.
    for (var word in result) {
      // Check if the verses list is empty or the last verse ID is different from the current word ID.
      if (verses.isEmpty || verses.last.id != word['id']) {
        // Create a new QuranVerseModel when encountering a new word ID.
        verses.add(
          QuranVerseModel(
            id: word['id'],
            verseNumber: word['verse_number'],
            verseKey: word['verse_key'],
            hizbNumber: word['hizb_number'],
            rubElhizbNumber: word['rub_el_hizb_number'],
            pageNumber: word['page_number'],
            juzNumber: word['juz_number'],
            surahNumber: int.parse(word['verse_key'].split(':')[0]),
            textUthmaniSimple: word['text_uthmani_simple'],
            words: [],
          ),
        );
      }
      // Add the current word to the last created verse.
      verses.last.words.add(
        Word(
          id: word['w_id'],
          verseId: word['verse_id'],
          position: word['position'],
          wordType: word['word_type'],
          textUthmani: word['text_uthmani'],
          pageNumber: word['page_number'],
          lineNumber: word['line_number'],
          textV1: word['text_v1'],
          surahNumber: int.parse(word['verse_key'].split(':')[0]),
        ),
      );
    }

    // Create and return a QuranPageModel with the collected verse data.
    return QuranPageModel(
      surahNumber: verses.first.surahNumber,
      hizbNumber: verses.first.hizbNumber,
      rubElHizbNumber: verses.first.rubElhizbNumber,
      juzNumber: verses.first.juzNumber,
      pageNumber: pageNumber,
      verses: verses,
    );
  }

  Future<List<QuranVerseModel>> getQuranAllVersesData() async {
    final List<Map<String, dynamic>> result = await _dbService.queryData(
      query: '''
       SELECT verse_number, verse_key, text_uthmani_simple, page_number FROM verses
      ''',
    );
    return result.map((e) => QuranVerseModel.fromJson(e)).toList();
  }
}
