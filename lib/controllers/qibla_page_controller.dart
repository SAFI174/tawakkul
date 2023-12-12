import 'dart:async';
import 'package:flutter_qiblah_update/flutter_qiblah.dart';
import 'package:get/get.dart';
import 'package:tawakkal/utils/utils.dart';

class QiblaController extends GetxController {
  final _locationStreamController =
      StreamController<LocationStatus>.broadcast();

  Stream<LocationStatus> get stream => _locationStreamController.stream;
  // Method to check and handle location status
  Future<void> checkLocationStatus() async {
    var status = await Utils.handleLocationStatus();
    _locationStreamController.sink.add(status);
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
