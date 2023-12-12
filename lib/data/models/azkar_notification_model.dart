import 'package:flutter/material.dart';

class AzkarNotificationModel {
  final String title;
  final String description;
  final TimeOfDay time;
  final String payload;
  
  AzkarNotificationModel({
    required this.title,
    required this.description,
    required this.time,
    required this.payload,
  });
  AzkarNotificationModel copyWith({TimeOfDay? time}) {
    return AzkarNotificationModel(
      title: title,
      description: description,
      time: time ?? this.time,
      payload: payload,
    );
  }
}
