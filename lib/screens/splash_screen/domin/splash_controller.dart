import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:odoo_rpc/odoo_rpc.dart';
import 'package:orbit_workforce/constant/app_constant.dart';
import 'package:orbit_workforce/constant/commenwidget.dart';
import 'package:orbit_workforce/model/user_model.dart';
import 'package:orbit_workforce/model/database_model.dart';
import 'package:orbit_workforce/routes/app_pages.dart';

class SplashController extends GetxController {
  final box = GetStorage();

  // Administrative credentials are intentionally absent from this client.

  // Admin client for initial login
  late OdooClient adminClient;

  // Database list
  List<DatabaseModel> databasesList = [];
  final RxBool isLoadingDatabases = false.obs;
  final RxBool isVerifyingDatabase = false.obs;

  // Flag to track if initial load is done
  bool _hasLoadedInitially = false;

  // Selected database
  DatabaseModel? selectedDatabase;

  @override
  void onInit() {
    super.onInit();
    // Initialize admin client
    adminClient = OdooClient('${AppConstant.adminDatabaseUrl}/odoo');
  }

  @override
  Future<void> onReady() async {
    // Only perform admin login if databases list is empty
    // This prevents duplicate login when navigating from InitialLoadingScreen
    if (databasesList.isEmpty) {
      print('⚠️ [SPLASH] Databases list فاضية - إعادة جلب Databases');
      await performRequiredLogin();
    } else {
      print('✅ [SPLASH] Databases list موجودة - تخطي admin login');
    }
    super.onReady();
  }

  /// Step 1: Perform required login with admin credentials
  Future<void> performRequiredLogin() async {
    throw UnsupportedError(
      'Client-side administrative discovery is disabled. Configure a server-side tenant directory instead.',
    );
  }

  /// Step 2: Fetch databases list from Odoo
  Future<void> fetchDatabasesList() async {
    // Only show loading if this is the first time
    if (!_hasLoadedInitially) {
      isLoadingDatabases.value = true;
    }

    try {
      if (kDebugMode) {
        print('📋 جاري جلب قائمة Databases...');
      }

      // Fetch databases using Odoo RPC
      // نحاول جلب كل الحقول، وإذا فشل نجلب الحقول الأساسية فقط
      dynamic response;
      try {
        response = await adminClient.callKw({
          'model': 'intel.link.databases',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'fields': [
              'id',
              'name',
              'url',
              'company_name',
              'password',
              'users_count',
              'date',
            ],
            'limit': 100,
          },
        });
      } catch (e) {
        if (kDebugMode) {
          print(
            '⚠️ فشل جلب الحقول الإضافية، محاولة جلب الحقول الأساسية فقط...',
          );
        }
        // إذا فشل، نجلب الحقول الأساسية فقط
        response = await adminClient.callKw({
          'model': 'intel.link.databases',
          'method': 'search_read',
          'args': [],
          'kwargs': {
            'fields': ['id', 'name', 'url', 'users_count', 'date'],
            'limit': 100,
          },
        });
      }

      if (kDebugMode) {
        print('📦 استجابة Databases: $response');
      }

      databasesList.clear();

      if (response is List && response.isNotEmpty) {
        for (var item in response) {
          if (kDebugMode) {
            print('📦 Database Item: $item');
          }
          databasesList.add(DatabaseModel.fromJson(item));
        }

        if (kDebugMode) {
          print('✅ تم جلب ${databasesList.length} database');
          for (var db in databasesList) {
            print(
              '  - ID: ${db.id}, Customer: ${db.customerName}, URL: ${db.databaseUrl}, Expiration: ${db.expirationDate}',
            );
          }
        }
      } else {
        if (kDebugMode) {
          print('⚠️ لا توجد databases');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('❌ خطأ في جلب قائمة Databases: $e');
      }

      mySnakBar(
        title: 'error'.tr,
        msg: '${'failed_fetch_databases'.tr}: $e',
        second: 5,
        color: Colors.red,
      );
    } finally {
      isLoadingDatabases.value = false;
      _hasLoadedInitially = true; // Mark as loaded
    }
  }

  /// Step 3: Verify database name and expiration date
  Future<bool> verifyDatabase(String databaseName) async {
    print('\n========================================');
    print('🔍 [CONTROLLER] تم استدعاء verifyDatabase');
    print('========================================');
    // تنظيف اسم قاعدة البيانات من المسافات الزائدة
    // إزالة المسافات من البداية والنهاية وإزالة المسافات المتعددة في المنتصف
    String cleanedName = databaseName.trim().replaceAll(
      RegExp(r'\s+'),
      ' ',
    ); // استبدال المسافات المتعددة بمسافة واحدة

    if (cleanedName.isEmpty) {
      print('❌ [CONTROLLER] الاسم فارغ');
      mySnakBar(
        title: 'error'.tr,
        msg: 'enter_database_name_error'.tr,
        second: 3,
        color: Colors.red,
      );
      return false;
    }

    isVerifyingDatabase.value = true;
    print('⏳ [CONTROLLER] تم تفعيل حالة التحقق...');

    if (kDebugMode) {
      print('🔍 البحث عن Database: "$cleanedName" (الأصلي: "$databaseName")');
      print('📋 عدد Databases المتاحة: ${databasesList.length}');
    }

    // Search for database by name (compare customer_name or extracted from URL)
    DatabaseModel? foundDatabase;

    for (var db in databasesList) {
      // Check if database name matches customer_name or extracted name from URL
      final dbName = (db.databaseName ?? '').toLowerCase().trim();
      final customerName = (db.customerName ?? '').toLowerCase().trim();
      final inputName = cleanedName.toLowerCase().trim();
      final databaseUrl = (db.databaseUrl ?? '').toLowerCase().trim();

      if (kDebugMode) {
        print('  🔎 مقارنة:');
        print('     Input: "$inputName"');
        print(
          '     Customer Name: "$customerName" (length: ${customerName.length})',
        );
        print('     Database Name: "$dbName" (length: ${dbName.length})');
        print('     Database URL: "$databaseUrl"');
      }

      // Match by customer_name (exact or contains)
      // Match by database_name (exact or contains)
      // Match if URL contains the input
      // Also check if customer_name or dbName is not empty before comparing
      bool isMatch = false;

      if (customerName.isNotEmpty) {
        isMatch = customerName == inputName || customerName.contains(inputName);
      }

      if (!isMatch && dbName.isNotEmpty) {
        isMatch = dbName == inputName || dbName.contains(inputName);
      }

      if (!isMatch && databaseUrl.isNotEmpty) {
        isMatch = databaseUrl.contains(inputName);
      }

      if (kDebugMode) {
        print('     Match: $isMatch');
      }

      if (isMatch) {
        foundDatabase = db;
        print('\n✅ [CONTROLLER] تم العثور على Database!');
        if (kDebugMode) {
          print('✅ تم العثور على Database: ${db.customerName} (ID: ${db.id})');
        }
        break;
      }
    }

    if (foundDatabase == null) {
      print('\n❌ [CONTROLLER] Database غير موجود!');
      if (kDebugMode) {
        print('❌ Database "$cleanedName" غير موجود في القائمة');
        print('📋 Databases المتاحة:');
        for (var db in databasesList) {
          print(
            '   - Customer: "${db.customerName}", DB Name: "${db.databaseName}"',
          );
        }
      }

      mySnakBar(
        title: 'error'.tr,
        msg: '${'database_name_incorrect'.tr}: "$cleanedName"',
        second: 5,
        color: Colors.red,
      );
      isVerifyingDatabase.value = false;
      return false;
    }

    // Check expiration date
    print('\n📅 [CONTROLLER] فحص تاريخ الانتهاء...');
    if (!foundDatabase.isExpirationDateValid) {
      print('❌ [CONTROLLER] تاريخ الانتهاء منتهي!');
      if (kDebugMode) {
        print('❌ تاريخ انتهاء Database منتهي: ${foundDatabase.expirationDate}');
      }

      mySnakBar(
        title: 'error'.tr,
        msg: '${'database_expired'.tr}: ${foundDatabase.expirationDate}',
        second: 5,
        color: Colors.red,
      );
      isVerifyingDatabase.value = false;
      return false;
    }

    selectedDatabase = foundDatabase;

    // Save database info to storage for future use
    if (foundDatabase.databaseUrl != null) {
      await box.write('database_url', foundDatabase.databaseUrl);
      await box.write(
        'database_name',
        foundDatabase.customerName ?? cleanedName,
      );
      // Save the actual database name for authentication
      await box.write('database_auth_name', foundDatabase.databaseName);
      print('💾 [CONTROLLER] تم حفظ Database URL و Name');
      if (kDebugMode) {
        print('💾 تم حفظ Database للتخزين:');
        print('   - URL: ${foundDatabase.databaseUrl}');
        print(
          '   - Customer Name: ${foundDatabase.customerName ?? cleanedName}',
        );
        print('   - Auth DB Name: ${foundDatabase.databaseName}');
      }
    }

    print('\n========================================');
    print('📦 [CONTROLLER] معلومات Database:');
    if (kDebugMode) {
      print('✅ Database تم التحقق منه: ${foundDatabase.customerName}');
      print('🌐 Database URL: ${foundDatabase.databaseUrl}');
      print('📅 Expiration Date: ${foundDatabase.expirationDate}');
      print('🏢 Company Name: ${foundDatabase.companyName}');
    }
    print('========================================\n');

    // Check if company name and password are available for auto-login
    final hasCompanyName =
        foundDatabase.companyName != null &&
        foundDatabase.companyName!.isNotEmpty;
    final hasPassword =
        foundDatabase.password != null && foundDatabase.password!.isNotEmpty;

    print('   🏢 Company Name: ${hasCompanyName ? "✅ موجود" : "❌ غير موجود"}');

    if (hasCompanyName && hasPassword) {
      print('🚀 [CONTROLLER] سيتم تسجيل الدخول التلقائي...');
      if (kDebugMode) {}

      // Perform auto-login with company name and password
      try {
        final loginSuccess = await performAutoLogin(
          cleanedName,
          foundDatabase.companyName!,
          foundDatabase.password!,
        );

        isVerifyingDatabase.value = false;
        print('⏹️ [CONTROLLER] تم إيقاف حالة التحقق');

        // If auto-login succeeded, navigate to home
        if (loginSuccess) {
          print(
            '\n✅ [CONTROLLER] Auto-login نجح - سيتم التوجه للصفحة الرئيسية',
          );
          print('========================================\n');
          return true;
        } else {
          // This shouldn't happen as we throw exception for no employee
          print('\n⚠️ [CONTROLLER] Auto-login فشل - البقاء في صفحة Splash');
          print('========================================\n');
          return false;
        }
      } catch (e) {
        isVerifyingDatabase.value = false;
        print('⏹️ [CONTROLLER] تم إيقاف حالة التحقق');

        if (e.toString().contains('NO_EMPLOYEE_FOUND')) {
          // Database connected successfully but no employee found
          // Navigate to login page
          print('\n✅ [CONTROLLER] Database متصل - التوجه لصفحة Login');
          print('========================================\n');
          return true; // Return true to navigate to login
        } else {
          // Connection error - stay on splash
          print('\n❌ [CONTROLLER] خطأ في الاتصال - البقاء في Splash');
          print('========================================\n');
          return false; // Return false to stay on splash
        }
      }
    } else {
      if (kDebugMode) {}

      // Just update the database URL and navigate to login
      AppConstant.updateDatabaseUrl(foundDatabase.databaseUrl!);

      if (kDebugMode) {
        print('✅ تم تحديث Database URL: ${foundDatabase.databaseUrl}');
        print('➡️ التوجه لصفحة تسجيل الدخول');
      }

      isVerifyingDatabase.value = false;
      print('⏹️ [CONTROLLER] تم إيقاف حالة التحقق');
      print('========================================\n');
      return true;
    }
  }

  /// Perform required login with selected database using entered name and password
  Future<bool> performRequiredLoginWithDatabase(String enteredName) async {
    throw UnsupportedError(
      'Administrative tenant login is disabled in this portfolio copy.',
    );
  }

  /// Perform auto-login with company name and password
  Future<bool> performAutoLogin(
    String customerName,
    String companyName,
    String password,
  ) async {
    print('\n🔐 [AUTO-LOGIN] بدء تسجيل الدخول التلقائي...');
    if (selectedDatabase == null || selectedDatabase!.databaseUrl == null) {
      print('❌ [AUTO-LOGIN] لم يتم اختيار Database');
      if (kDebugMode) {
        print('❌ لم يتم اختيار Database');
      }
      return false;
    }

    try {
      // Update AppConstant with selected database URL
      AppConstant.updateDatabaseUrl(selectedDatabase!.databaseUrl!);
      print('✅ [AUTO-LOGIN] تم تحديث Database URL');

      // Extract database name from URL
      String? dbName = selectedDatabase!.databaseName;

      // For Odoo SaaS (.odoo.com without .dev), try customer name as database name
      // if extracted name doesn't work
      final isSaaS =
          selectedDatabase!.databaseUrl != null &&
          !selectedDatabase!.databaseUrl!.contains('.dev.odoo.com');

      if (dbName == null) {
        // Fallback: use customer name for SaaS databases
        if (isSaaS && selectedDatabase!.customerName != null) {
          dbName = selectedDatabase!.customerName!.toLowerCase().trim();
          print(
            '⚠️ [AUTO-LOGIN] استخدام Customer Name كـ Database Name: $dbName',
          );
        } else {
          print('❌ [AUTO-LOGIN] خطأ في استخراج اسم Database');
          if (kDebugMode) {
            print('❌ خطأ في استخراج اسم Database');
          }
          return false;
        }
      }

      if (kDebugMode) {
        print('🔐 بدء تسجيل الدخول التلقائي...');
        print('🌐 Database: $dbName');
        print(
          '🌐 Database Type: ${isSaaS ? "SaaS (.odoo.com)" : "Dev (.dev.odoo.com)"}',
        );
        print('🏢 Company Name: $companyName');
      }

      print('📡 [AUTO-LOGIN] محاولة المصادقة مع Odoo...');
      print('   🌐 Database Name: $dbName');
      print('   🌐 Base URL: ${AppConstant.baseUrl}');
      print('   🏢 Company Name: $companyName');

      // For SaaS databases, try to get available databases list first
      List<String> availableDatabases = [];
      if (isSaaS) {
        try {
          print('🔍 [AUTO-LOGIN] جلب قائمة Databases المتاحة من Odoo SaaS...');
          final response = await http.get(
            Uri.parse('${AppConstant.baseUrl}/web/database/list'),
          );

          if (response.statusCode == 200) {
            final data = jsonDecode(response.body);
            if (data is Map && data['result'] is List) {
              availableDatabases = List<String>.from(data['result']);
              print(
                '✅ [AUTO-LOGIN] تم جلب ${availableDatabases.length} database متاح',
              );
              print('   📋 Databases المتاحة: $availableDatabases');
            }
          }
        } catch (e) {
          print('⚠️ [AUTO-LOGIN] فشل جلب قائمة Databases: $e');
        }
      }

      // Try authentication with extracted database name first
      dynamic session;
      List<String> dbNamesToTry = [dbName];

      // Add available databases from API if found
      if (availableDatabases.isNotEmpty) {
        dbNamesToTry.addAll(availableDatabases);
        // Remove duplicates while preserving order
        dbNamesToTry = dbNamesToTry.toSet().toList();
      }

      // Also try customer name if different
      if (selectedDatabase!.customerName != null &&
          !dbNamesToTry.contains(
            selectedDatabase!.customerName!.toLowerCase().trim(),
          )) {
        dbNamesToTry.add(selectedDatabase!.customerName!.toLowerCase().trim());
      }

      Exception? lastError;
      for (final tryDbName in dbNamesToTry) {
        try {
          print('🔄 [AUTO-LOGIN] محاولة المصادقة مع Database: $tryDbName');
          session = await AppConstant.client.authenticate(
            tryDbName,
            companyName,
            password,
          );

          print('   ✅ Database Name الصحيح: $tryDbName');
          break; // Success, exit loop
        } catch (e) {
          lastError = e is Exception ? e : Exception(e.toString());
          print('❌ [AUTO-LOGIN] فشل مع Database: $tryDbName');
          if (e.toString().contains('AccessError')) {
            continue; // Try next database name
          } else {
            // Other error, stop trying
            break;
          }
        }
      }

      if (session == null) {
        print('❌ [AUTO-LOGIN] فشلت جميع محاولات المصادقة');
        throw lastError ?? Exception('فشل تسجيل الدخول');
      }
      if (kDebugMode) {}

      // Save database credentials for auto-login on app restart
      // IMPORTANT: Save BEFORE searching for employee, so we have them even if search fails
      await box.write('database_company_name', companyName);
      await box.write('database_password', password);

      if (kDebugMode) {
        print('💾 [AUTO-LOGIN] تم حفظ بيانات Database للـ auto-login');
        print('   - company_name: $companyName');
      }

      print('🔍 [AUTO-LOGIN] البحث عن بيانات الموظف...');
      // Search for employee data
      final employeeResponse = await AppConstant.client.callKw({
        'model': 'hr.employee',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['email_app', '=', companyName.trim()],
            ['pass_app', '=', password.trim()],
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

      if (employeeResponse.isNotEmpty) {
        print('✅ [AUTO-LOGIN] تم العثور على بيانات الموظف');
        final employeeData = employeeResponse[0];

        print('💾 [AUTO-LOGIN] حفظ بيانات الموظف...');
        // Store employee data
        await box.write('employee_id', employeeData['id']);
        await box.write('employee_name', employeeData['name']);
        await box.write('work_email', employeeData['work_email']);
        await box.write('job_title', employeeData['job_title']);
        await box.write('work_phone', employeeData['work_phone'] ?? '');
        await box.write('emp_seq', employeeData['emp_seq'] ?? '');
        await box.write('work_location_ids', employeeData['work_location_ids']);

        print('✅ [AUTO-LOGIN] تم حفظ بيانات الموظف بنجاح');
        if (kDebugMode) {
          print('✅ تم حفظ بيانات الموظف');
        }

        print('🚀 [AUTO-LOGIN] التوجه للصفحة الرئيسية...');
        // Navigate to navbar (home screen)
        await continueNormalFlow();
        return true;
      } else {
        print('⚠️ [AUTO-LOGIN] لم يتم العثور على بيانات الموظف');
        if (kDebugMode) {
          print(
            '⚠️ لم يتم العثور على بيانات الموظف - التوجه لصفحة تسجيل الدخول',
          );
        }

        // Show message to user
        mySnakBar(
          title: 'info'.tr,
          msg: 'database_connected_please_login_with_employee_credentials'.tr,
          second: 4,
          color: Colors.blue,
        );

        // Database connection successful but no auto-login employee found
        // Navigate to login page - throw special exception to indicate this
        throw Exception('NO_EMPLOYEE_FOUND');
      }
    } catch (e) {
      // Check if this is our special exception
      if (e.toString().contains('NO_EMPLOYEE_FOUND')) {
        // Re-throw to be caught by verifyDatabase
        rethrow;
      }

      print('❌ [AUTO-LOGIN] خطأ: $e');
      if (kDebugMode) {
        print('❌ فشل تسجيل الدخول التلقائي: $e');
      }

      // Show error message to user for connection errors
      mySnakBar(
        title: 'error'.tr,
        msg: 'connection_error_or_invalid_credentials'.tr,
        second: 4,
        color: Colors.red,
      );

      // Re-throw to stay on splash screen
      rethrow;
    }
  }

  /// Step 4: Login with selected database URL and user credentials
  Future<bool> loginWithDatabase({
    required String email,
    required String password,
  }) async {
    if (selectedDatabase == null || selectedDatabase!.databaseUrl == null) {
      mySnakBar(
        title: 'error'.tr,
        msg: 'database_not_selected'.tr,
        second: 3,
        color: Colors.red,
      );
      return false;
    }

    if (email.isEmpty) {
      mySnakBar(
        title: 'error'.tr,
        msg: 'enter_email'.tr,
        second: 3,
        color: Colors.red,
      );
      return false;
    }

    if (password.isEmpty) {
      mySnakBar(
        title: 'error'.tr,
        msg: 'enter_password'.tr,
        second: 3,
        color: Colors.red,
      );
      return false;
    }

    try {
      // Update AppConstant with selected database URL
      AppConstant.updateDatabaseUrl(selectedDatabase!.databaseUrl!);

      if (kDebugMode) {
        print('🔐 بدء تسجيل الدخول بـ Database الجديد...');
        print('🌐 Database URL: ${selectedDatabase!.databaseUrl}');
        print('📧 Email: $email');
      }

      // Extract database name from URL
      final dbName = selectedDatabase!.databaseName;
      if (dbName == null) {
        mySnakBar(
          title: 'error'.tr,
          msg: 'database_name_extraction_error'.tr,
          second: 3,
          color: Colors.red,
        );
        return false;
      }

      // Authenticate with new database
      await AppConstant.client.authenticate(dbName, email, password);

      if (kDebugMode) {
        print('🌐 Database: $dbName');
      }

      // Search for employee data
      final employeeResponse = await AppConstant.client.callKw({
        'model': 'hr.employee',
        'method': 'search_read',
        'args': [],
        'kwargs': {
          'context': {'bin_size': true},
          'domain': [
            ['email_app', '=', email.trim()],
            ['pass_app', '=', password.trim()],
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

      if (employeeResponse.isNotEmpty) {
        final employeeData = employeeResponse[0];

        // Store employee data
        await box.write('employee_id', employeeData['id']);
        await box.write('employee_name', employeeData['name']);
        await box.write('work_email', employeeData['work_email']);
        await box.write('job_title', employeeData['job_title']);
        await box.write('work_phone', employeeData['work_phone'] ?? '');
        await box.write('emp_seq', employeeData['emp_seq'] ?? '');
        await box.write('work_location_ids', employeeData['work_location_ids']);

        if (kDebugMode) {
          print('✅ تم حفظ بيانات الموظف');
        }
      }

      await continueNormalFlow();
      return true;
    } catch (e) {
      if (kDebugMode) {
        print('❌ فشل تسجيل الدخول: $e');
      }

      mySnakBar(
        title: 'error'.tr,
        msg: '${'login_failed'.tr}: $e',
        second: 5,
        color: Colors.red,
      );
      return false;
    }
  }

  Future<void> continueNormalFlow() async {
    final employeeData = await getStoredUser();
    if (employeeData!.id != null) {
      Get.offAllNamed(Routes.navbar);
    } else {
      Get.offAllNamed(Routes.intro);
    }
  }

  Future<UserModel?> getStoredUser() async {
    final id = box.read('employee_id');
    final name = box.read('employee_name');
    final email = box.read('work_email');
    final jobTitle = box.read('job_title');
    final empSeq = box.read('emp_seq');
    final phone = box.read('work_phone');
    final workLocationId = box.read('work_location_ids');

    if (kDebugMode) {
      print('📖 === قراءة بيانات الموظف من التخزين ===');
      print('🆔 Employee ID: $id');
      print('👤 Name: $name');
      print('📧 Email: $email');
      print('💼 Job Title: $jobTitle');
      print('📞 Phone: $phone');
      print('🔢 Employee Sequence: $empSeq');
      print('🏢 Work Location ID: $workLocationId');
      print('📖 === نهاية قراءة البيانات ===');
    }

    return UserModel(
      id: id,
      name: name,
      email: email,
      jobTitle: jobTitle,
      empSeq: empSeq,
      phone: phone,
      workLocationId: workLocationId,
    );
  }
}
