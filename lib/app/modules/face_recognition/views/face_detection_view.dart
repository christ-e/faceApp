// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:facesdk_plugin/facedetection_interface.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controllers/face_recognition_controller.dart';

class FaceDetectionView extends StatelessWidget {
  final FaceRecognitionController controller; 

  const FaceDetectionView({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    if (defaultTargetPlatform == TargetPlatform.android) {
      return AndroidView(
        viewType: 'facedetectionview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    } else {
      return UiKitView(
        viewType: 'facedetectionview',
        onPlatformViewCreated: _onPlatformViewCreated,
      );
    }
  }

  void _onPlatformViewCreated(int id) async {
    final prefs = await SharedPreferences.getInstance();
    var cameraLens = prefs.getInt("camera_lens") ?? 1;

    // Initialize the FaceDetectionViewController
    final faceDetectionViewController = FaceDetectionViewController(id, controller);
    await faceDetectionViewController.initHandler();

    // Set the controller in the FaceRecognitionController
    controller.setFaceDetectionViewController(faceDetectionViewController);

    // Start the camera
    await faceDetectionViewController.startCamera(cameraLens);
  }
}