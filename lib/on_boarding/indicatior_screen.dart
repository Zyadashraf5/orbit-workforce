import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/on_boarding/domain/on_boarding_controller.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class IndecatorPage extends GetView<OnBordingController> {
  const IndecatorPage({super.key});

  @override
  Widget build(BuildContext context) {
    controller.height = MediaQuery.of(context).size.height;
    controller.width = MediaQuery.of(context).size.width;

    return Scaffold(
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final bottomInset = MediaQuery.of(context).viewInsets.bottom;
              return AnimatedPadding(
                duration: const Duration(milliseconds: 200),
                curve: Curves.easeOut,
                padding: EdgeInsets.only(bottom: bottomInset),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 24,
                    vertical: 24,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Expanded(
                        child: GetBuilder<OnBordingController>(
                          builder: (_) {
                            return PageView(
                              scrollDirection: Axis.horizontal,
                              controller: controller.controller,
                              reverse: false,
                              children: <Widget>[
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    SizedBox(height: 16.h),
                                    Expanded(
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 8.0,
                                        ),
                                        child: Image.asset(
                                          'assets/images/intro1.png',
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                    SizedBox(height: 20.h),
                                    Text(
                                      'مرحبا بك!',
                                      style: AppTextStyle.montserraSemiBold
                                          .copyWith(
                                            fontSize: 18.sp,
                                            color: ThemeColors.black,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'تابع ونظم أوقات عملك بسهولة ويسر',
                                      style: AppTextStyle.montserraBold
                                          .copyWith(
                                            fontSize: 28.sp,
                                            color: ThemeColors.black,
                                          ),
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 16.h),
                                  ],
                                ),
                                // Other pages here...
                              ],
                            );
                          },
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SmoothPageIndicator(
                        controller: controller.controller,
                        count: 3,
                        axisDirection: Axis.horizontal,
                        effect: SlideEffect(
                          activeDotColor: Colors.blue,
                          dotHeight: 10,
                          dotColor: HexColor('#E0E0E0'),
                          dotWidth: 20,
                        ),
                      ),
                      SizedBox(height: 24.h),
                      SizedBox(
                        width: double.infinity,
                        height: 54,
                        child: GestureDetector(
                          onTap: () {
                            Get.toNamed(Routes.login);
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
                              'إبدأ الآن',
                              style: AppTextStyle.montserraRegular.copyWith(
                                fontSize: 18.sp,
                                color: ThemeColors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
