import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawakkal/data/models/azkar_detail_model.dart';
import 'package:tawakkal/data/repository/azkar_repository.dart';

import '../../constants/enum.dart';
import '../../utils/dialogs/dialogs.dart';
import '../data/cache/azkar_settings_cache.dart';

class AzkarDetailsController extends GetxController {
  // List to hold the AzkarDetailModel items
  RxList<AzkarDetailModel> azkarData = RxList();

  // Current page type
  late AzkarPageType zkrType;

  late final int? categoryId;
  // Controller for the list view scrolling
  late final ScrollController listScrollController;
  // Progress variable to track the overall completion progress
  late final RxDouble progress;

  // Function to update the progress based on the AzkarDetailModel items
  void updateProgress() async {
    // Calculate the total item count based on the count property of each AzkarDetailModel
    int totalItemCount = azkarData.fold<int>(
      0,
      (previousValue, item) => previousValue + item.count,
    );

    // Calculate the sum of completed items based on the counter property of each dua or tasbih
    int completedItemCount = azkarData.fold<int>(
      0,
      (previousValue, item) => previousValue + item.counter,
    );

    // Update the progress based on the calculated values
    progress.value = (totalItemCount - completedItemCount) / totalItemCount;

    // check if the user is done all azkar
    if (progress.value == 1) {
      if (await showAzkarCompletedDialog()) {
        onResetAllButtonPressed();
      }
    }
    if (progress.value == 0) {
      // delete progress from cache
      if (zkrType == AzkarPageType.azkar) {
        await AzkarRepository()
            .resetCountersForCategoryId(categoryId: categoryId!);
      } else {
        AzkarRepository().resetCountersForType(zkrType: zkrType);
      }
    }
    update();
  }

  // Fetch data based on the specified AzkarPageType
  Future<void> fetchDataByType() async {
    List<AzkarDetailModel> newData =
        await AzkarRepository().getAzkarByType(zkrType: zkrType);
    azkarData.value = newData;
    updateProgress();
  }

  // Fetch data based on the specified Category Id
  Future<void> fetchDataByCategoryId() async {
    List<AzkarDetailModel> newData =
        await AzkarRepository().getAzkarByCategoryId(categoryId: categoryId);
    azkarData.value = newData;
    updateProgress();
  }

  // Function to handle the reset button press
  void onResetButtonPressed({required AzkarDetailModel zkr}) {
    // Reset the counter and mark the item as not done
    zkr.counter = zkr.count;
    zkr.isDone = false;

    // Update the progress after the reset
    updateProgress();
  }

  // Function to handle the counter button press
  void onCounterButtonPressed({required AzkarDetailModel zkr}) {
    // Decrement the counter
    if (zkr.counter > 0) {
      zkr.counter = zkr.counter - 1;
      if (zkr.counter == 0) {
        // If the counter reaches zero, mark the item as done
        zkr.isDone = true;
      }
    } else {
      // If the counter is already zero, mark the item as done
      zkr.isDone = true;
    }

    // Update the progress after the counter change
    updateProgress();
  }

  // Function to handle reset all button press
  Future<void> onResetAllButtonPressed() async {
    // Re-fetch the data from the repository
    if (zkrType == AzkarPageType.azkar) {
      await AzkarRepository()
          .resetCountersForCategoryId(categoryId: categoryId!);
      await Future.delayed(const Duration(milliseconds: 250));
    } else {
      await AzkarRepository().resetCountersForType(zkrType: zkrType);
      await Future.delayed(const Duration(milliseconds: 250));
    }
    for (var element in azkarData) {
      element.counter = element.count;
      element.isDone = false;
    }
    // Reset the progress bar
    progress.value = 0;

    // Scroll to the top
    listScrollController.animateTo(
      0,
      curve: Curves.easeOutCubic,
      duration: const Duration(milliseconds: 800),
    );
    update();
  }

  // Function to check if the user is done all azkar
  bool isUserDoneAllAzkar() {
    return azkarData.every((element) => element.isDone == true);
  }

  // Show confirmation dialog on exit
  Future<void> showConfirmationDialogForExit() async {
    if (AzkarSettingsCache.getShowExitConfirmDialog()) {
      if (!isUserDoneAllAzkar() && progress.value > 0) {
        final shouldSave = await showAzkarNotDoneDialog();
        if (shouldSave == null) {
          return;
        }
        if (shouldSave) {
          if (progress.value != 0) {
            await AzkarRepository().saveAzkarProgress(data: azkarData);
          }
          Get.back();
        } else {
          Get.close(2);
        }
      }
    }
  }

  @override
  void onInit() async {
    super.onInit();
    listScrollController = ScrollController();
    progress = RxDouble(0);
    zkrType = Get.arguments['type'];
    categoryId = Get.arguments['categoryId'];
  }

  @override
  void onReady() {
    if (zkrType == AzkarPageType.azkar) {
      fetchDataByCategoryId();
    } else {
      fetchDataByType();
    }
  }
}
