import 'package:get/get.dart';
import 'package:orbit_workforce/screens/request_screen/domin/permission_controller.dart';

class PermissionBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PermissionController>(() => PermissionController());
  }
}
