import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import 'package:tawakkal/controllers/e_tasbih_controller.dart';
import 'package:tawakkal/data/models/e_tasbih.dart';
import '../widgets/e_tasbih_counter_button.dart';

class ElectronicTashbihCounterPage extends GetView<ElectronicTasbihController> {
  const ElectronicTashbihCounterPage({Key? key, required this.eTasbihModel})
      : super(key: key);
  final ElectronicTasbihModel eTasbihModel;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        shadowColor: theme.colorScheme.shadow,
        title: const Text('المسبحة الإلكترونية'),
        titleTextStyle: theme.primaryTextTheme.titleMedium,
        actions: [
          IconButton(
            onPressed: () =>
                controller.onResetCounterPressed(eTasbihModel: eTasbihModel),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () =>
            controller.counterDecrement(eTasbihModel: eTasbihModel),
        child: Text('${ArabicNumbers().convert(1)}-'),
      ),
      body: OrientationBuilder(
        builder: (context, orientation) {
          return orientation == Orientation.portrait
              ? buildPortraitLayout(theme)
              : buildLandscapeLayout(theme);
        },
      ),
    );
  }

  Widget buildPortraitLayout(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        buildInfoSection(theme),
        buildAdditionalSection(theme),
        const SizedBox(),
        const SizedBox(),
        const SizedBox(),
      ],
    );
  }

  Widget buildInfoSection(ThemeData theme) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 25),
          child: AutoSizeText(
            eTasbihModel.name,
            style: theme.textTheme.titleLarge,
            textAlign: TextAlign.center,
          ),
        ),
        const Divider(
          height: 30,
          endIndent: 20,
          indent: 20,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Obx(() {
              return buildCounterColumn('عدد الدورات',
                  eTasbihModel.totalCounter.value ~/ eTasbihModel.count, theme);
            }),
            const SizedBox(height: 35, child: VerticalDivider()),
            buildCounterColumn('عدد الحبات', eTasbihModel.count, theme),
            const SizedBox(height: 35, child: VerticalDivider()),
            Obx(() {
              return buildCounterColumn(
                  'العدد الإجمالي', eTasbihModel.totalCounter.value, theme);
            }),
          ],
        ),
      ],
    );
  }

  Widget buildCounterColumn(String label, int value, ThemeData theme) {
    return Column(
      children: [
        Text(label),
        Text(
          ArabicNumbers().convert(value),
          style: theme.textTheme.titleLarge,
        ),
      ],
    );
  }

  Widget buildAdditionalSection(ThemeData theme) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(height: 10),
        Obx(() {
          return Text(
            ArabicNumbers().convert(eTasbihModel.counter.value),
            style: theme.textTheme.headlineLarge,
          );
        }),
        const SizedBox(height: 40),
        ElectronicMasbhaButton(
          onPressed: () {
            controller.counterIncrement(eTasbihModel: eTasbihModel);
          },
          icon: FlutterIslamicIcons.tasbih,
        ),
      ],
    );
  }

  Widget buildLandscapeLayout(ThemeData theme) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        const SizedBox(width: 50),
        buildAdditionalSection(theme),
        const SizedBox(width: 20),
        Expanded(
          child: buildInfoSection(theme),
        ),
      ],
    );
  }
}
