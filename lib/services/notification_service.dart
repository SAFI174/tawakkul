import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tawakkal/data/models/azkar_notification_model.dart';
import 'package:tawakkal/utils/dialogs/dialogs.dart';

import '../data/models/prayer_time_model.dart';

class NotificationService extends GetxService {
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void onInit() async {
    super.onInit();
    await initializeNotifications();
  }

  Future<void> initializeNotifications() async {
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('ic_stat_icon_04');
    const InitializationSettings initializationSettings =
        InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
    );
  }

  void checkAndRequestNotificationPermission() async {
    if (!(await Permission.notification.isGranted)) {
      if (await showAskUserForNotificationsPermission()) {
        FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
            FlutterLocalNotificationsPlugin();
        flutterLocalNotificationsPlugin
            .resolvePlatformSpecificImplementation<
                AndroidFlutterLocalNotificationsPlugin>()!
            .requestNotificationsPermission();
      }
    }
  }

  Future<void> showAzkarNotifications(
      {required AzkarNotificationModel azkar}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'azkar_channel_id',
      'Azkar Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
      2,
      azkar.title,
      azkar.description,
      platformChannelSpecifics,
      payload: azkar.payload,
    );
  }

  Future<void> showPrayerNotification(PrayerTimeModel prayer) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'prayer_channel_id',
      'Prayer Notifications',
      importance: Importance.max,
      priority: Priority.high,
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await flutterLocalNotificationsPlugin.show(
        0,
        '${prayer.name} ${ArabicNumbers().convert(prayer.time)}${prayer.amPmAr}',
        'حان الآن موعد آذان ${prayer.name}',
        platformChannelSpecifics,
        payload: prayer.name);
  }

  Future<void> cancelAllNotifications() async {
    await flutterLocalNotificationsPlugin.cancelAll();
  }
}
