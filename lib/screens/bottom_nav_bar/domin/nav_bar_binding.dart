import 'package:get/get.dart';
import 'package:orbit_workforce/screens/bottom_nav_bar/domin/nav_bar_controller.dart';

class NavBarBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => NavBarController());
  }
}
