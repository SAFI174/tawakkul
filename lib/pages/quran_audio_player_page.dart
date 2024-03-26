import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:audio_service/audio_service.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:iconsax/iconsax.dart';
import 'package:tawakkal/controllers/quran_audio_player_controller.dart';

import '../data/cache/audio_settings_cache.dart';
import '../../../../../services/audio/audio_manager.dart';
import '../../../../../widgets/custom_progress_indicator.dart';
import '../routes/app_pages.dart';

class QuranAudioPlayerBottomBar
    extends GetView<QuranAudioPlayerBottomBarController> {
  const QuranAudioPlayerBottomBar({super.key});

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return BottomAppBar(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      elevation: 1,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        mainAxisSize: MainAxisSize.max,
        children: [
          Obx(
            () => !controller.isControlsVisible.value
                ? Expanded(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        FilledButton.icon(
                          onPressed: controller.onMainPlayPressed,
                          icon: controller.isControlsVisible.value
                              ? CustomCircularProgressIndicator()
                              : const Icon(
                                  FluentIcons.play_circle_48_regular,
                                  size: 26,
                                ),
                          label: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                'تشغيل التلاوة',
                                style: TextStyle(fontSize: 12),
                              ),
                              Obx(
                                () {
                                  return Text(
                                    controller.selectedReader.value.name,
                                    style: const TextStyle(fontSize: 12),
                                  );
                                },
                              )
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(
                            FluentIcons.play_settings_20_regular,
                            size: 29,
                          ),
                          onPressed: () {
                            Get.toNamed(
                              Routes.AUDIO_SETTINGS,
                              arguments: controller
                                  .quranPageViewController.currentPageData,
                            );
                          },
                        )
                      ],
                    ),
                  )
                : const SizedBox(),
          ),
          Obx(() => controller.isControlsVisible.value &&
                  controller.audioHandler != null
              ? Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Row(
                        children: [
                          StreamBuilder<PlaybackState>(
                            stream: controller.audioHandler!.playbackState,
                            builder: (context, snapshot) {
                              final playbackState = snapshot.data;
                              final processingState =
                                  playbackState?.processingState;
                              final playing = playbackState?.playing;
                              if (processingState ==
                                      AudioProcessingState.loading ||
                                  processingState ==
                                      AudioProcessingState.buffering) {
                                return Container(
                                  margin: const EdgeInsets.all(8.0),
                                  child: Center(
                                      child: CustomCircularProgressIndicator()),
                                );
                              } else if (playing != true) {
                                return IconButton.filled(
                                  onPressed: controller.audioHandler!.play,
                                  icon: const Icon(
                                    FluentIcons.play_48_regular,
                                    size: 30,
                                  ),
                                );
                              } else {
                                return IconButton.filled(
                                  onPressed: controller.audioHandler!.pause,
                                  icon: const Icon(
                                    Iconsax.pause,
                                    size: 30,
                                  ),
                                );
                              }
                            },
                          ),
                          const SizedBox(width: 5),
                          Row(
                            children: [
                              IconButton(
                                style: IconButton.styleFrom(
                                  visualDensity: VisualDensity.compact,
                                ),
                                onPressed: () {
                                  controller.audioHandler!.stop();
                                  controller.isControlsVisible.value = false;
                                  AudioSettingsCache.setPlayRangeValidState(
                                      isValid: false);
                                },
                                icon: const Icon(
                                  FluentIcons.stop_16_regular,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 10),
                              Obx(() {
                                return GestureDetector(
                                  onTap: () {
                                    controller.changeSpeed();
                                  },
                                  child: Text(
                                    '${ArabicNumbers().convert(controller.playbackSpeed.value.toString())}x',
                                    style: theme.textTheme.labelLarge,
                                  ),
                                );
                              }),
                              const SizedBox(width: 10),
                              StreamBuilder<QueueState>(
                                stream: controller.audioHandler!.queueState,
                                builder: (context, snapshot) {
                                  final queueState =
                                      snapshot.data ?? QueueState.empty;
                                  return IconButton(
                                    style: IconButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    onPressed: queueState.hasNext
                                        ? controller.audioHandler!.skipToNext
                                        : null,
                                    icon: const Icon(
                                      FluentIcons.fast_forward_20_regular,
                                    ),
                                  );
                                },
                              ),
                              StreamBuilder<QueueState>(
                                stream: controller.audioHandler!.queueState,
                                builder: (context, snapshot) {
                                  final queueState =
                                      snapshot.data ?? QueueState.empty;
                                  return IconButton(
                                    style: IconButton.styleFrom(
                                      visualDensity: VisualDensity.compact,
                                    ),
                                    icon: Transform.flip(
                                      flipX: true,
                                      child: const Icon(
                                        FluentIcons.fast_forward_20_regular,
                                      ),
                                    ),
                                    onPressed: queueState.hasPrevious
                                        ? controller
                                            .audioHandler!.skipToPrevious
                                        : null,
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      IconButton(
                        icon: const Icon(
                          FluentIcons.play_settings_20_regular,
                        ),
                        onPressed: () {
                          Get.toNamed(
                            Routes.AUDIO_SETTINGS,
                            arguments: controller
                                .quranPageViewController.currentPageData,
                          );
                        },
                      )
                    ],
                  ),
                )
              : const SizedBox())
        ],
      ),
    );
  }
}
