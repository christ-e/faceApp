import 'package:facerecognition_flutter/utils/app_size_box.dart';
import 'package:facerecognition_flutter/utils/color_const.dart';
import 'package:facerecognition_flutter/utils/image_const.dart';
import 'package:facerecognition_flutter/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/authentication_screen_controller.dart';

class AuthenticationScreenView extends GetView<AuthenticationScreenController> {
  const AuthenticationScreenView({super.key});
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: const CommonAppbar(
          showRetryIcon: false,
          showBackButton: true,
        ),
        backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
        body: Center(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  sizedHeight(15),
                  Container(
                    width: Get.width,
                    // height: Get.height * .2,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: Color.fromRGBO(254, 235, 235, 1)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 40.w, vertical: 20.w),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          enroll(
                              identified: false,
                              image:
                                  "https://images.unsplash.com/photo-1491349174775-aaafddd81942?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHBlcnNvbnxlbnwwfHwwfHx8MA%3D%3D"),
                          Spacer(),
                          enroll(
                              identified: true,
                              image:
                                  "https://images.unsplash.com/photo-1491349174775-aaafddd81942?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHBlcnNvbnxlbnwwfHwwfHx8MA%3D%3D")
                        ],
                      ),
                    ),
                  ),
                  sizedHeight(16),
                  Text(
                    "Jhone Doe",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w500,
                      fontSize: 19.sp,
                      height: 1.0.h,
                      letterSpacing: 0.19,
                      color: Colors.black,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  sizedHeight(06),
                  Text(
                    "MZ001234",
                    style: TextStyle(
                      fontFamily: 'Roboto',
                      fontWeight: FontWeight.w400,
                      fontSize: 13.sp,
                      height: 1.0.h,
                      letterSpacing: 0.13,
                      color: Color.fromRGBO(106, 125, 148, 1),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  sizedHeight(25),
                  Container(
                    width: Get.width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2.r,
                          blurRadius: 5.r,
                          offset: Offset(0, 3),
                        ),
                      ],
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: 12.w, vertical: 10.h),
                      child: Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Color.fromRGBO(232, 156, 30, 1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Padding(
                              padding: EdgeInsets.only(
                                  right: 16.w,
                                  left: 16.w,
                                  top: 10.h,
                                  bottom: 10.h),
                              child: Column(
                                children: [
                                  Text(
                                    "06",
                                    style: TextStyle(
                                      fontFamily: 'Roboto',
                                      fontWeight: FontWeight.w600,
                                      fontSize: 19.sp,
                                      height: 1.0.h,
                                      letterSpacing: 0.0,
                                      color: AppColors.whiteColor,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                  Text(
                                    "TUE",
                                    style: TextStyle(
                                        fontFamily: 'Roboto',
                                        fontWeight: FontWeight.w400,
                                        fontSize: 11.sp,
                                        height: 1.0.h,
                                        letterSpacing: 0.0,
                                        color: AppColors.whiteColor),
                                    textAlign: TextAlign.center,
                                  )
                                ],
                              ),
                            ),
                          ),
                          sizedWidth(15),
                          Text(
                            "09:08 AM",
                            style: TextStyle(
                              fontFamily: 'Roboto',
                              fontWeight: FontWeight.w600,
                              fontSize: 12.sp,
                              height: 1.0.h,
                              letterSpacing: 0.0,
                              color: AppColors.blackColor,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          Spacer(),
                          Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.r),
                                color: AppColors.greenColor),
                            child: Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 05.h, horizontal: 10.w),
                              child: Text(
                                "Punch In",
                                style: TextStyle(
                                  fontFamily: 'Roboto',
                                  fontWeight: FontWeight.w500,
                                  fontSize: 11.sp,
                                  letterSpacing: 0.0,
                                  color: AppColors.whiteColor,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      showDialog(
                        context: Get.context!,
                        barrierDismissible: false,
                        builder: (context) {
                          return AlertDialog(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.r),
                            ),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 20.h, horizontal: 20.w),
                            content: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Center(
                                  child: SvgPicture.asset(
                                    width: 40.h,
                                    height: 40.h,
                                    ImageContants.warningIcon,
                                  ),
                                ),
                                sizedHeight(10),
                                Text(
                                  "ERROR!",
                                  style: TextStyle(
                                    fontFamily: 'Poppins',
                                    fontWeight: FontWeight.w600,
                                    fontSize: 16.sp,
                                    color: AppColors.redColor,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                sizedHeight(5),
                                Text(
                                  "Please try again to complete the process",
                                  style: TextStyle(
                                    fontFamily: 'Inter',
                                    fontWeight: FontWeight.w400,
                                    fontSize: 12.sp,
                                    color: Colors.black,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                sizedHeight(20),
                                ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.redColor,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(5.r),
                                    ),
                                  ),
                                  onPressed: () {
                                    Get.back();
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 30.0.w, vertical: 10.h),
                                    child: Text(
                                      "Try again",
                                      style: TextStyle(
                                        fontFamily: 'Inter',
                                        fontWeight: FontWeight.w500,
                                        fontSize: 14.sp,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                    child: Text("Show Error"),
                  ),
                  sizedHeight(Get.height * .2),
                  Obx(() {
                    if (!controller.showAnimation.value) {
                      return SizedBox.shrink();
                    }
                    return meassage()
                        .animate()
                        .fadeIn(duration: 600.ms)
                        .then(delay: 800.ms)
                        .slide();
                  }),
                ]),
          ),
        ));
  }

  Widget enroll({required bool identified, required String image}) {
    return Container(
      height: 120.h,
      width: 120.h,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: AppColors.whiteColor,
      ),
      child: Padding(
        padding: const EdgeInsets.only(top: 12),
        child: Column(
          children: [
            Container(
              width: 60.w,
              height: 60.w,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: identified == true
                      ? AppColors.greenColor.withOpacity(0.5)
                      : AppColors.blueColor.withOpacity(0.5),
                  width: 4,
                ),
              ),
              child: CircleAvatar(
                radius: 70.r,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(
                  image,
                  // "https://images.unsplash.com/photo-1491349174775-aaafddd81942?w=600&auto=format&fit=crop&q=60&ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTF8fHBlcnNvbnxlbnwwfHwwfHx8MA%3D%3D",
                ),
              ),
            ),
            sizedHeight(7),
            Text(
              identified == true ? "identified" : "Enroll",
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: Color.fromRGBO(106, 125, 148, 1),
                letterSpacing: 1.5,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
              maxLines: 1,
            ),
          ],
        ),
      ),
    );
  }

  Widget meassage() {
    return Container(
      height: 60.h,
      decoration: BoxDecoration(
        color: const Color.fromRGBO(0, 204, 153, .15),
        borderRadius: BorderRadius.circular(8.r),
      ),
      child: Row(
        children: [
          Container(
            width: 4.w,
            height: 60.h,
            decoration: BoxDecoration(
              color: Colors.orange,
              borderRadius: BorderRadius.circular(10.r),
            ),
          ),
          sizedWidth(15),
          CircleAvatar(
            radius: 20.r,
            backgroundColor: Colors.orange,
            child: Icon(
              Icons.check_sharp,
              color: AppColors.whiteColor,
              size: 26.sp,
            ),
          ),
          sizedWidth(10),
          Expanded(
            child: Text(
              "Attendance Placed Successfully",
              style: TextStyle(
                fontFamily: 'Poppins',
                fontWeight: FontWeight.w500,
                fontSize: 14.sp,
                letterSpacing: 0.0,
                color: AppColors.blackColor,
              ),
              textAlign: TextAlign.center,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
