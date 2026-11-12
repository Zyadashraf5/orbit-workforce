import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:orbit_workforce/constant/app_constant.dart';
import 'package:orbit_workforce/constant/commenwidget.dart';
import 'package:orbit_workforce/model/time_off_model.dart';

class ProfileController extends GetxController {
  bool switchValue = true;
  GetStorage box = GetStorage();

  // إضافة المتغيرات الجديدة
  bool loadingLeaveBalance = false;
  List<TimeOffModel> leaveBalanceList = [];
  String errorMessage = '';

  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newpasswordController = TextEditingController();
  TextEditingController new2passwordController = TextEditingController();

  bool passwordVisible = false;
  bool newPasswordVisible = false;
  bool confirmPasswordVisible = false;
  bool isChangingPassword = false;
  Future<void> logout() async {
    if (kDebugMode) {
      print('🔄 [PROFILE] بدء تسجيل الخروج...');
    }

    // مسح جميع البيانات
    await box.erase();

    // Reset AppConstant client
    AppConstant.resetClient();

    if (kDebugMode) {
      print('✅ [PROFILE] تم مسح البيانات');
      print('🔄 [PROFILE] التوجه إلى InitialLoadingScreen');
    }

    // الذهاب لـ InitialLoadingScreen لإعادة جلب Databases
    Get.offAllNamed('/');

    mySnakBar(
      title: 'success'.tr,
      msg: 'logout_success'.tr,
      second: 2,
      color: Colors.green,
    );
  }

  // دالة لجلب رصيد الإجازات
  // دالة لجلب رصيد الإجازات
  // دالة لجلب رصيد الإجازات
  Future<void> getLeaveBalance() async {
    loadingLeaveBalance = true;
    leaveBalanceList.clear();
    errorMessage = '';
    update();

    try {
      // الحصول على sessionId
      final sessionId = AppConstant.client.sessionId?.id;
      if (sessionId == null || sessionId.isEmpty) {
        errorMessage = 'not_logged_in'.tr;
        if (kDebugMode) {
          print('❌ لا يوجد session ID');
        }
        return;
      }

      // الحصول على employee_code
      final employeeCode = box.read('emp_seq');
      if (employeeCode == null) {
        errorMessage = 'employee_code_not_found'.tr;
        if (kDebugMode) {
          print('❌ لا يوجد كود الموظف');
        }
        return;
      }

      // إعداد رأس الطلب
      Map<String, String> headers = {
        'Content-Type': 'application/json',
        'Cookie': 'session_id=$sessionId',
      };

      // إعداد body الطلب مع تضمين كود الموظف
      final body = jsonEncode({'employee_code': employeeCode});

      // بناء رابط API
      final apiUrl = '${AppConstant.baseUrl}/get/employee/timeoff';

      if (kDebugMode) {
        print('🔍 جاري جلب بيانات رصيد الإجازات: $apiUrl');
        print('🔑 Header: $headers');
        print('📦 Body: $body');
      }

      // إرسال الطلب باستخدام POST
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: body,
      );

      if (kDebugMode) {
        print('📝 استجابة API: ${response.statusCode}');
        print('📄 محتوى الاستجابة: ${response.body}');
      }

      if (response.statusCode == 200) {
        // تحليل البيانات
        final Map<String, dynamic> responseData = json.decode(response.body);

        // التعامل مع هيكل البيانات الجديد
        if (responseData['result'] != null &&
            responseData['result']['status'] == 'success') {
          // التحقق من وجود بيانات الإجازة
          if (responseData['result']['Time Off'] != null) {
            final List<dynamic> data = responseData['result']['Time Off'];

            // تحويل البيانات إلى قائمة من TimeOffModel
            leaveBalanceList = data
                .map((item) => TimeOffModel.fromJson(item))
                .toList();

            if (kDebugMode) {
              print('✅ تم جلب ${leaveBalanceList.length} رصيد إجازات');
            }
          } else {
            errorMessage = 'no_leave_balance_data_error'.tr;
            if (kDebugMode) {
              print('⚠️ لا توجد بيانات رصيد إجازات');
            }
          }
        } else if (responseData['status'] == true &&
            responseData['data'] != null) {
          // للتوافق مع الهيكل القديم إذا تم استخدامه
          final List<dynamic> data = responseData['data'];
          leaveBalanceList = data
              .map((item) => TimeOffModel.fromJson(item))
              .toList();
        } else {
          errorMessage = responseData['message'] ?? 'حدث خطأ غير معروف';
          if (kDebugMode) {
            print('❌ خطأ في البيانات: $errorMessage');
          }
        }
      } else {
        errorMessage = 'خطأ في الاتصال: ${response.statusCode}';
        if (kDebugMode) {
          print('❌ خطأ في الاستجابة: ${response.statusCode}');
        }
      }
    } catch (e) {
      errorMessage = 'حدث خطأ: $e';
      if (kDebugMode) {
        print('❌ استثناء: $e');
      }
    } finally {
      loadingLeaveBalance = false;
      update();
    }
  }

  // دالة تغيير كلمة المرور
  Future<void> changePassword() async {
    // التحقق من صحة البيانات المدخلة
    if (!_validatePasswordInputs()) {
      return;
    }

    isChangingPassword = true;
    update();

    try {
      // التأكد من وجود جلسة نشطة
      final sessionId = AppConstant.client.sessionId?.id;
      if (sessionId == null || sessionId.isEmpty) {
        mySnakBar(
          title: 'error'.tr,
          msg: 'login_to_system_error'.tr,
          second: 3,
          color: Colors.red,
        );
        return;
      }

      // الحصول على employee_id
      final employeeId = box.read('employee_id');
      if (employeeId == null) {
        mySnakBar(
          title: 'error'.tr,
          msg: 'employee_id_not_found_error'.tr,
          second: 3,
          color: Colors.red,
        );
        return;
      }

      final currentPass = currentPasswordController.text.trim();
      final newPass = newpasswordController.text.trim();

      // التأكد من صحة كلمة المرور الحالية عبر Odoo
      final List<dynamic> currentPassResponse = await AppConstant.client.callKw(
        {
          'model': 'hr.employee',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'domain': [
              ['id', '=', employeeId],
              ['pass_app', '=', currentPass],
            ],
            'fields': ['id'],
            'limit': 1,
          },
        },
      );

      if (kDebugMode) {
        print('� التحقق من كلمة المرور الحالية: $currentPassResponse');
      }

      if (currentPassResponse.isEmpty) {
        mySnakBar(
          title: 'error'.tr,
          msg: 'current_password_incorrect'.tr,
          second: 3,
          color: Colors.red,
        );
        return;
      }

      // تحديث حقل pass_app بكلمة المرور الجديدة
      final bool writeResult = await AppConstant.client.callKw({
        'model': 'hr.employee',
        'method': 'write',
        'args': [
          [employeeId],
          {'pass_app': newPass},
        ],
        'kwargs': {},
      });

      if (kDebugMode) {
        print('🛠️ نتيجة تحديث كلمة المرور: $writeResult');
      }

      if (writeResult) {
        mySnakBar(
          title: 'success'.tr,
          msg: 'password_update_success'.tr,
          second: 3,
          color: Colors.green,
        );

        currentPasswordController.clear();
        newpasswordController.clear();
        new2passwordController.clear();

        // لا حاجة لتسجيل الخروج، لكن يمكن إعادة تحميل البيانات إذا لزم
      } else {
        mySnakBar(
          title: 'error'.tr,
          msg: 'password_update_failed'.tr,
          second: 3,
          color: Colors.red,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ استثناء في تحديث كلمة المرور: $e');
      }
      mySnakBar(
        title: 'error'.tr,
        msg: '${'unexpected_error'.tr}: $e',
        second: 4,
        color: Colors.red,
      );
    } finally {
      isChangingPassword = false;
      update();
    }
  }

  // دالة التحقق من صحة البيانات المدخلة
  bool _validatePasswordInputs() {
    // التحقق من كلمة المرور الحالية
    if (currentPasswordController.text.isEmpty) {
      mySnakBar(
        title: 'warning'.tr,
        msg: 'please_enter_current_password'.tr,
        second: 3,
        color: Colors.orange,
      );
      return false;
    }

    // التحقق من كلمة المرور الجديدة
    if (newpasswordController.text.isEmpty) {
      mySnakBar(
        title: 'warning'.tr,
        msg: 'please_enter_new_password'.tr,
        second: 3,
        color: Colors.orange,
      );
      return false;
    }

    // التحقق من طول كلمة المرور الجديدة
    if (newpasswordController.text.length < 6) {
      mySnakBar(
        title: 'warning'.tr,
        msg: 'new_password_min_length'.tr,
        second: 3,
        color: Colors.orange,
      );
      return false;
    }

    // التحقق من تأكيد كلمة المرور
    if (new2passwordController.text.isEmpty) {
      mySnakBar(
        title: 'warning'.tr,
        msg: 'please_confirm_new_password'.tr,
        second: 3,
        color: Colors.orange,
      );
      return false;
    }

    // التحقق من تطابق كلمة المرور الجديدة مع التأكيد
    if (newpasswordController.text != new2passwordController.text) {
      mySnakBar(
        title: 'warning'.tr,
        msg: 'passwords_not_match'.tr,
        second: 3,
        color: Colors.orange,
      );
      return false;
    }

    // التحقق من أن كلمة المرور الجديدة مختلفة عن الحالية
    if (currentPasswordController.text == newpasswordController.text) {
      mySnakBar(
        title: 'warning'.tr,
        msg: 'new_password_must_different'.tr,
        second: 3,
        color: Colors.orange,
      );
      return false;
    }

    return true;
  }

  @override
  void onInit() {
    super.onInit();
    // جلب بيانات رصيد الإجازات عند تحميل الشاشة
    getLeaveBalance();
  }

  @override
  void onClose() {
    // تنظيف الـ controllers
    currentPasswordController.dispose();
    newpasswordController.dispose();
    new2passwordController.dispose();
    super.onClose();
  }
}
