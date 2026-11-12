import 'package:get/get.dart';

import 'splash_controller.dart';

class SplashBindings extends Bindings {
  @override
  void dependencies() {
    // Use Get.put instead of lazyPut to create controller immediately
    // This ensures the controller is ready when navigating to splash
    Get.put(SplashController(), permanent: true);
  }
}
