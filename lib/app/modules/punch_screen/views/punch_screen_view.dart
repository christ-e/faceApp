import 'package:facerecognition_flutter/utils/app_size_box.dart';
import 'package:facerecognition_flutter/utils/image_const.dart';
import 'package:facerecognition_flutter/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/punch_screen_controller.dart';

class PunchScreenView extends GetView<PunchScreenController> {
  const PunchScreenView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CommonAppbar(
          showRetryIcon: false,
          showLogoIcon: true,
          showBackButton: false,
        ),
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: 100.h),
                    child: Text(
                      controller.time.value,
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontWeight: FontWeight.w300,
                        fontSize: 50.sp,
                        height: 1.0.h,
                        letterSpacing: 0.0,
                        textBaseline: TextBaseline.alphabetic,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  sizedHeight(10),
                  Text(
                    controller.date.value,
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 14.sp,
                      height: 1.0.h,
                      letterSpacing: 0.0,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  sizedHeight(57),
                  GestureDetector(
                    onTap: () {},
                    child: SizedBox(
                        height: 227.h,
                        width: 227.h,
                        child: SvgPicture.asset(ImageContants.punchIcon)),
                  )
                ]),
          ),
        ));
  }
}
