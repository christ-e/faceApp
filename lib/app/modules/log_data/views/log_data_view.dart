import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../controllers/log_data_controller.dart';

class LogDataView extends GetView<LogDataController> {
  const LogDataView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('LogDataView'),
        centerTitle: true,
      ),
      body: const Center(
        child: Text(
          'LogDataView is working',
          style: TextStyle(fontSize: 20),
        ),
      ),
    );
  }
}
