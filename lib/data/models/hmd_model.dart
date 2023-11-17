import 'package:get/get.dart';

class HmdModel {
  int? count;
  String? text;
  RxInt counter = RxInt(0);
  RxBool isDone = RxBool(false);

  HmdModel(
      {this.count, this.text, required this.counter, required this.isDone});

  HmdModel.fromJson(Map<String, dynamic> json) {
    count = json['count'];
    text = json['text'];
    counter = RxInt(count!);
    isDone = false.obs;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['count'] = count;
    data['text'] = text;
    return data;
  }
}
