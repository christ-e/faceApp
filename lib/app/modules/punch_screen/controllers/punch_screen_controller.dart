import 'dart:async';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

class PunchScreenController extends GetxController {
  var time = ''.obs;
  var date = ''.obs;
  late Timer _timer;

  @override
  void onInit() {
    super.onInit();
    updateDateTime();
    _timer = Timer.periodic(Duration(seconds: 60), (timer) {
      updateDateTime();
    });
  }

  void updateDateTime() {
    DateTime now = DateTime.now();
    time.value = DateFormat('hh:mm a').format(now);
    date.value = DateFormat('MMM dd, yyyy - EEEE').format(now);
  }

  @override
  void onClose() {
    _timer.cancel(); // Cancel the timer when the controller is closed
    super.onClose();
  }
}
