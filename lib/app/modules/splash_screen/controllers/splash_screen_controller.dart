import 'dart:developer';

import 'package:facerecognition_flutter/app/data/dataLayer/common_functions.dart';
import 'package:facerecognition_flutter/app/data/dataLayer/database.dart';
import 'package:facerecognition_flutter/app/routes/app_pages.dart';
import 'package:facerecognition_flutter/utils/app_guid.dart';
import 'package:facerecognition_flutter/utils/custom_flushbar.dart';
import 'package:facerecognition_flutter/utils/gloabl_vaiables.dart';
import 'package:get/get.dart';

class SplashScreenController extends GetxController {
  @override
  // void onReady() async {

  //   super.onReady();
  // }
  void onInit() {
    userLoginCheck();
    super.onInit();
  }

  var roleTypeId = prefs?.getString('R3RoleTypeID');
  Future<void> userLoginCheck() async {
    try {
      if (isLoggedIn) {
        await Future.delayed(const Duration(seconds: 3), () {
          if (roleTypeId == "1") {
            // Get.offAllNamed(Routes.PUNCH_SCREEN);
            Get.offAllNamed(Routes.MAIN_DASHBOARD);
          } else if (roleTypeId == "7") {
            Get.offAllNamed(Routes.PUNCH_SCREEN);
            // Get.offAllNamed(Routes.MAIN_DASHBOARD);
          }
        });
      } else {
        await Future.delayed(const Duration(seconds: 3), () {
          Get.offAllNamed(Routes.LOGIN_SCREEN);
        });
      }
    } catch (e) {
      log('ERROR : $e');
    }
  }
}
