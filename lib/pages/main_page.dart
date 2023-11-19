import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';

import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';

import 'package:get/get.dart';
import '../../../widgets/custom_button_big_icon.dart';
import '../controllers/main_controller.dart';

class MainPage extends GetView<MainController> {
  const MainPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        shadowColor: Theme.of(context).colorScheme.shadow,
        elevation: 0,
        centerTitle: true,
        title: FittedBox(
          child: Text(
            'تَوَكَّلَ',
          ),
        ),
        actions: [
          AutoSizeText(
            '${controller.currentDate}\n${controller.currentDateHijri}',
            textDirection: TextDirection.rtl,
          ),
          const SizedBox(width: 5),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            SizedBox(
              height: 100,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                itemCount: 5,
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  return Row(
                    children: [
                      CustomButtonBigIcon(
                        text: 'اسماء الله الحسنى',
                        iconData: FlutterIslamicIcons.allahText,
                        onTap: () {},
                      ),
                      SizedBox(width: 5),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
