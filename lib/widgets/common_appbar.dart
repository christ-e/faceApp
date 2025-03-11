import 'package:facerecognition_flutter/utils/app_size_box.dart';
import 'package:facerecognition_flutter/utils/image_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showRetryIcon;
  final bool showLogoIcon;

  const CommonAppbar({
    super.key,
    this.showBackButton = false,
    this.showRetryIcon = true,
    this.showLogoIcon = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      width: Get.width,
      color: const Color.fromRGBO(227, 227, 227, 1),
      padding: EdgeInsets.only(top: 30.h),
      child: Row(
        children: [
          sizedWidth(15),
          if (showLogoIcon == true)
            SizedBox(
              height: 80.h,
              width: 80.h,
              child: Image.asset("assets/png/corel-logo 1.png"),
            ),
          if (showBackButton)
            IconButton(
              icon: SvgPicture.asset(
                ImageContants.backButtonIcon,
                height: 16.h,
                width: 16.h,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          const Spacer(),
          if (showRetryIcon != false)
            SizedBox(
              height: 80.h,
              width: 80.h,
              child: Image.asset("assets/png/corel-logo 1.png"),
            ),
          if (showBackButton)
            SizedBox(
              height: 80.h,
              width: 80.h,
              child: Image.asset("assets/png/corel-logo 1.png"),
            ),
          if (showRetryIcon) ...[
            sizedWidth(10),
            Icon(Icons.refresh, color: Colors.black),
          ],
          sizedWidth(15),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(112);
}
