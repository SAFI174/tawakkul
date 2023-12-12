// TODO: Refactor this object
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tawakkal/widgets/custom_pop_menu_item.dart';

import '../utils/utils.dart';
import 'custom_container.dart';

class DailyContentContainer extends StatelessWidget {
  const DailyContentContainer({
    super.key,
    required this.title,
    required this.description,
    this.subtitle,
    this.descriptionTextStyle,
    this.subtitleTextStyle,
  });
  final TextStyle? descriptionTextStyle;
  final TextStyle? subtitleTextStyle;
  final String title;
  final String description;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.only(right: 15.0, left: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: theme.textTheme.titleSmall!.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              PopupMenuButton<dynamic>(
                position: PopupMenuPosition.under,
                padding: EdgeInsets.zero,
                itemBuilder: (context) {
                  return [
                    CustomPopupMenuItem.build(
                        index: 'copy',
                        iconData: FluentIcons.copy_16_regular,
                        text: 'نسخ'),
                    CustomPopupMenuItem.build(
                        index: 'share',
                        iconData: FluentIcons.share_16_regular,
                        text: 'مشاركة')
                  ];
                },
                onSelected: (value) {
                  switch (value) {
                    case 'copy':
                      Utils.copyToClipboard(text: "$description\n$subtitle");
                      break;
                    case 'share':
                      Utils.shareText(text: "$description\n$subtitle");
                      break;
                    default:
                  }
                },
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10.0),
          child: CustomContainer(
            useMaterial: true,
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: [
                  Text(
                    description,
                    style: descriptionTextStyle ??
                        theme.textTheme.titleMedium!.copyWith(height: 2),
                    textAlign: TextAlign.center,
                  ),
                  const Gap(10),
                  subtitle == null
                      ? SizedBox()
                      : Text(
                          subtitle!,
                          style: subtitleTextStyle ??
                              TextStyle(fontWeight: FontWeight.bold),
                          textAlign: TextAlign.center,
                        )
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
