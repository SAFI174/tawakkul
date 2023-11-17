import 'dart:async';
import 'package:flutter_qiblah_update/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class QiblaController extends GetxController {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  Stream<LocationStatus> get stream => _locationStreamController.stream;
  // Method to check and handle location status
  Future<void> checkLocationStatus() async {
    // Check current location status
    final locationStatus = await FlutterQiblah.checkLocationStatus();

    // If location is not enabled, open location settings and update status
    if (!locationStatus.enabled) {
      await Geolocator.openLocationSettings();
      final updatedStatus = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(updatedStatus);
    }

    // If location is enabled but permission is denied, request permission and handle accordingly
    if (locationStatus.enabled &&
        locationStatus.status == LocationPermission.denied) {
      await Geolocator.requestPermission();
      var updatedStatus = await FlutterQiblah.checkLocationStatus();

      if (updatedStatus.status == LocationPermission.denied) {
        // If permission is still denied, open app settings
        await Geolocator.openAppSettings();
      }

      // Check location status again and update the stream
      updatedStatus = await FlutterQiblah.checkLocationStatus();
      _locationStreamController.sink.add(updatedStatus);
    } else {
      // If location is enabled and permission is granted, update the stream
      _locationStreamController.sink.add(locationStatus);
    }
  }

  @override
  void onInit() async {
    super.onInit();
    // Check location status when the controller is initialized
    final initialStatus = await FlutterQiblah.checkLocationStatus();
    _locationStreamController.sink.add(initialStatus);
  }

  // Dispose of the stream controller when the controller is disposed
  @override
  void onClose() {
    _locationStreamController.close();
    super.onClose();
  }
}
