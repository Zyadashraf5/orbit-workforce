import 'package:flutter/material.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';

class OnBordingController extends GetxController {
  late double height;
  late double width;
  late PageController controller;

  @override
  void onInit() {
    super.onInit();
    controller = PageController();
  }

  @override
  void onClose() {
    controller.dispose();
    super.onClose();
  }
}
