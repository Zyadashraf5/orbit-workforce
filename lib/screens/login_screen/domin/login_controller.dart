import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../constant/app_constant.dart';
import '../../../constant/commenwidget.dart';
import '../../../model/user_model.dart';
import '../../../routes/app_pages.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  bool loading = false;
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  bool passwordVisible = false;
  GetStorage box = GetStorage();

  Future<void> loginToOdoo() async {
    if (emailController.text.isEmpty) {
      mySnakBar(
        title: 'error'.tr,
        msg: 'enter_username'.tr,
        second: 3,
        color: Colors.red,
      );
      return;
    }

    if (passwordController.text.isEmpty) {
      mySnakBar(
        title: 'error'.tr,
        msg: 'enter_password'.tr,
        second: 3,
        color: Colors.red,
      );
      return;
    }

    loading = true;
    update();

    try {
      // البحث عن الموظف في hr.employee بناءً على email و password
      List employeeResponse = await AppConstant.client.callKw({
        'model': 'hr.employee',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['email_app', '=', emailController.text.trim()],
            ['pass_app', '=', passwordController.text.trim()],
          ],

          'fields': [
            'id',
            'name',
            'job_title',
            'work_email',
            'work_phone',
            'emp_seq',
            'work_location_ids',
          ],

          'limit': 1,
        },
      });

      if (kDebugMode) {
        print('Employee Response: $employeeResponse');
        print('📋 === تفاصيل كاملة للاستجابة ===');
        if (employeeResponse.isNotEmpty) {
          var employeeData = employeeResponse[0];
          print('🔍 Raw employee data: $employeeData');
          employeeData.forEach((key, value) {
            print('🔑 $key: $value (${value.runtimeType})');
          });
          print('📋 === نهاية التفاصيل ===');
        }
      }

      if (employeeResponse.isEmpty) {
        // لم يتم العثور على موظف بهذه البيانات
        mySnakBar(
          title: 'error'.tr,
          msg: 'employee_data_incorrect'.tr,
          second: 3,
          color: Colors.red,
        );
      } else {
        var employeeData = employeeResponse[0];

        // طباعة البيانات المستلمة للتحقق
        if (kDebugMode) {
          print('📝 Employee Data Received: $employeeData');
          print('🏢 Work Location ID: ${employeeData['work_location_ids']}');
        }

        UserModel employeeUser = UserModel(
          id: employeeData['id'],
          name: employeeData['name'],
          email: employeeData['work_email'],
          jobTitle: employeeData['job_title'],
          phone: employeeData['work_phone'],
          empSeq: employeeData['emp_seq'],
          workLocationId: employeeData['work_location_ids'],
        );
        await storeEmployeeData(employeeUser);

        // Save login credentials for auto-login
        await box.write('app_email', emailController.text.trim());
        await box.write('app_password', passwordController.text.trim());

        if (kDebugMode) {
          print('🔑 تم حفظ بيانات تسجيل الدخول للـ auto-login');
          print('   - app_email: ${emailController.text.trim()}');
        }
        // الانتقال للصفحة الرئيسية
        Get.offAllNamed(Routes.navbar);

        mySnakBar(
          title: 'success'.tr,
          msg: 'employee_login_success'.tr,
          second: 3,
          color: Colors.green,
        );
      }
    } catch (e) {
      mySnakBar(
        title: 'error'.tr,
        msg: 'server_error_or_incorrect_data'.tr,
        second: 3,
        color: Colors.red,
      );

      if (kDebugMode) {
        print('Login error: $e');
      }
    }

    loading = false;
    update();
  }

  Future<void> storeEmployeeData(UserModel employeeData) async {
    await box.write('employee_id', employeeData.id);
    await box.write('employee_name', employeeData.name);
    await box.write('work_email', employeeData.email);
    await box.write('job_title', employeeData.jobTitle);
    await box.write('work_phone', employeeData.phone);
    await box.write('emp_seq', employeeData.empSeq);
    await box.write('work_location_ids', employeeData.workLocationId);
    final primaryWorkLocationId = employeeData.workLocationIdNumber;
    if (primaryWorkLocationId != null) {
      await box.write('work_location_id', primaryWorkLocationId);
      await box.write('work_location_primary_id', primaryWorkLocationId);
    }

    // طباعة البيانات المحفوظة للتحقق
    if (kDebugMode) {
      print('💾 === بيانات الموظف المحفوظة ===');
      print('🆔 Employee ID: ${employeeData.id}');
      print('👤 Name: ${employeeData.name}');
      print('📧 Email: ${employeeData.email}');
      print('💼 Job Title: ${employeeData.jobTitle}');
      print('📞 Phone: ${employeeData.phone}');
      print('🔢 Employee Sequence: ${employeeData.empSeq}');
      print('🏢 Work Location ID: ${employeeData.workLocationId}');
      print('🏢 Work Location Name: ${employeeData.workLocationName}');
      print('💾 === نهاية البيانات المحفوظة ===');
    }
  }

  /// وظيفة logout - مسح جميع البيانات من local storage والانتقال إلى splash
  Future<void> logout() async {
    try {
      if (kDebugMode) {
        print('🔄 بدء عملية تسجيل الخروج...');
      }

      // Clear all stored data
      await box.erase();

      // Reset AppConstant client
      AppConstant.resetClient();

      if (kDebugMode) {
        print('✅ تم مسح جميع البيانات');
        print('🔄 التوجه إلى InitialLoadingScreen لإعادة جلب Databases');
      }

      // Navigate to InitialLoadingScreen (home route '/')
      // This will trigger fetching databases again
      Get.offAllNamed('/');

      if (kDebugMode) {
        print('🔄 تم تسجيل الخروج بنجاح');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تسجيل الخروج: $e');
      }

      // Even if there's an error, still navigate to initial loading
      Get.offAllNamed('/');
    }
  }

  /// الحصول على بيانات الموظف المحفوظة
  // Future<UserModel?> getStoredEmployeeData() async {
  //   int? employeeId = box.read("employee_id");
  //   String? employeeName = box.read("employee_name");
  //   String? employeeEmail = box.read("employee_email");
  //   String? jobTitle = box.read("job_title");
  //   String? workPhone = box.read("work_phone");

  //   return UserModel(
  //     id: employeeId,
  //     name: employeeName,
  //     email: employeeEmail,
  //     jobTitle: jobTitle,
  //     workemail: employeeEmail,
  //     phone: workPhone ?? '',
  //   );
  // }
}
