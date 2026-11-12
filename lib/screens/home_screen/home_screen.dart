import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/constant/app_constant.dart';
import 'package:orbit_workforce/constant/commenwidget.dart';
import 'package:orbit_workforce/screens/home_screen/domin/home_controller.dart';
import 'package:orbit_workforce/screens/home_screen/widgets/build_attendance_section.dart';
import 'package:orbit_workforce/screens/home_screen/widgets/show_attendance_dialog.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:flutter/foundation.dart';

class HomeScreen extends GetView<HomeController> {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final GetStorage box = GetStorage();

    return Scaffold(
      backgroundColor: ThemeColors.background,
      body: SafeArea(
        child: GetBuilder<HomeController>(
          builder: (homeController) {
            return homeController.loading
                ? const Center(
                    child: CircularProgressIndicator(color: Colors.blue),
                  )
                : Container(
                    color: ThemeColors.background,
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: Center(
                      child: Container(
                        constraints: BoxConstraints(
                          maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                        ),
                        padding: ResponsiveUtils.padding(
                          context: context,
                          horizontal: 20,
                          vertical: 20,
                        ),
                        child: SingleChildScrollView(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Builder(
                                        builder: (context) {
                                          final imageUrl =
                                              '${AppConstant.baseUrl}/web/image/hr.employee/${box.read("employee_id") ?? "default"}/avatar_128';
                                          if (kDebugMode) {
                                            print('🖼️ Avatar URL: $imageUrl');
                                            print(
                                              '📋 Employee ID: ${box.read("employee_id") ?? "No ID"}',
                                            );
                                            print(
                                              '🌐 Base URL: ${AppConstant.baseUrl}',
                                            );
                                          }
                                          return imageHandel(
                                            image: imageUrl,
                                            height: ResponsiveUtils.h(
                                              60,
                                              context,
                                            ),
                                            width: ResponsiveUtils.w(
                                              60,
                                              context,
                                            ),
                                            shape: BoxShape.circle,
                                          );
                                        },
                                      ),
                                      ResponsiveUtils.sizedBoxW(10, context),
                                      Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${"hello".tr}، ${homeController.getShortName(box.read("employee_name") ?? 'user'.tr)}",
                                            style: AppTextStyle
                                                .montserraSemiBold
                                                .copyWith(
                                                  fontSize: ResponsiveUtils.sp(
                                                    18,
                                                    context,
                                                  ),
                                                  color: ThemeColors.black,
                                                ),
                                          ),
                                          Text(
                                            box.read('job_title') ??
                                                'app_developer'.tr,
                                            style: AppTextStyle.montserraRegular
                                                .copyWith(
                                                  fontSize: ResponsiveUtils.sp(
                                                    12,
                                                    context,
                                                  ),
                                                  color: ThemeColors.gry,
                                                ),
                                          ),

                                          Text(
                                            " ${box.read("emp_seq") ?? ""}",
                                            style: AppTextStyle.montserraRegular
                                                .copyWith(
                                                  fontSize: ResponsiveUtils.sp(
                                                    10,
                                                    context,
                                                  ),
                                                  color: ThemeColors.gry,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      Get.toNamed(Routes.notification);
                                    },
                                    child: Image.asset(
                                      'assets/images/notification.png',
                                      height: ResponsiveUtils.iconSize(
                                        24,
                                        context,
                                      ),
                                      width: ResponsiveUtils.iconSize(
                                        24,
                                        context,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              ResponsiveUtils.sizedBoxH(20, context),
                              Row(
                                children: [
                                  Flexible(
                                    child: Text(
                                      homeController.formattedDate,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 18,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                  const SizedBox(width: 5),
                                  Flexible(
                                    child: Text(
                                      homeController.formattedTime,
                                      style: const TextStyle(
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        fontSize: 20,
                                        color: Colors.black,
                                      ),
                                      overflow: TextOverflow.ellipsis,
                                      maxLines: 1,
                                    ),
                                  ),
                                ],
                              ),
                              ResponsiveUtils.sizedBoxH(20, context),

                              ResponsiveUtils.sizedBoxH(20, context),

                              // قسم عرض بيانات الموظف
                              ResponsiveUtils.sizedBoxH(20, context),
                              Container(
                                width: double.infinity,
                                padding: ResponsiveUtils.padding(
                                  context: context,
                                  all: 24,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.r(20, context),
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.1,
                                      ),
                                      blurRadius: 10,
                                      spreadRadius: 2,
                                      offset: const Offset(0, 4),
                                    ),
                                  ],
                                ),
                                child: Column(
                                  children: [
                                    // اللمبة التي تشير لحالة العمل
                                    Container(
                                      width: ResponsiveUtils.w(20, context),
                                      height: ResponsiveUtils.h(20, context),
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: homeController.checkIn
                                            ? Colors.green
                                            : Colors.red,
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                (homeController.checkIn
                                                        ? Colors.green
                                                        : Colors.red)
                                                    .withValues(alpha: 0.3),
                                            blurRadius: 8,
                                            spreadRadius: 2,
                                          ),
                                        ],
                                      ),
                                    ),

                                    ResponsiveUtils.sizedBoxH(16, context),

                                    // نص حالة العمل
                                    Text(
                                      homeController.checkIn
                                          ? 'you_are_at_work'.tr
                                          : 'you_are_not_at_work'.tr,
                                      style: AppTextStyle.montserraSemiBold
                                          .copyWith(
                                            fontSize: ResponsiveUtils.sp(
                                              16,
                                              context,
                                            ),
                                            color: homeController.checkIn
                                                ? Colors.green
                                                : Colors.red,
                                          ),
                                    ),

                                    ResponsiveUtils.sizedBoxH(20, context),

                                    ResponsiveUtils.sizedBoxH(24, context),

                                    // زر الحضور/الانصراف
                                    GestureDetector(
                                      onTap: () {
                                        showAttendanceDialog(
                                          context,
                                          homeController,
                                        );
                                      },
                                      child: Container(
                                        width: ResponsiveUtils.w(120, context),
                                        height: ResponsiveUtils.h(120, context),
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: homeController.checkIn
                                                ? [
                                                    Colors.red[400]!,
                                                    HexColor('#02A4BF'),
                                                  ]
                                                : [
                                                    Colors.green[400]!,
                                                    HexColor('#02A4BF'),
                                                  ],
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color:
                                                  (homeController.checkIn
                                                          ? Colors.red[400]!
                                                          : Colors.green[400]!)
                                                      .withValues(alpha: 0.3),
                                              blurRadius: 15,
                                              spreadRadius: 3,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              homeController.checkIn
                                                  ? Icons.logout_rounded
                                                  : Icons.login_rounded,
                                              color: Colors.white,
                                              size: ResponsiveUtils.iconSize(
                                                36,
                                                context,
                                              ),
                                            ),
                                            ResponsiveUtils.sizedBoxH(
                                              4,
                                              context,
                                            ),
                                            Flexible(
                                              child: Text(
                                                homeController.checkIn
                                                    ? 'leave'.tr
                                                    : 'attendance'.tr,
                                                style: AppTextStyle
                                                    .montserraBold
                                                    .copyWith(
                                                      fontSize:
                                                          ResponsiveUtils.sp(
                                                            14,
                                                            context,
                                                          ),
                                                      color: Colors.white,
                                                    ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),

                                    ResponsiveUtils.sizedBoxH(16, context),

                                    // نص إرشادي
                                    Text(
                                      'press_to_register'.tr,
                                      style: AppTextStyle.montserraRegular
                                          .copyWith(
                                            fontSize: ResponsiveUtils.sp(
                                              12,
                                              context,
                                            ),
                                            color: Colors.grey[600],
                                          ),
                                    ),
                                  ],
                                ),
                              ),

                              // قسم عرض سجل الحضور والانصراف
                              ResponsiveUtils.sizedBoxH(20, context),
                              buildAttendanceSection(homeController),
                              ResponsiveUtils.sizedBoxH(20, context),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
          },
        ),
      ),
    );
  }
}
