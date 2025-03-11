import 'package:get/get.dart';

import '../controllers/punch_screen_controller.dart';

class PunchScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PunchScreenController>(
      () => PunchScreenController(),
    );
  }
}
