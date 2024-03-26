import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../widgets/custom_search_bar.dart';
import '../../Views/hizb_list_view.dart';
import '../../Views/juz_list_view.dart';
import '../../Views/surah_list_view.dart';
import '../../Widgets/quran_tab_bar.dart';
import '../controllers/quran_main_dashborad_controller.dart';

class QuranMainDashboradPage extends GetView<QuranMainDashboradController> {
  const QuranMainDashboradPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: NestedScrollView(
          body: Obx(() {
            return TabBarView(
              controller: controller.tabController,
              children: [
                SurahListView(
                  searchText: controller.surahSearchText.value,
                ),
                JuzListView(
                  searchText: controller.juzSearchText.value,
                ),
                HizbListView(
                  searchText: controller.hizbSearchText.value,
                ),
              ],
            );
          }),
          headerSliverBuilder: (context, innerBoxIsScrolled) {
            return [
              SliverAppBar(
                forceElevated: innerBoxIsScrolled,
                toolbarHeight: 80,
                pinned: true,
                floating: true,
                title: Obx(() {
                  return CustomSearchBar(
                    onChanged: (value) {
                      controller.tabController.index == 0
                          ? controller.surahSearchText.value = value
                          : null;
                      controller.tabController.index == 1
                          ? controller.juzSearchText.value = value
                          : null;
                      controller.tabController.index == 2
                          ? controller.hizbSearchText.value = value
                          : null;
                    },
                    hintText: controller.hintTextSearchBar.value,
                  );
                }),
                leadingWidth: 0,
                actions: [
                  IconButton(
                    onPressed: controller.onLastPagePressed,
                    tooltip: 'اخر قراءة',
                    icon:
                        const Icon(FluentIcons.reading_mode_mobile_20_regular),
                  ),
                  IconButton(
                    tooltip: 'العلامات المرجعية',
                    onPressed: controller.onBookmarksPressed,
                    icon: const Icon(FluentIcons.bookmark_search_24_regular),
                  ),
                  const SizedBox(
                    width: 5,
                  )
                ],
                bottom: PreferredSize(
                  preferredSize: const Size.fromHeight(48.0),
                  child: QuranTabBar(
                    onTap: (value) => controller.updatehintText(value),
                    tabController: controller.tabController,
                  ),
                ),
              )
            ];
          },
        ),
      ),
    );
  }
}
