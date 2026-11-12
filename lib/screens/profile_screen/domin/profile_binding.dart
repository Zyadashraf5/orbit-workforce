import 'package:get/get.dart';

import 'package:orbit_workforce/screens/profile_screen/domin/profile_controller.dart';

class ProfileBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ProfileController());
  }
}
