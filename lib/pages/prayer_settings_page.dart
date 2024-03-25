import 'package:adhan/adhan.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawakkal/data/cache/prayer_time_cache.dart';
import 'package:tawakkal/pages/calc_method_selector_page.dart';
import 'package:tawakkal/utils/dialogs/select_madhab_dialog.dart';

import '../constants/constants.dart';
import '../controllers/prayer_time_controller.dart';

class PrayerSettingsPage extends GetView {
  const PrayerSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var controller = Get.find<PrayerTimeController>();

    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    // Build the UI
    return Scaffold(
      appBar: AppBar(
        title: const Text('إعدادات أوقات الصلاة'),
        titleTextStyle: theme.primaryTextTheme.titleMedium,
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'طرق الحساب',
              style: theme.textTheme.titleSmall!
                  .copyWith(color: theme.primaryColor),
            ),
            dense: true,
          ),
          ListTile(
            onTap: () {
              Get.to(() => const CalculationMethodSelectorPage());
            },
            dense: true,
            title: Text(
              'طريقة الحساب',
              style: titleTextStyle,
            ),
            subtitle: Text(
                calculationMethodList[
                        PrayerTimeCache.getCalculationMethodFromCache().index]
                    ['title'],
                style: subtitleTextStyle),
          ),
          ListTile(
            onTap: () {
              Get.dialog(const MadhabSelectionDialog());
            },
            dense: true,
            title: Text(
              'طريقة حساب العصر',
              style: titleTextStyle,
            ),
            subtitle: Text(
                madhabList[PrayerTimeCache.getMadhabFromCache().index]['title'],
                style: subtitleTextStyle),
          ),
          const Divider(),
          ListTile(
            title: Text(
              'تنبيه الصلوات',
              style: theme.textTheme.titleSmall!
                  .copyWith(color: theme.primaryColor),
            ),
            dense: true,
          ),
          ListView.builder(
            primary: false,
            shrinkWrap: true,
            itemCount: Prayer.values.length,
            itemBuilder: (context, index) {
              if (index == 0) {
                return const SizedBox();
              }
              var prayer = Prayer.values[index];
              var isNotificationEnabled =
                  PrayerTimeCache.getPrayerNotificationMode(prayer: prayer);

              return Obx(() {
                return SwitchListTile(
                  thumbIcon: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.selected)) {
                      return Icon(
                        Icons.notifications_active_outlined,
                        color: theme.primaryColorDark,
                      );
                    } else {
                      return const Icon(Icons.notifications_off_outlined);
                    }
                  }),
                  value: isNotificationEnabled.value,
                  title: Text(
                    controller.repository
                        .getPrayerNameArabic(prayer: Prayer.values[index]),
                    style: titleTextStyle,
                  ),
                  onChanged: (value) {
                    isNotificationEnabled.value = value;
                    PrayerTimeCache.savePrayerNotificationMode(
                        prayer: prayer, notificationMode: value);
                    controller.update();
                  },
                );
              });
            },
          ),
          ListTile(
            dense: true,
            title: Text(
              ' ملاحظة: سيتم تطبيق التغيرات بعد الإشعار القادم.',
              style: subtitleTextStyle,
            ),
          )
        ],
      ),
    );
  }
}
