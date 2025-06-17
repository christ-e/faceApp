import 'dart:developer';

import 'package:facerecognition_flutter/app/data/dataLayer/common_functions.dart';
import 'package:facerecognition_flutter/app/data/dataLayer/database.dart';
import 'package:facerecognition_flutter/utils/app_guid.dart';
import 'package:facerecognition_flutter/utils/custom_flushbar.dart';
import 'package:get/get.dart';

class MainDashboardController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    // employeData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  // Future<void> employeData() async {
  //   var params = [
  //     {"Name": "LISTTYPE", "Value": "EMPLOYEE_LIST"},

  //     // {"Name": "LISTTYPE", "Value": "EMPLOYEE_ENROLLED_LIST_WITH_FACE_DATA"},
  //     // {"Name": "EMPID", "Value": "EMP070E"}
  //   ];

  //   final result = await getR3Data(AppGuid.EMPLOYEDATA_GUID, params);
  //   log('employeData RESULT: $result');
  //   if (result != null && result["status"] == 200) {
  //     dynamic d = result["data"];
  //     // await box.put('employeData', d['DamageReasons']);
  //     // await initializeSettings(d);
  //   } else if (result != null && result["status"] == 404) {
  //     return showFlushBar(
  //         title: result["message"], context: Get.context, isError: true);
  //   }
  // }
}
