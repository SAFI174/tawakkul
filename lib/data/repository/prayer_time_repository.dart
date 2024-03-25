import 'package:adhan/adhan.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:tawakkal/data/cache/prayer_time_cache.dart';
import 'package:tawakkal/services/notification_service.dart';
import 'package:tawakkal/utils/utils.dart';
import '../models/prayer_time_model.dart';

class PrayerTimeRepository extends GetxService {
  PrayerTimes? prayerTimes;
  Coordinates? coordinates;
  late CalculationParameters parameters;
  late Madhab madhab;

  @override
  void onInit() async {
    super.onInit();
    // initialize the PrayerTime data
    await initPrayerTimes();
  }

  /// Initialize prayer times and related data.
  Future<void> initPrayerTimes() async {
    coordinates = PrayerTimeCache.getCoordinatesFromCache();
    if (coordinates == null && await Permission.location.isGranted) {
      coordinates = await getCoordinatesFromLocation();
    }
    if (coordinates != null) {
      parameters =
          PrayerTimeCache.getCalculationMethodFromCache().getParameters();
      madhab = PrayerTimeCache.getMadhabFromCache();
      parameters.madhab = madhab;
      prayerTimes = PrayerTimes.today(coordinates!, parameters);
    }
  }

  /// Get the Arabic name of a prayer.
  String getPrayerNameArabic({required Prayer prayer}) {
    switch (prayer) {
      case Prayer.fajr:
        return 'الفجر';
      case Prayer.sunrise:
        return 'الشروق';
      case Prayer.dhuhr:
        return 'الظهر';
      case Prayer.asr:
        return 'العصر';
      case Prayer.maghrib:
        return 'المغرب';
      case Prayer.isha:
        return 'العشاء';
      default:
        return '';
    }
  }

  /// Schedule notification for the next prayer time.
  Future<void> showPrayerNotification() async {
    // Get the next prayer time
    var currentPrayer = getCurrentPrayer();
    if (currentPrayer.isNotificationEnabled.value) {
      await Get.find<NotificationService>()
          .showPrayerNotification(currentPrayer);
    }
  }

  PrayerTimeModel _createPrayerTimeModel({
    required Prayer prayer,
    bool? isPrevPrayer,
    bool? isNextPrayer,
  }) {
    // Calculate the adjusted prayer time based on the flags
    DateTime prayerTime =
        _calculatePrayerTime(prayer, isPrevPrayer, isNextPrayer);

    // Format the prayer time as a string
    String formattedTime = _formatPrayerTime(prayerTime);

    // Determine if the prayer time is in the morning (AM)
    bool isAM = _isAM(prayerTime);

    // Get the Arabic representation (ص or م) based on whether it's AM or PM
    String amPmAr = _getAmPmAr(prayerTime);

    // Check if notification is enabled for the specific prayer
    var isNotificationEnabled =
        PrayerTimeCache.getPrayerNotificationMode(prayer: prayer);
    // Create and return the PrayerTimeModel
    return PrayerTimeModel(
      name: getPrayerNameArabic(prayer: prayer),
      time: formattedTime,
      type: prayer,
      isAm: isAM,
      amPmAr: amPmAr,
      fulldate: prayerTime,
      isNotificationEnabled: isNotificationEnabled,
      timeLeft: prayerTime.difference(DateTime.now()),
    );
  }

// Calculate the adjusted prayer time based on flags
  DateTime _calculatePrayerTime(
      Prayer prayer, bool? isPrevPrayer, bool? isNextPrayer) {
    DateTime currentPrayerTime = prayerTimes!.timeForPrayer(prayer)!;

    if (isPrevPrayer ?? false) {
      return currentPrayerTime.subtract(const Duration(days: 1));
    } else if (isNextPrayer ?? false) {
      return currentPrayerTime.add(const Duration(days: 1));
    }

    return currentPrayerTime;
  }

// Format the prayer time as a string
  String _formatPrayerTime(DateTime prayerTime) {
    String time = DateFormat.jm().format(prayerTime);
    return time.replaceAll('AM', '').replaceAll('PM', '');
  }

// Check if the prayer time is in the morning (AM)
  bool _isAM(DateTime prayerTime) {
    return DateFormat.jm().format(prayerTime).contains('AM');
  }

// Get the Arabic representation (ص or م) based on whether it's AM or PM
  String _getAmPmAr(DateTime prayerTime) {
    return _isAM(prayerTime) ? 'ص' : 'م';
  }

  /// Get the next prayer time as a [PrayerTimeModel].
  PrayerTimeModel getNextPrayer() {
    prayerTimes = PrayerTimes.today(coordinates!, parameters);
    var nextPrayer = prayerTimes!.nextPrayer();
    var isNonePrayer = nextPrayer == Prayer.none;
    if (nextPrayer == Prayer.none) {
      nextPrayer = Prayer.fajr;
    }
    return _createPrayerTimeModel(
        prayer: nextPrayer, isNextPrayer: isNonePrayer);
  }

  /// Get the [PrayerTimeModel] for the current prayer time.
  PrayerTimeModel getCurrentPrayer() {
    prayerTimes = PrayerTimes.today(coordinates!, parameters);
    var currentPrayer = prayerTimes!.currentPrayer();
    var isNonePrayer = currentPrayer == Prayer.none;
    if (isNonePrayer) {
      currentPrayer = Prayer.isha;
    }
    return _createPrayerTimeModel(
        prayer: currentPrayer, isPrevPrayer: isNonePrayer);
  }

  /// Get a list of [PrayerTimeModel] for all prayers.
  List<PrayerTimeModel> getPrayers() {
    List<PrayerTimeModel> allPrayers = [];
    for (var pray in Prayer.values) {
      if (pray == Prayer.none) {
        continue;
      } else {
        allPrayers.add(
          _createPrayerTimeModel(
            prayer: pray,
          ),
        );
      }
    }
    return allPrayers;
  }

  /// Get coordinates from the device's location and save to cache.
  Future<Coordinates> getCoordinatesFromLocation() async {
    Position? location = await Utils.getCurrentLocation();
    if (location != null) {
      Coordinates coordinates =
          Coordinates(location.latitude, location.longitude);
      PrayerTimeCache.saveCoordinatesToCache(coordinates);
      this.coordinates = coordinates;
      return coordinates;
    }
    return Coordinates(0, 0);
  }

  /// Get the decoded location text using reverse geocoding.
  Future<String> getLocationTextDecoded() async {
    try {
      await setLocaleIdentifier('ar-SA');
      List<Placemark> placemarks = await placemarkFromCoordinates(
          coordinates!.latitude, coordinates!.longitude);
      if (placemarks.isNotEmpty) {
        if (placemarks.length > 2) {
          return placemarks[3].street!;
        }
        return placemarks[0].street!;
      } else {
        return getLocationTextCoded();
      }
    } catch (e) {
      return getLocationTextCoded();
    }
  }

  /// Get the coded location text if reverse geocoding fails.
  String getLocationTextCoded() {
    return '${coordinates!.latitude.toString()}°"N  ${coordinates!.longitude.toString()}°"E';
  }
}
