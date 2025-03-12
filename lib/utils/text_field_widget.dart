import 'package:facerecognition_flutter/utils/color_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class TextfieldWidget extends StatelessWidget {
  const TextfieldWidget({
    super.key,
    this.labelText,
    this.maxLines,
    this.readOnly,
    this.controller,
    this.contentPadding,
    this.suffixIcon,
    this.onTap,
    this.height,
    this.keyboardType,
    this.hintText,
    this.obscureText = false,
    this.onSuffixIconTap,
    this.validator,
    this.enabled = true,
    this.initialValue,
  });

  final String? labelText;
  final String? initialValue;
  final int? maxLines;
  final bool? readOnly;
  final TextEditingController? controller;
  final EdgeInsetsGeometry? contentPadding;
  final Widget? suffixIcon;
  final VoidCallback? onTap;
  final double? height;
  final TextInputType? keyboardType;
  final String? hintText;
  final dynamic validator;
  final bool obscureText;
  final bool enabled;
  final VoidCallback? onSuffixIconTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: TextFormField(
        // initialValue: initialValue ?? "",
        enabled: enabled,
        validator: validator,
        keyboardType: keyboardType,
        onTap: onTap,
        obscureText: obscureText,
        maxLines: obscureText ? 1 : maxLines,
        decoration: InputDecoration(
          hintText: hintText,
          hintStyle: const TextStyle(color: AppColors.hinttext),
          suffixIcon: suffixIcon != null
              ? GestureDetector(onTap: onSuffixIconTap, child: suffixIcon)
              : null,
          contentPadding: contentPadding,
          fillColor: AppColors.whiteColor.withOpacity(.6),
          filled: true,
          labelText: labelText,
          labelStyle: const TextStyle(
            color: AppColors.hinttext,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: const BorderSide(color: AppColors.boderColorgrey2),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15.r),
            borderSide: const BorderSide(color: AppColors.boderColorgrey2),
          ),
        ),
        readOnly: readOnly ?? false,
        controller: controller,
      ),
    );
  }
}
