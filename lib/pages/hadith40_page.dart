import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:tawakkal/data/repository/hadith40_repository.dart';
import 'package:tawakkal/pages/hadith40_details_page.dart';

class Hadith40Page extends GetView {
  const Hadith40Page({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('الاربعون النووية'),
        titleTextStyle: theme.primaryTextTheme.titleMedium,
      ),
      body: FutureBuilder(
        future: Hadith0Repository.getAllAhadith(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var ahadith = snapshot.data!;
            return ListView.separated(
              itemCount: ahadith.length,
              separatorBuilder: (context, index) {
                return const Divider(height: 1);
              },
              itemBuilder: (context, index) {
                var hadith = ahadith[index];
                return ListTile(
                  titleTextStyle: theme.textTheme.titleSmall,
                  subtitleTextStyle: theme.textTheme.labelMedium!,
                  title: Text(hadith.topic),
                  onTap: () {
                    Get.to(() => Hadith40DetailsPage(hadith: hadith));
                  },
                  subtitle: Text(hadith.idAr),
                  trailing: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 18,
                  ),
                );
              },
            );
          } else {
            return const SizedBox();
          }
        },
      ),
    );
  }
}
