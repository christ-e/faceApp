import 'package:flutter_animate/flutter_animate.dart';
import 'package:get/get.dart';

class AuthenticationScreenController extends GetxController {
  var showAnimation = false.obs;
  @override
  void onInit() {
    super.onInit();
    Future.delayed(Duration(seconds: 2), () {
      toggleAnimation();
    });
  }

  void toggleAnimation() {
    showAnimation.value = true;
    Future.delayed(2400.ms, () {
      showAnimation.value = false;
    });
  }
}
