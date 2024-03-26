import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tawakkal/constants/all_activites.dart';
import 'package:tawakkal/constants/constants.dart';
import 'package:tawakkal/widgets/quran_reading_page_widgets.dart';
import '../../../widgets/custom_button_big_icon.dart';
import '../controllers/main_controller.dart';
import '../widgets/current_prayer_details_widget.dart';
import 'package:tawakkal/utils/utils.dart';

import '../widgets/daily_content_widget.dart';

class MainPage extends GetView<MainController> {
  const MainPage({super.key});
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(

          title: const Text(appName),
          actions: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  Utils.getCurrentDate(),
                  style: theme.primaryTextTheme.labelMedium,
                ),
                Text(
                  Utils.getCurrentDateHijri(),
                  style: theme.primaryTextTheme.labelMedium,
                ),
              ],
            ),
            const Gap(10),
          ],
        ),
        body: SingleChildScrollView(
          physics: const AlwaysScrollableScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0, left: 25, right: 25),
                child: FittedBox(
                  child: bismillahTextWidget(),
                ),
              ),
              const Padding(
                padding: EdgeInsets.all(10.0),
                child: CurrentPrayerDetailsWidget(),
              ),
              const Gap(15),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: Text(
                  'الإختصارات',
                  style: theme.textTheme.titleSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const Gap(10),
              SizedBox(
                height: 100,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: Activites.shortcuts.length,
                  shrinkWrap: true,
                  itemBuilder: (context, index) {
                    var activity = Activites.shortcuts[index];
                    return Row(
                      children: [
                        const Gap(5),
                        CustomButtonBigIcon(
                          text: activity['text'],
                          iconData: activity['icon'],
                          onTap: activity['onTap'],
                        ),
                        index == Activites.shortcuts.length - 1
                            ? const Gap(5)
                            : const Gap(0)
                      ],
                    );
                  },
                ),
              ),
              const Gap(10),
              GetBuilder<MainController>(builder: (context) {
                return Column(
                  children: [
                    DailyContentContainer(
                      description: controller.dailyContent?.dua ?? '',
                      title: 'دعاء اليوم',
                    ),
                    DailyContentContainer(
                      description:
                          '${controller.dailyContent?.generalInfo['content']}',
                      subtitle:
                          '${controller.dailyContent?.generalInfo['title']}',
                      title: 'معلومة',
                    ),
                    DailyContentContainer(
                      description: '${controller.dailyContent?.hadith['text']}',
                      subtitle: '${controller.dailyContent?.hadith['rwi']}',
                      title: 'حديث اليوم',
                    ),
                    DailyContentContainer(
                      description: '${controller.dailyContent?.verse['ayah']}',
                      subtitle: '${controller.dailyContent?.verse['surah']}',
                      title: 'آية اليوم',
                    ),
                    DailyContentContainer(
                      description: '${controller.dailyContent?.asmOfAllah.ttl}',
                      subtitle: '\n${controller.dailyContent?.asmOfAllah.dsc}',
                      descriptionTextStyle: theme.textTheme.displayLarge,
                      subtitleTextStyle: theme.textTheme.labelLarge,
                      title: 'اسماء الله الحسنى',
                    ),
                  ],
                );
              }),
              const Gap(25),
            ],
          ),
        ),
      ),
    );
  }
}
