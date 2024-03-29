import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tawakkal/constants/all_activites.dart';
import 'package:tawakkal/pages/app_settings_page.dart';

import '../../../widgets/custom_button_big_icon.dart';
import '../controllers/more_activities_controller.dart';

class MoreActivitiesPage extends GetView<MoreActivitiesController> {
  const MoreActivitiesPage({super.key});
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('المزيد من الأنشطة'),
          titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
          actions: [
            IconButton(
                onPressed: () {
              
                   Get.to(() => const AppSettingsPage());
                },
                icon: const Icon(FluentIcons.settings_16_regular))
          ],
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 75.h > 100.w ? 80.w / 3 : 80.w / 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(8.0),
          itemCount: Activites.activities.length,
          itemBuilder: (context, index) {
            return CustomButtonBigIcon(
              text: Activites.activities[index]['text'],
              iconData: Activites.activities[index]['icon'],
              onTap: Activites.activities[index]['onTap'],
            );
          },
        ),
      ),
    );
  }
}
