import 'package:facerecognition_flutter/utils/app_size_box.dart';
import 'package:facerecognition_flutter/widgets/common_appbar.dart';
import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/punch_screen_controller.dart';

class PunchScreenView extends GetView<PunchScreenController> {
  const PunchScreenView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromRGBO(248, 248, 248, 1),
        body: Column(children: [
          CommonAppbar(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(children: [
              Padding(
                padding: const EdgeInsets.only(top: 100),
                child: Text(
                  controller.time.value,
                  style: TextStyle(
                    fontFamily: 'Roboto',
                    fontWeight: FontWeight.w300,
                    fontSize: 50,
                    height: 1.0,
                    letterSpacing: 0.0,
                    textBaseline: TextBaseline.alphabetic,
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              sizedHeight(10),
              Text(
                controller.date.value,
                style: TextStyle(
                  fontFamily: 'Roboto',
                  fontWeight: FontWeight.w400,
                  fontSize: 14,
                  height: 1.0,
                  letterSpacing: 0.0,
                ),
                textAlign: TextAlign.center,
              )
            ]),
          )
        ]));
  }
}
