import 'dart:developer';

import 'package:facerecognition_flutter/app/data/dataLayer/database.dart';
import 'package:facerecognition_flutter/utils/app_guid.dart';
import 'package:facerecognition_flutter/utils/custom_flushbar.dart';
import 'package:get/get.dart';

class EnrollListController extends GetxController {
  RxList employees = [].obs;
  // RxList employees = <Employee>[].obs;

  @override
  void onInit() {
    super.onInit();
    // employees.addAll(Employee.getDummyData());
  }

  Future<void> employeData() async {
    var params = [
      {"Name": "LISTTYPE", "Value": "EMPLOYEE_LIST"},

      // {"Name": "LISTTYPE", "Value": "EMPLOYEE_ENROLLED_LIST_WITH_FACE_DATA"},
      // {"Name": "EMPID", "Value": "EMP070E"}
    ];

    final result = await getR3Data(AppGuid.EMPLOYEDATA_GUID, params);
    log('employeData RESULT: $result');
    if (result != null && result["status"] == 200) {
      dynamic d = result["data"];
      employees.value = d;
      // await box.put('employeData', d['DamageReasons']);
      // await initializeSettings(d);
    } else if (result != null && result["status"] == 404) {
      return showFlushBar(
          title: result["message"], context: Get.context, isError: true);
    }
  }
}

class Employee {
  int id;
  String name;
  String empId;
  bool enroll;
  String imageUrl;

  Employee({
    required this.id,
    required this.name,
    required this.empId,
    required this.enroll,
    required this.imageUrl,
  });

  static List<Employee> getDummyData() {
    return [
      Employee(
          id: 1,
          name: "Alice Johnson",
          empId: "E1001",
          enroll: true,
          imageUrl:
              "https://images.unsplash.com/photo-1499952127939-9bbf5af6c51c?w=600&auto=format&fit=crop&q=60"),
      Employee(
          id: 2,
          name: "Bob Smith",
          empId: "E1002",
          enroll: false,
          imageUrl:
              "https://plus.unsplash.com/premium_photo-1689977968861-9c91dbb16049?w=600&auto=format&fit=crop&q=60"),
      Employee(
          id: 3,
          name: "Charlie Brown",
          empId: "E1003",
          enroll: true,
          imageUrl:
              "https://images.unsplash.com/flagged/photo-1570612861542-284f4c12e75f?w=600&auto=format&fit=crop&q=60"),
      Employee(
          id: 4,
          name: "David Williams",
          empId: "E1004",
          enroll: false,
          imageUrl:
              "https://plus.unsplash.com/premium_photo-1671656349322-41de944d259b?w=600&auto=format&fit=crop&q=60"),
    ];
  }
}
