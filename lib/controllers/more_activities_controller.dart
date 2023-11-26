import 'package:fluentui_system_icons/fluentui_system_icons.dart';
import 'package:flutter_islamic_icons/flutter_islamic_icons.dart';
import 'package:get/get.dart';
import '../../../routes/app_pages.dart';
import '../../constants/enum.dart';

class MoreActivitiesController extends GetxController {
  List<Map<String, dynamic>> activities = [
    {
      'icon': FluentIcons.settings_16_regular,
      'onTap': () {},
      'text': 'الإعدادات',
    },
    {
      'icon': FlutterIslamicIcons.allahText,
      'onTap': () {
        Get.toNamed(Routes.ASMAULLAH_PAGE);
      },
      'text': 'اسماء الله الحسنى',
    },
    {
      'icon': FlutterIslamicIcons.tasbih2,
      'onTap': () {
        Get.toNamed(Routes.ELECTRONIC_TASBIH);
      },
      'text': 'المسبحة الإلكترونية',
    },
    {
      'icon': FlutterIslamicIcons.prayer,
      'onTap': () {
        Get.toNamed(Routes.AZKAR_CATEGORIES);
      },
      'text': 'أذكار المسلم',
    },
    {
      'icon': FlutterIslamicIcons.tasbihHand,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle': 'تسابيح', 'type': AzkarPageType.tasabih},
        );
      },
      'text': 'تسابيح',
    },
    {
      'icon': FlutterIslamicIcons.sajadah,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': 'الحمد',
            'type': AzkarPageType.hmd,
          },
        );
      },
      'text': 'الحمد',
    },
    {
      'icon': FlutterIslamicIcons.prayingPerson,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {'pageTitle': 'استغفار', 'type': AzkarPageType.istighfar},
        );
      },
      'text': 'استغفار',
    },
    {
      'icon': FlutterIslamicIcons.qibla2,
      'onTap': () {
        Get.toNamed(Routes.QIBLA_PAGE);
      },
      'text': 'القبلة',
    },
    {
      'icon': FlutterIslamicIcons.hadji,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': 'ادعية الانبياء',
            'type': AzkarPageType.prophet_dua
          },
        );
      },
      'text': 'ادعية الأنبياء',
    },
    {
      'icon': FlutterIslamicIcons.prayingPerson,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': 'ادعية نبوية',
            'type': AzkarPageType.p_dua,
          },
        );
      },
      'text': 'ادعية نبوية',
    },
    {
      'icon': FlutterIslamicIcons.quran2,
      'onTap': () {
        Get.toNamed(
          Routes.AZKAR_DETAILS,
          arguments: {
            'pageTitle': 'ادعية قرآنية',
            'type': AzkarPageType.quran_dua
          },
        );
      },
      'text': 'ادعية قرآنية',
    },
    {
      'icon': FluentIcons.bookmark_search_20_regular,
      'onTap': () {
        Get.toNamed(Routes.QURAN_BOOKMARKS);
      },
      'text': 'العلامات المرجعية',
    },
    {
      'icon': FluentIcons.book_search_20_regular,
      'onTap': () {
        Get.toNamed(Routes.QURAN_SEARCH_VIEW);
      },
      'text': 'بحث في القرآن',
    },
    {
      'icon': FluentIcons.share_20_regular,
      'onTap': () {},
      'text': 'شارك التطبيق',
    },
  ];
}
