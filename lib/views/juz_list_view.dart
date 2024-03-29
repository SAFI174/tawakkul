import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawakkal/utils/extension.dart';
import '../Widgets/juz_item.dart';

class JuzListView extends GetView {
  const JuzListView(
      {super.key, this.currentJuzNumber = -1, this.searchText = ''});
  final int currentJuzNumber;
  final String searchText;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: 30,
        padding: EdgeInsets.zero,
        itemBuilder: (context, juzNumber) {
          juzNumber++;
          return juzNumber.getJuzName.contains(searchText) ||
              juzNumber.toString().contains(searchText)
              ? Material(
            borderRadius: BorderRadius.circular(20),
            color: currentJuzNumber == juzNumber
                ? Theme.of(context).hoverColor
                : Colors.transparent,
            child: juzNumber == 1
                ? Column(
              children: [
                const SizedBox(
                  height: 10,
                ),
                JuzItem(juzNumber: juzNumber),
              ],
            )
                : JuzItem(juzNumber: juzNumber),
          )
              : const SizedBox();
        },
      ),
    );
  }
}
