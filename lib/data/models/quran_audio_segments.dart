class QuranAudioSegments {
  int ayah;
  List<List<int>> segments;
  int surah;

  QuranAudioSegments({
    required this.ayah,
    required this.segments,
    required this.surah,
  });

  factory QuranAudioSegments.fromJson(Map<String, dynamic> json) {
    return QuranAudioSegments(
      ayah: json['ayah'],
      segments: (json['segments'] as List)
          .map((segment) => List<int>.from(segment))
          .toList(),
      surah: json['surah'],
    );
  }
}
