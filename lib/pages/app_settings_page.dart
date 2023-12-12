import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:tawakkal/data/cache/app_settings_cache.dart';
import 'package:tawakkal/pages/azkar_settings_page.dart';
import 'package:tawakkal/pages/prayer_settings_page.dart';
import 'package:tawakkal/routes/app_pages.dart';
import 'package:tawakkal/utils/utils.dart';

class AppSettingsPage extends GetView {
  const AppSettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    return Scaffold(
      appBar: AppBar(
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
        title: const Text(
          'إعدادات التطبيق',
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text(
              'عام',
              style: titleTextStyle!.copyWith(color: theme.primaryColor),
            ),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.brightness_6_rounded),
            onTap: () => Get.dialog(ChangeThemeDialog()),
            title: Text(
              'مظهر التطبيق',
              style: titleTextStyle,
            ),
            subtitle: Text(
              Utils.themeModeToArabicText(AppSettingsCache.getThemeMode()),
              style: subtitleTextStyle,
            ),
            dense: true,
          ),
          ListTile(
            leading: const Icon(Icons.app_settings_alt_rounded),
            onTap: () => Get.toNamed(Routes.QURAN_DISPLAY_SETTINGS),
            title: Text(
              'القرآن الكريم',
              style: titleTextStyle,
            ),
            subtitle: Text(
              'العرض,الصوت,ادارة التنزيلات',
              style: subtitleTextStyle,
            ),
            dense: true,
          ),
          ListTile(
            leading: const Icon(FluentIcons.clock_12_regular),
            onTap: () => Get.to(() => const PrayerSettingsPage()),
            title: Text(
              'أوقات الصلاة',
              style: titleTextStyle,
            ),
            subtitle: Text(
              'طرق الحساب,المذهب,اشعارا الصلوات',
              style: subtitleTextStyle,
            ),
            dense: true,
          ),
          ListTile(
            leading: const Icon(FlutterIslamicIcons.tasbih3),
            onTap: () => Get.to(() =>  AzkarSettingsPage()),
            title: Text(
              'أذكار',
              style: titleTextStyle,
            ),
            subtitle: Text(
              'الخط, الاشعارات',
              style: subtitleTextStyle,
            ),
            dense: true,
          ),
        ],
      ),
    );
  }
}

class ChangeThemeDialog extends StatelessWidget {
  ChangeThemeDialog({super.key});
  final theme = AppSettingsCache.getThemeMode().obs;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('المظهر'),
      content: Obx(() {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            RadioListTile(
              value: ThemeMode.light,
              groupValue: theme.value,
              title: Text(
                Utils.themeModeToArabicText(ThemeMode.light),
              ),
              onChanged: (value) {
                theme.value = ThemeMode.light;
              },
            ),
            RadioListTile(
              value: ThemeMode.dark,
              groupValue: theme.value,
              title: Text(
                Utils.themeModeToArabicText(ThemeMode.dark),
              ),
              onChanged: (value) {
                theme.value = ThemeMode.dark;
              },
            ),
            RadioListTile(
              value: ThemeMode.system,
              groupValue: theme.value,
              title: Text(
                Utils.themeModeToArabicText(ThemeMode.system),
              ),
              onChanged: (value) {
                theme.value = ThemeMode.system;
              },
            ),
          ],
        );
      }),
      actions: [
        TextButton(
          onPressed: () => Get.back(),
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            Get.back();

            AppSettingsCache.setThemeMode(themeMode: theme.value);
          },
          child: const Text('تأكيد'),
        ),
      ],
    );
  }
}
