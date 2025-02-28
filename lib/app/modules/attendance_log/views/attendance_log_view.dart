import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/attendance_log_controller.dart';

class AttendanceLogView extends GetView<AttendanceLogController> {
  const AttendanceLogView({super.key});

  @override
  Widget build(BuildContext context) {
    controller.getAttendanceData();

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        title: const Text('Attendance Log'),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: Obx(() {
        if (controller.attendanceLog.isEmpty) {
          return const Center(child: Text("No attendance records found"));
        }

        return ListView.separated(
          itemCount: controller.attendanceLog.length,
          separatorBuilder: (context, index) => Column(
            children: const [
              SizedBox(height: 2.5),
              Divider(),
              SizedBox(height: 2.5),
            ],
          ),
          itemBuilder: (context, index) {
            var record = controller.attendanceLog[index];

            return ListTile(
              leading: CircleAvatar(
                radius: 25,
                backgroundImage: record['imageJpg'] != null
                    ? MemoryImage(record['imageJpg'])
                    : const AssetImage('assets/default_avatar.png')
                        as ImageProvider,
              ),
              title: Text("Employee: ${record['employeeName']}"),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("Date: ${record['date']}"),
                  Text("Time: ${record['time']}"),
                ],
              ),
              trailing: Text(
                record['punchStatus'],
                style: TextStyle(
                    color: record['punchStatus'] == "Punch-In"
                        ? Colors.green
                        : Colors.red),
              ),
            );
          },
        );
      }),
    );
  }
}
