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
    var titleTextStyle = theme.textTheme.titleSmall;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'تفسير',
          ),
            titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
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
                  return ListView.separated(
                    itemCount: tafsirList.length,
                    separatorBuilder: (context, index) {
                      return const Divider();
                    },
                    itemBuilder: (BuildContext context, int index) {
                      final tafsir = tafsirList[index];

                      return Obx(
                        () {
                          return ListTile(
                              onTap: () {
                                controller.onDownloadButtonPressed(tafsir);
                              },
                              dense: true,
                              title: Text(
                                tafsir.name!,
                                style: titleTextStyle,
                              ),
                              subtitle: Text(
                                tafsir.englishName!,
                                style: subtitleTextStyle,
                              ),
                              trailing: !tafsir.isDownloaded.value
                                  ? !tafsir.isDownloading.value
                                      ? IconButton(
                                          style: IconButton.styleFrom(
                                              visualDensity:
                                                  VisualDensity.compact),
                                          onPressed: () async {
                                            controller.onDownloadButtonPressed(
                                                tafsir);
                                          },
                                          icon: Icon(
                                            Iconsax.arrow_down_2,
                                            color: theme.colorScheme.primary,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.all(10.0),
                                          child: Text(
                                            '% ${ArabicNumbers().convert(tafsir.downloadProgress.value)}',
                                            style: theme.textTheme.titleSmall,
                                          ),
                                        )
                                  : IconButton(
                                      style: IconButton.styleFrom(
                                          visualDensity: VisualDensity.compact),
                                      onPressed: () async {
                                        controller.deleteTafsir(tafsir);
                                      },
                                      icon: Icon(
                                        Iconsax.minus_cirlce,
                                        color: theme.colorScheme.error,
                                      ),
                                    ));
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
