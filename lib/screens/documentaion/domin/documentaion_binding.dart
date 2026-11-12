import 'package:get/get.dart';
import 'package:orbit_workforce/screens/home_screen/domin/home_controller.dart';

class DocumentaionBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => HomeController());
  }
}
