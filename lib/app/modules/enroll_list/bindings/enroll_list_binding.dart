import 'package:get/get.dart';

import '../controllers/enroll_list_controller.dart';

class EnrollListBinding extends Bindings {
  @override
  void dependencies() {
    Get.put<EnrollListController>(
      EnrollListController(),
    );
  }
}
