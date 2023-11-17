import 'package:flutter/material.dart';

class QuranTabBar extends StatelessWidget {
  const QuranTabBar(
      {super.key, required this.onTap, required this.tabController});
  final TabController tabController;
  final Function(int)? onTap;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: TabBar(
        controller: tabController,
        onTap: onTap,
        splashBorderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
        labelPadding:
            EdgeInsets.zero, // Auto-adjust font size based on available space

        tabs: const [
          Tab(
            text: "السّور",
          ),
          Tab(
            text: "الأجزاء",
          ),
          Tab(
            text: "الأحزاب",
          ),
        ],
      ),
    );
  }
}
