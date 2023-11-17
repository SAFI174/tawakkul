// Show a dialog indicating no internet connection.
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tawakkal/constants/json_path.dart';

import '../../widgets/loading_error_text.dart';

// show qibla compass calibration dialog
void showQiblaCompassCalibrationDialog() {
  Get.dialog(
    AlertDialog(
      title: const Text('عملية معايرة الهاتف والبوصلة'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('قم بمعايرة الهاتف والبوصلة باستخدام الخطوات التالية:'),
            SizedBox(height: 16),
            Row(
              children: [
                Icon(Icons.arrow_forward, color: Colors.blue),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'حرك الهاتف في الاتجاه الأفقي (يمينًا ويسارًا)',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.arrow_downward, color: Colors.blue),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'حرك الهاتف في الاتجاه الرأسي (أعلى وأسفل)',
                  ),
                ),
              ],
            ),
            Row(
              children: [
                Icon(Icons.refresh, color: Colors.blue),
                SizedBox(width: 8),
                Flexible(
                  child: Text(
                    'قم بتدوير الهاتف حول نفسه باتجاه عقارب الساعة وضد عقارب الساعة',
                  ),
                ),
              ],
            ),
            SizedBox(height: 16),
            Text('تنبيه: إبتعد عن الأشياء المغناطيسية'),
          ],
        ),
      ),
      actions: <Widget>[
        TextButton(
          child: const Text('حسناً'),
          onPressed: () {
            Get.back(); // Close the dialog
          },
        ),
      ],
    ),
  );
}

// show azkar not done alert dialog
Future<dynamic> showAzkarNotDoneDialog() {
  return Get.dialog(
    AlertDialog(
      title: const Text('تنبيه'),
      content: SizedBox(
        width: 100.w,
        child: const Text(' لم تنتهي من قراءة الأذكار بعد, هل تريد الخروج؟'),
      ),
      actionsPadding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
      actions: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () => Get.back(result: true),
              child: const Text('حفظ التقدم ومغادرة'),
            ),
            Row(
              children: [
                TextButton(
                  onPressed: () {
                    Get.back();
                  },
                  child: const Text('تابع القراءة'),
                ),
                TextButton(
                  onPressed: () {
                    Get.close(2);
                  },
                  child: const Text('مغادرة'),
                ),
              ],
            )
          ],
        ),
      ],
    ),
  );
}

// show enable location to continue
Future<void> showLocationDisabledDialog() async {
  await Get.dialog(
    AlertDialog(
      title: const Text('تم تعطيل خدمات الموقع'),
      content: const SingleChildScrollView(
        child: ListBody(
          children: <Widget>[
            Text('الرجاء تمكين خدمات الموقع لاستخدام القبلة.'),
          ],
        ),
      ),
      actionsPadding: const EdgeInsets.all(5),
      actions: <Widget>[
        TextButton(
          child: const Text('الذهاب إلى الإعدادات'),
          onPressed: () async {
            await Geolocator.openLocationSettings();
          },
        ),
        TextButton(
          child: const Text('إلغاء'),
          onPressed: () {
            Get.back(); // Close the dialog
          },
        ),
      ],
    ),
  );
}

// Show a dialog indicating no internet connection.
void showNoInternetDialog() {
  Get.dialog(
    Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('لا يوجد اتصال بالإنترنت'),
        content: const LoadingErrorText(),
        actions: [
          TextButton(
            onPressed: () {
              Get.back();
            },
            child: const Text('موافق'),
          ),
        ],
      ),
    ),
  );
}

// عرض مربع حوار يشير إلى فشل التنزيل.
void showDownloadFailedDialog() {
  showDialog(
    context: Get.overlayContext!,
    builder: (context) {
      return AlertDialog(
        title: const Text('فشل التنزيل'),
        content:
            const Text('فشل في تنزيل الملف. يرجى المحاولة مرة أخرى لاحقًا.'),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('موافق'),
          ),
        ],
      );
    },
  );
}

// show celebration dialog for done azkar
Future<dynamic> showCongratulationsAzkarDialog() {
  return Get.dialog(
    AlertDialog(
      content: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 200,
            child: LottieBuilder.asset(
              JsonPaths.checkIcon,
            ),
          ),
          const Text('لقد اتممت قراءة الاذكار')
        ],
      ),
      actions: [
        TextButton(
            onPressed: () {
              Get.close(2);
            },
            child: const Text('غادر')),
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: const Text('إعادة'),
        ),
      ],
    ),
  );
}

// show Zkr Progress is found
Future<dynamic> showZkrProgressFoundForContinue() async {
  return Get.dialog(
    WillPopScope(
      onWillPop: () {
        Get.close(2);
        return Future.value(false);
      },
      child: AlertDialog(
        title: const Text('تنبيه'),
        content: const Text('هناك تقدم سابق\n هل تريد المتابعة من حيث توقفت؟'),
        actions: [
          TextButton(
            onPressed: () {
              Get.back(result: true);
            },
            child: const Text('متابعة'),
          ),
          TextButton(
            onPressed: () {
              Get.back(result: false);
            },
            child: const Text('بدء من جديد'),
          ),
        ],
      ),
    ),
    barrierDismissible: false,
  );
}
