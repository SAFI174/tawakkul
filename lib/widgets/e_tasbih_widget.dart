import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';

class TasbihWidget extends StatelessWidget {
  const TasbihWidget({
    super.key,
    required this.name,
    required this.count,
    required this.totalCounter,
    required this.onTap,
    required this.onDeletePressed,
    required this.onEditPressed,
  });
  final Function() onTap;
  final Function() onDeletePressed;
  final Function() onEditPressed;
  final String name;
  final int count;
  final int totalCounter;
  Widget buildTextIconButton(IconData icon, String text, Function() onTap,
      {iconSize = 20.0}) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: iconSize,
            ),
            const SizedBox(width: 5),
            Text(
              text,
              style: Theme.of(Get.context!).textTheme.labelSmall,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: theme.disabledColor.withAlpha(40),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Material(
              borderRadius: const BorderRadius.only(
                  topRight: Radius.circular(9), topLeft: Radius.circular(9)),
              child: Row(
                children: [
                  buildTextIconButton(
                    FluentIcons.copy_16_regular,
                    'نسخ',
                    () async {
                      await Clipboard.setData(
                        ClipboardData(text: name),
                      );
                    },
                  ),
                  const SizedBox(height: 45, child: VerticalDivider(width: 1)),
                  buildTextIconButton(
                    Iconsax.edit,
                    'تعديل',
                    onEditPressed,
                    iconSize: 18.0,
                  ),
                  const SizedBox(height: 45, child: VerticalDivider(width: 1)),
                  buildTextIconButton(
                    Iconsax.minus_cirlce,
                    'حذف',
                    onDeletePressed,
                    iconSize: 18.0,
                  ),
                  const SizedBox(height: 45, child: VerticalDivider(width: 1)),
                ],
              ),
            ),
            const Divider(height: 1),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Text(
                name,
              ),
            ),
            SizedBox(height: 10),
            const Divider(height: 1),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'عدد الحبات : ${ArabicNumbers().convert(count)}',
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    const SizedBox(
                        height: 45, child: VerticalDivider(width: 1)),
                  ],
                ),
                Row(
                  children: [
                    const SizedBox(
                        height: 45, child: VerticalDivider(width: 1)),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'العدد الكلي : ${ArabicNumbers().convert(totalCounter)}',
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
