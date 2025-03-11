import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextStyles {
  CustomTextStyles._();

  static TextStyle textWithFontW100(double size,
      {double? height,
      Color color = Colors.black,
      bool isResponsiveText = true}) {
    return TextStyle(
      fontSize: isResponsiveText ? size.sp : size,
      fontWeight: FontWeight.w100,
      color: color,
      height: height,
    );
  }

  static TextStyle textWithFontW200(double size,
      {double? height,
      Color color = Colors.black,
      bool isResponsiveText = true}) {
    return TextStyle(
      fontSize: isResponsiveText ? size.sp : size,
      fontWeight: FontWeight.w200,
      color: color,
      height: height,
    );
  }

  static TextStyle textWithFontW300(double size,
      {double? height,
      Color color = Colors.black,
      bool isResponsiveText = true}) {
    return TextStyle(
      fontSize: isResponsiveText ? size.sp : size,
      fontWeight: FontWeight.w300,
      color: color,
      height: height,
    );
  }

  static TextStyle textWithFontW400(double size,
      {double? height,
      Color color = Colors.black,
      bool isResponsiveText = true}) {
    return TextStyle(
      fontSize: isResponsiveText ? size.sp : size,
      fontWeight: FontWeight.w400,
      color: color,
      height: height,
    );
  }

  static TextStyle textWithFontW500(double size,
      {double? height,
      Color color = Colors.black,
      bool isResponsiveText = true}) {
    return TextStyle(
      fontSize: isResponsiveText ? size.sp : size,
      fontWeight: FontWeight.w500,
      color: color,
      height: height,
    );
  }

  static TextStyle textWithFontW600(double size,
      {double? height,
      Color color = Colors.black,
      bool isResponsiveText = true}) {
    return TextStyle(
      fontSize: isResponsiveText ? size.sp : size,
      fontWeight: FontWeight.w600,
      color: color,
      height: height,
    );
  }

  static TextStyle textWithFontW700(double size,
      {double? height,
      Color color = Colors.black,
      bool isResponsiveText = true}) {
    return TextStyle(
      fontSize: isResponsiveText ? size.sp : size,
      fontWeight: FontWeight.w700,
      color: color,
    );
  }
}
