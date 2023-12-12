import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../data/cache/azkar_settings_cache.dart';
import '../data/models/azkar_settings_model.dart';
import '../handlers/notification_alarm_handler.dart';
import 'azkar_details_controller.dart';

class AzkarSettingsController extends GetxController {
  late final AzkarSettingsModel azkarSettings;

  @override
  void onInit() {
    super.onInit();
    initAzkarSettings();
  }

  void initAzkarSettings() {
    azkarSettings = AzkarSettingsModel();
    azkarSettings.fontSize = AzkarSettingsCache.getFontSize();
    azkarSettings.showExitConfirmDialog =
        AzkarSettingsCache.getShowExitConfirmDialog();
    azkarSettings.showNotification = AzkarSettingsCache.getShowNotification();
    azkarSettings.morningTime = AzkarSettingsCache.getMorningTime();
    azkarSettings.nightTime = AzkarSettingsCache.getNightTime();
    azkarSettings.sleepTime = AzkarSettingsCache.getSleepTime();
  }

  Future<void> selectTime(BuildContext context, TimeOfDay initialTime,
      Function(TimeOfDay) onTimeSelected) async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: initialTime,
    );

    if (pickedTime != null) {
      Get.find<NotificationAlarmHandler>().scheduleAzkarAlarm();
      onTimeSelected(pickedTime);
    }
  }

  // Update functions
  void updateFontSize(double newFontSize) {
    AzkarSettingsCache.setFontSize(newFontSize);
    azkarSettings.fontSize = newFontSize;
    update(); // Trigger a rebuild of the UI
    // if AzkarDetailsController is available update the widget
    try {
      Get.find<AzkarDetailsController>().update();
    } catch (e) {
      log(e.toString());
    }
  }

  void updateShowExitConfirmDialog(bool newValue) {
    AzkarSettingsCache.setShowExitConfirmDialog(newValue);
    azkarSettings.showExitConfirmDialog = newValue;
    update(); // Trigger a rebuild of the UI
  }

  void updateShowNotification(bool newValue) {
    AzkarSettingsCache.setShowNotification(newValue);
    // start the alarm timer for showing the notification
    if (newValue) {
      Get.find<NotificationAlarmHandler>().scheduleAzkarAlarm();
    }
    azkarSettings.showNotification = newValue;
    update(); // Trigger a rebuild of the UI
  }

  void updateMorningTime(TimeOfDay newMorningTime) {
    AzkarSettingsCache.setMorningTime(newMorningTime);
    azkarSettings.morningTime = newMorningTime;
    update(); // Trigger a rebuild of the UI
  }

  void updateNightTime(TimeOfDay newNightTime) {
    AzkarSettingsCache.setNightTime(newNightTime);
    azkarSettings.nightTime = newNightTime;
    update(); // Trigger a rebuild of the UI
  }

  void updateSleepTime(TimeOfDay newSleepTime) {
    AzkarSettingsCache.setSleepTime(newSleepTime);
    azkarSettings.sleepTime = newSleepTime;
    update(); // Trigger a rebuild of the UI
  }
}
