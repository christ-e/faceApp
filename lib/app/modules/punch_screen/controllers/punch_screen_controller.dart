import 'package:get/get.dart';
import 'package:intl/intl.dart';

class PunchScreenController extends GetxController {
  var time = ''.obs;
  var date = ''.obs;

  @override
  void onInit() {
    super.onInit();
    updateDateTime();
  }

  void updateDateTime() {
    DateTime now = DateTime.now();
    time.value = DateFormat('hh:mm a').format(now);
    date.value = DateFormat('MMM dd, yyyy - EEEE').format(now);
  }
}
