import 'package:get/get.dart';
import 'package:orbit_workforce/screens/request_screen/domin/request_controller.dart';

class RequestBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => RequestController());
  }
}
