// ignore_for_file: depend_on_referenced_packages

import 'package:facerecognition_flutter/app/modules/home/controllers/home_controller.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:settings_ui/settings_ui.dart';
import '../controllers/settings_controller.dart';

class SettingsView extends GetView<SettingsController> {
  const SettingsView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        toolbarHeight: 70,
        centerTitle: true,
      ),
      body: Obx(() => SettingsList(
        sections: [
          SettingsSection(
            title: const Text('Camera Lens'),
            tiles: <SettingsTile>[
              SettingsTile.switchTile(
                onToggle: (value) {
                  controller.updateCameraLens(value);
                },
                initialValue: controller.cameraLens.value,
                leading: const Icon(Icons.camera),
                title: const Text('Front'),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Thresholds'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: const Text('Liveness Level'),
                value: Text(controller.selectedLivenessLevel.value == 0 ? 'Best Accuracy' : 'Light Weight'),
                leading: const Icon(Icons.person_pin_outlined),
                onPressed: (value) => _showDialog(
                  CupertinoPicker(
                    magnification: 1.22,
                    squeeze: 1.2,
                    useMagnifier: true,
                    itemExtent: 40.0,
                    scrollController: FixedExtentScrollController(
                      initialItem: controller.selectedLivenessLevel.value,
                    ),
                    onSelectedItemChanged: (int selectedItem) {
                      controller.updateLivenessLevel(selectedItem);
                    },
                    children: List<Widget>.generate(2, (int index) {
                      return Center(child: Text(index == 0 ? 'Best Accuracy' : 'Light Weight'));
                    }),
                  ),
                ),
              ),
              SettingsTile.navigation(
                title: const Text('Liveness Threshold'),
                value: Text(controller.livenessThreshold.value),
                leading: const Icon(Icons.person_pin_outlined),
                onPressed: (value) => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Liveness Threshold'),
                    content: TextField(
                      controller: TextEditingController(text: controller.livenessThreshold.value),
                      onChanged: (value) => {},
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.updateLivenessThreshold(controller.livenessThreshold.value);
                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
              SettingsTile.navigation(
                title: const Text('Identify Threshold'),
                leading: const Icon(Icons.person_search),
                value: Text(controller.identifyThreshold.value),
                onPressed: (value) => showDialog<String>(
                  context: context,
                  builder: (BuildContext context) => AlertDialog(
                    title: const Text('Identify Threshold'),
                    content: TextField(
                      controller: TextEditingController(text: controller.identifyThreshold.value),
                      onChanged: (value) => {},
                    ),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () => Navigator.pop(context, 'Cancel'),
                        child: const Text('Cancel'),
                      ),
                      TextButton(
                        onPressed: () {
                          controller.updateIdentifyThreshold(controller.identifyThreshold.value);
                          Navigator.pop(context, 'OK');
                        },
                        child: const Text('OK'),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          SettingsSection(
            title: const Text('Reset'),
            tiles: <SettingsTile>[
              SettingsTile.navigation(
                title: const Text('Restore default settings'),
                leading: const Icon(Icons.restore),
                onPressed: (value) => controller.restoreSettings(),
              ),
              SettingsTile.navigation(
                title: const Text('Clear all person'),
                leading: const Icon(Icons.clear_all),
                onPressed: (value) {
                  Get.find<HomeController>().deleteAllPerson();
                },
              ),
            ],
          ),
        ],
      )),
    );
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: Get.context!,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        color: CupertinoColors.systemBackground.resolveFrom(context),
        child: SafeArea(
          top: false,
          child: child,
        ),
      ),
    );
  }
}