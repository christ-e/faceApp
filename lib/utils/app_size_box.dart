import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget sizedHeight(double height) {
  return SizedBox(height: height.h);
}

Widget sizedWidth(double width) {
  return SizedBox(width: width.w);
}

Widget divider([double thickness = 1]) {
  return Divider(thickness: thickness);
}
