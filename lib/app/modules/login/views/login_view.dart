import 'package:facerecognition_flutter/utils/app_size_box.dart';
import 'package:facerecognition_flutter/utils/color_const.dart';
import 'package:facerecognition_flutter/utils/custom_button.dart';
import 'package:facerecognition_flutter/utils/image_const.dart';
import 'package:facerecognition_flutter/utils/text_field_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';

import 'package:get/get.dart';

import '../controllers/login_controller.dart';

class LoginView extends GetView<LoginController> {
  const LoginView({super.key});
  @override
  Widget build(BuildContext context) {
    final formKey = GlobalKey<FormState>();
    return Scaffold(
        body: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 25),
      child: SingleChildScrollView(
        child: Form(
          key: formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    sizedHeight(Get.height * .09),
                    Center(
                      child: Text(
                        "Welcome Back",
                        style: TextStyle(
                          color: AppColors.textColorblue,
                          fontSize: 24.sp,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    sizedHeight(5),
                    Center(
                      child: Text(
                        "Hello there, sign in to continue",
                        style: TextStyle(
                          fontSize: 12.sp,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              sizedHeight(30),
              SvgPicture.asset(ImageContants.loginLogo),
              sizedHeight(30),
              TextfieldWidget(
                controller: controller.userNameController,

                hintText: 'User Name',
                labelText: 'User Name',
                // validator: (input) {
                //   if (input == null || input.isEmpty) {
                //     return 'Please enter your email';
                //   }
                //   return null;
                // },
              ),
              sizedHeight(20),
              Obx(() {
                return TextfieldWidget(
                  controller: controller.passwordController,
                  hintText: 'Password',
                  labelText: "Password",
                  // validator: (input) {
                  //                       if (input == null || input.isEmpty) {
                  //                         return 'Please enter your password';
                  //                       } else if (input.isEmail == false) {
                  //                         return 'Please enter a valid password';
                  //                       }
                  //                       return null;
                  //                     },
                  obscureText: controller.isPasswordHidden.value,
                  suffixIcon: GestureDetector(
                    onTap: controller.togglePasswordVisibility,
                    child: Icon(
                      controller.isPasswordHidden.value
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                  ),
                );
              }),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text('Remember Me',
                      style: TextStyle(
                          fontSize: 16.sp, fontWeight: FontWeight.w400)),
                  sizedWidth(8),
                  Obx(
                    () => Switch(
                      value: controller.rememberMe.value,
                      activeColor: Color(0xFF5660BF),
                      onChanged: (value) {
                        controller.rememberMe.value = value;
                      },
                    ),
                  ),
                ],
              ),
              sizedHeight(68),
              Obx(() {
                return CustomButton(
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        controller.rsnLogin(
                          userName: controller.userNameController.text,
                          password: controller.passwordController.text,
                        );
                      }
                    },
                    title:
                        controller.isLoading.value ? 'Loading...' : 'Sign In');
              }),
            ],
          ),
        ),
      ),
    ));
  }
}
