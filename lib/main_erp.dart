import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:orbit_workforce/screens/initial_loading_screen.dart';

import 'lang/translation.dart';
import 'showcase/orbit_app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (const bool.fromEnvironment('ORBIT_DEMO', defaultValue: true)) {
    runApp(const OrbitApp());
    return;
  }

  try {
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }
  } catch (e) {
    debugPrint('Location permission error: $e');
  }

  // Initialize storage
  await GetStorage.init();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(390, 844),
      minTextAdapt: true,
      splitScreenMode: true,
      useInheritedMediaQuery: true,
      rebuildFactor: (old, data) => true,
      builder: (context, child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          locale: Get.deviceLocale,
          translations: TranslationService(),
          fallbackLocale: TranslationService.fallbackLocale,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            useMaterial3: true, // Enable Material 3
            colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
          ),
          home: const InitialLoadingScreen(),
          getPages: AppPages.routes,
          builder: (context, widget) {
            // تحديد الاتجاه بناءً على اللغة الحالية
            return Directionality(
              textDirection: Get.locale?.languageCode == 'ar'
                  ? TextDirection.rtl
                  : TextDirection.ltr,
              child: widget!,
            );
          },
        );
      },
    );
  }
}
