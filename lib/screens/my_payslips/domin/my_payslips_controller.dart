import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:orbit_workforce/constant/app_constant.dart';
import 'package:orbit_workforce/model/payslip_model.dart';
import 'package:orbit_workforce/model/payslip_run_model.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class MyPayslipsController extends GetxController {
  bool loading = false;
  bool batchesLoading = false;
  List<PayslipModel> payslipsList = [];
  List<PayslipRunModel> payslipRunList = [];
  List<PayslipRunModel> filteredPayslipRunList = [];
  final box = GetStorage();

  // متغيرات الفلتر
  String? selectedMonth;
  String? selectedYear;
  String? selectedBatchName; // اسم الدفعة المختارة
  bool isFilterActive = false;

  // جلب كشوف المرتبات للموظف (بدون فلتر - جميع البيانات)
  Future<void> getPayslipsByEmployeeId() async {
    print('\n========================================');
    print('💰 [GET_PAYSLIPS] بدء جلب جميع كشوف المرتبات (بدون فلتر)');
    print('========================================');

    final empSeq = box.read('emp_seq');

    if (empSeq == null || empSeq.toString().isEmpty) {
      print('❌ [GET_PAYSLIPS] لا يوجد رقم موظف محفوظ للكشوف');
      print('========================================\n');
      return;
    }

    print('👤 [GET_PAYSLIPS] Employee Sequence: $empSeq');
    print('🔍 [GET_PAYSLIPS] جلب جميع الكشوف بدون فلتر...');

    loading = true;
    update();

    try {
      print('📡 [GET_PAYSLIPS] إرسال طلب إلى Odoo...');
      print('   🔍 Domain: emp_seq = $empSeq (بدون فلتر دفعة أو حالة)');
      print(
        '   📋 Fields: id, emp_seq, employee_id, payslip_run_id, basic_wage, gross_wage, net_wage, state',
      );
      print('   📊 Limit: 100 (جميع الكشوف)');

      var response = await AppConstant.client.callKw({
        'model': 'hr.payslip',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['emp_seq', '=', empSeq],
            // تم إزالة فلتر الحالة لجلب جميع الكشوف بجميع الحالات (paid, verify, draft, etc.)
            // تم إزالة فلتر الدفعة لجلب جميع الكشوف من جميع الدفعات
          ],
          'fields': [
            'id',
            'emp_seq',
            'employee_id',
            'payslip_run_id',
            'basic_wage',
            'gross_wage',
            'net_wage',
            'state',
          ],
          'limit': 1000, // زيادة الـ limit لضمان جلب جميع الكشوف
          'order': 'create_date desc',
        },
      });

      print('📨 [GET_PAYSLIPS] استجابة من Odoo: ${response.length} كشف');
      if (kDebugMode) {
        print('💰 [GET_PAYSLIPS] Payslips Response: $response');
      }

      if (response.isNotEmpty) {
        payslipsList.clear();

        for (var item in response) {
          if (kDebugMode) {
            print('🔍 [GET_PAYSLIPS] Raw payslip data: $item');
            print(
              '🔍 [GET_PAYSLIPS] Employee ID field: ${item['employee_id']}',
            );
          }
          payslipsList.add(PayslipModel.fromJson(item));
        }

        print('✅ [GET_PAYSLIPS] تم تحميل ${payslipsList.length} كشف مرتب');
        if (kDebugMode) {
          // طباعة تفاصيل كل كشف
          for (var payslip in payslipsList) {
            print(
              '💰 [GET_PAYSLIPS] كشف ID: ${payslip.id}, emp_seq: ${payslip.empSeq}, اسم الموظف: ${payslip.employeeName}, الراتب الصافي: ${payslip.netWage}, الحالة: ${payslip.state}',
            );
          }
        }
      } else {
        print(
          '⚠️ [GET_PAYSLIPS] لا توجد كشوف مرتبات للموظف (emp_seq: $empSeq)',
        );
        payslipsList.clear();
      }

      print('========================================\n');
    } catch (e, stackTrace) {
      print('❌ [GET_PAYSLIPS] خطأ في تحميل كشوف المرتبات: $e');
      print('   📋 Stack Trace: $stackTrace');
      print('========================================\n');

      Get.snackbar(
        'error'.tr,
        'failed_to_load_payslips'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> downloadPayslipPdf(int payslipId) async {
    try {
      Get.snackbar(
        'loading'.tr,
        'start_downloading_payslip'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.blue,
        colorText: Colors.white,
        duration: const Duration(seconds: 2),
        showProgressIndicator: true,
      );

      String pdfUrl =
          '${AppConstant.baseUrl}/print/payslips?list_ids=$payslipId';

      String languageCode = _getCurrentLanguageCode();

      if (kDebugMode) {
        print('📄 بدء تحميل PDF للكشف ID: $payslipId');
        print('🌐 الرابط: $pdfUrl');
        print('🗣️ اللغة المرسلة: $languageCode');
        print('🔐 Session ID: ${AppConstant.client.sessionId?.id}');
      }

      // تحميل الملف
      final response = await http.get(
        Uri.parse(pdfUrl),
        headers: {
          'Cookie':
              'session_id=${AppConstant.client.sessionId?.id}; frontend_lang=$languageCode',
        },
      );

      if (response.statusCode == 200) {
        // تحديد مجلد التحميل
        Directory? directory;
        String fileName = 'payslip_$payslipId.pdf';

        try {
          if (Platform.isAndroid) {
            // للأندرويد - محاولة الحفظ في Downloads أولاً
            directory = Directory('/storage/emulated/0/Download');
            if (!await directory.exists()) {
              // إذا لم يكن متاح، استخدم external storage
              directory = await getExternalStorageDirectory();
              if (directory != null) {
                // إنشاء مجلد Downloads في external storage
                directory = Directory('${directory.path}/Download');
                await directory.create(recursive: true);
              }
            }
          } else if (Platform.isIOS) {
            // للآي او إس - الحفظ في Documents
            directory = await getApplicationDocumentsDirectory();
          }
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ خطأ في تحديد مجلد التحميل: $e');
          }
          // استخدام المجلد الافتراضي
          directory = await getApplicationDocumentsDirectory();
        }

        if (directory != null) {
          final filePath = '${directory.path}/$fileName';
          final file = File(filePath);

          // كتابة الملف
          await file.writeAsBytes(response.bodyBytes);

          if (kDebugMode) {
            print('✅ تم حفظ الملف في: $filePath');
          }

          Get.snackbar(
            'download_successful'.tr,
            Platform.isAndroid
                ? "${"download_path".tr}: ${directory.path}"
                : 'download_path_files'.tr,
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            duration: const Duration(seconds: 5),
            icon: const Icon(Icons.download_done, color: Colors.white),
          );
        } else {
          throw Exception('لا يمكن الوصول لمجلد التحميل');
        }
      } else {
        throw Exception('فشل في تحميل الملف: ${response.statusCode}');
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل PDF: $e');
      }

      Get.snackbar(
        'error_in_downloading'.tr,
        "${"failed_to_load_payslips".tr}: ${e.toString()}",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 4),
        icon: const Icon(Icons.error, color: Colors.white),
      );
    }
  }

  // الحصول على كود اللغة الحالية
  String _getCurrentLanguageCode() {
    String currentLocale = Get.locale?.languageCode ?? 'en';

    // محاولة الحصول على اللغة من storage أولاً
    String? savedLanguage = box.read('app_language');
    if (savedLanguage != null && savedLanguage.isNotEmpty) {
      currentLocale = savedLanguage;
    }

    // تحويل كود اللغة إلى تنسيق Odoo
    switch (currentLocale.toLowerCase()) {
      case 'ar':
        return 'ar_001'; // العربية
      case 'en':
        return 'en_US'; // الإنجليزية
      default:
        return 'en_US'; // افتراضي
    }
  }

  // تنسيق المبلغ المالي
  String formatCurrency(double amount) {
    return '${amount.toStringAsFixed(2)} ر.س';
  }

  // الحصول على لون الحالة
  Color getStateColor(String state) {
    switch (state.toLowerCase()) {
      case 'paid':
        return Colors.green;
      case 'draft':
        return Colors.orange;
      case 'verify':
        return Colors.blue;
      case 'cancel':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // الحصول على نص الحالة مترجم
  String getStateText(String state) {
    switch (state.toLowerCase()) {
      case 'paid':
        return 'payslip_paid'.tr.isNotEmpty ? 'payslip_paid'.tr : 'مدفوع';
      case 'draft':
        return 'payslip_draft'.tr.isNotEmpty ? 'payslip_draft'.tr : 'مسودة';
      case 'verify':
        return 'payslip_verify'.tr.isNotEmpty
            ? 'payslip_verify'.tr
            : 'قيد المراجعة';
      case 'cancel':
        return 'payslip_cancel'.tr.isNotEmpty ? 'payslip_cancel'.tr : 'ملغى';
      default:
        return state;
    }
  }

  // جلب جميع دفعات كشوف المرتبات المتاحة في النظام
  Future<void> getPayslipBatches() async {
    final empSeq = box.read('emp_seq');

    if (empSeq == null || empSeq.toString().isEmpty) {
      if (kDebugMode) {
        print('❌ لا يوجد رقم موظف محفوظ للدفعات');
      }
      return;
    }

    batchesLoading = true;
    update();

    try {
      // جلب جميع الدفعات المتاحة في النظام
      var batchResponse = await AppConstant.client.callKw({
        'model': 'hr.payslip.run',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [],
          'fields': [
            'id',
            'name',
            'date_start',
            'date_end',
            'state',
            'payslip_count',
          ],
          'order': 'date_start desc',
        },
      });

      if (kDebugMode) {
        print('📦 All Payslip Batches Response: $batchResponse');
      }

      payslipRunList.clear();

      for (var item in batchResponse) {
        if (kDebugMode) {
          print('🔍 Raw payslip batch data: $item');
        }
        payslipRunList.add(PayslipRunModel.fromJson(item));
      }

      // نسخ البيانات للقائمة المفلترة
      filteredPayslipRunList = List.from(payslipRunList);

      if (kDebugMode) {
        print('✅ تم تحميل ${payslipRunList.length} دفعة كشوف مرتبات');

        // طباعة تفاصيل كل دفعة
        for (var batch in payslipRunList) {
          print(
            '📅 دفعة: ${batch.name}, من: ${batch.dateStart}, إلى: ${batch.dateEnd}, الحالة: ${batch.state}, عدد الكشوف: ${batch.payslipCount}',
          );
        }
      }

      // لا نجلب الكشوف هنا - سيتم جلبها في onInit() بعد تحميل الدفعات
      if (kDebugMode) {
        print(
          '📋 [GET_BATCHES] تم تحميل الدفعات - سيتم جلب الكشوف في onInit()',
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل دفعات كشوف المرتبات: $e');
      }

      Get.snackbar(
        'error'.tr,
        'failed_to_load_payslips'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      batchesLoading = false;
      update();
    }
  }

  // الحصول على كشوف مرتبات لدفعة معينة باستخدام الاسم
  Future<void> getPayslipsByBatchName(String batchName) async {
    print('\n🔍 [GET_PAYSLIPS_BY_BATCH] بدء جلب الكشوف للدفعة: $batchName');

    final empSeq = box.read('emp_seq');

    if (empSeq == null || empSeq.toString().isEmpty) {
      print('❌ [GET_PAYSLIPS_BY_BATCH] لا يوجد رقم موظف محفوظ للكشوف');
      print('========================================\n');
      return;
    }

    print('👤 [GET_PAYSLIPS_BY_BATCH] Employee Sequence: $empSeq');
    print('📦 [GET_PAYSLIPS_BY_BATCH] Batch Name: $batchName');

    loading = true;
    update();

    try {
      print('📡 [GET_PAYSLIPS_BY_BATCH] البحث عن الدفعة...');
      // البحث عن الدفعة بالاسم أولاً
      var batchResponse = await AppConstant.client.callKw({
        'model': 'hr.payslip.run',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['name', '=', batchName],
          ],
          'fields': ['id', 'name'],
          'limit': 1,
        },
      });

      if (batchResponse.isEmpty) {
        print(
          '❌ [GET_PAYSLIPS_BY_BATCH] لم يتم العثور على دفعة بالاسم: $batchName',
        );
        print('========================================\n');
        payslipsList.clear();
        return;
      }

      int batchId = batchResponse[0]['id'];
      print('✅ [GET_PAYSLIPS_BY_BATCH] تم العثور على الدفعة - ID: $batchId');

      // البحث عن كشوف المرتبات للموظف في هذه الدفعة
      print('📡 [GET_PAYSLIPS_BY_BATCH] جلب الكشوف من الدفعة...');
      var response = await AppConstant.client.callKw({
        'model': 'hr.payslip',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['payslip_run_id', '=', batchId],
            ['emp_seq', '=', empSeq], // فلتر للموظف الحالي فقط
          ],
          'fields': [
            'id',
            'emp_seq',
            'employee_id',
            'payslip_run_id',
            'basic_wage',
            'gross_wage',
            'net_wage',
            'state',
          ],
          'limit': 100,
          'order': 'create_date desc',
        },
      });

      print(
        '📨 [GET_PAYSLIPS_BY_BATCH] استجابة من Odoo: ${response.length} كشف',
      );
      if (kDebugMode) {
        print('💰 [GET_PAYSLIPS_BY_BATCH] Payslips Response: $response');
      }

      if (response.isNotEmpty) {
        payslipsList.clear();

        for (var item in response) {
          payslipsList.add(PayslipModel.fromJson(item));
        }

        print(
          '✅ [GET_PAYSLIPS_BY_BATCH] تم تحميل ${payslipsList.length} كشف مرتب',
        );
        if (kDebugMode) {
          print(
            '✅ [GET_PAYSLIPS_BY_BATCH] تم تحميل ${payslipsList.length} كشف مرتب للموظف $empSeq في الدفعة $batchName',
          );
        }
      } else {
        payslipsList.clear();
        print(
          '⚠️ [GET_PAYSLIPS_BY_BATCH] لا توجد كشوف مرتبات للموظف $empSeq في الدفعة $batchName',
        );
      }

      print('========================================\n');
    } catch (e, stackTrace) {
      print('❌ [GET_PAYSLIPS_BY_BATCH] خطأ في تحميل كشوف المرتبات للدفعة: $e');
      print('   📋 Stack Trace: $stackTrace');
      print('========================================\n');

      Get.snackbar(
        'error'.tr,
        'failed_to_load_payslips'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      loading = false;
      update();
    }
  }

  // الحصول على كشوف مرتبات لدفعة معينة - للموظف الحالي فقط
  Future<void> getPayslipsByBatchId(int batchId) async {
    final empSeq = box.read('emp_seq');

    if (empSeq == null || empSeq.toString().isEmpty) {
      if (kDebugMode) {
        print('❌ لا يوجد رقم موظف محفوظ للكشوف');
      }
      return;
    }

    loading = true;
    update();

    try {
      var response = await AppConstant.client.callKw({
        'model': 'hr.payslip',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['payslip_run_id', '=', batchId],
            ['emp_seq', '=', empSeq], // فلتر للموظف الحالي فقط
            // تم إزالة فلتر الحالة لجلب جميع الكشوف بجميع الحالات
          ],
          'fields': [
            'id',
            'emp_seq',
            'employee_id',
            'payslip_run_id',
            'basic_wage',
            'gross_wage',
            'net_wage',
            'state',
          ],
          'limit': 100,
          'order': 'create_date desc',
        },
      });

      if (kDebugMode) {
        print(
          '💰 Payslips Response for Employee $empSeq in Batch ID $batchId: $response',
        );
      }

      if (response.isNotEmpty) {
        payslipsList.clear();

        for (var item in response) {
          payslipsList.add(PayslipModel.fromJson(item));
        }

        if (kDebugMode) {
          print(
            '✅ تم تحميل ${payslipsList.length} كشف مرتب للموظف $empSeq في الدفعة $batchId',
          );
        }
      } else {
        payslipsList.clear();
        if (kDebugMode) {
          print('⚠️ لا توجد كشوف مرتبات للموظف $empSeq في الدفعة $batchId');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل كشوف المرتبات للدفعة: $e');
      }

      Get.snackbar(
        'error'.tr,
        'failed_to_load_payslips'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        duration: const Duration(seconds: 3),
      );
    } finally {
      loading = false;
      update();
    }
  }

  // الحصول على الشهور المتاحة - عرض كل الشهور الموجودة فعلياً
  List<String> getAvailableMonths() {
    Set<String> months = {};
    for (var batch in payslipRunList) {
      if (batch.name.isNotEmpty) {
        // إضافة الاسم كاملاً كخيار (مثل "Aug 2025")
        months.add(batch.name);
      }
    }
    return months.toList()..sort((a, b) {
      // ترتيب حسب التاريخ - الأحدث أولاً
      try {
        List<String> aParts = a.split(' ');
        List<String> bParts = b.split(' ');
        if (aParts.length >= 2 && bParts.length >= 2) {
          int aYear = int.parse(aParts[1]);
          int bYear = int.parse(bParts[1]);
          if (aYear != bYear) {
            return bYear.compareTo(aYear); // السنة الأحدث أولاً
          }
          // إذا كانت نفس السنة، رتب حسب الشهر
          return _getMonthNumber(
            bParts[0],
          ).compareTo(_getMonthNumber(aParts[0]));
        }
      } catch (e) {
        if (kDebugMode) {
          print('خطأ في ترتيب الشهور: $e');
        }
      }
      return b.compareTo(a);
    });
  }

  // الحصول على رقم الشهر لترتيب أفضل
  int _getMonthNumber(String month) {
    switch (month.toLowerCase()) {
      case 'jan':
      case 'january':
        return 1;
      case 'feb':
      case 'february':
        return 2;
      case 'mar':
      case 'march':
        return 3;
      case 'apr':
      case 'april':
        return 4;
      case 'may':
        return 5;
      case 'jun':
      case 'june':
        return 6;
      case 'jul':
      case 'july':
        return 7;
      case 'aug':
      case 'august':
        return 8;
      case 'sep':
      case 'september':
        return 9;
      case 'oct':
      case 'october':
        return 10;
      case 'nov':
      case 'november':
        return 11;
      case 'dec':
      case 'december':
        return 12;
      default:
        return 0;
    }
  }

  // البحث عن الدفعة بناءً على الشهر والسنة المختارين
  String? findBatchNameByMonthYear(String month, String year) {
    for (var batch in payslipRunList) {
      String batchName = batch.name.toLowerCase();
      String searchMonth = month.toLowerCase();

      // البحث في الاسم إذا كان يحتوي على الشهر والسنة
      if (batchName.contains(searchMonth) && batchName.contains(year)) {
        if (kDebugMode) {
          print(
            '🔍 وجدت دفعة مطابقة: ${batch.name} للشهر: $month والسنة: $year',
          );
        }
        return batch.name; // إرجاع الاسم الكامل
      }
    }

    if (kDebugMode) {
      print('❌ لم يتم العثور على دفعة للشهر: $month والسنة: $year');
    }
    return null;
  }

  // تطبيق الفلتر بناءً على الشهر والسنة
  void applyFilterByMonthYear(String? month, String? year) {
    print('\n🔍 [APPLY_FILTER] بدء تطبيق الفلتر...');
    print('   📅 الشهر: $month');
    print('   📅 السنة: $year');

    if (month != null && month.isNotEmpty && year != null && year.isNotEmpty) {
      selectedMonth = month;
      selectedYear = year;

      // البحث عن اسم الدفعة المطابق
      print('🔍 [APPLY_FILTER] البحث عن دفعة مطابقة...');
      selectedBatchName = findBatchNameByMonthYear(month, year);

      if (selectedBatchName != null) {
        isFilterActive = true;
        print('✅ [APPLY_FILTER] تم العثور على دفعة: $selectedBatchName');
        print('📋 [APPLY_FILTER] جلب الكشوف المفلترة...');

        // استخدام اسم الدفعة للفلترة
        getPayslipsByBatchName(selectedBatchName!);

        if (kDebugMode) {
          print(
            '✅ [APPLY_FILTER] تم تطبيق فلتر للشهر: $month والسنة: $year باستخدام الدفعة: $selectedBatchName',
          );
        }
      } else {
        // لم يتم العثور على دفعة مطابقة
        print('❌ [APPLY_FILTER] لم يتم العثور على دفعة مطابقة');
        payslipsList.clear();
        isFilterActive = true;

        Get.snackbar(
          'warning'.tr,
          'no_payslips_for_selected_period'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 3),
        );
      }
    } else {
      // إلغاء الفلتر
      print('🔄 [APPLY_FILTER] إلغاء الفلتر - جلب جميع البيانات...');
      clearFilter();
    }

    update();
  }

  // الحصول على الشهور المتاحة منفصلة
  List<String> getAvailableMonthsOnly() {
    Set<String> months = {};
    for (var batch in payslipRunList) {
      if (batch.name.isNotEmpty) {
        List<String> parts = batch.name.split(' ');
        if (parts.isNotEmpty) {
          String month = parts[0]; // الشهر هو الجزء الأول
          months.add(month);
        }
      }
    }

    List<String> monthsList = months.toList();
    // ترتيب الشهور حسب الرقم
    monthsList.sort((a, b) => _getMonthNumber(a).compareTo(_getMonthNumber(b)));
    return monthsList;
  }

  // الحصول على السنوات المتاحة منفصلة
  List<String> getAvailableYearsOnly() {
    Set<String> years = {};
    for (var batch in payslipRunList) {
      if (batch.name.isNotEmpty) {
        List<String> parts = batch.name.split(' ');
        if (parts.length > 1) {
          String year = parts[1]; // السنة هي الجزء الثاني
          years.add(year);
        }
      }
    }

    List<String> yearsList = years.toList();
    // ترتيب السنوات من الأحدث للأقدم
    yearsList.sort((a, b) => b.compareTo(a));
    return yearsList;
  }

  // إعادة تعيين الفلتر
  void clearFilter() {
    print('\n🔄 [CLEAR_FILTER] بدء مسح الفلتر...');

    selectedMonth = null;
    selectedYear = null;
    selectedBatchName = null;
    isFilterActive = false;
    filteredPayslipRunList = List.from(payslipRunList);

    print('✅ [CLEAR_FILTER] تم مسح الفلتر - جلب جميع البيانات...');
    getPayslipsByEmployeeId();

    if (kDebugMode) {
      print('🔄 [CLEAR_FILTER] تم مسح الفلتر بنجاح');
    }

    update();
  }

  // الحصول على اسم الشهر بالعربية من الاسم الكامل مع تنسيق أفضل
  String getArabicMonthName(String batchName) {
    if (batchName.isEmpty) return batchName;

    List<String> parts = batchName.split(' ');
    if (parts.isEmpty) return batchName;

    String month = parts[0];
    String year = parts.length > 1 ? parts[1] : '';
    String arabicMonth;

    switch (month.toLowerCase()) {
      case 'jan':
      case 'january':
        arabicMonth = 'يناير';
        break;
      case 'feb':
      case 'february':
        arabicMonth = 'فبراير';
        break;
      case 'mar':
      case 'march':
        arabicMonth = 'مارس';
        break;
      case 'apr':
      case 'april':
        arabicMonth = 'أبريل';
        break;
      case 'may':
        arabicMonth = 'مايو';
        break;
      case 'jun':
      case 'june':
        arabicMonth = 'يونيو';
        break;
      case 'jul':
      case 'july':
        arabicMonth = 'يوليو';
        break;
      case 'aug':
      case 'august':
        arabicMonth = 'أغسطس';
        break;
      case 'sep':
      case 'september':
        arabicMonth = 'سبتمبر';
        break;
      case 'oct':
      case 'october':
        arabicMonth = 'أكتوبر';
        break;
      case 'nov':
      case 'november':
        arabicMonth = 'نوفمبر';
        break;
      case 'dec':
      case 'december':
        arabicMonth = 'ديسمبر';
        break;
      default:
        return batchName; // إرجاع الاسم الأصلي إذا لم يتم التعرف على الشهر
    }

    // إنشاء سلسلة منسقة بالشكل: "الشهر العربي سنة"
    if (year.isNotEmpty) {
      return '$arabicMonth $year';
    } else {
      return arabicMonth;
    }
  }

  // دالة لجلب البيانات من أحدث دفعة تلقائياً
  Future<void> loadDataFromLatestBatch() async {
    print('\n🔄 [LOAD_LATEST_BATCH] محاولة جلب البيانات من أحدث دفعة...');

    if (payslipRunList.isEmpty) {
      print('⚠️ [LOAD_LATEST_BATCH] لا توجد دفعات متاحة');
      return;
    }

    // الحصول على أحدث دفعة (الأولى في القائمة لأنها مرتبة حسب التاريخ)
    final latestBatch = payslipRunList.first;
    print('📦 [LOAD_LATEST_BATCH] أحدث دفعة: ${latestBatch.name}');

    // استخراج الشهر والسنة من اسم الدفعة
    List<String> parts = latestBatch.name.split(' ');
    if (parts.length >= 2) {
      String month = parts[0];
      String year = parts[1];

      print('📅 [LOAD_LATEST_BATCH] الشهر: $month, السنة: $year');

      // جلب البيانات من هذه الدفعة بدون تفعيل الفلتر
      await getPayslipsByBatchName(latestBatch.name);

      // تعيين القيم للفلتر لكن بدون تفعيله (للعرض فقط)
      selectedMonth = month;
      selectedYear = year;
      selectedBatchName = latestBatch.name;
      isFilterActive = false; // مهم: لا نفعّل الفلتر

      print(
        '✅ [LOAD_LATEST_BATCH] تم جلب البيانات من أحدث دفعة بدون تفعيل الفلتر',
      );
      update();
    } else {
      print(
        '⚠️ [LOAD_LATEST_BATCH] لا يمكن استخراج الشهر والسنة من اسم الدفعة',
      );
    }
  }

  @override
  Future<void> onInit() async {
    // استخدام await لضمان تحميل البيانات بشكل متسلسل ومنتظم
    try {
      if (kDebugMode) {
        print('🚀 تهيئة كونترولر كشوف المرتبات');
        print('📋 [INIT] جلب جميع البيانات بدون فلتر...');
      }

      // جلب بيانات الدفعات أولاً
      await getPayslipBatches();

      // بعد تحميل الدفعات، يتم تحميل كشوف المرتبات الخاصة بالموظف الحالي
      // (هذه الدالة تُستدعى تلقائياً داخل getPayslipBatches)
      // لكن للتأكد، نستدعيها مرة أخرى بشكل صريح
      if (!isFilterActive) {
        if (kDebugMode) {
          print('📋 [INIT] لا يوجد فلتر نشط - جلب جميع البيانات...');
        }
        await getPayslipsByEmployeeId();

        // إذا لم توجد بيانات بدون فلتر، جلب البيانات من أحدث دفعة تلقائياً
        if (payslipsList.isEmpty && payslipRunList.isNotEmpty) {
          print(
            '⚠️ [INIT] لا توجد بيانات بدون فلتر - جلب البيانات من أحدث دفعة تلقائياً...',
          );
          await loadDataFromLatestBatch();
        }
      }

      if (kDebugMode) {
        print('✅ اكتملت تهيئة كونترولر كشوف المرتبات بنجاح');
        print('📊 [INIT] عدد الكشوف المحملة: ${payslipsList.length}');
        if (isFilterActive) {
          print('🔍 [INIT] الفلتر نشط: $selectedMonth $selectedYear');
        } else {
          print('📋 [INIT] لا يوجد فلتر نشط');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ أثناء تهيئة كونترولر كشوف المرتبات: $e');
      }
    }

    super.onInit();
  }
}
