import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get_storage/get_storage.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orbit_workforce/constant/app_constant.dart';
import 'package:orbit_workforce/lang/translation.dart';
import 'package:orbit_workforce/model/attendance_model.dart';
import 'package:orbit_workforce/model/history_model.dart';
import 'package:orbit_workforce/model/user_model.dart';
import 'package:orbit_workforce/model/work_location_model.dart';
import 'package:orbit_workforce/model/work_location_details_model.dart';
import 'package:http/http.dart' as http;
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';

class HomeController extends GetxController {
  bool loading = true; // يبدأ بـ true عشان يظهر loading لحد ما نجيب البيانات

  bool checkIn = false;
  Timer? timer;
  int numberOfHour = 9;
  UserModel? user;
  AttendanceModel? attendance;
  List<AttendanceModel> attendanceList = []; // قائمة بيانات الحضور
  RxInt inMinutes = 0.obs;
  RxInt inHour = 0.obs;
  RxInt inSecond = 0.obs;

  GetStorage box = GetStorage();

  double barstatus = 0;

  // متغيرات الخريطة
  GoogleMapController? mapController;
  Rx<LatLng?> currentLocation = Rx<LatLng?>(null);
  RxString selectedPunchState = 'Check In'.obs;
  RxBool isLoadingLocation = false.obs;

  String formattedDate = 'Loading...';
  String formattedTime = '--:--';
  List<OrbitHistoryModel> intelLinkHistoryList = [];
  String selectedFilter = 'ALL'; // فلتر الحالة: ALL, ATT, LATE, ABS, OVT
  DateTime selectedDate = DateTime.now(); // التاريخ المحدد للفلتر
  String selectedDateFilter = 'month'; // نوع فلتر التاريخ: day, month, year

  // Future<void> startTimer() async {
  //   Position position = await Geolocator.getCurrentPosition(
  //     locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
  //   );

  //   double distanceInMeters = Geolocator.distanceBetween(
  //     position.latitude,
  //     position.longitude,
  //     targetLat,
  //     targetLong,
  //   );

  //   if (distanceInMeters <= allowedDistance) {
  //     checkIn = !checkIn;

  //     if (checkIn) {
  //       DateTime checkInTime = DateTime.now();
  //       print("Check-in time: $checkInTime");

  //       const oneSec = Duration(seconds: 1);
  //       timer = Timer.periodic(oneSec, (Timer timer) {
  //         if (inHour.value <= numberOfHour) {
  //           inSecond++;
  //           barstatus =
  //               (inHour.value * 60 * 60 +
  //                   inMinutes.value * 60 +
  //                   inSecond.value) *
  //               100 /
  //               (numberOfHour * 60 * 60);

  //           if (inSecond.value == 60) {
  //             inMinutes++;
  //             inSecond.value = 0;
  //           }
  //           if (inMinutes.value == 60) {
  //             inHour++;
  //             inSecond.value = 0;
  //             inMinutes.value = 0;
  //           }
  //           update();
  //         } else {
  //           timer.cancel();
  //           update();
  //         }
  //       });
  //     } else {
  //       timer!.cancel();
  //       DateTime checkOutTime = DateTime.now();
  //       print("Check-out time: $checkOutTime");
  //     }
  //     update();
  //   } else {
  //     Get.snackbar(
  //       "خطأ",
  //       "انت خارج اطار العمل",
  //       snackPosition: SnackPosition.BOTTOM,
  //       backgroundColor: Colors.red,
  //       colorText: Colors.white,
  //       duration: Duration(seconds: 3),
  //     );
  //     print("You are outside the allowed area.");
  //   }
  // }

  Future<void> startTimer() async {
    print('\n========================================');
    print('⏰ [ATTENDANCE] بدء عملية الحضور/الانصراف');
    print('========================================');

    // Step 1: جلب جميع مواقع العمل للموظف
    print('📍 [STEP 1] جلب جميع مواقع العمل للموظف...');
    List<WorkLocationDetailsModel> employeeWorkLocations =
        await getCurrentEmployeeWorkLocations();

    if (employeeWorkLocations.isEmpty) {
      print('❌ [STEP 1] فشل جلب مواقع العمل');
      print('========================================\n');
      Get.snackbar(
        'warning'.tr,
        'work_location_not_registered'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }

    print('✅ [STEP 1] تم جلب ${employeeWorkLocations.length} موقع عمل');
    for (var location in employeeWorkLocations) {
      print('   🏢 ${location.name} (ID: ${location.id})');
      print('      📍 Lat: ${location.lat}, Long: ${location.long}');
      print('      📏 النطاق: ${location.range}م');
    }

    // Step 2: التحقق من صحة الإحداثيات لجميع المواقع
    print('🔍 [STEP 2] التحقق من صحة الإحداثيات...');
    List<WorkLocationDetailsModel> validLocations = [];
    for (var location in employeeWorkLocations) {
      if (location.lat != 0.0 || location.long != 0.0) {
        validLocations.add(location);
        print('   ✅ ${location.name}: إحداثيات صحيحة');
      } else {
        print('   ❌ ${location.name}: إحداثيات غير صحيحة (0.0, 0.0)');
      }
    }

    if (validLocations.isEmpty) {
      print('❌ [STEP 2] لا توجد مواقع بإحداثيات صحيحة');
      print('========================================\n');
      Get.snackbar(
        'warning'.tr,
        'no_coordinates_registered'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
      return;
    }
    print('✅ [STEP 2] ${validLocations.length} موقع بإحداثيات صحيحة');

    // Step 3: الحصول على الموقع الحالي للمستخدم
    print('📍 [STEP 3] الحصول على الموقع الحالي للمستخدم...');
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.high),
    );
    print('✅ [STEP 3] تم الحصول على الموقع الحالي');
    print('   📍 Lat الحالي: ${position.latitude}');
    print('   📍 Long الحالي: ${position.longitude}');

    // Step 4: حساب المسافة من جميع المواقع والعثور على أقرب موقع داخل النطاق
    print('📏 [STEP 4] حساب المسافة من جميع المواقع...');
    WorkLocationDetailsModel? nearestValidLocation;
    double minDistance = double.infinity;

    for (var location in validLocations) {
      double distanceInMeters = Geolocator.distanceBetween(
        position.latitude,
        position.longitude,
        location.lat,
        location.long,
      );

      print('   📍 ${location.name}:');
      print('      📏 المسافة: ${distanceInMeters.toStringAsFixed(1)}م');
      print('      📏 النطاق المسموح: ${location.range}م');
      print('      ✅ داخل النطاق: ${distanceInMeters <= location.range}');

      if (distanceInMeters <= location.range) {
        if (distanceInMeters < minDistance) {
          minDistance = distanceInMeters;
          nearestValidLocation = location;
        }
      }
    }

    if (nearestValidLocation == null) {
      print('❌ [STEP 4] المستخدم خارج نطاق جميع المواقع');
      print('   📊 أقرب مسافة: ${minDistance.toStringAsFixed(1)}م');
      print('========================================\n');

      // عرض رسالة تحتوي على معلومات جميع المواقع
      String locationsInfo = validLocations
          .map((loc) => '${loc.name} (${loc.range}م)')
          .join(', ');
      Get.snackbar(
        'error'.tr,
        "${'outside_work_location'.tr}\n${'available_locations'.tr}: $locationsInfo",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 5),
      );
      return;
    }

    print('✅ [STEP 4] المستخدم داخل نطاق موقع: ${nearestValidLocation.name}');
    print('   📏 المسافة: ${minDistance.toStringAsFixed(1)}م');

    print('✅ [STEP 4] المستخدم داخل النطاق المسموح - المتابعة');
    print('========================================');

    // Step 5: تغيير حالة الحضور
    print('🔄 [STEP 5] تغيير حالة الحضور...');
    checkIn = !checkIn;
    print('   ✅ الحالة الجديدة: ${checkIn ? "Check In" : "Check Out"}');

    // Step 6: إعداد بيانات الطلب
    print('📝 [STEP 6] إعداد بيانات الطلب...');
    final now = DateTime.now();
    final formattedDate = DateFormat('yyyy-MM-dd HH:mm:ss').format(now);
    final employeeCode = box.read('emp_seq');

    final payload = {
      'employee_code': '$employeeCode',
      'type': checkIn ? 'check_in' : 'check_out',
      'date': formattedDate,
    };

    print('   📋 بيانات الطلب:');
    print('      - Employee Code: $employeeCode');
    print('      - Type: ${checkIn ? "check_in" : "check_out"}');
    print('      - Date: $formattedDate');
    print('   📋 Payload كامل: $payload');

    // Step 7: إرسال طلب الحضور/الانصراف
    print('📡 [STEP 7] إرسال طلب الحضور/الانصراف إلى السيرفر...');
    print('   🌐 URL: ${AppConstant.baseUrl}/attendance/create');
    try {
      final response = await http.post(
        Uri.parse('${AppConstant.baseUrl}/attendance/create'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(payload),
      );

      print('📨 [STEP 7] تم استلام استجابة من السيرفر');
      print('   📊 Status Code: ${response.statusCode}');
      print('   📋 Response Body: ${response.body}');

      // Step 8: معالجة الاستجابة
      print('🔍 [STEP 8] معالجة استجابة السيرفر...');
      Map<String, dynamic>? data;
      dynamic decodedBody;

      try {
        decodedBody = jsonDecode(response.body);
        print('   ✅ تم تحويل الاستجابة إلى JSON');
        if (decodedBody is Map<String, dynamic>) {
          data = decodedBody;
          print('   📋 البيانات المحولة: $data');
        }
      } catch (decodeError) {
        print('   ❌ فشل في تحويل استجابة الحضور إلى JSON: $decodeError');
        print('   🔄 الاستجابة الأصلية: ${response.body}');
      }

      final dynamic resultSection = data != null ? data['result'] : null;
      final Map<String, dynamic>? resultMap =
          resultSection is Map<String, dynamic> ? resultSection : null;
      final String? status =
          resultMap?['status']?.toString() ?? (data?['status']?.toString());
      final String? serverMessage =
          resultMap?['message']?.toString() ?? data?['message']?.toString();

      print('   📊 Status: $status');
      if (serverMessage != null) {
        print('   📝 Message: $serverMessage');
      }

      if (response.statusCode == 200 && status == 'success') {
        print('✅ [STEP 8] نجحت عملية الحضور/الانصراف');
        print('========================================\n');
        Get.snackbar(
          'operation_completed'.tr,
          checkIn ? 'attendance_registered'.tr : 'leave_registered'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
        print('🔄 [STEP 9] تحديث بيانات الحضور...');
        getAttendanceByEmployeeId();
      } else {
        final errorMessage =
            serverMessage ??
            (resultMap?['error']?.toString() ??
                data?['error']?.toString() ??
                'استجابة غير معروفة من الخادم');
        print('❌ [STEP 8] فشلت عملية الحضور/الانصراف: $errorMessage');
        print('========================================\n');
        throw Exception("${'attendance_leave_failed'.tr}: $errorMessage");
      }
    } catch (e, stackTrace) {
      print('❌ [ERROR] خطأ في إرسال طلب الحضور/الانصراف: $e');
      print('   📋 Stack Trace: $stackTrace');
      print('========================================\n');
      Get.snackbar(
        'error'.tr,
        'failed_send_data_server'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    }

    // التايمر
    if (checkIn) {
      const oneSec = Duration(seconds: 1);
      timer = Timer.periodic(oneSec, (Timer timer) {
        if (inHour.value <= numberOfHour) {
          inSecond++;
          barstatus =
              (inHour.value * 3600 + inMinutes.value * 60 + inSecond.value) *
              100 /
              (numberOfHour * 3600);

          if (inSecond.value == 60) {
            inMinutes++;
            inSecond.value = 0;
          }
          if (inMinutes.value == 60) {
            inHour++;
            inSecond.value = 0;
            inMinutes.value = 0;
          }
          update();
        } else {
          timer.cancel();
          update();
        }
      });
    } else {
      timer?.cancel();
    }

    update();
  }

  Future<void> _initializeDateFormatting() async {
    await initializeDateFormatting('ar', null);
  }

  void _updateDateTime() async {
    await _initializeDateFormatting();

    DateTime now = DateTime.now();

    // الحصول على اللغة الحالية من TranslationService
    String languageCode =
        TranslationService.getCurrentLanguage(); // استخدم دالة getCurrentLanguage لجلب اللغة الحالية

    // تنسيق التاريخ والوقت بناءً على اللغة
    if (languageCode == 'ar') {
      formattedDate = DateFormat('EEEE dd MMMM - yyyy', 'ar').format(now);
      formattedTime = DateFormat('hh:mm a', 'ar').format(now);
    } else {
      formattedDate = DateFormat('EEEE dd MMMM - yyyy', 'en').format(now);
      formattedTime = DateFormat('hh:mm a', 'en').format(now);
    }

    update(); // تحديث واجهة المستخدم بعد التغيير
  }

  Future<void> getAttendanceByEmployeeId() async {
    final employeeId = box.read('employee_id');

    if (employeeId == null) {
      if (kDebugMode) {
        print('❌ لا يوجد معرف موظف محفوظ للحضور');
      }
      // مفيش employee_id - نوقف اللودينج ونخلي الحالة الافتراضية
      checkIn = false;
      loading = false;
      update();
      return;
    }

    // loading تبدأ true من البداية، مش محتاجين نغيرها هنا

    try {
      var response = await AppConstant.client.callKw({
        'model': 'hr.attendance',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['employee_id', '=', employeeId], // فلتر حسب الموظف
          ],
          'fields': [
            'id',
            'employee_id',
            'check_in',
            'check_out',
            'worked_hours',
            'overtime_hours',
            'validated_overtime_hours',
          ],
          'limit': 100,
          'order': 'create_date desc',
        },
      });

      if (kDebugMode) {
        print('📅 Attendance Response for Employee $employeeId: $response');
      }

      if (response.isNotEmpty) {
        // تنظيف القائمة الحالية
        attendanceList.clear();

        // تحويل البيانات لـ models
        for (var item in response) {
          attendanceList.add(AttendanceModel.fromJson(item));
        }

        // تحديث حالة الحضور بناءً على آخر سجل
        // إذا كان آخر سجل فيه check_in بدون check_out، يعني الموظف في العمل حالياً
        _updateCheckInStatusFromAttendance();

        if (kDebugMode) {
          print(
            '✅ تم تحميل ${attendanceList.length} سجل حضور للموظف $employeeId',
          );

          // طباعة إحصائيات الحضور
          print('📊 === إحصائيات الحضور ===');
          print('📅 عدد أيام الحضور: ${getAttendanceDays()}');
          print(
            '📍 حالة الحضور الحالية: ${checkIn ? "في العمل" : "خارج العمل"}',
          );

          print('📊 === نهاية إحصائيات الحضور ===');
        }
      } else {
        // لا توجد بيانات حضور - إعادة تعيين الحالة
        checkIn = false;
        if (kDebugMode) {
          print('⚠️ لا توجد بيانات حضور للموظف $employeeId');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل بيانات الحضور: $e');
      }
    } finally {
      loading = false;
      update();
    }
  }

  // Function لجلب البيانات الخاصة بموظف معين
  Future<void> getOrbitHistoryByEmployee() async {
    final employeeId = box.read('employee_id');

    if (employeeId == null) {
      if (kDebugMode) {
        print('❌ لا يوجد معرف موظف محفوظ');
      }
      return;
    }

    // لا نغير loading هنا - نخليها تتحكم فيها getAttendanceByEmployeeId فقط

    try {
      var response = await AppConstant.client.callKw({
        'model': 'intel.link.history',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['employee_id', '=', employeeId],
          ],
          'fields': [
            'id',
            'name',
            'code',
            'date',
            'day_name',
            'days',
            'hours',
            'employee_id',
          ],
          'limit': 100,
          'order': 'date desc',
        },
      });

      if (kDebugMode) {
        print('📊 Orbit Workforce History for Employee $employeeId: $response');
      }

      if (response.isNotEmpty) {
        intelLinkHistoryList.clear();

        for (var item in response) {
          intelLinkHistoryList.add(OrbitHistoryModel.fromJson(item));
        }

        if (kDebugMode) {
          print(
            '✅ تم تحميل ${intelLinkHistoryList.length} سجل للموظف $employeeId',
          );

          // طباعة الإحصائيات المحسوبة
          print('📊 === إحصائيات الشهر الحالي ===');
          print('🏢 أيام الحضور: ${getAttendanceDays()}');
          print(
            '⏰ إجمالي ساعات العمل: ${getTotalWorkedHours().toStringAsFixed(1)} ساعة',
          );
          print('⏰ أيام التأخير: ${getLateDays()}');
          print('❌ أيام الغياب: ${getAbsentDays()}');
          print('⏱️ ساعات إضافية: ${getOvertimeHours().toStringAsFixed(1)}');

          print('📊 === نهاية الإحصائيات ===');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل بيانات الموظف: $e');
      }
    } finally {
      // لا نغير loading هنا - نخليها تتحكم فيها getAttendanceByEmployeeId فقط
      update();
    }
  }

  /// تحديث حالة الحضور بناءً على آخر سجل في قائمة الحضور
  /// إذا كان آخر سجل فيه check_in بدون check_out، يعني الموظف في العمل حالياً
  void _updateCheckInStatusFromAttendance() {
    if (attendanceList.isEmpty) {
      checkIn = false;
      return;
    }

    // آخر سجل حضور (القائمة مرتبة تنازلياً بالتاريخ)
    final latestAttendance = attendanceList.first;

    // التحقق من وجود check_in وعدم وجود check_out
    // checkOut يكون فارغ أو 'false' إذا لم يسجل انصراف بعد
    final hasCheckIn =
        latestAttendance.checkIn.isNotEmpty &&
        latestAttendance.checkIn != 'false';
    final hasCheckOut =
        latestAttendance.checkOut.isNotEmpty &&
        latestAttendance.checkOut != 'false';

    // إذا سجل حضور ولم يسجل انصراف، يعني في العمل
    checkIn = hasCheckIn && !hasCheckOut;

    if (kDebugMode) {
      print('🔄 تحديث حالة الحضور:');
      print('   📋 آخر check_in: ${latestAttendance.checkIn}');
      print('   📋 آخر check_out: ${latestAttendance.checkOut}');
      print('   📋 hasCheckIn: $hasCheckIn');
      print('   📋 hasCheckOut: $hasCheckOut');
      print('   ✅ الحالة النهائية: ${checkIn ? "في العمل" : "خارج العمل"}');
    }
  }

  double getTotalWorkedHours() {
    double totalHours = attendanceList.fold(
      0.0,
      (sum, item) => sum + item.workedHours,
    );

    return totalHours;
  }

  // حساب عدد أيام الحضور من جدول hr.attendance
  int getAttendanceDays() {
    return attendanceList.length;
  }

  // حساب عدد أيام الحضور من Orbit Workforce History
  int getOrbitAttendanceDays() {
    return intelLinkHistoryList.where((item) => item.code == 'ATT').length;
  }

  // حساب عدد أيام التأخير
  int getLateDays() {
    return intelLinkHistoryList.where((item) => item.code == 'LATE').length;
  }

  // حساب عدد أيام الغياب
  int getAbsentDays() {
    return intelLinkHistoryList
        .where((item) => item.code == 'ABS')
        .fold(0, (sum, item) => sum + (item.day ?? 0));
  }

  // حساب عدد ساعات الوقت الإضافي (من جدول hr.attendance فقط)
  double getOvertimeHours() {
    // ساعات إضافية موجبة فقط من جدول hr.attendance
    double attendanceOvertime = 0.0;

    for (var item in attendanceList) {
      double itemOvertime = item.externalHours;
      if (itemOvertime > 0) {
        attendanceOvertime += itemOvertime;
      }
    }

    if (kDebugMode) {
      print(
        '💼 ساعات إضافية من الحضور: ${attendanceOvertime.toStringAsFixed(1)} (${attendanceOvertime >= 0 ? 'موجب' : 'سالب'})',
      );
      print('📊 عدد سجلات الحضور: ${attendanceList.length}');

      // طباعة تفاصيل كل سجل
      for (var item in attendanceList) {
        print(
          '📝 سجل ID: ${item.id}, ساعات إضافية: ${item.externalHours.toStringAsFixed(1)}',
        );
      }
    }

    // إرجاع الساعات الإضافية من المصدر الواحد فقط
    return attendanceOvertime;
  }

  // تغيير الفلتر
  void setFilter(String filter) {
    selectedFilter = filter;
    update();
  }

  // الحصول على القائمة المفلترة
  List<OrbitHistoryModel> getFilteredHistoryList() {
    List<OrbitHistoryModel> filteredList = intelLinkHistoryList;

    // فلتر حسب التاريخ
    filteredList = getDateFilteredList(filteredList);

    // فلتر حسب النوع
    if (selectedFilter != 'ALL') {
      filteredList = filteredList
          .where((item) => item.code == selectedFilter)
          .toList();
    }

    return filteredList;
  }

  // فلتر البيانات حسب التاريخ المحدد
  List<OrbitHistoryModel> getDateFilteredList(List<OrbitHistoryModel> list) {
    return list.where((item) {
      if (item.date == null) return false;

      DateTime itemDate = DateTime.parse(item.date!);

      switch (selectedDateFilter) {
        case 'day':
          return itemDate.year == selectedDate.year &&
              itemDate.month == selectedDate.month &&
              itemDate.day == selectedDate.day;
        case 'month':
          return itemDate.year == selectedDate.year &&
              itemDate.month == selectedDate.month;
        case 'year':
          return itemDate.year == selectedDate.year;
        default:
          return true;
      }
    }).toList();
  }

  // تغيير فلتر التاريخ
  void setDateFilter(String filter) {
    selectedDateFilter = filter;
    update();
  }

  // تغيير التاريخ المحدد
  void setSelectedDate(DateTime date) {
    selectedDate = date;
    update();
  }

  // الحصول على النص المعروض للتاريخ
  String getDateDisplayText() {
    List<String> monthKeys = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];

    switch (selectedDateFilter) {
      case 'day':
        return '${selectedDate.day} ${monthKeys[selectedDate.month - 1].tr} ${selectedDate.year}';
      case 'month':
        return '${monthKeys[selectedDate.month - 1].tr} ${selectedDate.year}';
      case 'year':
        return '${selectedDate.year}';
      default:
        return '${monthKeys[selectedDate.month - 1].tr} ${selectedDate.year}';
    }
  }

  // الحصول على اسم الشهر من التاريخ
  String getMonthName(String? dateString) {
    if (dateString == null) return 'not_specified'.tr;

    try {
      DateTime date = DateTime.parse(dateString);
      List<String> monthKeys = [
        'january',
        'february',
        'march',
        'april',
        'may',
        'june',
        'july',
        'august',
        'september',
        'october',
        'november',
        'december',
      ];
      return monthKeys[date.month - 1].tr;
    } catch (e) {
      return 'غير محدد';
    }
  }

  // الحصول على النص المعروض مع اسم الشهر
  String getFormattedDateText(String? dateString) {
    if (dateString == null) return 'not_specified'.tr;

    try {
      DateTime date = DateTime.parse(dateString);
      String monthName = getMonthName(dateString);
      return '$monthName ${date.year}';
    } catch (e) {
      return 'غير محدد';
    }
  }

  // الحصول على رقم اليوم من التاريخ
  String getDayFromDate(String? dateString) {
    if (dateString == null) return '01';

    try {
      DateTime date = DateTime.parse(dateString);
      return '${date.day}'.padLeft(2, '0');
    } catch (e) {
      return '01';
    }
  }

  // الحصول على قائمة الشهور والسنين المتاحة (جميع الإمكانيات)
  List<String> getAvailableMonthsAndYears() {
    Set<String> monthsAndYears = {};
    List<String> monthKeys = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];

    // إنشاء جميع الشهور من 2020 حتى السنة الحالية + سنة إضافية
    DateTime now = DateTime.now();
    int startYear = 2020;
    int endYear = now.year + 1;

    // إضافة جميع الشهور والسنين الممكنة
    for (int year = startYear; year <= endYear; year++) {
      for (int month = 1; month <= 12; month++) {
        String monthYear = '${monthKeys[month - 1].tr} $year';
        monthsAndYears.add(monthYear);
      }
    }

    List<String> sortedList = monthsAndYears.toList();

    // ترتيب تنازلي (الأحدث أولاً)
    sortedList.sort((a, b) {
      try {
        List<String> aParts = a.split(' ');
        List<String> bParts = b.split(' ');

        int aYear = int.parse(aParts[1]);
        int bYear = int.parse(bParts[1]);

        if (aYear != bYear) {
          return bYear.compareTo(aYear); // ترتيب تنازلي للسنة
        }

        // للحصول على رقم الشهر من النص المترجم
        int aMonth = -1;
        int bMonth = -1;

        for (int i = 0; i < monthKeys.length; i++) {
          if (monthKeys[i].tr == aParts[0]) aMonth = i + 1;
          if (monthKeys[i].tr == bParts[0]) bMonth = i + 1;
        }

        return bMonth.compareTo(aMonth); // ترتيب تنازلي للشهر
      } catch (e) {
        return 0;
      }
    });

    if (kDebugMode) {
      print('📅 جميع الشهور والسنين المتاحة: ${sortedList.length} خيار');
      print('� من ${sortedList.last} إلى ${sortedList.first}');
    }

    return sortedList;
  }

  // تحديد الشهر والسنة المختارة من النص
  void setSelectedMonthYear(String monthYearText) {
    List<String> monthKeys = [
      'january',
      'february',
      'march',
      'april',
      'may',
      'june',
      'july',
      'august',
      'september',
      'october',
      'november',
      'december',
    ];

    try {
      List<String> parts = monthYearText.split(' ');
      if (parts.length >= 2) {
        String monthName = parts[0];
        int year = int.parse(parts[1]);

        // البحث عن رقم الشهر من النص المترجم
        int month = -1;
        for (int i = 0; i < monthKeys.length; i++) {
          if (monthKeys[i].tr == monthName) {
            month = i + 1;
            break;
          }
        }

        if (month > 0) {
          selectedDate = DateTime(year, month, 1);
          selectedDateFilter = 'month';

          if (kDebugMode) {
            print('📅 تم تحديد التاريخ: $monthYearText');
            print('📅 selectedDate: $selectedDate');
            print('📅 selectedDateFilter: $selectedDateFilter');
            print('📅 الإحصائيات بعد التحديث:');
            print('   - الحضور: ${getFilteredAttendanceDays()}');
            print('   - التأخير: ${getFilteredLateDays()}');
            print('   - الغياب: ${getFilteredAbsentDays()}');
            print('   - الساعات الإضافية: ${getFilteredOvertimeHours()}');
            print(
              '   - عدد العناصر المفلترة: ${getFilteredHistoryList().length}',
            );
          }

          update();
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحديد التاريخ: $e');
      }
      // في حالة خطأ، استخدم التاريخ الحالي
    }
  } // حساب الإحصائيات المفلترة

  int getFilteredAttendanceDays() {
    return getDateFilteredList(
      intelLinkHistoryList,
    ).where((item) => item.code == 'ATT').length;
  }

  int getFilteredLateDays() {
    return getDateFilteredList(
      intelLinkHistoryList,
    ).where((item) => item.code == 'LATE').length;
  }

  int getFilteredAbsentDays() {
    return getDateFilteredList(intelLinkHistoryList)
        .where((item) => item.code == 'ABS')
        .fold(0, (sum, item) => sum + (item.day ?? 0));
  }

  double getFilteredOvertimeHours() {
    return getDateFilteredList(intelLinkHistoryList)
        .where((item) => item.code == 'OVT')
        .fold(0.0, (sum, item) => sum + (item.hours ?? 0.0));
  }

  double getFilteredTotalWorkedHours() {
    List<AttendanceModel> filteredAttendance = attendanceList.where((item) {
      if (item.checkIn.isEmpty) return false;

      DateTime itemDate = DateTime.parse(item.checkIn);

      switch (selectedDateFilter) {
        case 'day':
          return itemDate.year == selectedDate.year &&
              itemDate.month == selectedDate.month &&
              itemDate.day == selectedDate.day;
        case 'month':
          return itemDate.year == selectedDate.year &&
              itemDate.month == selectedDate.month;
        case 'year':
          return itemDate.year == selectedDate.year;
        default:
          return true;
      }
    }).toList();

    return filteredAttendance.fold(0.0, (sum, item) => sum + item.workedHours);
  }

  int getCurrentMonthAttendanceDays() {
    DateTime now = DateTime.now();
    return intelLinkHistoryList.where((item) {
      if (item.date == null) return false;
      DateTime itemDate = DateTime.parse(item.date!);
      return itemDate.year == now.year &&
          itemDate.month == now.month &&
          item.code == 'ATT';
    }).length;
  }

  // حساب أيام التأخير للشهر الحالي فقط
  int getCurrentMonthLateDays() {
    DateTime now = DateTime.now();
    return intelLinkHistoryList.where((item) {
      if (item.date == null) return false;
      DateTime itemDate = DateTime.parse(item.date!);
      return itemDate.year == now.year &&
          itemDate.month == now.month &&
          item.code == 'LATE';
    }).length;
  }

  // حساب أيام الغياب للشهر الحالي فقط
  int getCurrentMonthAbsentDays() {
    DateTime now = DateTime.now();
    return intelLinkHistoryList
        .where((item) {
          if (item.date == null) return false;
          DateTime itemDate = DateTime.parse(item.date!);
          return itemDate.year == now.year &&
              itemDate.month == now.month &&
              item.code == 'ABS';
        })
        .fold(0, (sum, item) => sum + (item.day ?? 0));
  }

  // حساب الساعات الإضافية للشهر الحالي فقط
  double getCurrentMonthOvertimeHours() {
    DateTime now = DateTime.now();

    // ساعات إضافية من Orbit Workforce History للشهر الحالي فقط
    double overtimeHours = 0.0;

    for (var item in intelLinkHistoryList) {
      if (item.date == null) continue;

      DateTime itemDate = DateTime.parse(item.date!);
      if (itemDate.year == now.year &&
          itemDate.month == now.month &&
          item.code == 'OVT') {
        overtimeHours += item.hours ?? 0.0;
      }
    }

    if (kDebugMode) {
      print(
        '📅 الساعات الإضافية للشهر الحالي (${now.month}/${now.year}): ${overtimeHours.toStringAsFixed(1)} ساعة من Orbit Workforce History',
      );
      print(
        '📊 عدد سجلات OVT للشهر الحالي: ${intelLinkHistoryList.where((item) => item.date != null && DateTime.parse(item.date!).year == now.year && DateTime.parse(item.date!).month == now.month && item.code == 'OVT').length}',
      );
    }

    return overtimeHours;
  }

  // حساب ساعات الإذن للشهر الحالي فقط
  double getCurrentMonthPermissionHours() {
    DateTime now = DateTime.now();
    double permissionHours = 0.0;

    for (var item in intelLinkHistoryList) {
      if (item.date == null) continue;

      DateTime itemDate = DateTime.parse(item.date!);
      if (itemDate.year == now.year &&
          itemDate.month == now.month &&
          item.code == 'PERM') {
        permissionHours += item.hours ?? 0.0;
      }
    }

    if (kDebugMode) {
      print(
        '📅 ساعات الإذن للشهر الحالي (${now.month}/${now.year}): ${permissionHours.toStringAsFixed(1)} ساعة',
      );
      print(
        '📊 عدد سجلات PERM للشهر الحالي: ${intelLinkHistoryList.where((item) => item.date != null && DateTime.parse(item.date!).year == now.year && DateTime.parse(item.date!).month == now.month && item.code == 'PERM').length}',
      );
    }

    return permissionHours;
  }

  // حساب ساعات الإذن المفلترة
  double getFilteredPermissionHours() {
    return getDateFilteredList(intelLinkHistoryList)
        .where((item) => item.code == 'PERM')
        .fold(0.0, (sum, item) => sum + (item.hours ?? 0.0));
  }

  // @override
  @override
  void onInit() {
    // إعادة تحميل بيانات المستخدم من GetStorage عند كل فتح للشاشة
    _loadUserData();
    _updateDateTime();
    // تحميل بيانات المستخدم من local storage إذا لم تكن موجودة
    getOrbitHistoryByEmployee();
    getAttendanceByEmployeeId(); // جلب بيانات الحضور
    getCurrentLocation(); // تحديد الموقع عند بدء التطبيق
    getWorkLocations(); // جلب مواقع العمل
    super.onInit();
  }

  // دالة لإعادة تحميل بيانات المستخدم من GetStorage
  void _loadUserData() {
    try {
      final userData = box.read('user');
      if (userData != null) {
        user = UserModel.fromJson(userData);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل بيانات المستخدم: $e');
      }
      user = null;
    }
  }

  @override
  void onClose() {
    if (timer != null) {
      timer!.cancel();
    }
    super.onClose();
  }

  // دالة للحصول على الموقع الحالي
  Future<void> getCurrentLocation() async {
    try {
      isLoadingLocation.value = true;

      // التحقق من صلاحيات الموقع أولاً (مهم لـ iOS)
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Get.snackbar(
            'error'.tr,
            'location_permission_required'.tr,
            backgroundColor: Colors.red,
            colorText: Colors.white,
          );
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Get.snackbar(
          'error'.tr,
          'enable_location_permission'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoadingLocation.value = false;
        return;
      }

      // التحقق من أن خدمة الموقع مفعلة (بعد التحقق من الصلاحيات)
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Get.snackbar(
          'error'.tr,
          'location_service_disabled'.tr,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        isLoadingLocation.value = false;
        return;
      }

      // الحصول على الموقع الحالي
      // إزالة timeLimit لأنه قد يسبب مشاكل في iOS
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      currentLocation.value = LatLng(position.latitude, position.longitude);

      // تحديث الخريطة إذا كانت جاهزة (بدون await لتجنب المشاكل)
      if (mapController != null && currentLocation.value != null) {
        mapController!
            .animateCamera(
              CameraUpdate.newLatLngZoom(currentLocation.value!, 16.0),
            )
            .catchError((error) {
              if (kDebugMode) {
                print('⚠️ خطأ في تحديث الخريطة: $error');
              }
            });
      }

      if (kDebugMode) {
        print(
          '✅ تم الحصول على الموقع: ${position.latitude}, ${position.longitude}',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في الحصول على الموقع: $e');
      }
      Get.snackbar(
        'error'.tr,
        "${'location_error'.tr}: ${e.toString()}",
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  // دالة للتحقق من صحة عملية الحضور/الانصراف
  bool validatePunchAction(String action, bool currentCheckInStatus) {
    if (action == 'Check In' && currentCheckInStatus) {
      Get.snackbar(
        'warning'.tr,
        'already_logged_in'.tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    if (action == 'Check Out' && !currentCheckInStatus) {
      Get.snackbar(
        'warning'.tr,
        'must_login_first'.tr,
        backgroundColor: Colors.orange,
        colorText: Colors.white,
      );
      return false;
    }

    return true;
  }

  // دالة تحديث حالة الـ dropdown حسب حالة الموظف
  void updatePunchState(bool checkInStatus) {
    selectedPunchState.value = checkInStatus ? 'Check Out' : 'Check In';
  }

  // دوال مواقع العمل
  List<WorkLocationModel> workLocationsList = [];
  List<WorkLocationDetailsModel> workLocationDetailsList = [];
  bool loadingWorkLocations = false;

  // دالة لجلب أسماء مواقع العمل
  Future<void> getWorkLocations() async {
    loadingWorkLocations = true;
    update();

    try {
      var response = await AppConstant.client.callKw({
        'model': 'hr.work.location',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'fields': ['id', 'name'],
          'order': 'name asc',
        },
      });

      if (kDebugMode) {
        print('📍 Work Locations Response: $response');
      }

      if (response.isNotEmpty) {
        workLocationsList.clear();

        for (var item in response) {
          workLocationsList.add(WorkLocationModel.fromJson(item));
        }

        if (kDebugMode) {
          print('✅ تم تحميل ${workLocationsList.length} موقع عمل');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ لا توجد مواقع عمل متاحة');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل مواقع العمل: $e');
      }
    } finally {
      loadingWorkLocations = false;
      update();
    }
  }

  // دالة لجلب تفاصيل موقع عمل بالاسم
  Future<WorkLocationDetailsModel?> getWorkLocationDetailsByName(
    String locationName,
  ) async {
    try {
      var response = await AppConstant.client.callKw({
        'model': 'hr.work.location',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['name', '=', locationName],
          ],
          'fields': ['id', 'name', 'address_id', 'lat', 'long', 'range'],
          'limit': 1,
        },
      });

      if (kDebugMode) {
        print('📍 Work Location Details Response for $locationName: $response');
      }

      if (response.isNotEmpty) {
        var locationDetails = WorkLocationDetailsModel.fromJson(response[0]);

        if (kDebugMode) {
          print('✅ تم تحميل تفاصيل موقع: $locationName');
          print('📍 العنوان: ${locationDetails.addressName}');
          print(
            '📍 الإحداثيات: ${locationDetails.lat}, ${locationDetails.long}',
          );
          print('📍 النطاق: ${locationDetails.range}م');
        }

        return locationDetails;
      } else {
        if (kDebugMode) {
          print('⚠️ لم يتم العثور على تفاصيل الموقع: $locationName');
        }
        return null;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل تفاصيل الموقع $locationName: $e');
      }
      return null;
    }
  }

  Future<WorkLocationDetailsModel?> getWorkLocationDetailsById(int id) async {
    print('🔍 [GET_LOCATION_BY_ID] بدء جلب بيانات الموقع بالـ ID: $id');
    try {
      print('📡 [GET_LOCATION_BY_ID] إرسال طلب إلى Odoo...');
      var response = await AppConstant.client.callKw({
        'model': 'hr.work.location',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', '=', id],
          ],
          'fields': ['id', 'name', 'address_id', 'lat', 'long', 'range'],
          'limit': 1,
        },
      });

      print('📨 [GET_LOCATION_BY_ID] استجابة من Odoo: $response');

      if (response.isNotEmpty) {
        print('✅ [GET_LOCATION_BY_ID] تم استلام بيانات الموقع');
        var locationData = response[0];
        print('   📋 البيانات المستلمة:');
        print('      - ID: ${locationData['id']}');
        print('      - Name: ${locationData['name']}');
        print('      - Lat: ${locationData['lat']}');
        print('      - Long: ${locationData['long']}');
        print('      - Range: ${locationData['range']}');

        var locationDetails = WorkLocationDetailsModel.fromJson(locationData);
        print(
          '✅ [GET_LOCATION_BY_ID] تم تحويل البيانات إلى WorkLocationDetailsModel',
        );
        print('   📍 Lat النهائي: ${locationDetails.lat}');
        print('   📍 Long النهائي: ${locationDetails.long}');
        return locationDetails;
      }

      print(
        '⚠️ [GET_LOCATION_BY_ID] لم يتم العثور على تفاصيل الموقع بالمعرّف: $id',
      );
      return null;
    } catch (e, stackTrace) {
      print('❌ [GET_LOCATION_BY_ID] خطأ في تحميل تفاصيل الموقع $id: $e');
      print('   📋 Stack Trace: $stackTrace');
      return null;
    }
  }

  // دالة جديدة لجلب جميع مواقع العمل دفعة واحدة (أسرع وأكثر كفاءة)
  Future<List<WorkLocationDetailsModel>> getWorkLocationsDetailsByIds(
    List<int> locationIds,
  ) async {
    print(
      '🔍 [GET_LOCATIONS_BY_IDS] بدء جلب بيانات المواقع بالـ IDs: $locationIds',
    );
    try {
      print(
        '📡 [GET_LOCATIONS_BY_IDS] إرسال طلب إلى Odoo لجميع المواقع دفعة واحدة...',
      );

      var response = await AppConstant.client.callKw({
        'model': 'hr.work.location',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'domain': [
            ['id', 'in', locationIds], // جلب جميع المواقع دفعة واحدة
          ],
          'fields': ['id', 'name', 'address_id', 'lat', 'long', 'range'],
        },
      });

      print('📨 [GET_LOCATIONS_BY_IDS] استجابة من Odoo: $response');
      print('   📊 عدد المواقع المستلمة: ${response.length}');

      List<WorkLocationDetailsModel> locations = [];

      for (var locationData in response) {
        print('   📋 معالجة موقع ID: ${locationData['id']}');
        print('      - Name: ${locationData['name']}');
        print('      - Lat: ${locationData['lat']}');
        print('      - Long: ${locationData['long']}');
        print('      - Range: ${locationData['range']}');

        var locationDetails = WorkLocationDetailsModel.fromJson(locationData);
        locations.add(locationDetails);

        // إضافة للقائمة المحلية إذا لم يكن موجوداً
        final alreadyCached = findWorkLocationById(locationDetails.id);
        if (alreadyCached == null) {
          workLocationDetailsList.add(locationDetails);
          print('      ✅ تم إضافة الموقع للقائمة المحلية');
        } else {
          print('      ℹ️ الموقع موجود بالفعل في القائمة المحلية');
        }
      }

      print('✅ [GET_LOCATIONS_BY_IDS] تم جلب ${locations.length} موقع بنجاح');
      return locations;
    } catch (e, stackTrace) {
      print('❌ [GET_LOCATIONS_BY_IDS] خطأ في جلب المواقع: $e');
      print('   📋 Stack Trace: $stackTrace');
      return [];
    }
  }

  // دالة لجلب جميع تفاصيل مواقع العمل
  Future<void> getAllWorkLocationDetails() async {
    if (workLocationsList.isEmpty) {
      await getWorkLocations();
    }

    workLocationDetailsList.clear();

    for (var location in workLocationsList) {
      var details = await getWorkLocationDetailsByName(location.name);
      if (details != null) {
        workLocationDetailsList.add(details);
      }
    }

    if (kDebugMode) {
      print('✅ تم تحميل تفاصيل ${workLocationDetailsList.length} موقع عمل');
    }

    update();
  }

  // دالة للبحث عن موقع عمل بالاسم من القائمة المحلية
  WorkLocationDetailsModel? findWorkLocationByName(String locationName) {
    try {
      return workLocationDetailsList.firstWhere(
        (location) => location.name.toLowerCase() == locationName.toLowerCase(),
      );
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ لم يتم العثور على الموقع في القائمة المحلية: $locationName');
      }
      return null;
    }
  }

  WorkLocationDetailsModel? findWorkLocationById(int id) {
    try {
      return workLocationDetailsList.firstWhere(
        (location) => location.id == id,
      );
    } catch (e) {
      if (kDebugMode) {
        print('⚠️ لم يتم العثور على الموقع في القائمة المحلية بالمعرّف: $id');
      }
      return null;
    }
  }

  // دالة لجلب جميع مواقع العمل للموظف الحالي (دعم مواقع متعددة)
  Future<List<WorkLocationDetailsModel>>
  getCurrentEmployeeWorkLocations() async {
    print('\n========================================');
    print('📍 [ATTENDANCE] بدء جلب مواقع العمل للموظف');
    print('========================================');

    try {
      // Step 1: جلب work_location_ids من التخزين
      final storedValue = box.read('work_location_ids');
      print('🏢 [STEP 1] Work Location ID من التخزين: $storedValue');
      print('   📋 نوع البيانات: ${storedValue.runtimeType}');

      if (storedValue == null || storedValue == false) {
        print('⚠️ [STEP 1] لا يوجد موقع عمل مسجل للموظف');
        print('========================================\n');
        return [];
      }

      // Step 2: استخراج قائمة الـ IDs من القيمة المخزنة
      List<int> locationIds = [];

      if (storedValue is int) {
        locationIds = [storedValue];
        print('✅ [STEP 2] تم استخراج ID واحد: $locationIds');
      } else if (storedValue is List) {
        print(
          '📋 [STEP 2] القيمة المخزنة هي قائمة، عدد العناصر: ${storedValue.length}',
        );
        print('   📋 محتوى القائمة: $storedValue');

        if (storedValue.isEmpty) {
          print('⚠️ [STEP 2] قائمة مواقع العمل فارغة');
          print('========================================\n');
          return [];
        }

        // استخراج جميع الـ IDs من القائمة
        for (var item in storedValue) {
          if (item is int) {
            locationIds.add(item);
            print('   ✅ [STEP 2] تم إضافة ID: $item');
          } else if (item is List && item.isNotEmpty && item[0] is int) {
            locationIds.add(item[0] as int);
            print('   ✅ [STEP 2] تم استخراج ID من قائمة فرعية: ${item[0]}');
          }
        }

        print('📋 [STEP 2] قائمة الـ IDs المستخرجة: $locationIds');
      } else {
        print('❌ [STEP 2] نوع بيانات غير متوقع: ${storedValue.runtimeType}');
        print('========================================\n');
        return [];
      }

      if (locationIds.isEmpty) {
        print('❌ [STEP 2] لم يتم استخراج أي IDs من القيمة المخزنة');
        print('========================================\n');
        return [];
      }

      // Step 3: البحث في القائمة المحلية أولاً
      print('🔍 [STEP 3] البحث في القائمة المحلية...');
      List<WorkLocationDetailsModel> cachedLocations = [];
      List<int> missingIds = [];

      for (var id in locationIds) {
        final cached = findWorkLocationById(id);
        if (cached != null) {
          cachedLocations.add(cached);
          print('   ✅ [STEP 3] تم العثور على الموقع $id في القائمة المحلية');
        } else {
          missingIds.add(id);
          print('   ⚠️ [STEP 3] الموقع $id غير موجود في القائمة المحلية');
        }
      }

      print('📊 [STEP 3] المواقع الموجودة محلياً: ${cachedLocations.length}');
      print('📊 [STEP 3] المواقع المفقودة: ${missingIds.length}');

      // Step 4: جلب المواقع المفقودة من السيرفر دفعة واحدة (أسرع)
      if (missingIds.isNotEmpty) {
        print(
          '🌐 [STEP 4] جلب ${missingIds.length} موقع من السيرفر دفعة واحدة...',
        );
        final serverLocations = await getWorkLocationsDetailsByIds(missingIds);
        cachedLocations.addAll(serverLocations);
        print('✅ [STEP 4] تم جلب ${serverLocations.length} موقع من السيرفر');
      }

      // Step 5: عرض جميع المواقع
      print('📋 [STEP 5] ملخص جميع مواقع العمل:');
      for (var location in cachedLocations) {
        print('   🏢 ID: ${location.id} - ${location.name}');
        print('      📍 Lat: ${location.lat}, Long: ${location.long}');
        print('      📏 النطاق: ${location.range}م');
      }

      print('✅ [STEP 5] إجمالي المواقع: ${cachedLocations.length}');
      print('========================================\n');
      return cachedLocations;
    } catch (e, stackTrace) {
      print('❌ [ERROR] خطأ في جلب مواقع العمل للموظف: $e');
      print('   📋 Stack Trace: $stackTrace');
      print('========================================\n');
      return [];
    }
  }

  // دالة قديمة للتوافق مع الكود القديم (ترجع أول موقع فقط)
  @Deprecated('Use getCurrentEmployeeWorkLocations() instead')
  Future<WorkLocationDetailsModel?> getCurrentEmployeeWorkLocation() async {
    final locations = await getCurrentEmployeeWorkLocations();
    return locations.isNotEmpty ? locations.first : null;
  }

  // دالة لتحديد عرض الاسم ليكون كلمتين فقط
  String getShortName(String fullName) {
    if (fullName.isEmpty) return 'user'.tr;

    List<String> nameParts = fullName.trim().split(' ');
    if (nameParts.length <= 2) {
      return fullName;
    } else {
      // أخذ الكلمة الأولى والأخيرة فقط
      return '${nameParts.first} ${nameParts.last}';
    }
  }

  // دوال جديدة لفلتر التاريخ الجديد
  void setSelectedYear(int year) {
    selectedDate = DateTime(year, selectedDate.month, 1);
    update();
  }

  void setSelectedYearAndMonth(int year, int month) {
    selectedDate = DateTime(year, month, 1);
    selectedDateFilter = 'month';

    if (kDebugMode) {
      print('📅 تم تحديد التاريخ: $year/$month');
      print('📅 selectedDate: $selectedDate');
      print('📅 selectedDateFilter: $selectedDateFilter');
      print('📅 الإحصائيات بعد التحديث:');
      print('   - الحضور: ${getFilteredAttendanceDays()}');
      print('   - التأخير: ${getFilteredLateDays()}');
      print('   - الغياب: ${getFilteredAbsentDays()}');
      print('   - الساعات الإضافية: ${getFilteredOvertimeHours()}');
      print('   - ساعات الإذن: ${getFilteredPermissionHours()}');
      print('   - عدد العناصر المفلترة: ${getFilteredHistoryList().length}');
    }

    update();
  }
}
