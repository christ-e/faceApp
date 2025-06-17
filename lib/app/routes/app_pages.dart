import 'package:get/get.dart';

import '../modules/attendance_log/bindings/attendance_log_binding.dart';
import '../modules/attendance_log/views/attendance_log_view.dart';
import '../modules/authentication_screen/bindings/authentication_screen_binding.dart';
import '../modules/authentication_screen/views/authentication_screen_view.dart';
import '../modules/enroll_list/bindings/enroll_list_binding.dart';
import '../modules/enroll_list/views/enroll_list_view.dart';
import '../modules/face_recognition/bindings/face_recognition_binding.dart';
import '../modules/face_recognition/views/face_recognition_view.dart';
import '../modules/home/bindings/home_binding.dart';
import '../modules/home/views/home_view.dart';
import '../modules/log_data/bindings/log_data_binding.dart';
import '../modules/log_data/views/log_data_view.dart';
import '../modules/login/bindings/login_binding.dart';
import '../modules/login/views/login_view.dart';
import '../modules/main_dashboard/bindings/main_dashboard_binding.dart';
import '../modules/main_dashboard/views/main_dashboard_view.dart';
import '../modules/punch_screen/bindings/punch_screen_binding.dart';
import '../modules/punch_screen/views/punch_screen_view.dart';
import '../modules/settings/bindings/settings_binding.dart';
import '../modules/settings/views/settings_view.dart';
import '../modules/splash_screen/bindings/splash_screen_binding.dart';
import '../modules/splash_screen/views/splash_screen_view.dart';

part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const INITIAL = Routes.SPLASH_SCREEN;

  static final routes = [
    GetPage(
      name: _Paths.LOGIN_SCREEN,
      page: () => const LoginView(),
      binding: LoginBinding(),
    ),
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
      name: _Paths.PUNCH_SCREEN,
      page: () => const PunchScreenView(),
      binding: PunchScreenBinding(),
    ),
    GetPage(
      name: _Paths.ENROLL_LIST,
      page: () => const EnrollListView(),
      binding: EnrollListBinding(),
    ),
    GetPage(
      name: _Paths.AUTHENTICATION_SCREEN,
      page: () => const AuthenticationScreenView(),
      binding: AuthenticationScreenBinding(),
    ),
    GetPage(
      name: _Paths.SPLASH_SCREEN,
      page: () => const SplashScreenView(),
      binding: SplashScreenBinding(),
    ),
    GetPage(
      name: _Paths.MAIN_DASHBOARD,
      page: () => const MainDashboardView(),
      binding: MainDashboardBinding(),
    ),
    GetPage(
      name: _Paths.LOG_DATA,
      page: () => const LogDataView(),
      binding: LogDataBinding(),
    ),
  ];
}
