import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawakkal/controllers/e_tasbih_controller.dart';
import 'package:tawakkal/pages/e_tasbih_counter_page.dart';

import '../widgets/e_tasbih_widget.dart';

class ElectronicTashbihPage extends GetView<ElectronicTasbihController> {
  const ElectronicTashbihPage({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('المسبحة الإلكترونية'),
        titleTextStyle: theme.primaryTextTheme.titleMedium,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: controller.addTasbih,
        label: const Text('إضافة'),
        icon: const Icon(Icons.add),
      ),
      body: GetBuilder<ElectronicTasbihController>(builder: (context) {
        return ListView.builder(
          itemCount: controller.tasbihData.length,
          itemBuilder: (context, index) {
            var tasbih = controller.tasbihData[index];
            return Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              child: Column(
                children: [
                  const SizedBox(height: 10),
                  TasbihWidget(
                    name: tasbih.name,
                    count: tasbih.count,
                    totalCounter: tasbih.totalCounter.value,
                    onTap: () {
                      Get.to(() =>
                          ElectronicTashbihCounterPage(eTasbihModel: tasbih));
                    },
                    onDeletePressed: () => controller.deleteTasbih(tasbih.id!),
                    onEditPressed: () => controller.editTasbih(tasbih),
                  ),
                  if (index == controller.tasbihData.length - 1)
                    const SizedBox(height: 150),
                ],
              ),
            );
          },
        );
      }),
    );
  }
}
