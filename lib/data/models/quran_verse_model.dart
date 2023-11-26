import 'package:get/get.dart';

class QuranVerseModel {
  final int id;
  final int verseNumber;
  final int surahNumber;
  final String verseKey;
  final int hizbNumber;
  final int rubElhizbNumber;
  final int pageNumber;
  final int juzNumber;
  final String textUthmaniSimple;
  final List<Word> words;
  final RxBool isHighlighted = RxBool(false);

  QuranVerseModel({
    required this.id,
    required this.verseNumber,
    required this.verseKey,
    required this.hizbNumber,
    required this.surahNumber,
    required this.rubElhizbNumber,
    required this.pageNumber,
    required this.juzNumber,
    required this.textUthmaniSimple,
    required this.words,
  });

  factory QuranVerseModel.fromJson(Map<String, dynamic> json) {
    return QuranVerseModel(
        id: json['id'] ?? 0,
        verseNumber: json['verse_number'] ?? 0,
        verseKey: json['verse_key'] ?? '0:0',
        hizbNumber: json['hizb_number'] ?? 0,
        rubElhizbNumber: json['rub_el_hizb_number'] ?? 0,
        pageNumber: json['page_number'] ?? 0,
        juzNumber: json['juz_number'] ?? 0,
        textUthmaniSimple: json['text_uthmani_simple'] ?? '',
        words: List<Word>.from(
            (json['words'] ?? []).map((word) => Word.fromJson(word))),
        surahNumber: int.parse((json['verse_key'] ?? '0:0').split(':')[0]));
  }
}

class Word {
  final int id;
  final int verseId;
  final String wordType;
  final String textUthmani;
  final int position;
  final int pageNumber;
  final int lineNumber;
  final String textV1;
  final RxBool isHighlighted = RxBool(false);
  final int? surahNumber;
  Word({
    required this.id,
    required this.verseId,
    required this.wordType,
    required this.position,
    required this.textUthmani,
    required this.pageNumber,
    required this.lineNumber,
    required this.textV1,
    this.surahNumber,
  });

  factory Word.fromJson(Map<String, dynamic> json) {
    return Word(
      id: json['id'],
      verseId: json['verse_id'],
      wordType: json['word_type'],
      textUthmani: json['text_uthmani'],
      position: json['position'],
      pageNumber: json['page_number'],
      lineNumber: json['line_number'],
      textV1: json['text_v1'],
    );
  }
  
}
