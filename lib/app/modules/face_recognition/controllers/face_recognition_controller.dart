// ignore_for_file: depend_on_referenced_packages

import 'dart:developer';
import 'dart:typed_data';
import 'package:facerecognition_flutter/app/data/person_model.dart';
import 'package:facerecognition_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:facesdk_plugin/facedetection_interface.dart';
import 'package:get/get.dart';
import 'package:facesdk_plugin/facesdk_plugin.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FaceRecognitionController extends GetxController implements FaceDetectionInterface {
  final FacesdkPlugin _facesdkPlugin = FacesdkPlugin();
  FaceDetectionViewController? faceDetectionViewController;

  var faces = <dynamic>[].obs;
  var recognized = false.obs;
  var identifiedName = "".obs;
  var identifiedSimilarity = "".obs;
  var identifiedLiveness = "".obs;
  var identifiedYaw = "".obs;
  var identifiedRoll = "".obs;
  var identifiedPitch = "".obs;
  var identifieddesignation = "".obs;

  var identifiedempid = "".obs;
  var identifiedFace = Rx<Uint8List?>(null);
  var enrolledFace = Rx<Uint8List?>(null);

  double livenessThreshold = 0.7;
  double identifyThreshold = 0.8;
  List<Person> personList = [];

  @override
  void onInit() {
    super.onInit();
    loadSettings();
    personList = Get.find<HomeController>().personList;
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    livenessThreshold = double.parse(prefs.getString("liveness_threshold") ?? "0.7");
    identifyThreshold = double.parse(prefs.getString("identify_threshold") ?? "0.8");
  }

  void setFaceDetectionViewController(FaceDetectionViewController controller) {
    faceDetectionViewController = controller;
  }

  Future<void> startFaceRecognition() async {
    final prefs = await SharedPreferences.getInstance();
    var cameraLens = prefs.getInt("camera_lens") ?? 1;

    recognized.value = false;
    faces.clear();

    if (faceDetectionViewController != null) {
      await faceDetectionViewController!.startCamera(cameraLens);
    } else {
      log("Error: faceDetectionViewController is null");
    }
  }

  @override
  Future<void> onFaceDetected(dynamic detectedFaces) async {
    if (recognized.value) return;

    faces.assignAll(detectedFaces);

    if (detectedFaces.isNotEmpty) {
      var face = detectedFaces[0];

      for (var person in personList) {
        double? similarity = await _facesdkPlugin.similarityCalculation(
          face['templates'],
          person.templates,
        );

        if (similarity != null &&
            similarity > identifyThreshold &&
            face['liveness'] > livenessThreshold) {
          recognized.value = true;
          identifiedName.value = person.name;
          identifieddesignation.value = person.designation;
          identifiedempid.value = person.empid;

          identifiedSimilarity.value = similarity.toStringAsFixed(2);
          identifiedLiveness.value = face['liveness'].toStringAsFixed(2);
          identifiedYaw.value = face['yaw'].toStringAsFixed(2);
          identifiedRoll.value = face['roll'].toStringAsFixed(2);
          identifiedPitch.value = face['pitch'].toStringAsFixed(2);
          identifiedFace.value = face['faceJpg'];
          enrolledFace.value = person.faceJpg;

          await faceDetectionViewController?.stopCamera();
          break;
        }
      }
    }
  }

  void resetRecognition() {
    recognized.value = false;
    identifiedName.value = "";
    identifiedSimilarity.value = "";
    identifiedLiveness.value = "";
    identifiedYaw.value = "";
    identifiedRoll.value = "";
    identifiedPitch.value = "";
    identifiedFace.value = null;
    enrolledFace.value = null;
  }
}