import 'dart:convert';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:intl/intl.dart';
import 'package:orbit_workforce/constant/app_constant.dart';
import 'package:orbit_workforce/model/leave_request_model.dart';
import 'package:orbit_workforce/model/leave_type_model.dart';
import 'package:orbit_workforce/model/loan_model.dart';
import 'package:orbit_workforce/model/loan_type_model.dart';

class RequestController extends GetxController {
  bool loading = false;
  bool loadingTypes = false;
  bool uploadingAttachment = false;
  GetStorage box = GetStorage();

  // المتحكمات بالنص
  TextEditingController descriptionController =
      TextEditingController(); // تم تغيير الاسم من emailController لوصف أفضل

  // متغيرات التاريخ
  DateTime startDate = DateTime.now();
  DateTime endDate = DateTime.now().add(const Duration(days: 1));

  // متغيرات لعرض التاريخ في واجهة المستخدم
  String get formattedStartDate {
    final locale = Get.locale?.languageCode ?? 'ar';
    return DateFormat('EEEE, d MMMM yyyy', locale).format(startDate);
  }

  String get formattedEndDate {
    final locale = Get.locale?.languageCode ?? 'ar';
    return DateFormat('EEEE, d MMMM yyyy', locale).format(endDate);
  }

  // دوال اختيار التاريخ
  Future<void> selectStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: startDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: HexColor('#004ADB'),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: HexColor('#004ADB')),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != startDate) {
      startDate = picked;
      // إذا كان تاريخ البداية بعد تاريخ النهاية، قم بتحديث تاريخ النهاية أيضًا
      if (startDate.isAfter(endDate)) {
        endDate = startDate.add(const Duration(days: 1));
      }
      update();
    }
  }

  Future<void> selectEndDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: endDate.isAfter(startDate)
          ? endDate
          : startDate.add(const Duration(days: 1)),
      firstDate: startDate,
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: HexColor('#004ADB'),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: HexColor('#004ADB')),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != endDate) {
      endDate = picked;
      update();
    }
  }

  // دالة اختيار تاريخ بداية القرض
  Future<void> selectLoanStartDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: loanStartDate,
      firstDate: DateTime.now(),
      lastDate: DateTime(2030),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: HexColor('#004ADB'),
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: HexColor('#004ADB')),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != loanStartDate) {
      loanStartDate = picked;
      update();
    }
  }

  // المرفقات
  List<String> attachments = [];
  // معلومات الملفات المرفقة
  List<Map<String, dynamic>> attachmentFiles = [];

  String requestType = 'leave_type_placeholder'.tr;
  List<LeaveRequestModel> leaveRequestsList = [];
  List<LeaveRequestModel> filteredLeaveRequestsList = [];
  // قائمة أنواع الإجازات من النظام
  List<LeaveTypeModel> leaveTypesList = [];
  // القائمة المستخدمة في واجهة المستخدم
  List<String> requestTypelist = [];

  // متغيرات الفلترة
  String selectedHolidayStatusFilter = 'all_types'.tr;
  String selectedStateFilter = 'all_statuses'.tr;
  List<String> holidayStatusFilterOptions = ['all_types'.tr];
  List<String> stateFilterOptions = [
    'all_statuses'.tr,
    'submitted'.tr,
    'approved_1'.tr,
    'approved_2'.tr,
    'rejected'.tr,
    'cancelled'.tr,
  ];

  // متغيرات خاصة بالقروض
  bool loadingLoans = false;
  List<LoanModel> loansList = [];
  List<LoanModel> filteredLoansList = [];

  // متغيرات فلترة القروض
  String selectedLoanTypeFilter = 'all_loan_types'.tr;
  String selectedLoanStateFilter = 'all_loan_statuses'.tr;
  List<String> loanTypeFilterOptions = ['all_loan_types'.tr];
  List<String> loanStateFilterOptions = ['all_loan_statuses'.tr];

  // متغيرات خاصة بأنواع القروض
  bool loadingLoanTypes = false;
  List<LoanTypeModel> loanTypesList = [];
  List<String> loanTypesDisplayList = [];
  String selectedLoanType = 'اختر نوع القرض';

  // متغيرات طلب القرض الجديد
  bool loadingCreateLoan = false;
  TextEditingController loanAmountController = TextEditingController();
  TextEditingController loanMonthsController = TextEditingController();
  TextEditingController loanReasonController = TextEditingController();
  DateTime loanStartDate = DateTime.now();
  String selectedLoanAction = 'قرض شخصي';
  List<String> loanActionsList = ['قرض شخصي', 'قرض نهاية خدمة'];

  // دالة لتنسيق تاريخ القرض
  String get formattedLoanStartDate {
    final locale = Get.locale?.languageCode ?? 'ar';
    return DateFormat('EEEE, d MMMM yyyy', locale).format(loanStartDate);
  }

  // حذف مرفق محدد
  void removeAttachment(int index) {
    if (index >= 0 && index < attachmentFiles.length) {
      attachmentFiles.removeAt(index);
      if (index < attachments.length) {
        attachments.removeAt(index);
      }
      update();
    }
  }

  // الحصول على معرف نوع الإجازة من الاسم المعروض
  int getLeaveTypeIdByName(String displayName) {
    try {
      final leaveType = leaveTypesList.firstWhere(
        (type) => type.displayName == displayName,
        orElse: () => LeaveTypeModel(
          id: 0,
          displayName: '',
          allocationType: '',
          workEntryTypeId: [],
        ),
      );
      return leaveType.id;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في العثور على نوع الإجازة: $e');
      }
      return 0;
    }
  }

  // دوال الفلترة
  void applyFilters() {
    filteredLeaveRequestsList = leaveRequestsList.where((request) {
      bool matchesHolidayStatus = true;
      bool matchesState = true;

      // فلترة حسب نوع الإجازة
      if (selectedHolidayStatusFilter != 'all_types'.tr) {
        matchesHolidayStatus =
            request.holidayStatusName == selectedHolidayStatusFilter;
      }

      // فلترة حسب الحالة
      if (selectedStateFilter != 'all_statuses'.tr) {
        matchesState = request.statusText == selectedStateFilter;
      }

      return matchesHolidayStatus && matchesState;
    }).toList();

    update();
  }

  void clearFilters() {
    selectedHolidayStatusFilter = 'all_types'.tr;
    selectedStateFilter = 'all_statuses'.tr;
    filteredLeaveRequestsList = List.from(leaveRequestsList);
    update();
  }

  void setHolidayStatusFilter(String status) {
    selectedHolidayStatusFilter = status;
    applyFilters();
  }

  void setStateFilter(String state) {
    selectedStateFilter = state;
    applyFilters();
  }

  void updateFilterOptions() {
    // تحديث خيارات فلترة نوع الإجازة
    holidayStatusFilterOptions = ['all_types'.tr];
    Set<String> uniqueHolidayStatuses = leaveRequestsList
        .map((request) => request.holidayStatusName)
        .where((name) => name.isNotEmpty)
        .toSet();
    holidayStatusFilterOptions.addAll(uniqueHolidayStatuses.toList());
  }

  // دوال فلترة القروض
  void applyLoanFilters() {
    filteredLoansList = loansList.where((loan) {
      bool matchesType = true;
      bool matchesState = true;

      // فلترة حسب نوع القرض
      if (selectedLoanTypeFilter != 'all_loan_types'.tr) {
        matchesType = loan.getLoanActionText() == selectedLoanTypeFilter;
      }

      // فلترة حسب الحالة
      if (selectedLoanStateFilter != 'all_loan_statuses'.tr) {
        matchesState = loan.getStateText() == selectedLoanStateFilter;
      }

      return matchesType && matchesState;
    }).toList();

    update();
  }

  void clearLoanFilters() {
    selectedLoanTypeFilter = 'all_loan_types'.tr;
    selectedLoanStateFilter = 'all_loan_statuses'.tr;
    filteredLoansList = List.from(loansList);
    update();
  }

  void setLoanTypeFilter(String type) {
    selectedLoanTypeFilter = type;
    applyLoanFilters();
  }

  void setLoanStateFilter(String state) {
    selectedLoanStateFilter = state;
    applyLoanFilters();
  }

  void updateLoanFilterOptions() {
    // تحديث خيارات فلترة نوع القرض
    loanTypeFilterOptions = ['all_loan_types'.tr];
    Set<String> uniqueLoanTypes = loansList
        .map((loan) => loan.getLoanActionText())
        .where((name) => name.isNotEmpty)
        .toSet();
    loanTypeFilterOptions.addAll(uniqueLoanTypes.toList());

    // تحديث خيارات فلترة حالة القرض
    loanStateFilterOptions = ['all_loan_statuses'.tr];
    Set<String> uniqueLoanStates = loansList
        .map((loan) => loan.getStateText())
        .where((state) => state.isNotEmpty)
        .toSet();
    loanStateFilterOptions.addAll(uniqueLoanStates.toList());
  }

  // قائمة طلبات الإجازات

  // دالة للحصول على طلبات الإجازات للموظف
  Future<void> getLeaveRequestsByEmployeeId() async {
    final employeeId = box.read('employee_id');

    if (employeeId == null) {
      if (kDebugMode) {
        print('❌ لا يوجد معرف موظف محفوظ للإجازات');
      }
      return;
    }

    loading = true;
    update();

    try {
      var response = await AppConstant.client.callKw({
        'model': 'hr.leave',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['employee_id', '=', employeeId], // فلتر حسب الموظف
          ],
          'fields': [
            'id',
            'holiday_status_id',
            'name',
            'date_from',
            'date_to',
            'duration_display',
            'state',
          ],
          'limit': 100,
          'order': 'create_date desc',
        },
      });

      if (kDebugMode) {
        print('📝 Leave Requests Response for Employee $employeeId: $response');
      }

      if (response.isNotEmpty) {
        // تنظيف القائمة الحالية
        leaveRequestsList.clear();

        // تحويل البيانات لـ models
        for (var item in response) {
          leaveRequestsList.add(LeaveRequestModel.fromJson(item));
        }

        if (kDebugMode) {
          print(
            '✅ تم تحميل ${leaveRequestsList.length} طلب إجازة للموظف $employeeId',
          );
        }

        // تحديث خيارات الفلترة وإعداد القائمة المفلترة
        updateFilterOptions();
        filteredLeaveRequestsList = List.from(leaveRequestsList);
      } else {
        if (kDebugMode) {
          print('⚠️ لا توجد طلبات إجازات للموظف $employeeId');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل طلبات الإجازات: $e');
      }
    } finally {
      loading = false;
      update();
    }
  }

  Future<void> getLeaveTypes() async {
    loadingTypes = true;
    update();

    try {
      var response = await AppConstant.client.callKw({
        'model': 'hr.leave.type',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['active', '=', true],
          ],
          'fields': [
            'id',
            'display_name',
            'allocation_validation_type',
            'work_entry_type_id',
          ],
          'limit': 50,
        },
      });

      if (kDebugMode) {
        print('📝 Leave Types Response: $response');
      }

      if (response.isNotEmpty) {
        leaveTypesList.clear();
        requestTypelist.clear();

        for (var item in response) {
          LeaveTypeModel leaveType = LeaveTypeModel.fromJson(item);
          leaveTypesList.add(leaveType);

          requestTypelist.add(leaveType.displayName);
        }

        if (kDebugMode) {
          print('✅ تم تحميل ${leaveTypesList.length} نوع إجازة');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ لا توجد أنواع إجازات متاحة');
        }

        requestTypelist = ['سنوية', 'مدفوعة', 'مرضية'];
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل أنواع الإجازات: $e');
      }

      requestTypelist = ['سنوية', 'مدفوعة', 'مرضية'];
    } finally {
      loadingTypes = false;
      update();
    }
  }

  Future<bool> createLeaveRequest() async {
    loading = true;
    update();

    try {
      // التحقق من اختيار نوع الإجازة
      if (requestType == 'leave_type'.tr || requestType.isEmpty) {
        Get.snackbar(
          'incomplete_data'.tr,
          'please_select_leave_type'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // الحصول على معرف نوع الإجازة المحدد
      final leaveTypeId = getLeaveTypeIdByName(requestType);
      if (leaveTypeId == 0) {
        if (kDebugMode) {
          print('❌ لم يتم العثور على نوع الإجازة: $requestType');
        }
        Get.snackbar(
          'data_error'.tr,
          'invalid_leave_type'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // الحصول على معرف الموظف
      final employeeId = box.read('employee_id');
      if (employeeId == null) {
        if (kDebugMode) {
          print('❌ لا يوجد معرف موظف محفوظ');
        }
        Get.snackbar(
          'data_error'.tr,
          'employee_id_not_found_login'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // التحقق من وصف الإجازة (اختياري ولكن يمكن التحقق منه)
      if (descriptionController.text.isEmpty) {
        Get.snackbar(
          'warning'.tr,
          'no_description_warning'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.orange,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );
        // استمر في التنفيذ لأن الوصف اختياري
      }

      // التحقق من أن تاريخ النهاية لا يقل عن تاريخ البداية
      if (endDate.isBefore(startDate)) {
        Get.snackbar(
          'date_error'.tr,
          'end_date_after_start'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // تنسيق التواريخ بشكل يفهمه Odoo
      final fromDateStr = DateFormat('yyyy-MM-dd').format(startDate);
      final toDateStr = DateFormat('yyyy-MM-dd').format(endDate);

      // إنشاء بيانات الطلب - مع تضمين كلا التاريخين
      Map<String, dynamic> requestData = {
        'employee_id': employeeId,
        'holiday_status_id': leaveTypeId,
        'request_date_from': fromDateStr,
        'request_date_to': toDateStr, // إضافة تاريخ النهاية
        'name': descriptionController.text.isEmpty
            ? 'leave_request'.tr
            : descriptionController.text,
      };

      // إضافة المرفقات إذا وجدت (صورة واحدة فقط)
      if (attachments.isNotEmpty) {
        try {
          int attachmentId = int.parse(attachments.first);
          requestData['supported_attachment_ids'] = [
            [
              6,
              0,
              [attachmentId],
            ],
          ];
        } catch (e) {
          if (kDebugMode) {
            print('❌ خطأ في تجهيز المرفق: $e');
          }
        }
      }

      // طباعة البيانات المرسلة للتحقق
      if (kDebugMode) {
        print('📝 Leave Request Data to Send: $requestData');
      }

      // محاولة إنشاء السجل
      var response = await AppConstant.client.callKw({
        'model': 'hr.leave',
        'method': 'create',
        'args': [requestData],
        'kwargs': {},
      });

      if (kDebugMode) {
        print('📝 Create Leave Request Response: $response');
      }

      if (response != null) {
        // تحديث قائمة طلبات الإجازة بعد الإنشاء
        await getLeaveRequestsByEmployeeId();

        // إعادة تعيين النموذج
        clearRequestForm();

        // إظهار رسالة نجاح
        Get.snackbar(
          'success'.tr,
          'leave_request_sent_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // تأخير الانتقال قليلًا للسماح بعرض رسالة النجاح
        await Future.delayed(const Duration(milliseconds: 500));

        // الانتقال إلى صفحة السجل
        Get.toNamed(Routes.historyRequest);

        return true;
      } else {
        Get.snackbar(
          'operation_failed'.tr,
          'leave_request_not_created'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في إنشاء طلب الإجازة: $e');
      }
      // عرض رسالة خطأ مفصلة للمستخدم
      Get.snackbar(
        'error'.tr,
        'error_creating_leave'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      loading = false;
      update();
    }
  }

  // دالة لإعادة تعيين النموذج بعد إرسال الطلب
  void clearRequestForm() {
    descriptionController.clear();
    requestType = 'leave_type'.tr;
    startDate = DateTime.now();
    endDate = DateTime.now().add(const Duration(days: 1));
    attachments.clear();
    attachmentFiles.clear();
    update();
  }

  Future<bool> uploadAttachment(String filePath, String fileName) async {
    uploadingAttachment = true;
    update();

    try {
      // التحقق من أن الملف هو صورة
      if (!_isImageFile(filePath)) {
        if (kDebugMode) {
          print('❌ الملف المرفق ليس صورة');
        }
        return false;
      }

      // مسح المرفقات السابقة لضمان وجود مرفق واحد فقط
      attachments.clear();
      attachmentFiles.clear();

      // قراءة الملف كبيانات ثنائية
      List<int> fileBytes = await File(filePath).readAsBytes();
      // تحويل البيانات لـ base64
      String base64File = base64Encode(fileBytes);

      var response = await AppConstant.client.callKw({
        'model': 'ir.attachment',
        'method': 'create',
        'args': [
          {
            'name': fileName,
            'datas': base64File,
            'res_model': 'hr.leave',
            'res_id': 0, // سيتم تحديثه لاحقًا عند إنشاء الطلب
            'type': 'binary',
          },
        ],
        'kwargs': {},
      });

      if (kDebugMode) {
        print('📝 Upload Attachment Response: $response');
      }

      if (response != null) {
        // إضافة معرف المرفق إلى القائمة
        attachments.add(response.toString());
        // إضافة معلومات الملف إلى القائمة
        attachmentFiles.add({
          'id': response.toString(),
          'name': fileName,
          'path': filePath,
          'isImage': _isImageFile(filePath),
        });
        return true;
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في رفع المرفق: $e');
      }
      return false;
    } finally {
      uploadingAttachment = false;
      update();
    }
  }

  bool _isImageFile(String filePath) {
    final ext = filePath.toLowerCase().split('.').last;
    return ['jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'heic'].contains(ext);
  }

  void setStartDate(DateTime date) {
    startDate = date;
    // تأكد من أن تاريخ النهاية ليس قبل تاريخ البداية
    if (endDate.isBefore(startDate)) {
      endDate = startDate.add(const Duration(days: 1));
    }
    update();
  }

  void setEndDate(DateTime date) {
    if (date.isAfter(startDate) || date.isAtSameMomentAs(startDate)) {
      endDate = date;
      update();
    }
  }

  String getFormattedDate(DateTime date) {
    // تنسيق التاريخ للعرض - يمكن تخصيص حسب اللغة
    final locale = Get.locale?.languageCode ?? 'ar';
    if (locale == 'en') {
      return DateFormat('EEEE, d MMMM yyyy', 'en').format(date);
    } else {
      return '${_getDayName(date.weekday)} ${date.day} ${_getMonthName(date.month)} ${date.year}';
    }
  }

  String _getDayName(int day) {
    List<String> days = [
      'الإثنين',
      'الثلاثاء',
      'الأربعاء',
      'الخميس',
      'الجمعة',
      'السبت',
      'الأحد',
    ];
    return days[day - 1]; // الأيام تبدأ من 1 (الإثنين) في DateTime
  }

  String _getMonthName(int month) {
    List<String> months = [
      'يناير',
      'فبراير',
      'مارس',
      'أبريل',
      'مايو',
      'يونيو',
      'يوليو',
      'أغسطس',
      'سبتمبر',
      'أكتوبر',
      'نوفمبر',
      'ديسمبر',
    ];
    return months[month - 1]; // الشهور تبدأ من 1 (يناير) في DateTime
  }

  @override
  void onInit() {
    super.onInit();
    filteredLeaveRequestsList = List.from(leaveRequestsList);
    filteredLoansList = List.from(loansList);
    getLeaveRequestsByEmployeeId();
    getLeaveTypes();
    getLoansByEmployeeId(); // إضافة جلب القروض عند التهيئة
    getLoanTypes(); // إضافة جلب أنواع القروض عند التهيئة
  }

  // دالة للحصول على تاريخ القروض للموظف
  Future<void> getLoansByEmployeeId() async {
    final employeeId = box.read('employee_id');

    if (employeeId == null) {
      if (kDebugMode) {
        print('❌ لا يوجد معرف موظف محفوظ للقروض');
      }
      return;
    }

    loadingLoans = true;
    update();

    try {
      var response = await AppConstant.client.callKw({
        'model': 'hr.loan', // نموذج القروض في Odoo
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
            'loan_action',
            'start_date',
            'end_date',
            'amount',
            'balance',
            'state',
          ],
          'limit': 100,
          'order': 'create_date desc',
        },
      });

      if (kDebugMode) {
        print('📝 Loans Response for Employee $employeeId: $response');
      }

      if (response.isNotEmpty) {
        // تنظيف القائمة الحالية
        loansList.clear();

        // تحويل البيانات لـ models
        for (var item in response) {
          loansList.add(LoanModel.fromJson(item));
        }

        if (kDebugMode) {
          print('✅ تم تحميل ${loansList.length} قرض للموظف $employeeId');
        }

        // تحديث خيارات الفلترة وإعداد القائمة المفلترة
        updateLoanFilterOptions();
        filteredLoansList = List.from(loansList);
      } else {
        if (kDebugMode) {
          print('⚠️ لا توجد قروض للموظف $employeeId');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل القروض: $e');
      }
    } finally {
      loadingLoans = false;
      update();
    }
  }

  // دالة للحصول على أنواع القروض
  Future<void> getLoanTypes() async {
    loadingLoanTypes = true;
    update();

    try {
      var response = await AppConstant.client.callKw({
        'model': 'loan.type', // نموذج أنواع القروض في Odoo
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [], // جلب جميع الأنواع المتاحة
          'fields': ['name', 'policy_id'],
          'limit': 50,
          'order': 'name asc',
        },
      });

      if (kDebugMode) {
        print('📝 Loan Types Response: $response');
      }

      if (response.isNotEmpty) {
        // تنظيف القائمة الحالية
        loanTypesList.clear();
        loanTypesDisplayList.clear();

        // تحويل البيانات لـ models
        for (var item in response) {
          LoanTypeModel loanType = LoanTypeModel.fromJson(item);
          loanTypesList.add(loanType);
          loanTypesDisplayList.add(loanType.displayText);
        }

        if (kDebugMode) {
          print('✅ تم تحميل ${loanTypesList.length} نوع قرض');
          print('📋 أنواع القروض: ${loanTypesDisplayList.join(", ")}');
        }
      } else {
        if (kDebugMode) {
          print('⚠️ لا توجد أنواع قروض متاحة');
        }
        // إضافة أنواع افتراضية في حالة عدم وجود بيانات
        loanTypesDisplayList = ['قرض شخصي', 'قرض نهاية خدمة'];
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل أنواع القروض: $e');
      }
      // إضافة أنواع افتراضية في حالة الخطأ
      loanTypesDisplayList = ['قرض شخصي', 'قرض نهاية خدمة'];
    } finally {
      loadingLoanTypes = false;
      update();
    }
  }

  // دالة للحصول على معرف نوع القرض من النص المعروض
  int? getLoanTypeIdByDisplayText(String displayText) {
    try {
      final loanType = loanTypesList.firstWhere(
        (type) => type.displayText == displayText,
        orElse: () => LoanTypeModel(
          id: null,
          name: '',
          description: '',
          loanPolicy: '',
          policyId: null,
        ),
      );
      return loanType.id;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في العثور على نوع القرض: $e');
      }
      return null;
    }
  }

  // دالة إنشاء طلب القرض
  Future<bool> createLoanRequest() async {
    loadingCreateLoan = true;
    update();

    try {
      // التحقق من البيانات المطلوبة
      if (selectedLoanType == 'select_loan_type_error'.tr ||
          selectedLoanType.isEmpty) {
        Get.snackbar(
          'incomplete_data'.tr,
          'please_select_loan_type'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      if (loanAmountController.text.isEmpty) {
        Get.snackbar(
          'incomplete_data'.tr,
          'please_enter_loan_amount'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      if (loanMonthsController.text.isEmpty) {
        Get.snackbar(
          'incomplete_data'.tr,
          'please_enter_number_months'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // الحصول على معرف الموظف
      final employeeId = box.read('employee_id');
      if (employeeId == null) {
        if (kDebugMode) {
          print('❌ لا يوجد معرف موظف محفوظ');
        }
        Get.snackbar(
          'data_error'.tr,
          'employee_id_not_found_login'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // الحصول على معرف نوع القرض
      final loanTypeId = getLoanTypeIdByDisplayText(selectedLoanType);

      // التحقق من وجود نوع القرض
      if (loanTypeId == null) {
        Get.snackbar(
          'data_error'.tr,
          'invalid_loan_type'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // تحويل المبلغ إلى رقم
      double amount;
      try {
        amount = double.parse(loanAmountController.text);
      } catch (e) {
        Get.snackbar(
          'data_error'.tr,
          'please_enter_valid_amount'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      // تحويل عدد الأشهر إلى رقم
      int months;
      try {
        months = int.parse(loanMonthsController.text);
      } catch (e) {
        Get.snackbar(
          'data_error'.tr,
          'please_enter_valid_months'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }

      final startDateStr = DateFormat('yyyy-MM-dd').format(loanStartDate);

      // String loanActionValue = selectedLoanAction == "قرض شخصي"
      //     ? "personal"
      //     : "eos";

      // إعداد بيانات طلب القرض
      Map<String, dynamic> loanData = {
        'employee_id': employeeId,
        'loan_type': loanTypeId,
        'amount': amount,
        'start_date': startDateStr,
        // 'loan_action': loanActionValue,
        'no_of_months': months,
        'reason': loanReasonController.text.isEmpty
            ? 'loan_request'.tr
            : loanReasonController.text,
      };

      if (kDebugMode) {
        print('📝 Loan Request Data to Send: $loanData');
      }

      // إرسال الطلب
      var response = await AppConstant.client.callKw({
        'model': 'hr.loan',
        'method': 'create',
        'args': [loanData],
        'kwargs': {},
      });

      if (kDebugMode) {
        print('📝 Create Loan Request Response: $response');
      }

      if (response != null) {
        // إظهار رسالة نجاح أولاً
        Get.snackbar(
          'success'.tr,
          'loan_request_sent_success'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // تحديث قائمة القروض
        await getLoansByEmployeeId();

        // إعادة تعيين النموذج
        clearLoanRequestForm();

        // تأخير قصير للسماح بعرض رسالة النجاح
        await Future.delayed(const Duration(milliseconds: 800));

        // الانتقال إلى صفحة تاريخ القروض
        Get.back(); // العودة إلى الصفحة السابقة أولاً
        Get.toNamed(Routes.historyOfLoans); // ثم الذهاب إلى تاريخ القروض

        return true;
      } else {
        Get.snackbar(
          'operation_failed'.tr,
          'loan_request_not_created'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return false;
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في إنشاء طلب القرض: $e');
      }
      Get.snackbar(
        'error'.tr,
        'error_creating_loan'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return false;
    } finally {
      loadingCreateLoan = false;
      update();
    }
  }

  // دالة لإعادة تعيين نموذج طلب القرض
  void clearLoanRequestForm() {
    loanAmountController.clear();
    loanMonthsController.clear();
    loanReasonController.clear();
    selectedLoanType = 'select_loan_type_error'.tr;
    selectedLoanAction = 'قرض شخصي';
    loanStartDate = DateTime.now();
    update();
  }
}
