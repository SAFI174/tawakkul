import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService extends GetxService {
  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  SharedPreferences get prefs {
    _prefs.reload();
    return _prefs;
  }

  static SharedPreferencesService get instance =>
      Get.find<SharedPreferencesService>();
}
