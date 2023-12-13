import 'package:audio_service/audio_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:tawakkal/constants/constants.dart';
import 'package:tawakkal/data/cache/app_settings_cache.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'constants/themes.dart';
import 'routes/app_pages.dart';
import 'services/shared_preferences_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize GetStorage for different data types
  await GetStorage.init('bookmarks');
  await GetStorage.init('daily_content');
  // init SharedPreferencesService for app preference
  await Get.putAsync(() async {
    var service = SharedPreferencesService();
    await service.init();
    return service;
  });
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
          onDispose: () async {
            // ignore: deprecated_member_use
            await AudioService.stop();
          },
          supportedLocales: const [
            Locale('ar', 'SA'), // Arabic
          ],
          // Set the default locale
          locale: const Locale('ar', 'SA'),
          localizationsDelegates: const [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate
          ],
          debugShowCheckedModeBanner: false,
          title: appName,
          theme: lightTheme,
          darkTheme: darkTheme,
          themeMode: AppSettingsCache.getThemeMode(),
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
        );
      },
    ),
  );
}
