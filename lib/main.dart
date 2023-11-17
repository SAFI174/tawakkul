import 'dart:ui';

import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'constants/themes.dart';
import 'data/cache/quran_settings.dart';
import 'routes/app_pages.dart';

// Custom scroll behavior to support multiple pointer devices
class AppScrollBehavior extends MaterialScrollBehavior {
  @override
  Set<PointerDeviceKind> get dragDevices => {
        PointerDeviceKind.touch,
        PointerDeviceKind.mouse,
      };
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for different data types
  await GetStorage.init('audio_settings');
  await GetStorage.init('app_settings');
  await GetStorage.init('azkar_progress');
  await GetStorage.init('bookmarks');

  // Retrieve the current theme from cache
  final currentTheme = await QuranSettingsCache().getThemeMode();

  runApp(
    ResponsiveSizer(
      builder: (context1, orientation, screenType) {
        return GetMaterialApp(
          // Builder to modify the default MediaQuery's textScaleFactor
          builder: (context, child) {
            final MediaQueryData data = MediaQuery.of(context);
            return MediaQuery(
              data: data.copyWith(
                  textScaleFactor:
                      data.textScaleFactor > 1.2 ? 1.2 : data.textScaleFactor),
              child: child!,
            );
          },
          // Dispose AudioService on app dispose
          onDispose: () async {
            await AudioService.stop();
          },
          supportedLocales: const [
            Locale('ar', 'SA'), // Arabic
          ],
          // Set the default locale
          locale: const Locale('ar'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
          ],
          // Use custom scroll behavior
          scrollBehavior: AppScrollBehavior(),
          debugShowCheckedModeBanner: false,
          title: "tawakkal",
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: currentTheme,
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
