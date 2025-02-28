import 'package:facerecognition_flutter/app/data/local_db.dart';
import 'package:get/get.dart';

class AttendanceLogController extends GetxController {
  LocalDb localDb = LocalDb();
  RxList<Map<String, dynamic>> attendanceLog = <Map<String, dynamic>>[].obs;

  Future<void> getAttendanceData() async {
    List<Map<String, dynamic>> data = await localDb.getAttendanceLog();
    attendanceLog.assignAll(data);
  }
}
