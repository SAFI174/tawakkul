import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../data/models/e_tasbih.dart';

class AddEditTasbihDialog extends StatelessWidget {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController countController = TextEditingController();
  final isAddButtonEnabled = RxBool(false);

  final bool isEditing;
  final ElectronicTasbihModel? editItem;

  AddEditTasbihDialog({required this.isEditing, this.editItem, Key? key})
      : super(key: key) {
    if (isEditing) {
      nameController.text = editItem?.name ?? '';
      countController.text = editItem?.count.toString() ?? '';
      updateAddButtonStatus('');
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        isEditing ? 'تعديل التسبيح' : 'إضافة تسبيح جديد',
        style: Theme.of(context).textTheme.titleMedium,
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          TextField(
            controller: nameController,
            onChanged: updateAddButtonStatus,
            decoration: InputDecoration(
              labelText: 'التسبيح',
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(10),
              labelStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
          const SizedBox(height: 10),
          TextField(
            controller: countController,
            onChanged: updateAddButtonStatus,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              labelText: 'عدد الحبات',
              fillColor: Colors.transparent,
              contentPadding: const EdgeInsets.all(10),
              labelStyle: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        ],
      ),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: null),
          child: const Text('إلغاء'),
        ),
        Obx(() {
          return TextButton(
            onPressed: isAddButtonEnabled.value ? saveItem : null,
            child: Text(isEditing ? 'حفظ التعديل' : 'إضافة'),
          );
        }),
      ],
    );
  }

  void updateAddButtonStatus(String _) {
    isAddButtonEnabled.value =
        nameController.text.isNotEmpty && countController.text.isNotEmpty;
  }

  void saveItem() {
    final name = nameController.text;
    final count = int.tryParse(countController.text) ?? 0;
    if (isEditing) {
      Get.back(
          result: ElectronicTasbihModel(
              id: editItem!.id, name: name, count: count));
    } else {
      Get.back(result: ElectronicTasbihModel(name: name, count: count));
    }
  }
}
