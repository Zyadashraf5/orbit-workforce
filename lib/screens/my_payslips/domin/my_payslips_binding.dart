import 'package:get/get.dart';

import 'package:orbit_workforce/screens/my_payslips/domin/my_payslips_controller.dart';

class MyPayslipsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => MyPayslipsController());
  }
}
