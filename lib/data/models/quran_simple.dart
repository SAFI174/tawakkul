class QuranSimple {
  int? id;
  String? verseKey;
  String? textUthmaniSimple;

  QuranSimple({this.id, this.verseKey, this.textUthmaniSimple});

  QuranSimple.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    verseKey = json['verse_key'];
    textUthmaniSimple = json['text_uthmani_simple'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['id'] = id;
    data['verse_key'] = verseKey;
    data['text_uthmani_simple'] = textUthmaniSimple;
    return data;
  }
}
