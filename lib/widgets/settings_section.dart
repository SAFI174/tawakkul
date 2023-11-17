import 'package:expandable/expandable.dart';
import 'package:flutter/material.dart';

class SettingsSection extends StatelessWidget {
  const SettingsSection(
      {super.key, required this.sectionTitle, required this.child});
  final String sectionTitle;
  final Widget child;
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            width: 1,
            color: Theme.of(context).disabledColor.withAlpha(40),
          ),
        ),
        child: ExpandablePanel(
          controller: ExpandableController(initialExpanded: true),
          header: Material(
            type: MaterialType.card,
            color: Colors.transparent,
            borderRadius: const BorderRadius.only(
              topRight: Radius.circular(9),
              topLeft: Radius.circular(9),
            ),
            surfaceTintColor: Theme.of(context).primaryColor,
            shadowColor: Colors.transparent,
            elevation: 1,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          sectionTitle,
                          style: Theme.of(context)
                              .textTheme
                              .labelLarge!
                              .copyWith(
                                  color: Theme.of(context)
                                      .colorScheme
                                      .onBackground),
                        ),
                        const Icon(Icons.keyboard_arrow_down),
                      ],
                    )),
              ],
            ),
          ),
          collapsed: SizedBox(),
          theme: ExpandableThemeData.combine(
              ExpandableThemeData(
                animationDuration: Duration(milliseconds: 1),
                hasIcon: false,
                useInkWell: false,
                headerAlignment: ExpandablePanelHeaderAlignment.center,
                iconColor: Theme.of(context).colorScheme.onBackground,
              ),
              ExpandableThemeData.defaults),
          expanded: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Divider(
                thickness: 1.2,
                height: 1.2,
              ),
              child
            ],
          ),
        ),
      ),
    );
  }
}
