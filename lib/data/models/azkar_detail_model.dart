import 'package:enum_to_string/enum_to_string.dart';
import 'package:tawakkal/constants/enum.dart';

class AzkarDetailModel {
  int id;
  int count;
  String? title;
  String text;
  String? note;
  int counter;
  bool isDone;
  AzkarPageType azkarPageType;

  AzkarDetailModel({
    required this.id,
    required this.count,
    this.title,
    required this.text,
    this.note,
    required this.azkarPageType,
    this.counter = 0,
    this.isDone = false,
  });

  // Convert AzkarDetailModel to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'title': title,
      'text': text,
      'note': note,
      'counter': counter,
      'isDone': isDone,
      'zkr_type': EnumToString.convertToString(azkarPageType), // Enum to string
    };
  }

  // Create AzkarDetailModel from a JSON Map
  factory AzkarDetailModel.fromJson(Map<String, dynamic> json) {
    return AzkarDetailModel(
      id: json['id'],
      count: json['count'],
      title: json['title'],
      text: json['text'] as String,
      note: json['note'],
      azkarPageType: EnumToString.fromString(
          AzkarPageType.values, json['zkr_type'] as String)!,
    )
      ..counter = json['counter'] as int
      ..isDone = json['isDone'] == 0 ? false : true;
  }
}
