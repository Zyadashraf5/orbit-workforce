import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/lang/language_controller.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:orbit_workforce/screens/home_screen/domin/home_controller.dart';
import 'package:orbit_workforce/screens/my_payslips/my_payslips_screen.dart';
import 'package:orbit_workforce/screens/profile_screen/domin/profile_controller.dart';
import 'package:orbit_workforce/screens/profile_screen/widget/change_password.dart';
import 'package:orbit_workforce/screens/profile_screen/widget/info_screen.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

import '../../lang/translation.dart';

class ProfileScreen extends GetView<ProfileController> {
  ProfileScreen({super.key});

  @override
  final controller = Get.put(ProfileController());

  @override
  Widget build(BuildContext context) {
    final GetStorage box = GetStorage();
    Get.put(LanguageController());
    final bool isTablet = ResponsiveUtils.isTablet(context);
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'menu'.tr,
          style: AppTextStyle.montserraBold.copyWith(
            fontSize: ResponsiveUtils.sp(20, context),
            color: ThemeColors.black,
          ),
        ),
      ),
      body: Container(
        color: ThemeColors.background,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Align(
          alignment: isTablet ? Alignment.center : Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveUtils.getMaxContentWidth(context),
            ),
            padding: EdgeInsets.symmetric(
              horizontal: 20,
              vertical: isTablet ? 20 : 16,
            ),
            child: GetBuilder<ProfileController>(
              builder: (controller) {
                return SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GestureDetector(
                        onTap: () {
                          Get.to(const InfoScreen());
                        },
                        child: Container(
                          padding: const EdgeInsets.only(right: 60),
                          child: Column(
                            children: [
                              Text(
                                "${'good_morning'.tr}، ${Get.find<HomeController>().getShortName(box.read("employee_name") ?? 'user'.tr)}",
                                style: AppTextStyle.montserraSemiBold.copyWith(
                                  fontSize: ResponsiveUtils.sp(18, context),
                                  color: ThemeColors.black,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                              Text(
                                "${box.read("job_title")}".tr,
                                style: AppTextStyle.montserraRegular.copyWith(
                                  fontSize: ResponsiveUtils.sp(12, context),
                                  color: ThemeColors.gry,
                                ),
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(height: isTablet ? 40 : 8),
                      InkWell(
                        onTap: () {
                          Get.toNamed(Routes.leaveBalance);
                          print('dddddd');
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/day-icon.png',
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'leave_balance'.tr,
                                  style: AppTextStyle.montserraSemiBold
                                      .copyWith(
                                        fontSize: ResponsiveUtils.sp(
                                          18,
                                          context,
                                        ),
                                        color: ThemeColors.black,
                                      ),
                                ),
                                Text(
                                  'track_your_leave_balance'.tr,
                                  style: AppTextStyle.montserraRegular.copyWith(
                                    fontSize: ResponsiveUtils.sp(12, context),
                                    color: ThemeColors.gry,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),

                      // SizedBox(height: 20),
                      // Row(
                      //   children: [
                      //     Image.asset(
                      //       "assets/images/notification_icon.png",
                      //       height: 40,
                      //       width: 40,
                      //     ),
                      //     SizedBox(width: 10),
                      //     Column(
                      //       mainAxisAlignment: MainAxisAlignment.start,
                      //       crossAxisAlignment: CrossAxisAlignment.start,
                      //       children: [
                      //         Text(
                      //           "notifications".tr,
                      //           style: AppTextStyle.montserraSemiBold.copyWith(
                      //             fontSize: ResponsiveUtils.sp(18, context),
                      //             color: ThemeColors.black,
                      //           ),
                      //         ),
                      //         Text(
                      //           "control_app_notifications".tr,
                      //           style: AppTextStyle.montserraRegular.copyWith(
                      //             fontSize: ResponsiveUtils.sp(12, context),
                      //             color: ThemeColors.gry,
                      //           ),
                      //         ),
                      //       ],
                      //     ),
                      //     Spacer(),
                      //     Transform.scale(
                      //       transformHitTests: false,
                      //       scale: 0.8,
                      //       child: CupertinoSwitch(
                      //         value: controller.switchValue,
                      //         activeTrackColor: HexColor("004ADB"),
                      //         onChanged: (value) {
                      //           controller.switchValue = value;
                      //           controller.update();
                      //         },
                      //       ),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(
                        height: ResponsiveUtils.isTablet(context) ? 20 : 16,
                      ),
                      GestureDetector(
                        onTap: () {
                          Get.to(const ChangePassword());
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/password_icon.png',
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'security_settings'.tr,
                                  style: AppTextStyle.montserraSemiBold
                                      .copyWith(
                                        fontSize: ResponsiveUtils.sp(
                                          18,
                                          context,
                                        ),
                                        color: ThemeColors.black,
                                      ),
                                ),
                                Text(
                                  'change_account_password'.tr,
                                  style: AppTextStyle.montserraRegular.copyWith(
                                    fontSize: ResponsiveUtils.sp(12, context),
                                    color: ThemeColors.gry,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            const Icon(Icons.arrow_forward_ios, size: 20),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      InkWell(
                        onTap: () {
                          Get.to(() => const MyPayslipsScreen());
                        },
                        child: Row(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                color: HexColor('#E0F7FA'),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              padding: const EdgeInsets.all(8),
                              child: Icon(
                                Icons.attach_money,
                                color: HexColor('#00796B'),
                                size: 28,
                              ),
                            ),
                            const SizedBox(width: 14),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'mypayslips'.tr,
                                  style: AppTextStyle.montserraSemiBold
                                      .copyWith(
                                        fontSize: ResponsiveUtils.sp(
                                          18,
                                          context,
                                        ),
                                        color: ThemeColors.black,
                                      ),
                                ),
                                Text(
                                  'view_and_download_your_payslips'.tr,
                                  style: AppTextStyle.montserraRegular.copyWith(
                                    fontSize: ResponsiveUtils.sp(12, context),
                                    color: ThemeColors.gry,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Icon(
                              Icons.arrow_forward_ios,
                              size: 20,
                              color: ThemeColors.gry,
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 20 : 16),
                      InkWell(
                        onTap: () {
                          showModalBottomSheet(
                            context: context,
                            backgroundColor: Colors.grey.shade100,
                            barrierColor: Colors.black87.withValues(alpha: 0.5),
                            shape: const RoundedRectangleBorder(
                              borderRadius: BorderRadius.vertical(
                                top: Radius.circular(30),
                              ),
                            ),
                            builder: (builder) => GetBuilder<LanguageController>(
                              builder: (controller) {
                                return SizedBox(
                                  height: 200,
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      ListTile(
                                        leading: Image.asset(
                                          controller.flagImage,
                                          width: 24,
                                          height: 24,
                                        ),
                                        title: Text(
                                          TranslationService.getLanguageText(
                                            'en',
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          controller.changeLanguage('en');
                                          Navigator.pop(context);
                                        },
                                      ),
                                      ListTile(
                                        leading: Image.asset(
                                          controller.flagImages,
                                          width: 24,
                                          height: 24,
                                        ),
                                        title: Text(
                                          TranslationService.getLanguageText(
                                            'ar',
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ),
                                        onTap: () {
                                          controller.changeLanguage('ar');
                                          Navigator.pop(context);
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              },
                            ),
                          );
                        },

                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/lang_icon.png',
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 10),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'lang'.tr,
                                  style: AppTextStyle.montserraSemiBold
                                      .copyWith(
                                        fontSize: ResponsiveUtils.sp(
                                          18,
                                          context,
                                        ),
                                        color: ThemeColors.black,
                                      ),
                                ),
                                Text(
                                  'change_language_to_english'.tr,
                                  style: AppTextStyle.montserraRegular.copyWith(
                                    fontSize: ResponsiveUtils.sp(12, context),
                                    color: ThemeColors.gry,
                                  ),
                                ),
                              ],
                            ),
                            const Spacer(),
                            Text(
                              TranslationService.getLanguageText(
                                Get.locale?.languageCode ?? 'en',
                              ),
                              style: AppTextStyle.montserraRegular.copyWith(
                                fontSize: ResponsiveUtils.sp(16, context),
                                color: ThemeColors.black,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: isTablet ? 50 : 16),
                      InkWell(
                        onTap: () async {
                          // استخدام وظيفة logout الجديدة من LoginController

                          await controller.logout();
                        },
                        child: Row(
                          children: [
                            Image.asset(
                              'assets/images/logout_icon.png',
                              height: 40,
                              width: 40,
                            ),
                            const SizedBox(width: 10),
                            Text(
                              'logout_button'.tr,
                              style: AppTextStyle.montserraRegular.copyWith(
                                fontSize: ResponsiveUtils.sp(16, context),
                                color: HexColor('#F44336'),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}
