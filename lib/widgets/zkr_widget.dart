import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:share_plus/share_plus.dart';

class ZkrWidget extends StatelessWidget {
  const ZkrWidget({
    Key? key,
    this.title,
    required this.description,
    required this.count,
    this.note,
    required this.counter,
    required this.onCounterButtonPressed,
    required this.onResetButtonPressed,
    required this.isDone,
  }) : super(key: key);

  final String? title;
  final String description;
  final String? note;
  final int count;
  final int counter;
  final Function() onCounterButtonPressed;
  final Function() onResetButtonPressed;
  final bool isDone;

  // Helper method for building text with icon buttons
  Widget buildTextIconButton(IconData icon, String text, Function() onTap) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 11, vertical: 12),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
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
    var sharetext = '$description\n التكرار: $count';

    return Container(
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
          // Top row with action buttons
          Material(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(9), topLeft: Radius.circular(9)),
            type: MaterialType.card,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Copy, Share, Reset buttons
                Row(
                  children: [
                    buildTextIconButton(
                      FluentIcons.copy_16_regular,
                      'نسخ',
                      () async {
                        await Clipboard.setData(
                          ClipboardData(text: sharetext),
                        );
                      },
                    ),
                    const SizedBox(
                        height: 45, child: VerticalDivider(width: 1)),
                    buildTextIconButton(
                      FluentIcons.share_16_regular,
                      'مشاركة',
                      () async {
                        await Share.share(sharetext);
                      },
                    ),
                    const SizedBox(
                        height: 45, child: VerticalDivider(width: 1)),
                    buildTextIconButton(
                      Icons.refresh_rounded,
                      'إعادة',
                      onResetButtonPressed,
                    ),
                    const SizedBox(
                        height: 45, child: VerticalDivider(width: 1)),
                  ],
                ),
                // Display the count
                Row(
                  children: [
                    const SizedBox(
                        height: 45, child: VerticalDivider(width: 1)),
                    Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        'التكرار : ${ArabicNumbers().convert(count)}',
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const Divider(height: 1),

          // Main content
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                if (title != null)
                  Text(
                    title!,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.justify,
                  ),
                SizedBox(height: note != null ? 10 : 0),
                Text(
                  description,
                  style: Theme.of(context).textTheme.titleMedium,
                  textAlign: TextAlign.justify,
                ),
                SizedBox(height: note != null ? 10 : 0),
                if (note != null)
                  Text(
                    '($note)',
                    textAlign: TextAlign.justify,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                const SizedBox(height: 10),
              ],
            ),
          ),
          const Divider(height: 1),

          // Bottom row with the counter button
          Material(
            type: MaterialType.card,
            borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(9),
                bottomRight: Radius.circular(9)),
            child: Row(
              children: [
                Expanded(
                  child: Material(
                    color: isDone
                        ? Get.isDarkMode
                            ? theme.primaryColorDark
                            : theme.primaryColor.withAlpha(200)
                        : Colors.transparent,
                    borderRadius: const BorderRadius.only(
                        bottomRight: Radius.circular(9),
                        bottomLeft: Radius.circular(9)),
                    child: InkWell(
                      borderRadius: const BorderRadius.only(
                          bottomRight: Radius.circular(9),
                          bottomLeft: Radius.circular(9)),
                      onTap: isDone ? null : onCounterButtonPressed,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 13, horizontal: 80),
                        child: isDone
                            ? const Icon(
                                Icons.check,
                                size: 20,
                                color: Colors.white,
                              )
                            : AutoSizeText(
                                ArabicNumbers().convert(counter),
                                presetFontSizes: const [14, 20, 25],
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: isDone
                                      ? Colors.white
                                      : theme.colorScheme.onBackground,
                                ),
                                maxLines: 1,
                              ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
