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
          title: const Text('المزيد من الأنشطة'),
          titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
          actions: [
            IconButton(
                onPressed: () {}, icon: const Icon(Icons.settings_outlined))
          ],
        ),
        body: GridView.builder(
          gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
            maxCrossAxisExtent: 100.w > 100.h ? 80.w / 6 : 80.w / 2,
            mainAxisSpacing: 8,
            childAspectRatio: 16 / 14,
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
// GridView.builder(
//           gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
//             maxCrossAxisExtent: 100.w > 100.h ? 80.w / 6 : 80.w / 2,
//             mainAxisSpacing: 8,
//             crossAxisSpacing: 8,
//           ),
//           padding: const EdgeInsets.all(8.0),
//           itemCount: controller.activities.length,
//           itemBuilder: (context, index) {
//             return CustomButtonBigIcon(
//               text: controller.activities[index]['text'],
//               iconData: controller.activities[index]['icon'],
//               onTap: controller.activities[index]['onTap'],
//             );
//           },
//         ),