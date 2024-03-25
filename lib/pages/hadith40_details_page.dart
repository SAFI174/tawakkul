import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:tawakkal/data/models/hadith40_model.dart';

class Hadith40DetailsPage extends StatelessWidget {
  const Hadith40DetailsPage({super.key, required this.hadith});
  final Hadith40Model hadith;
  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(hadith.idAr),
        titleTextStyle: theme.primaryTextTheme.titleMedium,
      ),
      body: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Gap(15),
            // Display Hadith Topic
            Text(
              hadith.topic,
              style: theme.textTheme.titleLarge!
                  .copyWith(fontWeight: FontWeight.bold),
              textAlign: TextAlign.center,
            ),
            const Gap(15),
            // Hadith Container
            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Divider(height: 0),
                const Material(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'نص الحديث:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 0),
                // Display Hadith Text
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    hadith.text,
                    textAlign: TextAlign.center,
                    style: theme.textTheme.titleMedium!.copyWith(height: 2),
                  ),
                ),
                // Display Rawi Information
                Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: Text(
                    hadith.rawi,
                    textAlign: TextAlign.end,
                    style: theme.textTheme.titleSmall!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                const Divider(
                  height: 0,
                  thickness: 1.5,
                ),
                // Header for Hadith Description
                const Material(
                  child: Padding(
                    padding: EdgeInsets.all(15.0),
                    child: Text(
                      'شرح وفوائد الحديث:',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const Divider(height: 0),
                // Display Hadith Description
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    hadith.description,
                    textAlign: TextAlign.start,
                    style: theme.textTheme.titleMedium!.copyWith(height: 2),
                  ),
                ),
              ],
            ),
            const Gap(25),
          ],
        ),
      ),
    );
  }
}
