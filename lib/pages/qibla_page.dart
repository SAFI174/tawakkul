import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:auto_size_text/auto_size_text.dart';
import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:flutter_svg/svg.dart';
import 'package:gap/gap.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import '../../utils/dialogs/dialogs.dart';
import '../../widgets/custom_progress_indicator.dart';
import '../controllers/qibla_page_controller.dart';
import '../widgets/custom_message_button_widget.dart';
import '../widgets/loading_error_text.dart';

class QiblaPage extends GetView<QiblaController> {
  const QiblaPage({super.key});

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

          if (snapshot.data?.enabled == true) {
            switch (snapshot.data?.status) {
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
                          : snapshot.data?.qiblah ?? 0;

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
                      final kabba = ((snapshot.data?.offset ?? 0) -
                              (snapshot.data?.direction ?? 0))
                          .toInt();
                      qiblahTurns += (diff / 360);
                      preValue = snapshot.data?.qiblah ?? 0;

                      // Build UI
                      return OrientationBuilder(
                          builder: (context, orientation) {
                        if (orientation == Orientation.portrait) {
                          return Center(
                            child: SingleChildScrollView(
                              child: Column(
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
                                      duration:
                                          const Duration(milliseconds: 400),
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
                                      AutoSizeText(
                                          '°${ArabicNumbers().convert(snapshot.data?.offset.toInt().toString())} S من الشمال الحقيقي'),
                                      const Gap(10),
                                      const AutoSizeText(
                                          'قم بماعير البوصلة في كل مرة تستخدمها'),
                                      const Gap(10),
                                      StreamBuilder<Position>(
                                          stream: controller.locStream,
                                          builder: (context, snapshot) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                AutoSizeText(
                                                  snapshot.data != null
                                                      ? '${snapshot.data?.latitude.toString()}°"N'
                                                      : '',
                                                  textDirection:
                                                      TextDirection.ltr,
                                                ),
                                                const Gap(10),
                                                AutoSizeText(
                                                  snapshot.data != null
                                                      ? '${snapshot.data?.longitude.toString()}°"W'
                                                      : '',
                                                  textDirection:
                                                      TextDirection.ltr,
                                                ),
                                              ],
                                            );
                                          }),
                                    ],
                                  ),
                                ],
                              ),
                            ),
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
                                          '°${ArabicNumbers().convert(snapshot.data?.offset.toInt().toString())} S من الشمال الحقيقي'),
                                      const SizedBox(height: 10),
                                      const Text(
                                          'قم بماعير البوصلة في كل مرة تستخدمها'),
                                      const SizedBox(height: 10),
                                      StreamBuilder<Position>(
                                          stream: controller.locStream,
                                          builder: (context, snapshot) {
                                            return Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  snapshot.data != null
                                                      ? '${snapshot.data?.latitude.toString()}°"N'
                                                      : '',
                                                  textDirection:
                                                      TextDirection.ltr,
                                                ),
                                                const SizedBox(width: 10),
                                                Text(
                                                  snapshot.data != null
                                                      ? '${snapshot.data?.longitude.toString()}°"W'
                                                      : '',
                                                  textDirection:
                                                      TextDirection.ltr,
                                                ),
                                              ],
                                            );
                                          }),
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
                return MessageWithButtonWidget(
                    title:
                        'الرجاء السماح بصلاحيات الموقع للحصول على اتجاه القبلة',
                    buttonText: 'إعطاء صلاحية',
                    onTap: controller.checkLocationStatus);

              default:
                return const Center(child: LoadingErrorText());
            }
          } else {
            // Display widget when location settings are disabled
            return MessageWithButtonWidget(
                title: "تم إيقاف إعدادات الموقع. يرجى تمكينها للمتابعة",
                buttonText: "تفعيل إعدادات الموقع",
                onTap: controller.checkLocationStatus);
          }
        },
      ),
    );
  }

  // Widget for requesting location permissions
}
