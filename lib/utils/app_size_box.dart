import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

Widget sizedHeight(double height) {
  return SizedBox(height: height);
}

Widget sizedWidth(double width) {
  return SizedBox(width: width);
}

Widget divider([double thickness = 1]) {
  return Divider(thickness: thickness);
}
