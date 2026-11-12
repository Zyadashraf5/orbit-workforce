import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:orbit_workforce/constant/app_constant.dart';
import 'package:orbit_workforce/model/permission_model.dart';
import 'package:intl/intl.dart';

class PermissionController extends GetxController {
  bool loading = false;
  GetStorage box = GetStorage();

  // قائمة طلبات الإذن
  List<PermissionModel> permissionRequestsList = [];
  List<PermissionModel> filteredPermissionRequestsList = [];

  // متغيرات الفلترة
  String selectedTypeFilter = 'all_permission_types'.tr;
  String selectedStateFilter = 'all_permission_statuses'.tr;
  List<String> typeFilterOptions = ['all_permission_types'.tr];
  List<String> stateFilterOptions = [
    'all_permission_statuses'.tr,
    'draft'.tr,
    'approved'.tr,
    'cancelled'.tr,
  ];

  // دالة للحصول على طلبات الإذن للموظف
  Future<void> getPermissionRequestsByEmployeeId() async {
    final employeeId = box.read('employee_id');

    if (employeeId == null) {
      if (kDebugMode) {
        print('❌ لا يوجد معرف موظف محفوظ للإذن');
      }
      return;
    }

    loading = true;
    update();

    try {
      // محاولة جلب البيانات من نموذج permission
      var response = await AppConstant.client.callKw({
        'model': 'permission',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['employee_id', '=', employeeId], // فلتر حسب الموظف
          ],
          'fields': [
            'id',
            'name',
            'employee_id',
            'type_id',
            'date',
            'hours',
            'state',
          ],
          'limit': 100,
          'order': 'create_date desc',
        },
      });

      if (kDebugMode) {
        print(
          '📝 Permission Requests Response for Employee $employeeId: $response',
        );
      }

      if (response.isNotEmpty) {
        // تنظيف القائمة الحالية
        permissionRequestsList.clear();

        // تحويل البيانات لـ models
        for (var item in response) {
          permissionRequestsList.add(PermissionModel.fromJson(item));
        }

        if (kDebugMode) {
          print(
            '✅ تم تحميل ${permissionRequestsList.length} طلب إذن للموظف $employeeId',
          );
        }

        // تحديث خيارات الفلترة وإعداد القائمة المفلترة
        updateFilterOptions();
        filteredPermissionRequestsList = List.from(permissionRequestsList);
      } else {
        if (kDebugMode) {
          print('⚠️ لا توجد طلبات إذن للموظف $employeeId في نموذج permission');
        }

        // محاولة جلب البيانات من نموذج hr.leave كبديل
        await _getLeaveRequestsAsPermissions(employeeId);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل طلبات الإذن: $e');
      }

      // في حالة الخطأ، محاولة جلب البيانات من hr.leave
      await _getLeaveRequestsAsPermissions(employeeId);
    } finally {
      loading = false;
      update();
    }
  }

  // دالة مساعدة لجلب بيانات hr.leave كبديل
  Future<void> _getLeaveRequestsAsPermissions(int employeeId) async {
    try {
      if (kDebugMode) {
        print('🔄 محاولة جلب البيانات من hr.leave كبديل...');
      }

      var response = await AppConstant.client.callKw({
        'model': 'hr.leave',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['employee_id', '=', employeeId],
            [
              'holiday_status_id',
              'in',
              _getPermissionLeaveTypeIds(),
            ], // فلتر أنواع الإذن
          ],
          'fields': [
            'id',
            'name',
            'employee_id',
            'holiday_status_id',
            'date_from',
            'duration_display',
            'state',
          ],
          'limit': 100,
          'order': 'create_date desc',
        },
      });

      if (kDebugMode) {
        print('📝 HR Leave Response as Permissions: $response');
      }

      if (response.isNotEmpty) {
        // تنظيف القائمة الحالية
        permissionRequestsList.clear();

        // تحويل البيانات لـ PermissionModel
        for (var item in response) {
          // تحويل hr.leave إلى PermissionModel
          var permissionData = _convertLeaveToPermission(item);
          permissionRequestsList.add(PermissionModel.fromJson(permissionData));
        }

        if (kDebugMode) {
          print(
            '✅ تم تحميل ${permissionRequestsList.length} طلب إذن من hr.leave للموظف $employeeId',
          );
        }

        // تحديث خيارات الفلترة وإعداد القائمة المفلترة
        updateFilterOptions();
        filteredPermissionRequestsList = List.from(permissionRequestsList);
      } else {
        if (kDebugMode) {
          print('⚠️ لا توجد طلبات إذن في hr.leave للموظف $employeeId');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في جلب البيانات من hr.leave: $e');
      }
    }
  }

  // دالة للحصول على معرفات أنواع الإذن في hr.leave
  List<int> _getPermissionLeaveTypeIds() {
    // يمكن تحسين هذا لاحقاً بجلب البيانات من قاعدة البيانات
    return [1, 2, 3, 4]; // معرفات أنواع الإذن
  }

  // دالة لجلب أنواع الإذن من قاعدة البيانات
  Future<List<Map<String, dynamic>>> getPermissionTypes() async {
    try {
      // جلب أنواع الإذن من نموذج permission.type
      var response = await AppConstant.client.callKw({
        'model': 'permission.type',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [], // جلب جميع الأنواع
          'fields': ['id', 'name', 'hours'],
          'limit': 50,
          'order': 'name asc',
        },
      });

      if (kDebugMode) {
        print('📝 Permission Types Response: $response');
      }

      if (response.isNotEmpty) {
        List<Map<String, dynamic>> types = [];
        for (var item in response) {
          types.add({
            'id': item['id'],
            'name': item['name'] ?? '',
            'hours': (item['hours'] ?? 1.0).toDouble(),
          });
        }

        if (kDebugMode) {
          print('✅ تم جلب ${types.length} نوع إذن من قاعدة البيانات');
          for (var type in types) {
            print('📋 ${type['name']} - ${type['hours']} ساعة');
          }
        }

        return types;
      } else {
        if (kDebugMode) {
          print('⚠️ لا توجد أنواع إذن في قاعدة البيانات');
        }
        return [];
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في جلب أنواع الإذن: $e');
      }
      return [];
    }
  }

  // دالة لتحويل hr.leave إلى تنسيق permission
  Map<String, dynamic> _convertLeaveToPermission(
    Map<String, dynamic> leaveData,
  ) {
    return {
      'id': leaveData['id'],
      'name': leaveData['name'] ?? '',
      'employee_id': leaveData['employee_id'] ?? [],
      'type_id': leaveData['holiday_status_id'] ?? [],
      'date': leaveData['date_from'] ?? '',
      'hours': _extractHoursFromDuration(leaveData['duration_display'] ?? ''),
      'state': leaveData['state'] ?? 'draft',
    };
  }

  // دالة لاستخراج عدد الساعات من النص
  double _extractHoursFromDuration(String duration) {
    try {
      // البحث عن رقم في النص
      RegExp regex = RegExp(r'(\d+(?:\.\d+)?)');
      Match? match = regex.firstMatch(duration);
      if (match != null) {
        return double.parse(match.group(1)!);
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في استخراج الساعات: $e');
      }
    }
    return 1.0; // قيمة افتراضية
  }

  // دوال الفلترة
  void applyFilters() {
    filteredPermissionRequestsList = permissionRequestsList.where((request) {
      bool matchesType = true;
      bool matchesState = true;

      // فلترة حسب نوع الإذن
      if (selectedTypeFilter != 'all_permission_types'.tr) {
        matchesType = request.typeName == selectedTypeFilter;
      }

      // فلترة حسب الحالة
      if (selectedStateFilter != 'all_permission_statuses'.tr) {
        matchesState = request.statusText == selectedStateFilter;
      }

      return matchesType && matchesState;
    }).toList();

    update();
  }

  void clearFilters() {
    selectedTypeFilter = 'all_permission_types'.tr;
    selectedStateFilter = 'all_permission_statuses'.tr;
    filteredPermissionRequestsList = List.from(permissionRequestsList);
    update();
  }

  void setTypeFilter(String type) {
    selectedTypeFilter = type;
    applyFilters();
  }

  void setStateFilter(String state) {
    selectedStateFilter = state;
    applyFilters();
  }

  void updateFilterOptions() {
    // تحديث خيارات فلترة نوع الإذن من أنواع الإذن المتاحة في النظام
    typeFilterOptions = ['all_permission_types'.tr];

    // استخدام أنواع الإذن من قاعدة البيانات
    for (var type in permissionTypesList) {
      if (!typeFilterOptions.contains(type['name'])) {
        typeFilterOptions.add(type['name']);
      }
    }

    // إضافة الأنواع الموجودة في الطلبات أيضاً (في حالة وجود أنواع غير موجودة في النظام)
    Set<String> uniqueTypes = permissionRequestsList
        .map((request) => request.typeName)
        .where((name) => name.isNotEmpty && name != 'غير محدد')
        .toSet();

    for (var typeName in uniqueTypes) {
      if (!typeFilterOptions.contains(typeName)) {
        typeFilterOptions.add(typeName);
      }
    }
  }

  // متغيرات إنشاء طلب إذن جديد
  bool isCreatingPermission = false;
  String selectedPermissionType = '';
  double selectedPermissionHours = 0.0;
  DateTime permissionDate = DateTime.now();
  TextEditingController permissionDescriptionController =
      TextEditingController();
  TextEditingController permissionHoursController = TextEditingController();

  // قائمة أنواع الإذن من قاعدة البيانات
  List<Map<String, dynamic>> permissionTypesList = [];

  // اسم الموظف
  String get employeeName {
    final name = box.read('employee_name');
    return name ?? 'not_specified'.tr;
  }

  // دالة تحديث البيانات
  Future<void> refreshData() async {
    await getPermissionRequestsByEmployeeId();
    await loadPermissionTypes(); // تحديث أنواع الإذن أيضاً
  }

  // دالة اختيار نوع الإذن
  void setSelectedPermissionType(String type, double hours) {
    selectedPermissionType = type;
    selectedPermissionHours = hours;
    // تحديث حقل الساعات تلقائياً
    permissionHoursController.text = hours.toStringAsFixed(2);
    update();
  }

  // دالة تحديث الساعات
  void updatePermissionHours(String value) {
    try {
      selectedPermissionHours = double.parse(value);
    } catch (e) {
      selectedPermissionHours = 0.0;
    }
    update();
  }

  // دالة اختيار تاريخ الإذن
  Future<void> selectPermissionDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: permissionDate,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 30)),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Colors.blue,
              onPrimary: Colors.white,
              onSurface: Colors.black,
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(foregroundColor: Colors.blue),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != permissionDate) {
      permissionDate = picked;
      update();
    }
  }

  // دالة تنسيق تاريخ الإذن
  String get formattedPermissionDate {
    final locale = Get.locale?.languageCode ?? 'ar';
    return DateFormat('EEEE, d MMMM yyyy', locale).format(permissionDate);
  }

  // دالة إنشاء طلب إذن جديد
  Future<void> createPermissionRequest() async {
    // التحقق من البيانات المطلوبة
    if (permissionTypesList.isEmpty) {
      Get.snackbar(
        'system_error'.tr,
        'no_permission_types_system'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (selectedPermissionType.isEmpty) {
      Get.snackbar(
        'incomplete_data'.tr,
        'please_choose_permission_type'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    if (permissionHoursController.text.isEmpty ||
        selectedPermissionHours <= 0) {
      Get.snackbar(
        'incomplete_data'.tr,
        'please_enter_hours'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
      return;
    }

    isCreatingPermission = true;
    update();

    try {
      // الحصول على معرف الموظف
      final employeeId = box.read('employee_id');
      if (employeeId == null) {
        Get.snackbar(
          'data_error'.tr,
          'employee_id_not_found'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
        return;
      }

      // تنسيق التاريخ
      final dateStr = DateFormat('yyyy-MM-dd').format(permissionDate);

      // محاولة إنشاء طلب في نموذج permission أولاً
      bool success = await _createPermissionInPermissionModel(
        employeeId,
        dateStr,
      );

      // إذا فشل، جرب إنشاء طلب في hr.leave
      if (!success) {
        success = await _createPermissionInLeaveModel(employeeId, dateStr);
      }

      if (success) {
        // إظهار رسالة نجاح
        Get.snackbar(
          'success'.tr,
          'permission_request_sent_successfully'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          duration: const Duration(seconds: 2),
        );

        // إعادة تعيين النموذج
        clearPermissionForm();

        // تأخير قصير للسماح بعرض رسالة النجاح
        await Future.delayed(const Duration(milliseconds: 800));

        // العودة إلى صفحة السجل
        Get.back();

        // تحديث البيانات في صفحة السجل
        await refreshData();
      } else {
        Get.snackbar(
          'operation_failed'.tr,
          'permission_request_failed'.tr,
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.red,
          colorText: Colors.white,
        );
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في إنشاء طلب الإذن: $e');
      }
      Get.snackbar(
        'error_occurred'.tr,
        'permission_request_error'.tr,
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    } finally {
      isCreatingPermission = false;
      update();
    }
  }

  // دالة إنشاء طلب في نموذج permission
  Future<bool> _createPermissionInPermissionModel(
    int employeeId,
    String dateStr,
  ) async {
    try {
      // إعداد بيانات طلب الإذن
      Map<String, dynamic> permissionData = {
        'employee_id': employeeId,
        'type_id': _getPermissionTypeId(selectedPermissionType),
        'date': dateStr,
        'hours': selectedPermissionHours,
        'name': permissionDescriptionController.text.isEmpty
            ? 'طلب إذن - $selectedPermissionType'
            : permissionDescriptionController.text,
        'state': 'draft', // حالة مسودة
      };

      if (kDebugMode) {
        print('📝 Permission Request Data to Send: $permissionData');
      }

      // إرسال الطلب
      var response = await AppConstant.client.callKw({
        'model': 'permission',
        'method': 'create',
        'args': [permissionData],
        'kwargs': {},
      });

      if (kDebugMode) {
        print('📝 Create Permission Request Response: $response');
      }

      return response != null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في إنشاء طلب في نموذج permission: $e');
      }
      return false;
    }
  }

  // دالة إنشاء طلب في نموذج hr.leave
  Future<bool> _createPermissionInLeaveModel(
    int employeeId,
    String dateStr,
  ) async {
    try {
      // إعداد بيانات طلب الإذن في hr.leave
      Map<String, dynamic> leaveData = {
        'employee_id': employeeId,
        'holiday_status_id': _getPermissionTypeId(selectedPermissionType),
        'request_date_from': dateStr,
        'request_date_to': dateStr, // نفس التاريخ للإذن
        'name': permissionDescriptionController.text.isEmpty
            ? 'طلب إذن - $selectedPermissionType'
            : permissionDescriptionController.text,
      };

      if (kDebugMode) {
        print('📝 Leave Request Data to Send: $leaveData');
      }

      // إرسال الطلب
      var response = await AppConstant.client.callKw({
        'model': 'hr.leave',
        'method': 'create',
        'args': [leaveData],
        'kwargs': {},
      });

      if (kDebugMode) {
        print('📝 Create Leave Request Response: $response');
      }

      return response != null;
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في إنشاء طلب في نموذج hr.leave: $e');
      }
      return false;
    }
  }

  // دالة للحصول على معرف نوع الإذن
  int _getPermissionTypeId(String typeName) {
    try {
      final selectedType = permissionTypesList.firstWhere(
        (type) => type['name'] == typeName,
      );
      return selectedType['id'];
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في العثور على معرف نوع الإذن: $e');
      }
      return 1; // قيمة افتراضية
    }
  }

  // دالة لإعادة تعيين نموذج طلب الإذن
  void clearPermissionForm() {
    selectedPermissionType = '';
    selectedPermissionHours = 0.0;
    permissionDate = DateTime.now();
    permissionDescriptionController.clear();
    permissionHoursController.clear();
    update();
  }

  // دالة لإنشاء بيانات تجريبية (للتطوير فقط)
  void createSampleData() {
    permissionRequestsList = [
      PermissionModel(
        id: 1,
        name: 'طلب إذن شخصي',
        employeeId: [1, 'SAMEH MAHER'],
        typeId: [1, 'One Hour'],
        date: '2025-09-02',
        hours: 1.0,
        state: 'approved',
      ),
      PermissionModel(
        id: 2,
        name: 'طلب إذن طبي',
        employeeId: [1, 'SAMEH MAHER'],
        typeId: [2, '2 Hours'],
        date: '2025-09-04',
        hours: 2.0,
        state: 'approved',
      ),
      PermissionModel(
        id: 3,
        name: 'طلب إذن عائلي',
        employeeId: [1, 'SAMEH MAHER'],
        typeId: [3, 'Half Day'],
        date: '2025-09-06',
        hours: 4.0,
        state: 'draft',
      ),
      PermissionModel(
        id: 4,
        name: 'طلب إذن طارئ',
        employeeId: [1, 'SAMEH MAHER'],
        typeId: [4, 'Full Day'],
        date: '2025-09-08',
        hours: 8.0,
        state: 'cancelled',
      ),
    ];

    updateFilterOptions();
    filteredPermissionRequestsList = List.from(permissionRequestsList);
    update();
  }

  @override
  void onInit() {
    super.onInit();
    filteredPermissionRequestsList = List.from(permissionRequestsList);

    // جلب البيانات الحقيقية من Odoo
    getPermissionRequestsByEmployeeId();
    loadPermissionTypes();
  }

  // دالة تحميل أنواع الإذن
  Future<void> loadPermissionTypes() async {
    try {
      permissionTypesList = await getPermissionTypes();
      // تحديث خيارات الفلترة بعد تحميل الأنواع
      updateFilterOptions();
      update();
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في تحميل أنواع الإذن: $e');
      }
    }
  }
}
