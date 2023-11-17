class Bookmark {
  final int chapter;
  final int verse;
  DateTime? addedDate;

  Bookmark({
    required this.chapter,
    required this.verse,
    this.addedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'chapter': chapter,
      'verse': verse,
      'addedDate': addedDate!.toIso8601String(),
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      chapter: json['chapter'],
      verse: json['verse'],
      addedDate: DateTime.parse(json['addedDate'].toString()),
    );
  }
}
