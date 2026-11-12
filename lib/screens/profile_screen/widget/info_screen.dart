import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'profile'.tr,
          style: AppTextStyle.montserraBold.copyWith(
            fontSize: ResponsiveUtils.sp(20, context),
            color: ThemeColors.black,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: Container(
          color: ThemeColors.background,
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 45.0,
                        backgroundImage: AssetImage('assets/images/person.png'),
                        backgroundColor: Colors.transparent,
                      ),
                      Text(
                        'عبدالله البسطامي',
                        style: AppTextStyle.montserraSemiBold.copyWith(
                          fontSize: ResponsiveUtils.sp(24, context),
                          color: ThemeColors.black,
                        ),
                      ),
                      const SizedBox(height: 1),
                      Text(
                        'مصمم واجهات الإستخدام',
                        style: AppTextStyle.montserraRegular.copyWith(
                          fontSize: ResponsiveUtils.sp(14, context),
                          color: ThemeColors.gry,
                        ),
                      ),
                      const SizedBox(height: 5),
                    ],
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(color: HexColor('#FAFAFA')),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/user.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'nationality'.tr,
                            style: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(16, context),
                              color: ThemeColors.black,
                            ),
                          ),
                          Text(
                            'مصري',
                            style: AppTextStyle.montserraRegular.copyWith(
                              fontSize: ResponsiveUtils.sp(11, context),
                              color: ThemeColors.gry,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.sp(10, context)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(color: HexColor('#FAFAFA')),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/clock.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'work_hours'.tr,
                            style: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(16, context),
                              color: ThemeColors.black,
                            ),
                          ),
                          Text(
                            '09:00 AM - 05:00 PM',
                            style: AppTextStyle.montserraRegular.copyWith(
                              fontSize: ResponsiveUtils.sp(11, context),
                              color: ThemeColors.gry,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.sp(10, context)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(color: HexColor('#FAFAFA')),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/call-calling.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'mobile'.tr,
                            style: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(16, context),
                              color: ThemeColors.black,
                            ),
                          ),
                          Text(
                            '+201062540409',
                            style: AppTextStyle.montserraRegular.copyWith(
                              fontSize: ResponsiveUtils.sp(11, context),
                              color: ThemeColors.gry,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.sp(10, context)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(color: HexColor('#FAFAFA')),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/moneys.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'salary'.tr,
                            style: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(16, context),
                              color: ThemeColors.black,
                            ),
                          ),
                          Text(
                            '7.000 ريال',
                            style: AppTextStyle.montserraRegular.copyWith(
                              fontSize: ResponsiveUtils.sp(11, context),
                              color: ThemeColors.gry,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.sp(10, context)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(color: HexColor('#FAFAFA')),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/Case.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'job_title'.tr,
                            style: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(16, context),
                              color: ThemeColors.black,
                            ),
                          ),
                          Text(
                            'مصمم تجربة الاستخدام',
                            style: AppTextStyle.montserraRegular.copyWith(
                              fontSize: ResponsiveUtils.sp(11, context),
                              color: ThemeColors.gry,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.sp(10, context)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(color: HexColor('#FAFAFA')),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/slider.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'id_number'.tr,
                            style: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(16, context),
                              color: ThemeColors.black,
                            ),
                          ),
                          Text(
                            '35268745213698',
                            style: AppTextStyle.montserraRegular.copyWith(
                              fontSize: ResponsiveUtils.sp(11, context),
                              color: ThemeColors.gry,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: ResponsiveUtils.sp(10, context)),
                Container(
                  width: MediaQuery.of(context).size.width,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(color: HexColor('#FAFAFA')),
                  child: Row(
                    children: [
                      Image.asset(
                        'assets/images/location.png',
                        height: 24,
                        width: 24,
                      ),
                      const SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'work_location'.tr,
                            style: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(16, context),
                              color: ThemeColors.black,
                            ),
                          ),
                          Text(
                            'مكتب الرياض',
                            style: AppTextStyle.montserraRegular.copyWith(
                              fontSize: ResponsiveUtils.sp(11, context),
                              color: ThemeColors.gry,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
