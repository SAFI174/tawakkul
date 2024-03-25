import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:tawakkal/data/models/quran_reader.dart';

import '../../handlers/reader_timing_data_download_handler.dart';
import '../../widgets/linear_progress_indicator.dart';
import 'dialogs.dart';

class TimingDataDownloadDialog extends StatefulWidget {
  const TimingDataDownloadDialog({super.key, required this.reader});
  final QuranReader reader;
  @override
  State<TimingDataDownloadDialog> createState() =>
      _TimingDataDownloadDialogState();
}

class _TimingDataDownloadDialogState extends State<TimingDataDownloadDialog> {
  double progress = 0;
  double size = 0;
  @override
  void initState() {
    super.initState();
    ReaderTimingDataDownloadHandler.downloadData(
      reader: widget.reader,
      onReceiveProgress: (count, total) {
        setState(() {
          size = total / 1000 / 1024;
          progress = ((count / total));
        });
      },
    ).then((value) async {
      if (value) {
        Get.back(result: value);
      } else {
        await showDownloadFailedDialog();
        Get.back(result: value);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('تحميل'),
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('جاري تحميل بيانات التوقيت '),
          const Gap(15),
          AnimatedLinearProgressIndicator(
            percentage: progress,
          ),
          const Gap(5),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('${size.toStringAsFixed(1)}MB'),
              Text('%${ArabicNumbers().convert(
                (progress * 100).toStringAsFixed(1),
              )}'),
            ],
          ),
        ],
      ),
    );
  }
}
