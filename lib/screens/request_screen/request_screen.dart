import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class RequestScreen extends StatelessWidget {
  const RequestScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: ThemeColors.background,
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            'الطلبات',
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
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(
                'assets/images/no-request.png',
                height: ResponsiveUtils.sp(300, context),
                width: ResponsiveUtils.sp(290, context),
              ),
              SizedBox(height: ResponsiveUtils.sp(20, context)),
              Text(
                'لا توجد طلبات حتى الآن',
                style: AppTextStyle.montserraSemiBold.copyWith(
                  fontSize: ResponsiveUtils.sp(20, context),
                  color: ThemeColors.black,
                ),
              ),
              SizedBox(height: ResponsiveUtils.sp(30, context)),
              SizedBox(
                height: ResponsiveUtils.h(60, context),
                width: ResponsiveUtils.sp(290, context),
                child: GestureDetector(
                  onTap: () {},
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(12),
                      gradient: LinearGradient(
                        colors: [HexColor('#004ADB'), HexColor('#02A4BF')],
                        begin: const FractionalOffset(0.0, 0.0),
                        end: const FractionalOffset(0.8, 0.0),
                        stops: const [0.0, 1.0],
                        tileMode: TileMode.clamp,
                      ),
                    ),
                    child: Text(
                      'إنشاء طلب',
                      style: AppTextStyle.montserraSemiBold.copyWith(
                        color: ThemeColors.white,
                        fontSize: ResponsiveUtils.sp(18, context),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
