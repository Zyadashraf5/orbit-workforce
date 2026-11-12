import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:orbit_workforce/screens/splash_screen/domin/splash_controller.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:orbit_workforce/lang/language_controller.dart';
import 'package:orbit_workforce/lang/translation.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';

class SplashScreen extends GetView<SplashController> {
  SplashScreen({super.key});

  // Controller for organization name input
  final TextEditingController _organizationNameController =
      TextEditingController();

  @override
  Widget build(BuildContext context) {
    Get.put(SplashController());
    // Removed print to reduce console spam during rebuilds
    // print('🎬 [SPLASH] بناء شاشة Splash');

    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: Stack(
          children: [
            // Main content
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: Obx(() {
                if (controller.isLoadingDatabases.value) {
                  // Loading state - only shown once during initial load
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(
                            Color(0xFF004ADB),
                          ),
                          strokeWidth: 3,
                        ),
                        SizedBox(height: ResponsiveUtils.h(24, context)),
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
                  );
                }

                // Main UI - rebuilds are normal for Flutter widgets
                return Center(
                  child: SingleChildScrollView(
                    physics: const ClampingScrollPhysics(),
                    child: Padding(
                      padding: ResponsiveUtils.padding(
                        context: context,
                        horizontal: 32,
                        vertical: 40,
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Logo at the top
                          Image.asset(
                            'assets/images/logo_black.png',
                            width: ResponsiveUtils.w(180, context),
                            height: ResponsiveUtils.h(70, context),
                            fit: BoxFit.contain,
                          ),
                          SizedBox(height: ResponsiveUtils.h(60, context)),
                          // Title
                          Text(
                            'switch_organization'.tr,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(28, context),
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF1A1A1A),
                              letterSpacing: -0.5,
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.h(12, context)),
                          Text(
                            'enter_organization_desc'.tr,
                            style: TextStyle(
                              fontSize: ResponsiveUtils.sp(14, context),
                              color: const Color(0xFF6B7280),
                              fontWeight: FontWeight.w400,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          SizedBox(height: ResponsiveUtils.h(48, context)),
                          // Organization Name Input
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.r(12, context),
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(
                                    0xFF004ADB,
                                  ).withValues(alpha: 0.06),
                                  blurRadius: 20,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: TextField(
                              controller: _organizationNameController,
                              style: TextStyle(
                                fontSize: ResponsiveUtils.sp(16, context),
                                color: const Color(0xFF1A1A1A),
                                fontWeight: FontWeight.w500,
                              ),
                              decoration: InputDecoration(
                                hintText: 'organization_name'.tr,
                                hintStyle: TextStyle(
                                  color: const Color(0xFFBBBBBB),
                                  fontSize: ResponsiveUtils.sp(16, context),
                                  fontWeight: FontWeight.w400,
                                ),
                                filled: true,
                                fillColor: Colors.white,
                                contentPadding: ResponsiveUtils.padding(
                                  context: context,
                                  horizontal: 24,
                                  vertical: 20,
                                ),
                                prefixIcon: Container(
                                  margin: ResponsiveUtils.padding(
                                    context: context,
                                    left: 12,
                                    right: 12,
                                  ),
                                  child: Icon(
                                    Icons.business_outlined,
                                    color: const Color(0xFF004ADB),
                                    size: ResponsiveUtils.iconSize(24, context),
                                  ),
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.r(12, context),
                                  ),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 1.5,
                                  ),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.r(12, context),
                                  ),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE5E7EB),
                                    width: 1.5,
                                  ),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.r(12, context),
                                  ),
                                  borderSide: const BorderSide(
                                    color: Color(0xFF004ADB),
                                    width: 2,
                                  ),
                                ),
                              ),
                              autofocus: true,
                              textInputAction: TextInputAction.done,
                              onSubmitted: (_) async {
                                if (!controller.isVerifyingDatabase.value) {
                                  final cleanedText =
                                      _organizationNameController.text
                                          .trim()
                                          .replaceAll(RegExp(r'\s+'), ' ');
                                  print(
                                    '⌨️ [SPLASH] تم الضغط على Enter - النص: "$cleanedText"',
                                  );
                                  await _handleDatabaseVerification(
                                    context,
                                    cleanedText,
                                  );
                                }
                              },
                            ),
                          ),
                          SizedBox(height: ResponsiveUtils.h(32, context)),
                          // Submit Button
                          Obx(
                            () => controller.isVerifyingDatabase.value
                                ? Container(
                                    padding: ResponsiveUtils.padding(
                                      context: context,
                                      vertical: 20,
                                    ),
                                    child: Column(
                                      children: [
                                        const CircularProgressIndicator(
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                                Color(0xFF004ADB),
                                              ),
                                          strokeWidth: 3,
                                        ),
                                        SizedBox(
                                          height: ResponsiveUtils.h(
                                            20,
                                            context,
                                          ),
                                        ),
                                        Text(
                                          'verifying_database'.tr,
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils.sp(
                                              15,
                                              context,
                                            ),
                                            color: const Color(0xFF004ADB),
                                            fontWeight: FontWeight.w500,
                                          ),
                                        ),
                                      ],
                                    ),
                                  )
                                : Container(
                                    width: double.infinity,
                                    height: ResponsiveUtils.h(56, context),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(
                                        ResponsiveUtils.r(12, context),
                                      ),
                                      gradient: const LinearGradient(
                                        colors: [
                                          Color(0xFF004ADB),
                                          Color(0xFF02A4BF),
                                        ],
                                        begin: Alignment.centerLeft,
                                        end: Alignment.centerRight,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: const Color(
                                            0xFF004ADB,
                                          ).withValues(alpha: 0.3),
                                          blurRadius: 20,
                                          offset: const Offset(0, 10),
                                        ),
                                      ],
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () async {
                                        final cleanedText =
                                            _organizationNameController.text
                                                .trim()
                                                .replaceAll(
                                                  RegExp(r'\s+'),
                                                  ' ',
                                                );
                                        print(
                                          '🔘 [SPLASH] تم الضغط على زر Submit - النص: "$cleanedText"',
                                        );
                                        await _handleDatabaseVerification(
                                          context,
                                          cleanedText,
                                        );
                                      },
                                      style: ElevatedButton.styleFrom(
                                        backgroundColor: Colors.transparent,
                                        foregroundColor: Colors.white,
                                        shadowColor: Colors.transparent,
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            ResponsiveUtils.r(12, context),
                                          ),
                                        ),
                                        elevation: 0,
                                      ),
                                      child: Text(
                                        'continue_button'.tr,
                                        style: TextStyle(
                                          fontSize: ResponsiveUtils.sp(
                                            17,
                                            context,
                                          ),
                                          fontWeight: FontWeight.w600,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                  ),
                          ),
                          SizedBox(height: ResponsiveUtils.h(40, context)),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
            // Language button at top left
            Positioned(
              top: ResponsiveUtils.h(20, context),
              left: ResponsiveUtils.w(20, context),
              child: GetBuilder<LanguageController>(
                init: LanguageController(),
                builder: (langController) {
                  return Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.r(12, context),
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          blurRadius: 15,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: PopupMenuButton<String>(
                      onSelected: (value) {
                        langController.changeLanguage(value);
                      },
                      offset: const Offset(0, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.r(12, context),
                        ),
                      ),
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'en',
                          child: Row(
                            children: [
                              Image.asset(
                                TranslationService.getFlagForLanguage('en'),
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                TranslationService.getLanguageText('en'),
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(15, context),
                                  fontWeight: FontWeight.w500,
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
                                TranslationService.getFlagForLanguage('ar'),
                                width: 24,
                                height: 24,
                              ),
                              const SizedBox(width: 12),
                              Text(
                                TranslationService.getLanguageText('ar'),
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(15, context),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      child: Padding(
                        padding: ResponsiveUtils.padding(
                          context: context,
                          horizontal: 14,
                          vertical: 10,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Image.asset(
                              langController.flagImage,
                              width: 24,
                              height: 24,
                            ),
                            SizedBox(width: ResponsiveUtils.w(8, context)),
                            Text(
                              TranslationService.getLanguageText(
                                langController.selectedLanguage,
                              ),
                              style: TextStyle(
                                color: const Color(0xFF1A1A1A),
                                fontSize: ResponsiveUtils.sp(15, context),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            SizedBox(width: ResponsiveUtils.w(4, context)),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: const Color(0xFF004ADB),
                              size: ResponsiveUtils.iconSize(20, context),
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Handle database verification
  Future<void> _handleDatabaseVerification(
    BuildContext context,
    String databaseName,
  ) async {
    print('🔍 [SPLASH] بدء التحقق من Database: "$databaseName"');
    final isValid = await controller.verifyDatabase(databaseName);

    if (isValid) {
      print('✅ [SPLASH] التحقق نجح - التوجه لصفحة Login');
      Get.offNamed(Routes.login);
    } else {
      print('❌ [SPLASH] التحقق فشل');
    }
  }
}
