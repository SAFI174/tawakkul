import 'package:expandable/expandable.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:quran/quran.dart';

import '../../../../../data/models/tafsir_data.dart';
import '../../../Widgets/surah_verse.dart';
import '../bindings/tafsir_download_manager_binding.dart';
import '../controllers/tafsir_details_controller.dart';
import 'tafsir_download_manager_page.dart';

class TafsirDetailsPage extends GetView<TafsirDetailsController> {
  const TafsirDetailsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: buildAppBar(context),
        body: buildBody(),
      ),
    );
  }

  // Build the app bar
  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      titleTextStyle: Get.isDarkMode
          ? Theme.of(context).textTheme.titleMedium
          : Theme.of(context).primaryTextTheme.titleMedium,
      scrolledUnderElevation: 1,
      actions: [
        IconButton(
          onPressed: () {
            Get.to(
              () => const TafsirDownloadManagerPage(),
              binding: TafsirDownloadManagerBinding(),
              transition: Transition.rightToLeftWithFade,
            );
          },
          icon: const Icon(FluentIcons.document_arrow_down_20_regular),
        ),
      ],
      title: buildAppBarTitle(context),
      centerTitle: false,
    );
  }

  // Build the title widget in the app bar
  Widget buildAppBarTitle(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          SurahVerseWidget(
            surah: controller.surahNumber.value,
            verse: controller.verseNumber.value,
          ),
          Text(' -  الآية ${controller.verseNumber.value}'),
        ],
      );
    });
  }

  // Build the body content
  Widget buildBody() {
    return Obx(() {
      return Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(top: 25, right: 20, left: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    buildVerseText(),
                    const SizedBox(
                      height: 10,
                    ),
                    const Divider(),
                    buildTafsirsList(),
                  ],
                ),
              ),
            ),
          ),
          const Divider(
            height: 1,
          ),
          buildNavigationButtons(),
        ],
      );
    });
  }

  // Build the Quran verse text
  Widget buildVerseText() {
    return Text(
      getVerse(controller.surahNumber.value, controller.verseNumber.value),
      style: const TextStyle(
          fontFamily: 'Uthmanic_Script',
          fontSize: 25,
          fontWeight: FontWeight.bold),
    );
  }

  // Build the list of Tafsirs
  Widget buildTafsirsList() {
    return Obx(() {
      return controller.tafsirsUrls.isNotEmpty && controller.tafsirsData.isEmpty
          ? const Center(
              child: Padding(
                padding: EdgeInsets.all(25.0),
                child: Text(
                  'جاري التحميل...',
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : controller.tafsirsData.isEmpty
              ? const Center(
                  child: Text(
                    'لم يتم تحميل اي تفسير!\n إضغط على الزر في الأعلى لتحميل تفسير',
                    textAlign: TextAlign.center,
                  ),
                )
              : ListView.builder(
                  primary: false,
                  shrinkWrap: true,
                  itemCount: controller.tafsirsData.length,
                  itemBuilder: (context, index) {
                    if (controller.tafsirsUrls.length !=
                        controller.tafsirsData.length) {}
                    TafsirData tafsirData = controller.tafsirsData[index];
                    return buildTafsirCard(context, tafsirData);
                  },
                );
    });
  }

  // Build a single Tafsir card
  Widget buildTafsirCard(BuildContext context, TafsirData tafsirData) {
    return Column(
      children: [
        ExpandablePanel(
          controller: ExpandableController(initialExpanded: true),
          header: Text(
            tafsirData.edition.name,
            style: Theme.of(context)
                .textTheme
                .labelLarge!
                .copyWith(color: Theme.of(context).colorScheme.onBackground),
          ),
          collapsed: const Text(''),
          theme: ExpandableThemeData.combine(
              ExpandableThemeData(
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                iconColor: Theme.of(context).colorScheme.onBackground,
              ),
              ExpandableThemeData.defaults),
          expanded: buildTafsirCardContent(context, tafsirData),
        ),
        const SizedBox(
          height: 5,
        ),
      ],
    );
  }

  // Build the content of a single Tafsir card
  Widget buildTafsirCardContent(BuildContext context, TafsirData tafsirData) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Obx(
          () {
            return Text(tafsirData.tafsirLists[controller.surahNumber.value - 1]
                [controller.verseNumber.value - 1]);
          },
        ),
        Row(
          children: [
            IconButton(
              onPressed: () {
                controller.copyTafsir(tafsirData);
              },
              icon: const Icon(FluentIcons.copy_20_regular),
            ),
            IconButton(
              onPressed: () {
                controller.shareTafsir(tafsirData);
              },
              icon: const Icon(FluentIcons.share_20_regular),
            ),
          ],
        ),
      ],
    );
  }

  // Build the navigation buttons
  Widget buildNavigationButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        TextButton.icon(
          onPressed: () {
            controller.goToPreviousAyah();
          },
          icon: const Icon(FluentIcons.arrow_step_over_20_regular),
          label: const Text('السابق'),
        ),
        Directionality(
          textDirection: TextDirection.ltr,
          child: TextButton.icon(
            onPressed: () {
              controller.goToNextAyah();
            },
            icon: const Icon(FluentIcons.arrow_step_back_20_regular),
            label: const Text('التالي'),
          ),
        ),
      ],
    );
  }
}
