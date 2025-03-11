import 'package:get/get.dart';

import '../modules/attendance_log/bindings/attendance_log_binding.dart';
import '../modules/attendance_log/views/attendance_log_view.dart';
import '../modules/enroll_list/bindings/enroll_list_binding.dart';
import '../modules/enroll_list/views/enroll_list_view.dart';
import '../modules/face_recognition/bindings/face_recognition_binding.dart';
import '../modules/face_recognition/views/face_recognition_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/registration/bindings/registration_binding.dart';
import '../modules/registration/views/registration_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.REGISTRATION;

  static final routes = [
    GetPage(
      name: _Paths.HOME,
      page: () => const HomeView(),
      binding: HomeBinding(),
    ),
    GetPage(
      name: _Paths.SETTINGS,
      page: () => const SettingsView(),
      binding: SettingsBinding(),
    ),
    GetPage(
      name: _Paths.FACE_RECOGNITION,
      page: () => const FaceRecognitionView(),
      binding: FaceRecognitionBinding(),
    ),
    GetPage(
      name: _Paths.ATTENDANCE_LOG,
      page: () => const AttendanceLogView(),
      binding: AttendanceLogBinding(),
    ),
    GetPage(
      name: _Paths.ENROLL_LIST,
      page: () => const EnrollListView(),
      binding: EnrollListBinding(),
    ),
    GetPage(
      name: _Paths.REGISTRATION,
      page: () => const RegistrationView(),
      binding: RegistrationBinding(),
    ),
  ];
}
