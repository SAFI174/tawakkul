import 'package:auto_size_text/auto_size_text.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../data/repository/asmaullah_repository.dart';
import '../widgets/custom_progress_indicator.dart';
import '../widgets/loading_error_text.dart';

class AsmaullahPageView extends GetView {
  const AsmaullahPageView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: const Text('أسماء الله الحسنى'), // App bar title
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
      ),
      body: FutureBuilder(
        future: AsmaullahRepository().getAsmaullahData(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomCircularProgressIndicator();
          } else if (snapshot.hasError) {
            return const Center(
              child: LoadingErrorText(),
            );
          } else {
            var asmaullah = snapshot.data!;
            return GridView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: 99,
              gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 75.h > 100.w ? 80.w / 3 : 80.h / 6,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) {
                var name = asmaullah[index];
                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(
                      width: 1,
                      color: Theme.of(context).disabledColor.withAlpha(40),
                    ),
                  ),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(9),
                    onTap: () {
                      Get.dialog(
                        AlertDialog(
                          title: Text(name.ttl!),
                          content: Text(name.dsc!),
                          actions: <Widget>[
                            TextButton(
                              onPressed: () {
                                Get.back();
                              },
                              child: const Text("حسناََ"),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Center(
                      child: AutoSizeText(
                        name.ttl!,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}
