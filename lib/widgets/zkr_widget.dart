import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
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

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var sharetext = '$description\n التكرار: $count';
    Widget buildIcon(IconData icon, Function() onTap) {
      return InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(11.0),
          child: Icon(icon),
        ),
      );
    }

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
          Material(
            borderRadius: const BorderRadius.only(
                topRight: Radius.circular(9), topLeft: Radius.circular(9)),
            type: MaterialType.card,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    buildIcon(
                      FluentIcons.copy_16_regular,
                      () async {
                        await Clipboard.setData(
                          ClipboardData(text: sharetext),
                        );
                      },
                    ),
                    const SizedBox(
                        height: 45, child: VerticalDivider(width: 1)),
                    buildIcon(
                      FluentIcons.share_16_regular,
                      () async {
                        await Share.share(sharetext);
                      },
                    ),
                    const SizedBox(
                        height: 45, child: VerticalDivider(width: 1)),
                    buildIcon(
                      Icons.refresh_rounded,
                      onResetButtonPressed,
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
