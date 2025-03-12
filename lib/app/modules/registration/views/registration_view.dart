import 'package:facerecognition_flutter/widgets/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../controllers/registration_controller.dart';

class RegistrationView extends GetView<RegistrationController> {
  const RegistrationView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppbar(showBackButton: true, showRetryIcon: false),
      backgroundColor: const Color.fromRGBO(248, 248, 248, 1),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 80.h),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CircleAvatar(
              radius: 50.r,
              backgroundImage: AssetImage("assets/png/darvin.png"),
            ),
            SizedBox(height: 10.h),
            Text(
              'Darvin Pappachan',
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
            ),
            Text(
              'DRV-0012001',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20.h),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 30.w),
              child: SizedBox(
                width: double.infinity,
                height: 55.h,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color.fromRGBO(27, 188, 230, 1),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10.r),
                    ),
                  ),
                  onPressed: () {
                    showSuccessDialog();
                  },
                  child: Text(
                    'SAVE',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.sp,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

void showSuccessDialog() {
  Get.dialog(
    Dialog(
      shape: RoundedRectangleBorder(
       borderRadius: BorderRadius.circular(20.r),
      ),
      child: Stack(
        children: [
          Padding(
           padding: EdgeInsets.all(20.w),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
               SizedBox(height: 20.h),
                // SvgPicture.asset(
                //   "assets/svg/celebrate.svg",
                //   height: 80,
                //   width: 80,
                // ),
                CircleAvatar(
                  radius: 40.r,
                  backgroundColor: Color.fromRGBO(255, 234, 159, 1),
                  child: Image.asset(
                    "assets/png/celebrate.png",
                   height: 80.h,
                    width: 80.w,
                  ),
                ),
               SizedBox(height: 20.h),
                 Text(
                  "Registration Completed Successfully",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 24.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 20.h),
              ],
            ),
          ),
          Positioned(
           right: 10.w,
            top: 10.h,
            child: Container(
               width: 30.w,
              height: 30.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                shape: BoxShape.circle,
              ),
              child: IconButton(
                 iconSize: 14.sp,
                icon: const Icon(Icons.close, color: Colors.black),
                onPressed: () {
                  Get.back();
                },
              ),
            ),
          ),
        ],
      ),
    ),
  );
}
