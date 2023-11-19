import 'package:get/get.dart';

class ElectronicTasbihModel {
  int? id;
  String name;
  int count;
  RxInt counter = RxInt(0);
  RxInt totalCounter = RxInt(0);

  // Constructor
  ElectronicTasbihModel({
    this.id,
    required this.name,
    required this.count,
  });

  // Convert object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'count': count,
      'counter': counter.value,
      'total_counter': totalCounter.value,
    };
  }

  // Create object from JSON
  factory ElectronicTasbihModel.fromJson(Map<String, dynamic> json) {
    return ElectronicTasbihModel(
      id: json['id'],
      name: json['name'],
      count: json['count'],
    )
      ..counter.value = json['counter'] ?? 0
      ..totalCounter.value = json['total_counter'] ?? 0;
  }
}
