import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tawakkal/widgets/arabic_timer_widget.dart';

import '../data/models/prayer_time_model.dart';
import '../data/repository/prayer_time_repository.dart';
import 'custom_container.dart';
import 'timeago_text_widget.dart';
import 'package:timeago/timeago.dart' as timeago;

class CurrentPrayerDetailsWidget extends StatelessWidget {
  const CurrentPrayerDetailsWidget({super.key, this.onTimerFinishedCallback});
  final Function()? onTimerFinishedCallback;
  @override
  Widget build(BuildContext context) {
    timeago.setLocaleMessages('ar', timeago.ArMessages());

    PrayerTimeRepository repository = Get.find();
    return Directionality(
        textDirection: TextDirection.rtl,
        child: repository.coordinates != null
            ? Row(
                children: [
                  Expanded(
                    child: _buildPrayerTimeNextAndCurrent(
                        title: 'الصلاة الآن',
                        prayer: repository.getCurrentPrayer(),
                        theme: Theme.of(context)),
                  ),
                  const Gap(15),
                  Expanded(
                    child: _buildPrayerTimeNextAndCurrent(
                        title: 'الصلاة القادمة',
                        prayer: repository.getNextPrayer(),
                        isTimer: true,
                        theme: Theme.of(context)),
                  )
                ],
              )
            : const SizedBox());
  }

  Widget _buildPrayerTimeNextAndCurrent({
    required String title,
    required PrayerTimeModel prayer,
    bool isTimer = false,
    required ThemeData theme,
  }) {
    var timeLeftKey = GlobalKey<ArabicTimerWidgetState>();
    var timeAgoKey = GlobalKey<TimeAgoWidgetState>();
    return CustomContainer(
      useMaterial: true,
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: theme.textTheme.titleSmall,
            ),
            const Gap(5),
            Text(
              prayer.name,
              style: theme.textTheme.titleMedium!.copyWith(
                color: theme.primaryColor,
                fontWeight: FontWeight.bold,
              ),
            ),
            Row(
              children: [
                Text(
                  ArabicNumbers().convert(prayer.time),
                  style: theme.textTheme.headlineSmall!.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  prayer.isAm ? 'ص' : 'م',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
            const Gap(3),
            if (isTimer)
              ArabicTimerWidget(
                key: timeLeftKey,
                targetDate: prayer.fulldate,
                onTimerFinished: () {
                  if (onTimerFinishedCallback != null) {
                    onTimerFinishedCallback!();
                  }
                },
              ),
            if (!isTimer)
              TimeAgoWidget(
                key: timeAgoKey,
                targetDate: prayer.fulldate,
              )
          ],
        ),
      ),
    );
  }
}
