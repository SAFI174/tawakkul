import 'package:get/get.dart';
import 'package:tawakkal/data/models/e_tasbih.dart';
import 'package:tawakkal/data/repository/e_tasbih_repository.dart';

import 'package:tawakkal/utils/dialogs/dialogs.dart';
import 'package:vibration/vibration.dart';

import '../utils/dialogs/add_edit_tasbih_dialog.dart';

class ElectronicTasbihController extends GetxController {
  final RxList<ElectronicTasbihModel> tasbihData =
      <ElectronicTasbihModel>[].obs;

  late final ElectronicTasbihRepository electronicTasbihRepository;

  void fetchDate() async {
    tasbihData.value = await electronicTasbihRepository.getAllTasbih();
    update();
  }

  void editTasbih(ElectronicTasbihModel tasbih) async {
    var result = await Get.dialog(
      AddEditTasbihDialog(
        isEditing: true,
        editItem: tasbih,
      ),
    );
    if (result != null) {
      await electronicTasbihRepository.updateTasbih(
          electronicTasbihModel: result);
      fetchDate();
    }
  }

  void addTasbih() async {
    var result = await Get.dialog(
      AddEditTasbihDialog(
        isEditing: false,
      ),
    );
    if (result != null) {
      await electronicTasbihRepository.insertTasbih(
          electronicTasbihModel: result);
      fetchDate();
    }
  }

  void deleteTasbih(int id) async {
    var result = await showDeleteItemDialog();
    if (result) {
      await electronicTasbihRepository.deleteTasbih(id: id);
      fetchDate();
    }
  }

  void onResetCounterPressed(
      {required ElectronicTasbihModel eTasbihModel}) async {
    if (await showResetTasbihCountersDialog()) {
      resetCounter(eTasbihModel: eTasbihModel);
    }
  }

  void resetCounter({required ElectronicTasbihModel eTasbihModel}) async {
    eTasbihModel.counter.value = 0;
    eTasbihModel.totalCounter.value = 0;
    await electronicTasbihRepository.resetCounter(id: eTasbihModel.id!);
    update();
  }

  void counterIncrement({required ElectronicTasbihModel eTasbihModel}) async {
    eTasbihModel.counter.value += 1;
    eTasbihModel.totalCounter.value += 1;
    if (eTasbihModel.counter.value == eTasbihModel.count) {
      Vibration.vibrate(duration: 150);
    }
    if (eTasbihModel.counter.value > eTasbihModel.count) {
      eTasbihModel.counter.value = 1;
    }
    await electronicTasbihRepository.updateCounters(eTasbihModel: eTasbihModel);
    update();
  }

  void counterDecrement({required ElectronicTasbihModel eTasbihModel}) async {
    if (eTasbihModel.counter.value == 0) {
      return;
    }
    eTasbihModel.counter.value -= 1;

    eTasbihModel.totalCounter.value -= 1;

    if (eTasbihModel.counter.value == eTasbihModel.count) {
      Vibration.vibrate(duration: 150);
    }
    if (eTasbihModel.counter.value > eTasbihModel.count) {
      eTasbihModel.counter.value = 1;
    }
    await electronicTasbihRepository.updateCounters(eTasbihModel: eTasbihModel);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    electronicTasbihRepository = ElectronicTasbihRepository();
    fetchDate();
  }
}
