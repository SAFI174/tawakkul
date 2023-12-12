
import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';

import 'package:gap/gap.dart';
import 'package:get/get.dart';

import '../constants/constants.dart';
import '../controllers/azkar_settings_controller.dart';
import '../widgets/custom_container.dart';




class AzkarSettingsPage extends GetView {
  AzkarSettingsPage({super.key});
  @override
  final controller = Get.put(AzkarSettingsController());
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'إعدادات الأذكار',
          style: theme.primaryTextTheme.titleMedium,
        ),
      ),
      body: GetBuilder<AzkarSettingsController>(builder: (controller) {
        return ListView(
          children: [
            ListTile(
              title: Text(
                'العرض',
                style: titleTextStyle!.copyWith(color: theme.primaryColor),
              ),
              dense: true,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const ListTile(
                  title: Text(
                    'حجم الخط',
                  ),
                  dense: true,
                ),
                SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    activeTrackColor: theme.colorScheme.primaryContainer,
                    inactiveTickMarkColor: theme.colorScheme.primary,
                    inactiveTrackColor: theme.colorScheme.primaryContainer,
                  ),
                  child: Slider(
                    value: controller.azkarSettings.fontSize,
                    min: 16,
                    max: 32,
                    label: ArabicNumbers()
                        .convert('${controller.azkarSettings.fontSize}'),
                    onChanged: controller.updateFontSize,
                    divisions: 4,
                  ),
                ),
                const ListTile(
                  title: Text(
                    'معاينة',
                  ),
                  dense: true,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: CustomContainer(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Text(
                        previewText,
                        style: TextStyle(
                          fontSize: controller.azkarSettings.fontSize,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const Gap(15),
            const Divider(),
            ListTile(
              title: Text(
                'الإشعارات',
                style: titleTextStyle.copyWith(color: theme.primaryColor),
              ),
              dense: true,
            ),
            SwitchListTile(
              dense: true,
              title: Text(
                'إظهار تنبيه عند الخروج',
                style: titleTextStyle,
              ),
              subtitle: Text(
                'تنبيه عند عدم الإنتهاء من قراءة الأذكار',
                style: subtitleTextStyle,
              ),
              value: controller.azkarSettings.showExitConfirmDialog,
              onChanged: controller.updateShowExitConfirmDialog,
            ),
            SwitchListTile(
              dense: true,
              title: Text(
                'اشعارات',
                style: titleTextStyle,
              ),
              subtitle: Text(
                'إظهار اشعارات للتذكير بقراءة الاذكار',
                style: subtitleTextStyle,
              ),
              value: controller.azkarSettings.showNotification,
              onChanged: controller.updateShowNotification,
            ),
            ListTile(
              onTap: () => controller.selectTime(
                  context,
                  controller.azkarSettings.morningTime,
                  (newTime) => controller.updateMorningTime(newTime)),
              title: Text(
                'وقت أذكار الصباح',
                style: titleTextStyle,
              ),
              subtitle: Text(
                controller.azkarSettings.formattedMorningTime,
                style: subtitleTextStyle,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () => controller.selectTime(
                  context,
                  controller.azkarSettings.nightTime,
                  (newTime) => controller.updateNightTime(newTime)),
              title: Text(
                'وقت أذكار المساء',
                style: titleTextStyle,
              ),
              subtitle: Text(
                controller.azkarSettings.formattedNightTime,
                style: subtitleTextStyle,
              ),
              dense: true,
            ),
            ListTile(
              onTap: () => controller.selectTime(
                  context,
                  controller.azkarSettings.sleepTime,
                  (newTime) => controller.updateSleepTime(newTime)),
              title: Text(
                'وقت أذكار النوم',
                style: titleTextStyle,
              ),
              subtitle: Text(
                controller.azkarSettings.formattedSleepTime,
                style: subtitleTextStyle,
              ),
              dense: true,
            ),
          ],
        );
      }),
    );
  }
}
