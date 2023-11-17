import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:easy_rich_text/easy_rich_text.dart';
import 'package:flutter/material.dart';
import 'package:flutter_toggle_tab/flutter_toggle_tab.dart';

import 'package:get/get.dart';
import 'package:quran/quran.dart';
import '../../../../widgets/settings_section.dart';
import '../controllers/quran_settings_controller.dart';

class QuranSettingsPage extends GetView<QuranSettingsController> {
  const QuranSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        scrolledUnderElevation: 1,
        shadowColor: theme.shadowColor,
        elevation: 1,
        titleTextStyle: theme.textTheme.titleMedium,
        title: const Text(
          'إعدادات العرض',
          style: TextStyle(color: Colors.white),
        ),
        centerTitle: false,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(3.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SettingsSection(
                sectionTitle: 'إعدادات العرض',
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    const SizedBox(height: 10),
                    GetBuilder<QuranSettingsController>(
                      builder: (controller) {
                        return SwitchListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          title: const Row(
                            children: [
                              Icon(Icons.dark_mode_outlined),
                              SizedBox(width: 5),
                              Text('الوضع الليلي'),
                            ],
                          ),
                          value: controller.settingsModel.isDarkMode,
                          onChanged: (value) =>
                              controller.onThemeSwitched(value),
                        );
                      },
                    ),
                    const Divider(
                      endIndent: 15,
                      indent: 15,
                    ),
                    GetBuilder<QuranSettingsController>(
                      builder: (controller) {
                        return SwitchListTile(
                          dense: true,
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                          title: Row(
                            children: [
                              Text(
                                getVerseEndSymbol(1),
                                style: const TextStyle(
                                    fontFamily: '', fontSize: 18),
                              ),
                              const SizedBox(width: 5),
                              const Text('تلوين علامات الآيات وحقل السورة'),
                            ],
                          ),
                          value: controller.settingsModel.isMarkerColored,
                          onChanged: (value) =>
                              controller.onMarkerColorSwitched(value),
                        );
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'معاينة',
                        style: theme.textTheme.labelMedium,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(
                            width: 1,
                            color:
                                Theme.of(context).disabledColor.withAlpha(40),
                          ),
                        ),
                        child: GetBuilder<QuranSettingsController>(
                          builder: (controller) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                EasyRichText(
                                  'ﭑ ﭒ ﭓ ﭔ ﭕ ﭖ ﭗ',
                                  patternList: [
                                    EasyRichTextPattern(
                                        targetString: 'ﭔ',
                                        style: TextStyle(
                                            color: controller
                                                    .settingsModel.isMarkerColored
                                                ? theme.primaryColor
                                                : theme.colorScheme
                                                    .onBackground)),
                                    EasyRichTextPattern(
                                        targetString: 'ﭗ',
                                        style: TextStyle(
                                            color: controller
                                                    .settingsModel.isMarkerColored
                                                ? theme.primaryColor
                                                : theme.colorScheme.onBackground))
                                  ],
                                  defaultStyle: const TextStyle(
                                      fontFamily: 'QCF_P590', fontSize: 23),
                                ),
                                FittedBox(
                                  child: Text(
                                    'ò',
                                    style: TextStyle(
                                        fontFamily: 'QCFBSML',
                                        color: controller
                                                .settingsModel.isMarkerColored
                                            ? theme.primaryColor
                                            : theme.colorScheme.onBackground),
                                  ),
                                )
                              ],
                            );
                          },
                        ),
                      ),
                    ),
                    const Divider(
                      endIndent: 15,
                      indent: 15,
                    ),
                    const Padding(
                      padding: EdgeInsets.symmetric(horizontal: 8.0),
                      child: Text(
                        'تخطيط الصفحة',
                      ),
                    ),
                    GetBuilder<QuranSettingsController>(
                      builder: (controller) {
                        return Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlutterToggleTab(
                            width: 90, // width in percent
                            borderRadius: 10,
                            height: 50,
                            isShadowEnable: false,
                            selectedIndex:
                                controller.settingsModel.pageDisplayOption,
                            selectedTextStyle: const TextStyle(
                              color: Colors.white,
                            ),
                            unSelectedTextStyle: TextStyle(
                              color: Get.isDarkMode
                                  ? theme.colorScheme.onBackground
                                  : Colors.black,
                            ),
                            unSelectedBackgroundColors: [
                              theme.colorScheme.surfaceVariant
                            ],
                            labels: const ['مصحف المدينة', 'تكيفي'],
                            selectedLabelIndex:
                                controller.onDisplayOptionChanged,
                            isScroll: false,
                            marginSelected: const EdgeInsets.symmetric(
                                horizontal: 4, vertical: 4),
                          ),
                        );
                      },
                    ),
                    const Divider(
                      endIndent: 15,
                      indent: 15,
                    ),
                    GetBuilder<QuranSettingsController>(
                      builder: (controller) {
                        return controller.settingsModel.pageDisplayOption == 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'يعرض هذا الخيار القرآن الكريم بالخط الرسمي المعتمد في المدينة المنورة. يتيح للقراء التركيز على النص وسهولة الحفظ وتحسين تذكر الآيات بسهولة',
                                      style: theme.textTheme.labelMedium,
                                    ),
                                  ),
                                  Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'معاينة',
                                              style:
                                                  theme.textTheme.labelMedium,
                                            ),
                                            Text(
                                              '${ArabicNumbers().convert(15)} سطر',
                                              style: theme
                                                  .textTheme.labelMedium!
                                                  .copyWith(
                                                decoration:
                                                    TextDecoration.underline,
                                              ),
                                            ),
                                            Text(
                                              'رسم عثماني',
                                              style:
                                                  theme.textTheme.labelMedium,
                                            ),
                                          ],
                                        ),
                                      ),
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.all(15),
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              border: Border.all(
                                                width: 2,
                                                color: Theme.of(context)
                                                    .disabledColor
                                                    .withAlpha(40),
                                              ),
                                            ),
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(9),
                                              child: const Image(
                                                image: AssetImage(
                                                    'assets/images/quran_page.png'),
                                                fit: BoxFit.fitWidth,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              )
                            : Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'تسمح للمستخدمين بالتحكم الكامل في حجم الخط والتكبير والتصغير وفقًا لاحتياجاتهم الشخصية. يمكن ضبط النص بحجم مناسب للعينين، مما يجعل القراءة مريحة اكثر.',
                                      style: theme.textTheme.labelMedium,
                                    ),
                                  ),
                                  const Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text('حجم الخط'),
                                  ),
                                  SliderTheme(
                                    data: SliderTheme.of(context).copyWith(
                                      activeTrackColor:
                                          theme.colorScheme.primaryContainer,
                                      inactiveTickMarkColor:
                                          theme.colorScheme.primary,
                                      inactiveTrackColor:
                                          theme.colorScheme.primaryContainer,
                                    ),
                                    child: GetBuilder<QuranSettingsController>(
                                      builder: (controller) {
                                        return Slider(
                                          value:
                                              controller.settingsModel.displayFontSize,
                                          min: 25,
                                          max: 45,
                                          label: ArabicNumbers().convert(
                                              '${controller.settingsModel.displayFontSize}'),
                                          onChanged: (value) =>
                                              controller.onDisplayFontSizeChanged(value),
                                          divisions: 4,
                                        );
                                      },
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'معاينة',
                                      style: theme.textTheme.labelMedium,
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        border: Border.all(
                                          width: 1,
                                          color: Theme.of(context)
                                              .disabledColor
                                              .withAlpha(40),
                                        ),
                                      ),
                                      child: GetBuilder<QuranSettingsController>(
                                        builder: (controller) {
                                          return Text(
                                            "ﯜ ﯝ ﯞ ﯟ ﯠ",
                                            style: TextStyle(
                                                fontFamily: 'QCF_P596',
                                                fontSize: controller.settingsModel.displayFontSize),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              );
                      },
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
