import 'package:choice/choice.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:quran/quran.dart';
import '../../../../../data/models/quran_reader.dart';
import '../../../../../data/repository/readers_repository.dart';
import '../../../Widgets/surah_verse.dart';
import '../../../../../routes/app_pages.dart';
import '../controllers/quran_audio_player_settings_controller.dart';

class QuranAudioSettingsPage extends GetView<QuranAudioSettingsController> {
  const QuranAudioSettingsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          elevation: 1,
          shadowColor: theme.shadowColor,
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
            Padding(
              padding: const EdgeInsets.only(left: 10.0),
              child: FilledButton(
                style: FilledButton.styleFrom(
                  visualDensity: VisualDensity.comfortable,
                  padding: EdgeInsets.zero,
                ),
                onPressed: controller.onSaveAllPressed,
                child: const Text('حفظ'),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(15),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SurahAyahRangePickerWidget(),
                GetBuilder<QuranAudioSettingsController>(
                  builder: (controller) {
                    return SelectReaderWidget(
                      selectedReader: controller.quranReader,
                    );
                  },
                ),
                const SizedBox(height: 10),
                Text(
                  'إعدادت التشغيل',
                  style: theme.textTheme.titleMedium!
                      .copyWith(fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 10),
                Text(
                  'سرعة التلاوة',
                  style: theme.textTheme.titleSmall,
                ),
                GetBuilder<QuranAudioSettingsController>(
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
                                      : TextStyle(fontSize: 12),
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
                Text(
                  'كرر كل إية',
                  style: theme.textTheme.titleSmall,
                ),
                GetBuilder<QuranAudioSettingsController>(
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
                          materialTapTargetSize:
                              MaterialTapTargetSize.shrinkWrap,
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
                                      : TextStyle(fontSize: 12),
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class SelectReaderWidget extends StatelessWidget {
  const SelectReaderWidget({
    super.key,
    required this.selectedReader,
  });
  final QuranReader selectedReader;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'إعدادت القارئ',
          style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            GestureDetector(
              onTap: () async {
                var readersList = await ReadersRepository().getQuranReaders();
                var cachedReader =
                    await ReadersRepository().getSelectedReaderFromCache();
                var selectedReader = readersList
                    .indexWhere((element) => element.name == cachedReader.name);
                // ignore: use_build_context_synchronously
                showModalBottomSheet(
                  context: context,
                  builder: (context) {
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
                                        scrollController:
                                            FixedExtentScrollController(
                                                initialItem: selectedReader),
                                        childCount: readersList.length,
                                        itemExtent: 50,
                                        onSelectedItemChanged: (value) {
                                          selectedReader = value;
                                        },
                                        itemBuilder: (context, index) {
                                          return Center(
                                              child: Text(
                                            '${index + 1} - ${readersList[index].name}',
                                            style: theme.textTheme.bodyMedium,
                                          ));
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: FilledButton(
                                  onPressed: () async {
                                    ReadersRepository()
                                        .saveSelectedReaderToCache(
                                            readersList[selectedReader]);

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
                  },
                );
              },
              child: Row(
                children: [
                  const Icon(Iconsax.edit, size: 18),
                  const SizedBox(width: 10),
                  Text(selectedReader.name),
                ],
              ),
            ),
            FilledButton.icon(
              icon: const Icon(Iconsax.arrow_down_2),
              onPressed: () {
                Get.toNamed(Routes.RECITER_DOWNLOAD_MANAGER);
              },
              label: const Text('إدارة التنزيلات'),
            ),
          ],
        )
      ],
    );
  }
}

class SurahAyahRangePickerWidget extends StatelessWidget {
  const SurahAyahRangePickerWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    QuranAudioSettingsController controller = Get.find();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'حدد اللآيات',
          style: theme.textTheme.titleMedium!
              .copyWith(fontWeight: FontWeight.bold),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              elevation: 0,
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
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('بدء من اللآية'),
              Row(
                children: [
                  const Icon(Iconsax.edit, size: 18),
                  const SizedBox(width: 10),
                  GetBuilder<QuranAudioSettingsController>(
                    builder: (controller) {
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: SurahVerseWidget(
                            surah: controller.playRange.startSurah,
                            verse: controller.playRange.startVerse),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            showModalBottomSheet(
              elevation: 0,
              context: context,
              builder: (context) {
                return SurahAyahPicker(
                  isBegin: false,
                  initSurah: controller.playRange.endsSurah,
                  initVerse: controller.playRange.endsVerse,
                );
              },
            );
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('إنتهاء عند اللآية'),
              Row(
                children: [
                  const Icon(Iconsax.edit, size: 18),
                  const SizedBox(width: 10),
                  GetBuilder<QuranAudioSettingsController>(
                    builder: (controller) {
                      return Directionality(
                        textDirection: TextDirection.ltr,
                        child: SurahVerseWidget(
                            surah: controller.playRange.endsSurah,
                            verse: controller.playRange.endsVerse),
                      );
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
        Text(
          'تحديد سريع',
          style: theme.textTheme.titleSmall,
        ),
        GetBuilder<QuranAudioSettingsController>(
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
                  selected: state.selected(controller.rangeSpeedChoice[i]),
                  onSelected: state.onSelected(controller.rangeSpeedChoice[i]),
                  label: Text(
                    controller.rangeSpeedChoice[i],
                    style: state.selected(controller.rangeSpeedChoice[i])
                        ? const TextStyle(color: Colors.white, fontSize: 12)
                        : TextStyle(fontSize: 12),
                  ),
                  showCheckmark: false,
                );
              },
              listBuilder: ChoiceList.createScrollable(
                spacing: 5,
                padding: const EdgeInsets.only(top: 15, bottom: 15, left: 10),
              ),
            );
          },
        ),
      ],
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
                            '${index + 1} - ${getSurahNameArabic(index + 1)}',
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
