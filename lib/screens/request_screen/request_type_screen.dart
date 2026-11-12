import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class RequestTypeScreen extends StatelessWidget {
  const RequestTypeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bool isTablet = ResponsiveUtils.isTablet(context);

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ThemeColors.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'create_request'.tr,
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
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: isTablet ? 20 : 10),
                    Text(
                      'select_request_type'.tr,
                      style: AppTextStyle.montserraBold.copyWith(
                        fontSize: ResponsiveUtils.sp(18, context),
                        color: ThemeColors.black,
                      ),
                    ),
                    const SizedBox(height: 20),
                    profileContainer(
                      context,
                      'assets/images/type5.png',
                      'leave_request'.tr,
                      () {
                        Get.toNamed(Routes.historyRequest);
                      },
                    ),
                    const SizedBox(height: 20),
                    profileContainer(
                      context,
                      'assets/images/loans.png',
                      'loans_request'.tr,
                      () {
                        Get.toNamed(Routes.historyOfLoans);
                      },
                    ),
                    // profileContainer(
                    //   "assets/images/type4.png",
                    //   "work_task".tr,
                    //   () {},
                    // ),
                    const SizedBox(height: 20),
                    profileContainer(
                      context,
                      'assets/images/type3.png',
                      'permission_request'.tr,
                      () {
                        Get.toNamed(Routes.permissionHistory);
                      },
                    ),
                    // const SizedBox(height: 20),
                    // profileContainer(
                    //   "assets/images/type2.png",
                    //   "letter_request".tr,
                    //   () {},
                    // ),
                    // const SizedBox(height: 20),
                    // profileContainer(
                    //   "assets/images/type1.png",
                    //   "special_request".tr,
                    //   () {},
                    // ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget profileContainer(
    BuildContext context,
    String icon,
    String text,
    Function onTap,
  ) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return GestureDetector(
      onTap: () {
        onTap();
      },
      child: Container(
        width: double.infinity,
        height: 64,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(
              color: HexColor('#4F4F4F1A').withValues(alpha: 0.1),
              spreadRadius: 1,
              blurRadius: 3,
              offset: const Offset(1, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                SizedBox(
                  height: 40,
                  width: 40,
                  child: Image.asset(icon, height: 40, width: 40),
                ),
                SizedBox(width: screenWidth * 0.06),
                Text(
                  text,
                  style: AppTextStyle.montserraSemiBold.copyWith(
                    fontSize: ResponsiveUtils.sp(16, context),
                    color: ThemeColors.black,
                  ),
                ),
              ],
            ),
            Icon(
              Icons.arrow_forward_ios_rounded,
              size: 20,
              color: HexColor('#212121'),
            ),
          ],
        ),
      ),
    );
  }
}
