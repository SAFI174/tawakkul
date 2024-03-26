import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawakkal/pages/azkar_settings_page.dart';
import '../../widgets/linear_progress_indicator.dart';
import '../../widgets/zkr_widget.dart';
import '../controllers/azkar_details_controller.dart';
import '../data/cache/azkar_settings_cache.dart';

class AzkarDetailsPage extends GetView<AzkarDetailsController> {
  AzkarDetailsPage({
    Key? key,
  }) : super(key: key);
  final appBarTitle = Get.arguments['pageTitle'];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(appBarTitle),
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
        actions: [
          IconButton(
            onPressed: controller.onResetAllButtonPressed,
            icon: const Icon(Icons.refresh_rounded),
          ),
          IconButton(
            onPressed: () {
              Get.to(() => AzkarSettingsPage());
            },
            icon: const Icon(FluentIcons.settings_16_regular),
          ),
        ],
      ),
      body: PopScope(
        canPop: false,
        onPopInvoked: (didPop){
          if (didPop) {
            return;
          }
          controller.showConfirmationDialogForExit();
        },
        child: Column(
          children: [
            const Divider(height: 1),
            // Display the progress bar
            Obx(() {
              return AnimatedLinearProgressIndicator(
                percentage: controller.progress.value,
                animationDuration: const Duration(milliseconds: 400),
              );
            }),
            // Display the list of Azkar
            Expanded(
              child: Obx(
                () {
                  return ListView.builder(
                    controller: controller.listScrollController,
                    shrinkWrap: true,
                    itemCount: controller.azkarData.length,
                    itemBuilder: (context, index) {
                      var zkr = controller.azkarData[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5),
                        child: Column(
                          children: [
                            if (index == 0) const SizedBox(height: 10),
                            // Display each ZkrWidget for the Azkar
                            GetBuilder<AzkarDetailsController>(
                              builder: (controller) {
                                return ZkrWidget(
                                  fontSize: AzkarSettingsCache.getFontSize(),
                                  title: zkr.title,
                                  note: zkr.note,
                                  isDone: zkr.isDone,
                                  description:
                                      ArabicNumbers().convert(zkr.text),
                                  count: zkr.count,
                                  counter: zkr.counter,
                                  onResetButtonPressed: () {
                                    controller.onResetButtonPressed(zkr: zkr);
                                  },
                                  onCounterButtonPressed: () {
                                    controller.onCounterButtonPressed(zkr: zkr);
                                  },
                                );
                              },
                            ),
                            const SizedBox(height: 10),
                            if (index == controller.azkarData.length - 1)
                              const SizedBox(height: 30),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
