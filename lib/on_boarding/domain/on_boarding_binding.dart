import 'package:get/get.dart';

import 'on_boarding_controller.dart';

class OnBoardingBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OnBordingController());
  }
}
