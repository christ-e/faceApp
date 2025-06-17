import 'package:get/get.dart';

import '../controllers/log_data_controller.dart';

class LogDataBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LogDataController>(
      () => LogDataController(),
    );
  }
}
