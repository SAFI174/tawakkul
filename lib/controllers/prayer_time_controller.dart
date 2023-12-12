import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

import '../data/repository/prayer_time_repository.dart';
import '../handlers/notification_alarm_handler.dart';
import '../utils/dialogs/update_location_dialog.dart';

class PrayerTimeController extends GetxController {
  // Observable variable to track the location update status
  var isUpdatingLocation = false.obs;

  // Instance of PrayerTimeRepository to access repository methods
  final PrayerTimeRepository repository = Get.find();

  // Method to update the user's location
  Future<void> updateLocation() async {
    // Set isUpdatingLocation to true to indicate location update in progress
    isUpdatingLocation.value = true;

    // Request location permission using Geolocator
    Geolocator.requestPermission();

    // Continue updating location until isUpdatingLocation is true
    while (isUpdatingLocation.value) {
      // Display a dialog to indicate location update is in progress
      Get.dialog(UpdateLocationDialog(isUpdatingLocation: isUpdatingLocation));

      // Get coordinates from the device's location
      await repository.getCoordinatesFromLocation();

      // Initialize prayer times based on the updated location
      await repository.initPrayerTimes();

      // cancel all alarms and re schedule new alarm for next prayer
      Get.find<NotificationAlarmHandler>().cancelAllAndNextPrayerSchedule();

      // Set isUpdatingLocation to false to indicate location update is complete
      isUpdatingLocation.value = false;

      // Close the update location dialog
      Get.back();

      // Trigger UI update
      update();
    }
  }
}
