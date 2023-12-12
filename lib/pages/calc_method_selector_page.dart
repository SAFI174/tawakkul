import 'package:adhan/adhan.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawakkal/data/repository/prayer_time_repository.dart';
import 'package:tawakkal/handlers/notification_alarm_handler.dart';

import '../constants/constants.dart';
import '../data/cache/prayer_time_cache.dart';

class CalculationMethodSelectorPage extends GetView {
  const CalculationMethodSelectorPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    var repository = Get.find<PrayerTimeRepository>();
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: theme.textTheme.titleMedium,
        title: const Text(
          'اختر طريقة الحساب',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: ListView.builder(
        itemCount: calculationMethodList.length,
        itemBuilder: (context, index) {
          var isSelected =
              PrayerTimeCache.getCalculationMethodFromCache().index ==
                  calculationMethodList[index]['method'];
          return ListTile(
            dense: true,
            tileColor: isSelected
                ? theme.colorScheme.surfaceVariant
                : Colors.transparent,
            leading: isSelected
                ? Icon(
                    FluentIcons.checkmark_16_regular,
                    color: theme.hintColor,
                  )
                : const SizedBox(),
            title: Text(
              calculationMethodList[index]['title']!,
              style: titleTextStyle,
            ),
            subtitle: Text(
              calculationMethodList[index]['description']!,
              style: subtitleTextStyle,
            ),
            onTap: () async {
              // Update cache with the selected method index
              PrayerTimeCache.saveCalculationMethodToCache(
                  CalculationMethod.values[index]);
              await repository.initPrayerTimes();
              // cancel all alarms and re schedule new alarm for next prayer
              Get.find<NotificationAlarmHandler>()
                  .cancelAllAndNextPrayerSchedule();
              // Rebuild the widget to reflect the selection
              Get.forceAppUpdate();
            },
          );
        },
      ),
    );
  }
}
