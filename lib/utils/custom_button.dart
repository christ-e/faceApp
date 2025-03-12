import 'package:facerecognition_flutter/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onPressed,
    required this.title,
    this.width,
  });
  final VoidCallback onPressed;
  final String title;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: 46.h,
        width: width,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(26),
          gradient: const LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: [Color(0xFF5660BF), Color(0xFF55C2D8)],
          ),
          color: AppColors.whiteColor,
        ),
        child: Center(
          child: Text(title,
              style: TextStyle(
                color: AppColors.whiteColor,
                fontSize: 15.sp,
                fontWeight: FontWeight.w600,
              )),
        ),
      ),
    );
  }
}
