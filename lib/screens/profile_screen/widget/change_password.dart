import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/screens/profile_screen/domin/profile_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class ChangePassword extends GetView<ProfileController> {
  const ChangePassword({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'security_settings'.tr,
          style: AppTextStyle.montserraBold.copyWith(
            fontSize: ResponsiveUtils.sp(20, context),
            color: ThemeColors.black,
          ),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            child: GetBuilder<ProfileController>(
              builder: (controller) {
                final bottomInset = MediaQuery.of(context).viewInsets.bottom;
                return SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.asset(
                        'assets/images/change_password.png',
                        height: 190,
                        width: MediaQuery.of(context).size.width,
                      ),
                      const SizedBox(height: 25),
                      Text(
                        'current_app_password'.tr,
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
                          controller: controller.currentPasswordController,
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
                            hintText: 'current_app_password'.tr,
                            hintStyle: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(15, context),
                              color: ThemeColors.gry,
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
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'new_app_password'.tr,
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
                          controller: controller.newpasswordController,
                          obscureText: !controller.newPasswordVisible,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                              10,
                              0,
                              10,
                              0,
                            ),
                            filled: true,
                            fillColor: ThemeColors.white,
                            hintText: 'new_app_password'.tr,
                            hintStyle: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(15, context),
                              color: ThemeColors.gry,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on newPasswordVisible state choose the icon
                                controller.newPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: HexColor('#616161'),
                                size: 18,
                              ),
                              onPressed: () {
                                controller.newPasswordVisible =
                                    !controller.newPasswordVisible;
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
                      ),
                      const SizedBox(height: 10),
                      Text(
                        'confirm_new_app_password'.tr,
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
                          controller: controller.new2passwordController,
                          obscureText: !controller.confirmPasswordVisible,
                          decoration: InputDecoration(
                            contentPadding: const EdgeInsets.fromLTRB(
                              10,
                              0,
                              10,
                              0,
                            ),
                            filled: true,
                            fillColor: ThemeColors.white,
                            hintText: 'confirm_new_app_password'.tr,
                            hintStyle: AppTextStyle.montserraSemiBold.copyWith(
                              fontSize: ResponsiveUtils.sp(15, context),
                              color: ThemeColors.gry,
                            ),
                            suffixIcon: IconButton(
                              icon: Icon(
                                // Based on confirmPasswordVisible state choose the icon
                                controller.confirmPasswordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: HexColor('#616161'),
                                size: 18,
                              ),
                              onPressed: () {
                                controller.confirmPasswordVisible =
                                    !controller.confirmPasswordVisible;
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
                      ),
                      const SizedBox(height: 40),
                      Center(
                        child: SizedBox(
                          height: ResponsiveUtils.h(60, context),
                          width: MediaQuery.of(context).size.width * 0.65,
                          child: GestureDetector(
                            onTap: controller.isChangingPassword
                                ? null
                                : () {
                                    controller.changePassword();
                                  },
                            child: Container(
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                gradient: LinearGradient(
                                  colors: controller.isChangingPassword
                                      ? [Colors.grey, Colors.grey[400]!]
                                      : [
                                          HexColor('#004ADB'),
                                          HexColor('#02A4BF'),
                                        ],
                                  begin: const FractionalOffset(0.0, 0.0),
                                  end: const FractionalOffset(0.8, 0.0),
                                  stops: const [0.0, 1.0],
                                  tileMode: TileMode.clamp,
                                ),
                              ),
                              child: controller.isChangingPassword
                                  ? Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const SizedBox(
                                          width: 20,
                                          height: 20,
                                          child: CircularProgressIndicator(
                                            strokeWidth: 2,
                                            valueColor:
                                                AlwaysStoppedAnimation<Color>(
                                                  Colors.white,
                                                ),
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Text(
                                          'changing'.tr,
                                          style: AppTextStyle.montserraRegular
                                              .copyWith(
                                                color: ThemeColors.white,
                                                fontSize: ResponsiveUtils.sp(
                                                  18,
                                                  context,
                                                ),
                                              ),
                                        ),
                                      ],
                                    )
                                  : Text(
                                      'save'.tr,
                                      style: AppTextStyle.montserraRegular
                                          .copyWith(
                                            color: ThemeColors.white,
                                            fontSize: ResponsiveUtils.sp(
                                              18,
                                              context,
                                            ),
                                          ),
                                    ),
                            ),
                          ),
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
