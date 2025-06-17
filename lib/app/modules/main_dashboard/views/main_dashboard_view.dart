import 'package:facerecognition_flutter/app/routes/app_pages.dart';
import 'package:facerecognition_flutter/utils/app_size_box.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/main_dashboard_controller.dart';

class MainDashboardView extends GetView<MainDashboardController> {
  const MainDashboardView({super.key});
  @override
  Widget build(BuildContext context) {
    // controller.employeData();
    return Scaffold(
        appBar: AppBar(
          title: const Text('MainDashboardView'),
          centerTitle: true,
        ),
        body: Column(
          children: [
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.ENROLL_LIST);
                },
                child: Text("Enroll")),
            sizedHeight(10),
            ElevatedButton(
                onPressed: () {
                  Get.toNamed(Routes.LOG_DATA);
                },
                child: Text("Logs"))
          ],
        ));
  }
}
