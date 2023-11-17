import 'package:enum_to_string/enum_to_string.dart';
import 'package:get/get.dart';
import 'package:tawakkal/constants/enum.dart';

class AzkarDetailModel {
  int id;
  int count;
  String? title;
  String text;
  String? note;
  RxInt counter = RxInt(0);
  RxBool isDone = RxBool(false);
  AzkarPageType azkarPageType;

  AzkarDetailModel({
    required this.id,
    required this.count,
    this.title,
    required this.text,
    this.note,
    required this.azkarPageType,
  });

  // Convert AzkarDetailModel to a JSON Map
  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'title': title,
      'text': text,
      'note': note,
      'counter': counter.value,
      'isDone': isDone.value,
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
      ..counter.value = json['counter'] as int
      ..isDone.value = json['isDone'] == 0 ? false : true;
  }
}
