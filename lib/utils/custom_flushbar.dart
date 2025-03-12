import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:another_flushbar/flushbar.dart';

import '../../utils/color_const.dart';

void showFlushBar({
  required String title,
  required BuildContext? context,
  bool isError = false,
  int seconds = 3,
}) {
  Flushbar(
    backgroundColor: isError ? AppColors.redColor : CupertinoColors.systemGreen,
    icon: isError
        ? const Icon(Icons.warning_amber_outlined, color: AppColors.whiteColor)
        : const SizedBox(),
    borderRadius: const BorderRadius.all(Radius.circular(12)),
    margin: const EdgeInsets.only(bottom: 20, left: 10, right: 10),
    duration: Duration(seconds: seconds),
    messageText: Text(
      title,
      style: const TextStyle(
        color: AppColors.whiteColor,
        fontSize: 16,
        fontWeight: FontWeight.w600,
      ),
    ),
  ).show(context!);
}
