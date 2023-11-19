import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tawakkal/constants/enum.dart';
import 'package:tawakkal/data/repository/azkar_repository.dart';
import 'package:tawakkal/routes/app_pages.dart';
import 'package:tawakkal/widgets/custom_progress_indicator.dart';

import '../controllers/azkar_categories_controller.dart';
import '../widgets/custom_container.dart';
import '../widgets/loading_error_text.dart';

class AzkarCategoriesPage extends GetView<AzkarCategoriesController> {
  const AzkarCategoriesPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        shadowColor: Theme.of(context).colorScheme.shadow,
        title: const Text('أذكار المسلم'),
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
      ),
      body: GetBuilder<AzkarCategoriesController>(builder: (context) {
        return FutureBuilder(
          future: AzkarRepository().getAzkarCategories(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CustomCircularProgressIndicator();
            } else if (snapshot.hasData) {
              return GridView.builder(
                itemCount: snapshot.data!.length,
                padding: const EdgeInsets.all(8),
                gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 75.h > 100.w ? 80.w / 2 : 80.h / 6,
                  mainAxisSpacing: 8,
                  childAspectRatio: 16 / 12,
                  crossAxisSpacing: 8,
                ),
                itemBuilder: (context, index) {
                  var category = snapshot.data![index];
                  return CustomContainer(
                    child: InkWell(
                      borderRadius: BorderRadius.circular(9),
                      onTap: () {
                        Get.toNamed(Routes.AZKAR_DETAILS, arguments: {
                          'pageTitle': category.title,
                          'categoryId': category.id,
                          'type': AzkarPageType.azkar,
                        });
                      },
                      child: Center(child: Text(category.title)),
                    ),
                  );
                },
              );
            } else {
              return const Center(
                child: LoadingErrorText(),
              );
            }
          },
        );
      }),
    );
  }
}
