import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddZkrCategoryDialog extends StatelessWidget {
  final TextEditingController _nameController = TextEditingController();

  final RxBool isButtonDisabled = true.obs;

  AddZkrCategoryDialog({super.key});

  void _onTextChanged() {
    isButtonDisabled.value = _nameController.text.trim().isEmpty;
  }

  @override
  Widget build(BuildContext context) {
    _nameController.addListener(_onTextChanged);

    return AlertDialog(
      title: const Text(
        'إضافة مجموعة أذكار',
        style: TextStyle(fontSize: 20),
      ),
      content: TextField(
        autofocus: true,
        controller: _nameController,
        decoration: const InputDecoration(
          isDense: true,
          fillColor: Colors.transparent,
          labelText: 'اسم المجموعة',
        ),
      ),
      actions: [
        Obx(() {
          return TextButton(
            onPressed: isButtonDisabled.value
                ? null
                : () {
                    // Validate and save the category
                    String categoryName = _nameController.text.trim();
                    if (categoryName.isNotEmpty) {
                      Get.back(result: categoryName);
                    }
                  },
            child: const Text('إضافة'),
          );
        }),
        TextButton(
          onPressed: () {
            Get.back(); // Close the dialog using GetX
          },
          child: const Text('إلغاء'),
        ),
      ],
    );
  }
}
