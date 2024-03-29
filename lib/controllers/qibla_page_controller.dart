import 'dart:async';
import 'package:flutter_qiblah/flutter_qiblah.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:tawakkal/utils/utils.dart';

class QiblaController extends GetxController {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();
  Stream<LocationStatus> get stream => _locationStreamController.stream;

  final StreamController<Position> _positionStreamController =
      StreamController();
  Stream<Position> get locStream => _positionStreamController.stream;

  // Method to check and handle location status
  Future<void> checkLocationStatus() async {
    var status = await Utils.handleLocationStatus();
    _locationStreamController.sink.add(status);
    if (status.enabled &&
        (status.status == LocationPermission.always ||
            status.status == LocationPermission.whileInUse)) {
      getPosition();
    }
  }

  @override
  void onInit() async {
    super.onInit();
    // Check location status when the controller is initialized
    final initialStatus = await FlutterQiblah.checkLocationStatus();
    _locationStreamController.sink.add(initialStatus);
    if (initialStatus.enabled &&
        (initialStatus.status == LocationPermission.always ||
            initialStatus.status == LocationPermission.whileInUse)) {
      getPosition();
    }
  }

  // Dispose of the stream controller when the controller is disposed
  @override
  void onClose() {
    _locationStreamController.close();
    _positionStreamController.close();
    super.onClose();
  }

  void getPosition() {
    _positionStreamController
        .addStream(Geolocator.getPositionStream().handleError((error) {}));
  }
}
