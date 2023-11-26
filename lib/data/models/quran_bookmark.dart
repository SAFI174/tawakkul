class Bookmark {
  final int surah;
  final int verse;
  DateTime? addedDate;

  Bookmark({
    required this.surah,
    required this.verse,
    this.addedDate,
  });

  Map<String, dynamic> toJson() {
    return {
      'surah': surah,
      'verse': verse,
      'addedDate': addedDate!.toIso8601String(),
    };
  }

  factory Bookmark.fromJson(Map<String, dynamic> json) {
    return Bookmark(
      surah: json['surah'],
      verse: json['verse'],
      addedDate: DateTime.parse(json['addedDate'].toString()),
    );
  }
}
