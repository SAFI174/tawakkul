import 'package:get/get.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class QuranPage {
  RxList<Verse>? verses;
  AutoScrollController scrollController = AutoScrollController();

  QuranPage({
    this.verses,
  });

  QuranPage.fromJson(Map<String, dynamic> json) {
    if (json['verses'] != null) {
      verses = RxList<Verse>();
      json['verses'].forEach((v) {
        verses!.add(Verse.fromJson(v));
      });
      scrollController = AutoScrollController();
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    if (verses != null) {
      data['verses'] = verses!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Verse {
  int? id;
  int? verseNumber;
  String? verseKey;
  int? surahNumber;
  int? hizbNumber;
  int? rubElHizbNumber;
  int? rukuNumber;
  int? manzilNumber;
  int? sajdahNumber;
  String? textUthmaniSimple;
  String? textUthmani;
  int? pageNumber;
  int? juzNumber;
  RxList<Words>? words;
  RxBool isHighlighted = false.obs;
  Verse(
      {this.id,
      this.verseNumber,
      this.verseKey,
      this.hizbNumber,
      this.rubElHizbNumber,
      this.rukuNumber,
      this.surahNumber,
      this.manzilNumber,
      this.sajdahNumber,
      this.textUthmaniSimple,
      this.textUthmani,
      this.pageNumber,
      this.juzNumber,
      this.words});

  Verse.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    verseNumber = json['verse_number'];
    verseKey = json['verse_key'];
    hizbNumber = json['hizb_number'];
    rubElHizbNumber = json['rub_el_hizb_number'];
    rukuNumber = json['ruku_number'];
    manzilNumber = json['manzil_number'];
    sajdahNumber = json['sajdah_number'];
    textUthmaniSimple = json['text_uthmani_simple'];
    textUthmani = json['text_uthmani'];
    pageNumber = json['page_number'];
    juzNumber = json['juz_number'];
    surahNumber = int.parse(verseKey!.split(':')[0]);
    if (json['words'] != null) {
      words = RxList<Words>();
      json['words'].forEach((v) {
        words!.add(Words.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['verse_number'] = verseNumber;
    data['verse_key'] = verseKey;
    data['hizb_number'] = hizbNumber;
    data['rub_el_hizb_number'] = rubElHizbNumber;
    data['ruku_number'] = rukuNumber;
    data['manzil_number'] = manzilNumber;
    data['sajdah_number'] = sajdahNumber;
    data['text_uthmani_simple'] = textUthmaniSimple;
    data['text_uthmani'] = textUthmani;
    data['page_number'] = pageNumber;
    data['juz_number'] = juzNumber;
    if (words != null) {
      data['words'] = words!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Words {
  int? id;
  int? position;
  String? charTypeName;
  int? v1Page;
  String? textUthmaniSimple;
  String? textUthmani;
  String? textIndopak;
  String? codeV2;
  String? codeV1;
  int? pageNumber;
  int? lineNumber;
  String? text;
  RxBool isHighlighted = false.obs;
  Translation? translation;

  Words(
      {this.id,
      this.position,
      this.charTypeName,
      this.v1Page,
      this.textUthmaniSimple,
      this.textUthmani,
      this.textIndopak,
      this.codeV2,
      this.codeV1,
      this.pageNumber,
      this.lineNumber,
      this.text,
      this.translation});

  Words.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    position = json['position'];
    charTypeName = json['char_type_name'];
    v1Page = json['v1_page'];
    textUthmaniSimple = json['text_uthmani_simple'];
    textUthmani = json['text_uthmani'];
    textIndopak = json['text_indopak'];
    codeV2 = json['code_v2'];
    codeV1 = json['code_v1'];
    pageNumber = json['page_number'];
    lineNumber = json['line_number'];
    text = json['text'];
    translation = json['translation'] != null
        ? Translation.fromJson(json['translation'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['position'] = position;
    data['char_type_name'] = charTypeName;
    data['v1_page'] = v1Page;
    data['text_uthmani_simple'] = textUthmaniSimple;
    data['text_uthmani'] = textUthmani;
    data['text_indopak'] = textIndopak;
    data['code_v2'] = codeV2;
    data['code_v1'] = codeV1;
    data['page_number'] = pageNumber;
    data['line_number'] = lineNumber;
    data['text'] = text;
    if (translation != null) {
      data['translation'] = translation!.toJson();
    }
    return data;
  }
}

class Translation {
  String? text;
  String? languageName;

  Translation({this.text, this.languageName});

  Translation.fromJson(Map<String, dynamic> json) {
    text = json['text'];
    languageName = json['language_name'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['text'] = text;
    data['language_name'] = languageName;
    return data;
  }
}
