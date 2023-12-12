
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class UpdateLocationDialog extends StatelessWidget {
  const UpdateLocationDialog({super.key, required this.isUpdatingLocation});
  final RxBool isUpdatingLocation;
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: const Padding(
        padding: EdgeInsets.only(top: 8.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: [
            SizedBox(
              height: 25,
              width: 25,
              child: CircularProgressIndicator(
                strokeWidth: 2,
              ),
            ),
            Gap(15),
            Text('جاري الحصول على الموقع الحالي...'),
          ],
        ),
      ),
      actions: [
        TextButton(
            onPressed: () {
              isUpdatingLocation.value = false;
              Get.back();
            },
            child: const Text('إلغاء'))
      ],
    );
  }
}
