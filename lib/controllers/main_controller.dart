import 'package:arabic_numbers/arabic_numbers.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:jhijri/jHijri.dart';

class MainController extends GetxController {
  late String currentDate;
  late String currentDateHijri;

  void setDate() {
    var now = DateTime.now();
    var formatter = DateFormat.yMMMd('ar_SA');
    currentDate = formatter.format(now);
    currentDateHijri = ArabicNumbers().convert(
      HijriDate.now().toString(),
    );
  }

  @override
  void onInit() async {
    super.onInit();
    setDate();
  }


}
