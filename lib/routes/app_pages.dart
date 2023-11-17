import 'package:get/get.dart';
import 'package:tawakkal/pages/azkar_categories_page.dart';
import 'package:tawakkal/views/quran_bookmarks_view.dart';

import '../bindings/azkar_categories_binding.dart';
import '../bindings/azkar_details_binding.dart';
import '../bindings/home_binding.dart';
import '../bindings/main_binding.dart';
import '../bindings/more_activities_binding.dart';
import '../bindings/qibla_page_binding.dart';
import '../bindings/quran_audio_download_manager_binding.dart';
import '../bindings/quran_audio_player.dart';
import '../bindings/quran_audio_player_settings_binding.dart';
import '../bindings/quran_main_dashborad_binding.dart';
import '../bindings/quran_reading_view_binding.dart';
import '../bindings/quran_settings_binding.dart';
import '../bindings/tafsir_details_binding.dart';
import '../bindings/tafsir_download_manager_binding.dart';
import '../pages/azkar_detials_page.dart';
import '../pages/home_page.dart';
import '../pages/main_page.dart';
import '../pages/more_activities_page.dart';
import '../pages/qibla_page.dart';
import '../pages/quran_audio_download_manager_page.dart';
import '../pages/quran_audio_player_page.dart';
import '../pages/quran_audio_player_settings_page.dart';
import '../pages/quran_main_dashborad_page.dart';
import '../pages/quran_reading_page.dart';
import '../pages/quran_settings_page.dart';
import '../pages/tafisr_details_page.dart';
import '../pages/tafsir_download_manager_page.dart';
import '../views/asmaullah_page_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.HOME;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomePage(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.MAIN,
      page: () => const MainPage(),
      binding: MainBinding(),
    ),
    GetPage(
      name: _Paths.QURAN_MAIN,
      page: () => const QuranMainDashboradPage(),
      binding: QuranMainDashboradBinding(),
    ),
    GetPage(
      name: _Paths.MORE_ACTIVITIES,
      page: () => const MoreActivitiesPage(),
      binding: MoreActivitiesBinding(),
    ),
    GetPage(
      name: _Paths.QURAN_VIEW,
      page: () => const QuranReadingPage(),
      binding: QuranReadingPageBinding(),
    ),
    GetPage(
      name: _Paths.TAFSIR_DOWNLOAD_MANAGER,
      page: () => const TafsirDownloadManagerPage(),
      binding: TafsirDownloadManagerBinding(),
    ),
    GetPage(
      name: _Paths.AYAH_TAFSIR_DETAILS,
      page: () => const TafsirDetailsPage(),
      binding: TafsirDetailsBinding(),
    ),
    GetPage(
      name: _Paths.RECITER_DOWNLOAD_MANAGER,
      page: () => const QuranAudioDownloadManagerPage(),
      binding: QuranAudioDownloadManagerBinding(),
    ),
    GetPage(
      name: _Paths.AUDIO_PLAYER_CONTROLS,
      page: () => const QuranAudioPlayerBottomBar(),
      binding: QuranAudioPlayerBinding(),
    ),
    GetPage(
      name: _Paths.AUDIO_SETTINGS,
      page: () => const QuranAudioSettingsPage(),
      binding: QuranAudioPlayerSettingsBinding(),
    ),
    GetPage(
      name: _Paths.QURAN_DISPLAY_SETTINGS,
      page: () => const QuranSettingsPage(),
      binding: QuranSettingsBinding(),
    ),
    GetPage(
      name: _Paths.QIBLA_PAGE,
      page: () => const QiblaPage(),
      binding: QiblaPageBinding(),
    ),
    GetPage(
      name: _Paths.ASMAULLAH_PAGE,
      page: () => const AsmaullahPageView(),
    ),
    GetPage(
      name: _Paths.AZKAR_DETAILS,
      page: () => const AzkarDetailsPage(),
      binding: DuaTasbihMultiBinding(),
    ),
    GetPage(
      name: _Paths.AZKAR_CATEGORIES,
      page: () => const AzkarCategoriesPage(),
      binding: AzkarCategoriesBinding(),
    ),
    GetPage(
      name: _Paths.QURAN_BOOKMARKS,
      page: () => QuranBookmarksView(),
    ),
  ];
}
