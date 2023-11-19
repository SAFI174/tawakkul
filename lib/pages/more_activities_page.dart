import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../widgets/custom_button_big_icon.dart';
import '../controllers/more_activities_controller.dart';

class MoreActivitiesPage extends GetView<MoreActivitiesController> {
  const MoreActivitiesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          shadowColor: Theme.of(context).colorScheme.shadow,
          title: const Text('المزيد من الأنشطة'),
          titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 75.h > 100.w ? 80.w / 3 : 80.w / 6,
            mainAxisSpacing: 8,
            crossAxisSpacing: 8,
          ),
          padding: const EdgeInsets.all(8.0),
          itemCount: controller.activities.length,
          itemBuilder: (context, index) {
            return CustomButtonBigIcon(
              text: controller.activities[index]['text'],
              iconData: controller.activities[index]['icon'],
              onTap: controller.activities[index]['onTap'],
            );
          },
        ),
      ),
    );
  }
}
