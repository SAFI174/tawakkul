
import 'package:flutter/material.dart';

class AzkarSettingsModel {
  late double fontSize;
  late bool showExitConfirmDialog;
  late bool showNotification;
  late TimeOfDay morningTime;
  late TimeOfDay nightTime;
  late TimeOfDay sleepTime;

  String get formattedMorningTime {
    return formatTimeToArabicString(morningTime);
  }

  String get formattedNightTime {
    return formatTimeToArabicString(nightTime);
  }

  String get formattedSleepTime {
    return formatTimeToArabicString(sleepTime);
  }

  // Function to format TimeOfDay into Arabic string with AM and PM
  String formatTimeToArabicString(TimeOfDay time) {
    final int hour = time.hourOfPeriod;
    final String period = time.period == DayPeriod.am ? 'صباحًا' : 'مساءً';
    final String minute = time.minute.toString().padLeft(2, '0');

    return '$hour:$minute $period';
  }
}