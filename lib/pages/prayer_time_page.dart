import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tawakkal/handlers/notification_alarm_handler.dart';
import 'package:tawakkal/pages/prayer_settings_page.dart';
import 'package:tawakkal/utils/utils.dart';

import '../controllers/prayer_time_controller.dart';
import '../widgets/current_prayer_details_widget.dart';
import '../widgets/custom_container.dart';
import '../widgets/custom_message_button_widget.dart';

class PrayerTimePage extends GetView<PrayerTimeController> {
  const PrayerTimePage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    // Build the UI
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('أوقات الصلاة'),
          titleTextStyle: theme.primaryTextTheme.titleMedium,
          actions: [
            IconButton(
              onPressed: controller.updateLocation,
              icon: const Icon(FluentIcons.my_location_16_regular),
            ),
            IconButton(
              onPressed: () {
                Get.to(() => const PrayerSettingsPage());
              },
              icon: const Icon(FluentIcons.settings_16_regular),
            ),
          ],
        ),
        body: GetBuilder<PrayerTimeController>(builder: (controller) {
          // Check if the location is granted and coordinates are not null
          return controller.repository.coordinates != null
              ? SingleChildScrollView(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      _buildUserLocation(),
                      const Gap(15),
                      CurrentPrayerDetailsWidget(
                        onTimerFinishedCallback: () {
                          Get.forceAppUpdate();
                        },
                      ),
                      const Gap(15),
                      _buildPrayerListView(),
                    ],
                  ),
                )
              // If coordinates are null, ask the user to grant location permission
              : Center(
                  child: MessageWithButtonWidget(
                    title:
                        'الرجاء السماح بصلاحيات الموقع مرة واحدة على الاقل للحصول على بيانات اوقات الصلاة',
                    buttonText: 'إعطاء صلاحية',
                    onTap: () async {
                      await controller.repository.getCoordinatesFromLocation();

                      await controller.repository.initPrayerTimes();
                      if (controller.repository.coordinates != null) {
                        // Start a new alarm after the location has been updated
                        Get.find<NotificationAlarmHandler>().onInit();
                      }
                      controller.update();
                    },
                  ),
                );
        }),
      ),
    );
  }

  // Widget to build the user location display
  Widget _buildUserLocation() {
    return CustomContainer(
      useMaterial: true,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const Icon(
              Icons.location_on,
            ),
            const Gap(5),
            FutureBuilder(
              future: controller.repository.getLocationTextDecoded(),
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return Text(
                    snapshot.data!,
                    textDirection: TextDirection.ltr,
                  );
                } else {
                  return Text(
                    controller.repository.getLocationTextCoded(),
                    textDirection: TextDirection.ltr,
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }

  // Widget to build the prayer time list view
  Widget _buildPrayerListView() {
    final theme = Theme.of(Get.context!);
    var prayerTime = controller.repository.getPrayers();
    return CustomContainer(
      child: Column(
        children: [
          Material(
            borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    Utils.getCurrentDate(),
                    style: theme.textTheme.labelMedium,
                  ),
                  Text(
                    Utils.getCurrentDateHijri(),
                    style: theme.textTheme.labelMedium,
                  ),
                ],
              ),
            ),
          ),
          const Divider(height: 1),
          ListView.separated(
            primary: false,
            shrinkWrap: true,
            itemCount: prayerTime.length,
            separatorBuilder: (context, index) {
              return const Divider(
                height: 0,
              );
            },
            itemBuilder: (context, index) {
              final prayer = prayerTime[index];
              final textStyle = theme.textTheme.labelLarge;

              return ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.vertical(
                    bottom: index == prayerTime.length - 1
                        ? const Radius.circular(9.0)
                        : Radius.zero,
                  ),
                ),
                dense: false,
                title: Text(
                  prayer.name,
                  style: textStyle,
                ),
                trailing: Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      ArabicNumbers().convert(prayer.time),
                      style: textStyle,
                      textAlign: TextAlign.start,
                    ),
                    const Gap(15),
                    Text(
                      prayer.amPmAr,
                      textAlign: TextAlign.start,
                      style: textStyle,
                      textDirection: TextDirection.ltr,
                    ),
                    const Gap(15),
                    Icon(
                      prayer.isNotificationEnabled.value
                          ? Icons.notifications_active_outlined
                          : Icons.notifications_off_outlined,
                      color: prayer.isNotificationEnabled.value
                          ? theme.primaryColor
                          : theme.hintColor,
                      size: 20,
                    ),
                  ],
                ),
              );
            },
          )
        ],
      ),
    );
  }
}
