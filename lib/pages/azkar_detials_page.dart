import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../widgets/linear_progress_indicator.dart';
import '../../widgets/zkr_widget.dart';
import '../controllers/azkar_details_controller.dart';

class AzkarDetailsPage extends GetView<AzkarDetailsController> {
  const AzkarDetailsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(Get.arguments['pageTitle']),
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
        actions: [
          IconButton(
            onPressed: controller.onResetAllButtonPressed,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: WillPopScope(
        onWillPop: controller.showConfirmationDialogForExit,
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
                            Obx(() {
                              return ZkrWidget(
                                title: zkr.title,
                                note: zkr.note,
                                isDone: zkr.isDone.value,
                                description: ArabicNumbers().convert(zkr.text),
                                count: zkr.count,
                                counter: zkr.counter.value,
                                onResetButtonPressed: () {
                                  controller.onResetButtonPressed(zkr: zkr);
                                },
                                onCounterButtonPressed: () {
                                  controller.onCounterButtonPressed(zkr: zkr);
                                },
                              );
                            }),
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
