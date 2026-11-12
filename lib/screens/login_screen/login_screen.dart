import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

import '../../colors/colors.dart';
import '../../lang/language_controller.dart';
import '../../lang/translation.dart';
import 'domin/login_controller.dart';

class LoginScreen extends GetView<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Container(
            color: Colors.white,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: GetBuilder<LoginController>(
                builder: (controller) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              GetBuilder<LanguageController>(
                                builder: (controller) {
                                  return PopupMenuButton<String>(
                                    onSelected: (value) {
                                      controller.changeLanguage(value);
                                    },
                                    itemBuilder: (context) => [
                                      PopupMenuItem(
                                        value: 'en',
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              TranslationService.getFlagForLanguage(
                                                'en',
                                              ),
                                              width: 20,
                                              height: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              TranslationService.getLanguageText(
                                                'en',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                      PopupMenuItem(
                                        value: 'ar',
                                        child: Row(
                                          children: [
                                            Image.asset(
                                              TranslationService.getFlagForLanguage(
                                                'ar',
                                              ),
                                              width: 20,
                                              height: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              TranslationService.getLanguageText(
                                                'ar',
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                    child: Row(
                                      children: [
                                        Image.asset(
                                          controller.flagImage,
                                          width: 24,
                                          height: 24,
                                        ), // Display the selected flag
                                        const SizedBox(width: 8),
                                        Text(
                                          TranslationService.getLanguageText(
                                            controller.selectedLanguage,
                                          ),
                                          style: const TextStyle(
                                            color: Colors.black,
                                          ),
                                        ), // Display the selected language
                                        const Icon(
                                          Icons.arrow_drop_down,
                                        ), // Dropdown icon
                                      ],
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ],
                      ),
                      Center(
                        child: Text(
                          'login'.tr,
                          style: AppTextStyle.montserraBold.copyWith(
                            fontSize: ResponsiveUtils.sp(20, context),
                            color: ThemeColors.black,
                          ),
                        ),
                      ),
                      Center(
                        child: LayoutBuilder(
                          builder: (context, constraints) {
                            final double availableWidth = constraints.maxWidth;
                            final double calculatedSize = availableWidth * 0.45;
                            final double logoSize = math.max(
                              120.0,
                              math.min(calculatedSize, 260.0),
                            );

                            return SizedBox(
                              height: logoSize,
                              width: logoSize,
                              child: Image.asset(
                                'assets/images/logo_black.png',
                                fit: BoxFit.contain,
                              ),
                            );
                          },
                        ),
                      ),
                      ResponsiveUtils.sizedBoxH(30, context),
                      Text(
                        'email'.tr,
                        style: AppTextStyle.montserraRegular.copyWith(
                          fontSize: ResponsiveUtils.sp(15, context),
                          color: ThemeColors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      SizedBox(
                        height: ResponsiveUtils.h(60, context),
                        child: TextFormField(
                          keyboardType: TextInputType.text,
                          controller: controller.emailController,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                              10,
                              0,
                              10,
                              0,
                            ),
                            filled: true,
                            fillColor: ThemeColors.white,
                            hintText: 'email'.tr,
                            hintStyle: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(15, context),
                              color: ThemeColors.gry,
                            ),
                            prefixIcon: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Image.asset(
                                'assets/images/sms.png',
                                height: 20,
                                width: 20,
                              ),
                            ),
                            errorBorder: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(color: Colors.red),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: HexColor('#EEEEEE'),
                                width: 1.5,
                              ),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: HexColor('#EEEEEE'),
                                width: 1.5,
                              ),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: const BorderRadius.all(
                                Radius.circular(10.0),
                              ),
                              borderSide: BorderSide(
                                color: HexColor('#EEEEEE'),
                                width: 1.5,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'pass'.tr,
                        style: AppTextStyle.montserraRegular.copyWith(
                          fontSize: ResponsiveUtils.sp(15, context),
                          color: ThemeColors.black,
                        ),
                      ),
                      const SizedBox(height: 5),
                      TextFormField(
                        keyboardType: TextInputType.text,
                        controller: controller.passwordController,
                        obscureText: !controller.passwordVisible,
                        decoration: InputDecoration(
                          contentPadding: const EdgeInsets.fromLTRB(
                            10,
                            0,
                            10,
                            0,
                          ),
                          filled: true,
                          fillColor: ThemeColors.white,
                          hintText: 'pass'.tr,
                          hintStyle: AppTextStyle.montserraSemiBold.copyWith(
                            fontSize: ResponsiveUtils.sp(15, context),
                            color: ThemeColors.gry,
                          ),
                          prefixIcon: Padding(
                            padding: const EdgeInsets.all(14.0),
                            child: Image.asset(
                              'assets/images/lock.png',
                              height: 20,
                              width: 20,
                            ),
                          ),
                          suffixIcon: IconButton(
                            icon: Icon(
                              // Based on passwordVisible state choose the icon
                              controller.passwordVisible
                                  ? Icons.visibility
                                  : Icons.visibility_off,
                              color: HexColor('#616161'),
                              size: 18,
                            ),
                            onPressed: () {
                              controller.passwordVisible =
                                  !controller.passwordVisible;
                              controller.update();
                            },
                          ),
                          errorBorder: const OutlineInputBorder(
                            borderRadius: BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(color: Colors.red),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: HexColor('#EEEEEE'),
                              width: 1.5,
                            ),
                          ),
                          enabledBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: HexColor('#EEEEEE'),
                              width: 1.5,
                            ),
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: const BorderRadius.all(
                              Radius.circular(10.0),
                            ),
                            borderSide: BorderSide(
                              color: HexColor('#EEEEEE'),
                              width: 1.5,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      SizedBox(
                        height: ResponsiveUtils.h(60, context),
                        width: double.infinity,
                        child: GestureDetector(
                          onTap: () {
                            controller.loginToOdoo();
                          },
                          child: Container(
                            alignment: Alignment.center,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              gradient: LinearGradient(
                                colors: [
                                  HexColor('#004ADB'),
                                  HexColor('#02A4BF'),
                                ],
                                begin: const FractionalOffset(0.0, 0.0),
                                end: const FractionalOffset(0.8, 0.0),
                                stops: const [0.0, 1.0],
                                tileMode: TileMode.clamp,
                              ),
                            ),
                            child: Text(
                              'login'.tr,
                              style: AppTextStyle.montserraRegular.copyWith(
                                color: ThemeColors.white,
                                fontSize: ResponsiveUtils.sp(18, context),
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: ResponsiveUtils.h(50, context),
                        width: double.infinity,
                        child: OutlinedButton(
                          onPressed: () async {
                            // Switch organization - same as logout
                            await controller.logout();
                          },
                          style: OutlinedButton.styleFrom(
                            side: BorderSide(
                              color: HexColor('#004ADB'),
                              width: 1.5,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: Text(
                            'switch_organization'.tr,
                            style: AppTextStyle.montserraRegular.copyWith(
                              color: HexColor('#004ADB'),
                              fontSize: ResponsiveUtils.sp(16, context),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }
}
