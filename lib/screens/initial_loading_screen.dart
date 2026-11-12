import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:orbit_workforce/constant/app_constant.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:orbit_workforce/screens/splash_screen/domin/splash_controller.dart';

/// Initial loading screen that appears on app start
/// This screen handles checking saved data and fetching databases
class InitialLoadingScreen extends StatefulWidget {
  const InitialLoadingScreen({super.key});

  @override
  State<InitialLoadingScreen> createState() => _InitialLoadingScreenState();
}

class _InitialLoadingScreenState extends State<InitialLoadingScreen> {
  final box = GetStorage();

  @override
  void initState() {
    super.initState();
    _initialize();
  }

  Future<void> _initialize() async {
    // Small delay to show the loading screen
    await Future.delayed(const Duration(milliseconds: 500));

    // Check saved data
    final savedEmployeeId = box.read('employee_id');
    final savedDatabaseUrl = box.read('database_url');

    if (savedEmployeeId != null && savedDatabaseUrl != null) {
      // User is logged in, try to re-authenticate
      AppConstant.updateDatabaseUrl(savedDatabaseUrl.toString());

      if (kDebugMode) {
        print('🔐 محاولة إعادة تسجيل الدخول...');
        print('   - Employee ID: $savedEmployeeId');
        print('   - Database URL: $savedDatabaseUrl');
      }

      // Try to re-authenticate with saved credentials
      final reAuthSuccess = await _tryReAuthenticate();

      if (reAuthSuccess) {
        if (kDebugMode) {
          print('✅ إعادة تسجيل الدخول ناجح - التوجه للصفحة الرئيسية');
        }
        Get.offAllNamed(Routes.navbar);
      } else {
        if (kDebugMode) {
          print('❌ إعادة تسجيل الدخول فشل - التوجه لصفحة Login');
        }
        Get.offAllNamed(Routes.login);
      }
      return;
    } else if (savedDatabaseUrl != null) {
      // Database selected but not logged in, go to login
      AppConstant.updateDatabaseUrl(savedDatabaseUrl.toString());

      if (kDebugMode) {
        print('⚠️ Database محفوظ - التوجه لصفحة Login');
      }

      Get.offAllNamed(Routes.login);
    } else {
      // No saved data, need to fetch databases first
      if (kDebugMode) {
        print('🚀 لا توجد بيانات - جلب Databases ثم عرض Splash');
      }

      await _fetchDatabasesAndNavigate();
    }
  }

  Future<void> _fetchDatabasesAndNavigate() async {
    try {
      // Create splash controller with permanent flag to keep it alive
      final controller = Get.put(SplashController(), permanent: true);

      // Perform admin login and fetch databases
      await controller.performRequiredLogin();

      print('✅ تم جلب ${controller.databasesList.length} databases');

      // Navigate to splash screen after databases are loaded
      Get.offAllNamed(Routes.splash);
    } catch (e) {
      print('❌ خطأ في جلب Databases: $e');
      // Still navigate to splash even if there's an error
      Get.offAllNamed(Routes.splash);
    }
  }

  /// Try to re-authenticate with saved credentials
  Future<bool> _tryReAuthenticate() async {
    try {
      // First, try with database company credentials
      final companyName = box.read('database_company_name');
      final companyPassword = box.read('database_password');
      final dbName = box.read('database_auth_name');

      if (companyName != null && companyPassword != null && dbName != null) {
        if (kDebugMode) {
          print('🔑 محاولة المصادقة بـ database credentials: $companyName');
        }

        try {
          // Try to authenticate with company credentials
          await AppConstant.client.authenticate(
            dbName.toString(),
            companyName.toString(),
            companyPassword.toString(),
          );

          if (kDebugMode) {
            print('✅ تم إعادة تسجيل الدخول بنجاح بـ company credentials');
          }

          return true;
        } catch (e) {
          if (kDebugMode) {
            print('⚠️ فشل المصادقة بـ company credentials: $e');
          }
        }
      }

      // If company credentials failed or not available, try with app credentials
      final savedEmail = box.read('app_email');
      final savedPassword = box.read('app_password');

      if (savedEmail != null && savedPassword != null && dbName != null) {
        if (kDebugMode) {
          print('🔑 محاولة المصادقة بـ app credentials: $savedEmail');
        }

        await AppConstant.client.authenticate(
          dbName.toString(),
          savedEmail.toString(),
          savedPassword.toString(),
        );

        if (kDebugMode) {
          print('✅ تم إعادة تسجيل الدخول بنجاح بـ app credentials');
        }

        return true;
      }

      if (kDebugMode) {
        print('⚠️ بيانات تسجيل الدخول غير كاملة');
      }
      return false;
    } catch (e) {
      if (kDebugMode) {
        print('❌ فشل إعادة تسجيل الدخول: $e');
      }
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Logo
            Image.asset(
              'assets/images/logo_black.png',
              width: ResponsiveUtils.w(180, context),
              height: ResponsiveUtils.h(70, context),
              fit: BoxFit.contain,
            ),
            ResponsiveUtils.sizedBoxH(40, context),
            // Loading indicator
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF004ADB)),
              strokeWidth: 3,
            ),
            ResponsiveUtils.sizedBoxH(24, context),
            Text(
              'loading_data_please_wait'.tr,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(16, context),
                color: const Color(0xFF004ADB),
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
