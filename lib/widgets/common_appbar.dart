import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CommonAppbar extends StatelessWidget implements PreferredSizeWidget {
  final bool showBackButton;
  final bool showRetryIcon;

  const CommonAppbar({
    super.key,
    this.showBackButton = false,
    this.showRetryIcon = true,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      width: Get.width,
      color: const Color.fromRGBO(227, 227, 227, 1),
      padding: const EdgeInsets.only(top: 30),
      child: Row(
        children: [
          const SizedBox(width: 15),
          if (showBackButton)
            IconButton(
              icon: SvgPicture.asset(
                "assets/svg/back-icon.svg",
                height: 16,
                width: 16,
              ),
              onPressed: () {
                Get.back();
              },
            ),
          const Spacer(),
          SizedBox(
            height: 80,
            width: 80,
            child: Image.asset("assets/png/corel-logo 1.png"),
          ),
          if (showRetryIcon) ...[
            const SizedBox(width: 10),
            Icon(Icons.refresh, color: Colors.black),
          ],
          const SizedBox(width: 15),
        ],
      ),
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(112);
}
