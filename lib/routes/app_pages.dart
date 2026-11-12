import 'package:get/get.dart';
import 'package:orbit_workforce/on_boarding/domain/on_boarding_binding.dart';
import 'package:orbit_workforce/screens/bottom_nav_bar/bottom_navbar.dart';
import 'package:orbit_workforce/screens/home_screen/domin/home_binding.dart';
import 'package:orbit_workforce/screens/home_screen/home_screen.dart';
import 'package:orbit_workforce/screens/login_screen/domin/login_binding.dart';
import 'package:orbit_workforce/screens/login_screen/login_screen.dart';
import 'package:orbit_workforce/on_boarding/indicatior_screen.dart';
import 'package:orbit_workforce/screens/my_payslips/domin/my_payslips_binding.dart';
import 'package:orbit_workforce/screens/my_payslips/my_payslips_screen.dart';
import 'package:orbit_workforce/screens/profile_screen/domin/profile_binding.dart';
import 'package:orbit_workforce/screens/profile_screen/widget/leave_balance.dart';
import 'package:orbit_workforce/screens/request_screen/create_permission_screen.dart';
import 'package:orbit_workforce/screens/request_screen/create_request_screen.dart';
import 'package:orbit_workforce/screens/request_screen/domin/permission_binding.dart';
import 'package:orbit_workforce/screens/request_screen/domin/request_binding.dart';
import 'package:orbit_workforce/screens/request_screen/history_of_leave_request.dart';
import 'package:orbit_workforce/screens/request_screen/history_of_loans.dart';
import 'package:orbit_workforce/screens/request_screen/create_loans_order.dart';
import 'package:orbit_workforce/screens/request_screen/permission_history.dart';
import 'package:orbit_workforce/screens/notification_screen/notification_screen.dart';
import 'package:orbit_workforce/screens/notification_screen/domin/notification_binding.dart';
import 'package:orbit_workforce/screens/splash_screen/splash_screen.dart';

import '../screens/splash_screen/domin/splash_binding.dart';
part 'app_routes.dart';

class AppPages {
  AppPages._();

  static const initial = Routes.splash;

  static final routes = [
    GetPage(
      name: _Paths.splash,
      page: () => SplashScreen(),
      bindings: [SplashBindings()],
    ),

    GetPage(
      name: _Paths.login,
      page: () => const LoginScreen(),
      bindings: [LoginBindings()],
    ),
    GetPage(
      name: _Paths.intro,
      page: () => const IndecatorPage(),
      bindings: [OnBoardingBindings()],
    ),

    GetPage(
      name: _Paths.navbar,
      page: () => const AnimatedBarExample(),
      bindings: [HomeBindings()],
    ),
    GetPage(
      name: _Paths.home,
      page: () => const HomeScreen(),
      bindings: [HomeBindings()],
    ),
    GetPage(
      name: _Paths.myPayslips,
      page: () => const MyPayslipsScreen(),
      bindings: [MyPayslipsBinding()],
    ),
    GetPage(
      name: _Paths.createRequest,
      page: () => CreateRequestScreen(),
      bindings: [RequestBindings()],
    ),
    GetPage(
      name: _Paths.historyRequest,
      page: () => const HistoryOfLeaveRequest(),
      bindings: [RequestBindings()],
    ),
    GetPage(
      name: _Paths.leaveBalance,
      page: () => const LeaveBalance(),
      bindings: [ProfileBindings()],
    ),
    GetPage(
      name: _Paths.historyOfLoans,
      page: () => const HistoryOfLoansScreen(),
      bindings: [RequestBindings()],
    ),
    GetPage(
      name: _Paths.createLoansOrder,
      page: () => const CreateLoansOrder(),
      bindings: [RequestBindings()],
    ),
    GetPage(
      name: _Paths.permissionHistory,
      page: () => const PermissionHistory(),
      bindings: [PermissionBinding()],
    ),
    GetPage(
      name: _Paths.createPermission,
      page: () => const CreatePermissionScreen(),
      bindings: [PermissionBinding()],
    ),
    GetPage(
      name: _Paths.notification,
      page: () => const NotificationScreen(),
      bindings: [NotificationBinding()],
    ),
  ];
}
