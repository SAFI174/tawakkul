import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/home_controller.dart';
import 'main_page.dart';
import 'more_activities_page.dart';
import 'quran_main_dashborad_page.dart';

class HomePage extends GetView<HomeController> {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return WillPopScope(
        onWillPop: () {
          Get.back();
          return Future(() => true);
        },
        child: Directionality(
          textDirection: TextDirection.ltr,
          child: Scaffold(
            body: const [
              MainPage(),
              QuranMainDashboradPage(),
              QuranMainDashboradPage(),
              MoreActivitiesPage()
            ][controller.selectedDestination.value],
            bottomNavigationBar: Container(
              decoration: BoxDecoration(boxShadow: [
                BoxShadow(
                    color: Theme.of(context).shadowColor.withAlpha(90),
                    spreadRadius: 0,
                    blurRadius: 0.01,
                    blurStyle: BlurStyle.outer)
              ]),
              child: NavigationBar(
                elevation: 0,
                onDestinationSelected: (value) {
                  controller.onDestinationChanged(value);
                },
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                selectedIndex: controller.selectedDestination.value,
                destinations: const [
                  NavigationDestination(
                    icon: Icon(FluentIcons.home_24_regular),
                    selectedIcon: Icon(FluentIcons.home_24_filled),
                    label: "الرئيسية",
                  ),
                  NavigationDestination(
                    icon: Icon(FluentIcons.book_24_regular),
                    selectedIcon: Icon(FluentIcons.book_24_filled),
                    label: "القرآن الكريم",
                  ),
                  NavigationDestination(
                    icon: Icon(FluentIcons.clock_24_regular),
                    selectedIcon: Icon(FluentIcons.clock_24_filled),
                    label: "أوقات الصلاة",
                  ),
                  NavigationDestination(
                    icon: Icon(FluentIcons.more_circle_24_regular),
                    selectedIcon: Icon(FluentIcons.more_circle_24_filled),
                    label: "المزيد",
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    });
  }
}
