import 'asmaullah_model.dart';

class DailyContentModel {
  late String date;
  late AsmaullahModel asmOfAllah;
  late String dua;
  late Map<String, dynamic> hadith;
  late Map<String, dynamic> generalInfo;
  late Map<String, dynamic> verse;

  DailyContentModel({
    required this.date,
    required this.asmOfAllah,
    required this.dua,
    required this.hadith,
    required this.generalInfo,
    required this.verse,
  });

  factory DailyContentModel.fromJson(Map<String, dynamic> json) {
    return DailyContentModel(
      date: json['date'],
      asmOfAllah: AsmaullahModel.fromJson(json['asm']),
      dua: json['dua'],
      hadith: json['hadith'],
      generalInfo: json['generalInfo'],
      verse: json['verse'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date,
      'asm': asmOfAllah.toJson(),
      'dua': dua,
      'hadith': hadith,
      'generalInfo': generalInfo,
      'verse': verse,
    };
  }
}