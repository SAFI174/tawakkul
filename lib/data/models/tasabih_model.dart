import 'package:get/get.dart';

class DuaTasbihModel {
  int? count;
  String? text;
  String? note;
  RxInt counter = RxInt(0);
  RxBool isDone = RxBool(false);

  DuaTasbihModel({this.count, this.text, this.note});

  Map<String, dynamic> toJson() {
    return {
      'count': count,
      'text': text,
      'note': note,
      'counter': counter.value,
      'isDone': isDone.value,
    };
  }

  DuaTasbihModel.fromJson(Map<String, dynamic> json) {
    count = json['count'] ?? 1;
    text = json['text'];
    note = json['note'];
    counter = RxInt(json['counter'] ?? count!);
    isDone = RxBool(json['isDone']?? false);
  }
}