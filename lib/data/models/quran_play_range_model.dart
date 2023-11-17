class QuranPlayRangeModel {
  int startSurah;
  int startVerse;
  int endsSurah;
  int endsVerse;

  QuranPlayRangeModel({
    this.startSurah = 1,
    this.startVerse = 0,
    this.endsSurah = 1,
    this.endsVerse = 0,
  });

  Map<String, dynamic> toJson() {
    return {
      'startSurah': startSurah,
      'startVerse': startVerse,
      'endsSurah': endsSurah,
      'endsVerse': endsVerse,
    };
  }

  factory QuranPlayRangeModel.fromJson(Map<String, dynamic> json) {
    return QuranPlayRangeModel(
      startSurah: json['startSurah'],
      startVerse: json['startVerse'],
      endsSurah: json['endsSurah'],
      endsVerse: json['endsVerse'],
    );
  }
  QuranPlayRangeModel copyWith({
    int? startSurah,
    int? startVerse,
    int? endsSurah,
    int? endsVerse,
  }) {
    return QuranPlayRangeModel(
      startSurah: startSurah ?? this.startSurah,
      startVerse: startVerse ?? this.startVerse,
      endsSurah: endsSurah ?? this.endsSurah,
      endsVerse: endsVerse ?? this.endsVerse,
    );
  }
}
