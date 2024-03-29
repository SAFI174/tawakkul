// Show a dialog indicating no internet connection.
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:tawakkal/constants/json_path.dart';

Future<bool> showAskUserForAlarmPermission() async {
  return await Get.dialog(AlertDialog(
    title: const Text('إذن التنبيهات'),
    content: const Text(
        'ليقوم التطبيق بتذكيرك باوقات الصلاة والاذكار يجب إعطاء إذن التنبيهات'),
    actions: <Widget>[
      TextButton(
        onPressed: () {
          Get.back(result: true);
        },
        child: const Text('السماح'),
      ),
      TextButton(
        onPressed: () {
          Get.back(result: false);
        },
        child: const Text('لاحقاََ'),
      )
    ],
  ));
}

Future<bool> showAskUserForNotificationsPermission() async {
  return await Get.dialog(AlertDialog(
    title: const Text('إذن اظهار الإشعارات'),
    content: const Text(
        'ليقوم التطبيق بتذكيرك باوقات الصلاة والاذكار يجب إعطاء إذن اظهار الإشعارات'),
    actions: [
      TextButton(
        onPressed: () {
          Get.back(result: true);
        },
        child: const Text('السماح'),
      ),
      TextButton(
        onPressed: () {
          Get.back(result: false);
        },
        child: const Text('لاحقاََ'),
      )
    ],
  ));
}

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
Future<bool?> showAzkarNotDoneDialog() async {
  return await Get.dialog<bool>(
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
                  onPressed: () => Get.back(),
                  child: const Text('تابع القراءة'),
                ),
                TextButton(
                  onPressed: () => Get.back(result: false),
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
Future<void> showNoInternetDialog() async {
  await Get.dialog(
    Directionality(
      textDirection: TextDirection.rtl,
      child: AlertDialog(
        title: const Text('لا يوجد اتصال بالإنترنت'),
        content: const Text('حدث خطأ ما. يرجى المحاولة لاحقاََ'),
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

Future<bool> showAskUserForDownloadTimingData() async {
  return await Get.dialog(
    AlertDialog(
      title: const Text('تنبيه'),
      content: const Text(
          'يجب تنزيل ملفات التوقيت أولاً لتميز كلمة بكلمة. هل تريد التحميل الآن؟'),
      actions: [
        TextButton(
          onPressed: () => Get.back(result: true),
          child: const Text('تنزيل'),
        ),
        TextButton(
          onPressed: () => Get.back(result: false),
          child: const Text('إلغاء'),
        ),
      ],
    ),
  );
}

// عرض مربع حوار يشير إلى فشل التنزيل.
Future<void> showDownloadFailedDialog() async {
  await showDialog(
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

// show Completed dialog for  azkar
Future<dynamic> showAzkarCompletedDialog() {
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

Future<bool> showResetTasbihCountersDialog() async {
  return await Get.dialog(
    AlertDialog(
      title: const Text(
        'إعادة ضبط',
      ),
      content: const Text(
        'هل أنت متأكد أنك تريد تصفير العدادات؟',
      ),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false);
          },
          child: const Text(
            'إلغاء',
          ),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true);
          },
          child: const Text('تصفير'),
        ),
      ],
    ),
  );
}

Future<bool> showDeleteItemDialog() async {
  return await Get.dialog(
    AlertDialog(
      title: const Text('تأكيد الحذف'),
      content: const Text('هل أنت متأكد أنك تريد حذف هذا العنصر؟'),
      actions: [
        TextButton(
          onPressed: () {
            Get.back(result: false); // Close the dialog
          },
          child: const Text('إلغاء'),
        ),
        TextButton(
          onPressed: () {
            Get.back(result: true); // Close the dialog
          },
          child: const Text(
            'حذف',
          ),
        ),
      ],
    ),
  );
}

// show Zkr Progress is found
Future<bool?> showZkrProgressFoundForContinue() async {
  return await Get.dialog<bool>(
    AlertDialog(
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
    barrierDismissible: false,
  );
}
