import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tawakkal/controllers/tafsir_download_manager_controller.dart';
import 'package:tawakkal/widgets/custom_progress_indicator.dart';

class TafsirDownloadManagerPage
    extends GetView<TafsirDownloadManagerController> {
  const TafsirDownloadManagerPage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 1,
          elevation: 1,
          shadowColor: theme.shadowColor,
          title: const Text(
            'تفسير',
            style: TextStyle(color: Colors.white),
          ),
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Text(
                'عربي:',
                style: theme.textTheme.titleMedium,
              ),
            ),
            Expanded(
                child: FutureBuilder(
              future: controller.tafsirFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return CustomCircularProgressIndicator();
                } else {
                  var tafsirList = snapshot.data!;
                  return ListView.builder(
                    itemCount: tafsirList.length,
                    itemBuilder: (BuildContext context, int index) {
                      final tafsir = tafsirList[index];

                      return Obx(
                        () {
                          return Column(
                            children: [
                              ListTile(
                                  title: Text(tafsir.name!),
                                  subtitle: Text(tafsir.englishName!),
                                  trailing: !tafsir.isDownloaded.value
                                      ? !tafsir.isDownloading.value
                                          ? IconButton(
                                              style: IconButton.styleFrom(
                                                  visualDensity:
                                                      VisualDensity.compact),
                                              onPressed: () async {
                                                controller
                                                    .onDownloadButtonPressed(
                                                        tafsir);
                                              },
                                              icon: Icon(
                                                Iconsax.arrow_down_2,
                                                color:
                                                    theme.colorScheme.primary,
                                              ),
                                            )
                                          : Padding(
                                              padding:
                                                  const EdgeInsets.all(10.0),
                                              child: Text(
                                                '% ${ArabicNumbers().convert(tafsir.downloadProgress.value)}',
                                                style:
                                                    theme.textTheme.titleSmall,
                                              ),
                                            )
                                      : IconButton(
                                          style: IconButton.styleFrom(
                                              visualDensity:
                                                  VisualDensity.compact),
                                          onPressed: () async {
                                            controller.deleteTafsir(tafsir);
                                          },
                                          icon: Icon(
                                            Iconsax.minus_cirlce,
                                            color: theme.colorScheme.error,
                                          ),
                                        )),
                              const Divider(),
                            ],
                          );
                        },
                      );
                    },
                  );
                }
              },
            )),
          ],
        ),
      ),
    );
  }
}
