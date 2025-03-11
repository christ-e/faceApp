// import 'package:facerecognition_flutter/app/routes/app_pages.dart';
// import 'package:flutter/material.dart';

// import 'package:get/get_navigation/src/root/get_material_app.dart';

// void main() {
//   runApp(const MyApp());
// }

// class MyApp extends StatelessWidget {
//   const MyApp({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return GetMaterialApp(
//       debugShowCheckedModeBanner: false,
//       title: 'Face Recognition',
//       theme: ThemeData(
//         useMaterial3: true,
//         brightness: Brightness.dark,
//       ),
//       initialRoute: AppPages.INITIAL,
//       getPages: AppPages.routes,
//     );
//   }
// }




import 'package:facerecognition_flutter/app/data/dataLayer/database.dart';
import 'package:facerecognition_flutter/utils/app_theme.dart';
import 'package:facerecognition_flutter/utils/color_const.dart';
import 'package:facerecognition_flutter/utils/gloabl_vaiables.dart';
import 'package:facerecognition_flutter/utils/global_functions.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'app/routes/app_pages.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
  ]);
  dioInjection();
  prefs = await SharedPreferences.getInstance();
  // secureStorage = FlutterSecureStorage();
  DB.dbR3MS = prefs?.getString('dbR3MS') ?? '';
  DB.dbR3Url = prefs?.getString('R3Url') ?? '';
  if (DB.dbR3Url.endsWith('/')) {
    DB.dbR3Url = DB.dbR3Url.substring(0, DB.dbR3Url.length - 1);
  }
  DB.dbUserName = prefs?.getString('R3UserName') ?? '';
  DB.dbPassword = prefs?.getString('R3Password') ?? '';
  DB.dbCompanyGUID = prefs?.getString('dbCompanyGUID') ?? '';
  isLoggedIn = prefs?.getBool('isLoggedIn') ?? false;
  debugPrint('isLoggedIn= $isLoggedIn');
  debugPrint('DB.dbR3Url= ${DB.dbR3Url}');
  // Get.put(NetworkCheckController());

  runApp(
    ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      rebuildFactor: (old, data) => RebuildFactors.size(old, data),
      fontSizeResolver: (fontSize, instance) =>
          FontSizeResolvers.height(fontSize, instance),
      builder: (context, child) {
        return GetMaterialApp(
          // home: SasScreen(),
          debugShowCheckedModeBanner: false,
          title: "Face Recognition",
          initialRoute: AppPages.INITIAL,
          getPages: AppPages.routes,
          theme: ThemeData(
            appBarTheme: const AppBarTheme(
              backgroundColor: AppColors.mainBgColor,
              elevation: 0,
            ),
            useMaterial3: false,
            scaffoldBackgroundColor: AppColors.mainBgColor,
            primarySwatch: AppPrimaryColor.primarySwatch,
            primaryColor: AppPrimaryColor.primarySwatch,
          ),
        );
      },
    ),
  );
}
