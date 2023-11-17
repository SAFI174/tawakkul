import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah_update/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/custom_progress_indicator.dart';
import '../controllers/qibla_page_controller.dart';
import '../widgets/loading_error_text.dart';

class QiblaPage extends GetView<QiblaController> {
  const QiblaPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('القبلة'), // App bar title
        titleTextStyle: Theme.of(context).primaryTextTheme.titleMedium,
        actions: const [
          IconButton(
            onPressed: showQiblaCompassCalibrationDialog,
            icon: Icon(FluentIcons.info_12_regular),
          ),
          SizedBox(width: 10),
        ],
      ),
      body: StreamBuilder(
        stream: controller.stream,
        builder: (context, AsyncSnapshot<LocationStatus> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CustomCircularProgressIndicator();
          }

          if (snapshot.data!.enabled == true) {
            switch (snapshot.data!.status) {
              case LocationPermission.always:
              case LocationPermission.whileInUse:
                var qiblahTurns = 0.0;
                var preValue = 0.0;
                var direction = 0.0;

                return StreamBuilder<QiblahDirection>(
                  stream: FlutterQiblah.qiblahStream,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return CustomCircularProgressIndicator();
                    } else if (!snapshot.hasData || snapshot.hasError) {
                      return const Center(
                        child: LoadingErrorText(),
                      );
                    } else {
                      // Adjust direction value
                      direction = direction < 0
                          ? (360 + direction)
                          : snapshot.data!.qiblah;

                      // Calculate difference and adjust if needed
                      double diff = direction - preValue;
                      if (diff.abs() > 180) {
                        if (preValue > direction) {
                          diff = 360 - (direction - preValue).abs();
                        } else {
                          diff =
                              (360 - (preValue - direction).abs()).toDouble();
                          diff = diff * -1;
                        }
                      }

                      // Calculate turns
                      final kabba =
                          (snapshot.data!.offset - snapshot.data!.direction)
                              .toInt();
                      qiblahTurns += (diff / 360);
                      preValue = snapshot.data!.qiblah;

                      // Build UI
                      return OrientationBuilder(
                          builder: (context, orientation) {
                        if (orientation == Orientation.portrait) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Column(
                                children: [
                                  Text('الكعبة',
                                      style: Theme.of(context)
                                          .textTheme
                                          .bodyLarge),
                                  Text(
                                    '$kabba°',
                                    style: Theme.of(context)
                                        .textTheme
                                        .headlineMedium,
                                  ),
                                ],
                              ),
                              Transform.flip(
                                flipX: true,
                                child: AnimatedRotation(
                                  duration: const Duration(milliseconds: 400),
                                  turns: qiblahTurns,
                                  child: SvgPicture.asset(
                                    'assets/svg/qibla.svg',
                                    // ignore: deprecated_member_use
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Column(
                                children: [
                                  Text(
                                      '°${ArabicNumbers().convert(snapshot.data!.offset.toInt().toString())} S من الشمال الحقيقي'),
                                  const SizedBox(height: 10),
                                  const Text(
                                      'قم بماعير البوصلة في كل مرة تستخدمها'),
                                  const SizedBox(height: 10),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                        '${ArabicNumbers().convert(snapshot.data!.latitude.toString())}°"N',
                                        textDirection: TextDirection.ltr,
                                      ),
                                      const SizedBox(width: 10),
                                      Text(
                                        '${ArabicNumbers().convert(snapshot.data!.longitude.toString())}°"W',
                                        textDirection: TextDirection.ltr,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          );
                        } else {
                          return Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Transform.flip(
                                flipX: true,
                                child: AnimatedRotation(
                                  duration: const Duration(milliseconds: 400),
                                  turns: qiblahTurns,
                                  child: SvgPicture.asset(
                                    'assets/svg/qibla.svg',
                                    // ignore: deprecated_member_use
                                    color: Theme.of(context).primaryColor,
                                  ),
                                ),
                              ),
                              Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text('الكعبة',
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyLarge),
                                      Text(
                                        '$kabba°',
                                        style: Theme.of(context)
                                            .textTheme
                                            .headlineMedium,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                          '°${ArabicNumbers().convert(snapshot.data!.offset.toInt().toString())} S من الشمال الحقيقي'),
                                      const SizedBox(height: 10),
                                      const Text(
                                          'قم بماعير البوصلة في كل مرة تستخدمها'),
                                      const SizedBox(height: 10),
                                      Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Text(
                                            '${ArabicNumbers().convert(snapshot.data!.latitude.toString())}°"N',
                                            textDirection: TextDirection.ltr,
                                          ),
                                          const SizedBox(width: 10),
                                          Text(
                                            '${ArabicNumbers().convert(snapshot.data!.longitude.toString())}°"W',
                                            textDirection: TextDirection.ltr,
                                          ),
                                        ],
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ],
                          );
                        }
                      });
                    }
                  },
                );

              case LocationPermission.denied:
              case LocationPermission.deniedForever:
                // Display widget for denied location permissions
                return requestLocationWidget(
                  title:
                      'الرجاء السماح بصلاحيات الموقع للحصول على اتجاه القبلة',
                  buttonText: 'إعطاء صلاحية',
                  onTap: controller.checkLocationStatus,
                );

              default:
                return const Center(
                     child: LoadingErrorText());
            }
          } else {
            // Display widget when location settings are disabled
            return requestLocationWidget(
              title: "تم إيقاف إعدادات الموقع. يرجى تمكينها للمتابعة",
              buttonText: "تفعيل إعدادات الموقع",
              onTap: controller.checkLocationStatus,
            );
          }
        },
      ),
    );
  }

  // Widget for requesting location permissions
  Widget requestLocationWidget(
      {required String title,
      required String buttonText,
      required Function() onTap}) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(title),
            const SizedBox(height: 10),
            FilledButton(
              onPressed: onTap,
              child: Text(buttonText),
            ),
          ],
        ),
      ),
    );
  }
}

