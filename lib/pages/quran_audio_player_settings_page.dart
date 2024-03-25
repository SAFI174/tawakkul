import 'package:choice/choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:quran/quran.dart';
import 'package:tawakkal/data/cache/quran_settings_cache.dart';
import 'package:tawakkal/utils/sheets/sheet_methods.dart';
import '../../../Widgets/surah_verse.dart';
import '../controllers/quran_audio_player_controller.dart';
import '../controllers/quran_audio_player_settings_controller.dart';
import '../data/cache/quran_reader_cache.dart';

class QuranAudioSettingsPage extends GetView<QuranAudioSettingsController> {
  const QuranAudioSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    var titleTextStyle = theme.textTheme.titleSmall!;
    var subtitleTextStyle = TextStyle(color: theme.hintColor);
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          scrolledUnderElevation: 1,
          titleTextStyle: theme.textTheme.titleMedium,
          title: const Text(
            'إعدادات تشغيل الصوت',
            style: TextStyle(color: Colors.white),
          ),
          actions: [
            IconButton(
              onPressed: controller.onResetSettingsPressed,
              icon: const Icon(Icons.refresh_rounded),
            ),
            FilledButton(
              style: FilledButton.styleFrom(
                padding: EdgeInsets.zero,
                visualDensity: VisualDensity.comfortable,
              ),
              onPressed: controller.onSaveAllPressed,
              child: const Text('حفظ'),
            ),
            const Gap(10),
          ],
        ),
        body: ListView(
          children: [
            ListTile(
              title: Text(
                'مجال التشغيل',
                style: titleTextStyle.copyWith(color: theme.primaryColor),
              ),
              dense: true,
            ),
            GetBuilder<QuranAudioSettingsController>(
              builder: (controller) {
                return Column(
                  children: [
                    ListTile(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          context: context,
                          builder: (context) {
                            return SurahAyahPicker(
                              isBegin: true,
                              initSurah: controller.playRange.startSurah,
                              initVerse: controller.playRange.startVerse,
                            );
                          },
                        );
                      },
                      title: Text(
                        'بدءاََ من',
                        style: titleTextStyle,
                      ),
                      subtitle: Text(
                        '${getSurahNameOnlyArabicSimple(controller.playRange.startSurah)}  الآية  ${controller.playRange.startVerse}',
                        style: subtitleTextStyle,
                      ),
                      trailing: SurahVerseWidget(
                          showSurahName: false,
                          surah: controller.playRange.startSurah,
                          verse: controller.playRange.startVerse),
                      dense: true,
                    ),
                    ListTile(
                      onTap: () {
                        showMaterialModalBottomSheet(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(0)),
                          context: context,
                          builder: (context) {
                            return SurahAyahPicker(
                              isBegin: false,
                              initSurah: controller.playRange.startSurah,
                              initVerse: controller.playRange.startVerse,
                            );
                          },
                        );
                      },
                      title: Text(
                        'إنتهاء عند',
                        style: titleTextStyle,
                      ),
                      subtitle: Text(
                        '${getSurahNameOnlyArabicSimple(controller.playRange.endsSurah)}  الآية  ${controller.playRange.endsVerse}',
                        style: subtitleTextStyle,
                      ),
                      trailing: SurahVerseWidget(
                          surah: controller.playRange.endsSurah,
                          verse: controller.playRange.endsVerse,
                          showSurahName: false),
                      dense: true,
                    ),
                  ],
                );
              },
            ),
            ListTile(
              title: Text(
                'تحديد سريع',
                style: titleTextStyle,
              ),
              subtitle: GetBuilder<QuranAudioSettingsController>(
                builder: (controller) {
                  return Choice<String>.inline(
                    clearable: true,
                    value: ChoiceSingle.value(controller.selectedRange),
                    onChanged:
                        ChoiceSingle.onChanged(controller.onRangeChoiceChanged),
                    itemCount: controller.rangeSpeedChoice.length,
                    itemBuilder: (state, i) {
                      return ChoiceChip(
                        visualDensity: VisualDensity.compact,
                        selectedColor: theme.colorScheme.primary,
                        selected:
                            state.selected(controller.rangeSpeedChoice[i]),
                        onSelected:
                            state.onSelected(controller.rangeSpeedChoice[i]),
                        label: Text(
                          controller.rangeSpeedChoice[i],
                          style: state.selected(controller.rangeSpeedChoice[i])
                              ? const TextStyle(
                                  color: Colors.white, fontSize: 12)
                              : const TextStyle(fontSize: 12),
                        ),
                        showCheckmark: false,
                      );
                    },
                    listBuilder: ChoiceList.createScrollable(
                      spacing: 5,
                      padding:
                          const EdgeInsets.only(top: 15, bottom: 15, left: 10),
                    ),
                  );
                },
              ),
            ),
            const Divider(),
            ListTile(
              title: Text(
                'التشغيل',
                style: titleTextStyle.copyWith(color: theme.primaryColor),
              ),
              dense: true,
            ),
            ListTile(
              onTap: () => selectReaderSheet().then((value) {
                controller.update();
                // update the selected reader on bottom bar of audio player
                Get.find<QuranAudioPlayerBottomBarController>()
                    .selectedReader
                    .value = QuranReaderCache.getSelectedReaderFromCache();
              }),
              title: Text(
                'القارئ',
                style: titleTextStyle,
              ),
              subtitle: GetBuilder<QuranAudioSettingsController>(
                builder: (controller) {
                  return Text(
                      QuranReaderCache.getSelectedReaderFromCache().name,
                      style: subtitleTextStyle);
                },
              ),
              dense: true,
            ),
            GetBuilder<QuranAudioSettingsController>(
              builder: (controller) {
                return SwitchListTile(
                  dense: true,
                  title: Text(
                    'تمييز كلمة بكلمة',
                    style: titleTextStyle,
                  ),
                  subtitle: Text(
                    'تعزز فهم القرآن كلمة بكلمة أثناء القراءة.\n سيتم التطبيق بشكل كامل عند تشغيل التلاوة من جديد',
                    style: subtitleTextStyle,
                  ),
                  value: QuranSettingsCache.isWordByWordListen(),
                  onChanged: (value) {
                    QuranSettingsCache.setWordByWordListen(isWordByWord: value);
                    controller.update();
                  },
                );
              },
            ),
            ListTile(
              title: Text(
                'سرعة التلاوة',
                style: titleTextStyle,
              ),
              subtitle: GetBuilder<QuranAudioSettingsController>(
                builder: (controller) {
                  return Choice<String>.inline(
                    value: ChoiceSingle.value(controller.selectedSpeed),
                    onChanged: ChoiceSingle.onChanged(
                      (value) => controller.selectedSpeed = value ?? '',
                    ),
                    itemCount: controller.speedChoice.length,
                    itemBuilder: (state, i) {
                      return ChoiceChip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelPadding: EdgeInsets.zero,
                        selectedColor: theme.colorScheme.primary,
                        selected: state.selected(
                            controller.speedChoice.values.toList()[i]),
                        onSelected: state.onSelected(
                          controller.speedChoice.values.toList()[i],
                        ),
                        label: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 35),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                controller.speedChoice.values.toList()[i],
                                style: state.selected(controller
                                        .speedChoice.values
                                        .toList()[i])
                                    ? const TextStyle(
                                        color: Colors.white, fontSize: 12)
                                    : const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        showCheckmark: false,
                      );
                    },
                    listBuilder: ChoiceList.createScrollable(
                      spacing: 5,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      padding:
                          const EdgeInsets.only(top: 15, bottom: 15, left: 0),
                    ),
                  );
                },
              ),
            ),
            ListTile(
              title: Text(
                'كرر كل إية',
                style: titleTextStyle,
              ),
              contentPadding: const EdgeInsets.only(right: 16),
              subtitle: GetBuilder<QuranAudioSettingsController>(
                builder: (controller) {
                  return Choice<String>.inline(
                    value: ChoiceSingle.value(controller.selectedRepeat),
                    onChanged: ChoiceSingle.onChanged(
                      (value) => controller.selectedRepeat = value ?? '',
                    ),
                    itemCount: controller.repeatChoice.length,
                    itemBuilder: (state, i) {
                      return ChoiceChip(
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        labelPadding: EdgeInsets.zero,
                        selectedColor: theme.colorScheme.primary,
                        selected: state.selected(
                            controller.repeatChoice.values.toList()[i]),
                        onSelected: state.onSelected(
                          controller.repeatChoice.values.toList()[i],
                        ),
                        label: ConstrainedBox(
                          constraints: const BoxConstraints(minWidth: 50),
                          child: Center(
                            child: FittedBox(
                              child: Text(
                                controller.repeatChoice.values.toList()[i],
                                style: state.selected(controller
                                        .repeatChoice.values
                                        .toList()[i])
                                    ? const TextStyle(
                                        color: Colors.white, fontSize: 12)
                                    : const TextStyle(fontSize: 12),
                              ),
                            ),
                          ),
                        ),
                        showCheckmark: false,
                      );
                    },
                    listBuilder: ChoiceList.createScrollable(
                      spacing: 5,
                      alignment: WrapAlignment.center,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      padding:
                          const EdgeInsets.only(top: 15, bottom: 15, left: 0),
                    ),
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

class SurahAyahPicker extends GetView<QuranAudioSettingsController> {
  SurahAyahPicker({
    super.key,
    required this.isBegin,
    this.initSurah = 1,
    this.initVerse = 1,
  });
  final bool isBegin;
  final int initSurah;
  final int initVerse;
  final verseCount = 0.obs;

  @override
  Widget build(BuildContext context) {
    verseCount.value = getVerseCount(initSurah);
    var surahId = initSurah;
    var verseId = initVerse;
    var theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: SizedBox(
        child: SizedBox(
          height: 250,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Flexible(
                      flex: 3,
                      child: CupertinoPicker.builder(
                        scrollController: FixedExtentScrollController(
                            initialItem: initSurah - 1),
                        childCount: 114,
                        itemExtent: 50,
                        onSelectedItemChanged: (value) {
                          verseCount.value = getVerseCount(value + 1);
                          surahId = value + 1;
                          verseId = 1;
                        },
                        itemBuilder: (context, index) {
                          return Center(
                              child: Text(
                            '${index + 1} - ${getSurahNameOnlyArabicSimple(index + 1)}',
                            style: theme.textTheme.bodyMedium,
                          ));
                        },
                      ),
                    ),
                    Flexible(
                      child: Obx(() {
                        return CupertinoPicker.builder(
                          scrollController: FixedExtentScrollController(
                              initialItem: initVerse - 1),
                          childCount: verseCount.value,
                          itemExtent: 50,
                          onSelectedItemChanged: (value) {
                            verseId = value + 1;
                          },
                          itemBuilder: (context, index) {
                            return Center(
                                child: Text(
                              '${index + 1}',
                              style: theme.textTheme.bodyMedium,
                            ));
                          },
                        );
                      }),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: FilledButton(
                  onPressed: () async {
                    if (isBegin) {
                      controller.setQuranPlayRange(
                          playRange: controller.playRange.copyWith(
                              startSurah: surahId, startVerse: verseId),
                          isBegin: isBegin);
                    } else {
                      controller.setQuranPlayRange(
                          playRange: controller.playRange
                              .copyWith(endsSurah: surahId, endsVerse: verseId),
                          isBegin: isBegin);
                    }
                    Get.back();
                  },
                  child: const Text('موافق'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
