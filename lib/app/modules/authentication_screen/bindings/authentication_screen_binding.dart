import 'package:get/get.dart';

import '../controllers/authentication_screen_controller.dart';

class AuthenticationScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthenticationScreenController>(
      () => AuthenticationScreenController(),
    );
  }
}
