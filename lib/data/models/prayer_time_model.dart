import 'package:adhan/adhan.dart';
import 'package:get/get.dart';

class PrayerTimeModel {
  final String name;
  final String time;
  final Prayer type;
  final bool isAm;
  final String amPmAr;
  final DateTime fulldate;
  final Duration? timeLeft;
  final RxBool isNotificationEnabled;
  PrayerTimeModel({
    required this.name,
    required this.time,
    required this.type,
    required this.fulldate,
    required this.isAm,
    required this.amPmAr,
    this.timeLeft,
    required this.isNotificationEnabled,
  });
}
