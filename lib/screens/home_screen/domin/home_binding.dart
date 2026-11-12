import 'package:get/get.dart';
import 'package:orbit_workforce/screens/home_screen/domin/home_controller.dart';

class HomeBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
