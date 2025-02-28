// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class SettingsController extends GetxController {
  var cameraLens = false.obs;
  var livenessThreshold = "0.7".obs;
  var identifyThreshold = "0.8".obs;
  var selectedLivenessLevel = 0.obs;

  static Future<void> initSettings() async {
    final prefs = await SharedPreferences.getInstance();
    var firstWrite = prefs.getInt("first_write");
    if (firstWrite == 0) {
      await prefs.setInt("first_write", 1);
      await prefs.setInt("camera_lens", 1);
      await prefs.setInt("liveness_level", 0);
      await prefs.setString("liveness_threshold", "0.7");
      await prefs.setString("identify_threshold", "0.8");
    }
  }

  @override
  void onInit() {
    super.onInit();
    loadSettings();
  }

  Future<void> loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    var cameraLens = prefs.getInt("camera_lens");
    var livenessLevel = prefs.getInt("liveness_level");
    var livenessThreshold = prefs.getString("liveness_threshold");
    var identifyThreshold = prefs.getString("identify_threshold");

    this.cameraLens.value = cameraLens == 1 ? true : false;
    this.livenessThreshold.value = livenessThreshold ?? "0.7";
    this.identifyThreshold.value = identifyThreshold ?? "0.8";
    this.selectedLivenessLevel.value = livenessLevel ?? 0;
  }

  Future<void> restoreSettings() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("first_write", 0);
    await initSettings();
    await loadSettings();

    Fluttertoast.showToast(
        msg: "Default settings restored!",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0);
  }

  Future<void> updateLivenessLevel(int value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("liveness_level", value);
    selectedLivenessLevel.value = value;
  }

  Future<void> updateCameraLens(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt("camera_lens", value ? 1 : 0);
    cameraLens.value = value;
  }

  Future<void> updateLivenessThreshold(String value) async {
    try {
      var doubleValue = double.parse(value);
      if (doubleValue >= 0 && doubleValue < 1.0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("liveness_threshold", value);
        livenessThreshold.value = value;
      }
    } catch (e) {}
  }

  Future<void> updateIdentifyThreshold(String value) async {
    try {
      var doubleValue = double.parse(value);
      if (doubleValue >= 0 && doubleValue < 1.0) {
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString("identify_threshold", value);
        identifyThreshold.value = value;
      }
    } catch (e) {}
  }
}