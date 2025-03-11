import 'package:facerecognition_flutter/utils/image_const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:get/get.dart';

class CommonAppbar extends StatelessWidget {
  const CommonAppbar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      width: Get.width,
      color: Color.fromRGBO(227, 227, 227, 1),
      child: Column(
        children: [
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              // sizedWidth(10),
              SizedBox(
                width: 15,
              ),
              SizedBox(
                  height: 100,
                  width: 90,
                  child: Image.asset("assets/png/corel-logo 1.png")),
              Spacer(),
              SvgPicture.asset(ImageContants.retryIcon),
              SizedBox(
                width: 20,
              )
            ],
          ),
          // SizedBox(
          //   height: 10,
          // ),
        ],
      ),
    );
  }
}
