import 'package:get/get.dart';
import 'package:orbit_workforce/lang/language_controller.dart';

import 'login_controller.dart';

class LoginBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LoginController());
    Get.lazyPut(() => LanguageController());
  }
}
