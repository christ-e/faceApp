import 'package:facerecognition_flutter/utils/app_text_styles.dart';
import 'package:facerecognition_flutter/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/splash_screen_controller.dart';

class SplashScreenView extends GetView<SplashScreenController> {
  const SplashScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    controller.userLoginCheck();
    return Scaffold(
      backgroundColor: Color(0xFF7265E2),
      body: Stack(
        children: [
          // SvgPicture.asset(
          //   width: double.maxFinite,
          //   'assets/images/svg/ellips_icon.svg',
          // ),
          // Positioned(
          //   right: 0,
          //   child: Image.asset(
          //     'assets/images/png/splash_main.png',
          //   ),
          // ),
          Positioned.fill(
            top: 50.0,
            child: Align(
              alignment: Alignment.center,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Text(
                  'Streamline Your Projects, Empower Your Team!',
                  style: CustomTextStyles.textWithFontW500(
                    26.0,
                    color: AppColors.whiteColor,
                  ),
                ),
              ),
            ),
          ),
          // Positioned.fill(
          //   bottom: 18,
          //   child: Align(
          //     alignment: Alignment.bottomCenter,
          //     child: Image.asset(
          //       'assets/images/png/R3Logo.webp',
          //       height: 50,
          //       width: 50,
          //     ),
          //   ),
          // )
        ],
      ),
    );
  }
}
