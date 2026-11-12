import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/model/time_off_model.dart';
import 'package:orbit_workforce/screens/profile_screen/domin/profile_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class LeaveBalance extends GetView<ProfileController> {
  const LeaveBalance({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: ThemeColors.black),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'leave_balance'.tr,
          style: AppTextStyle.montserraBold.copyWith(
            fontSize: ResponsiveUtils.sp(20, context),
            color: ThemeColors.black,
          ),
        ),
        actions: [
          GetBuilder<ProfileController>(
            builder: (controller) => controller.loadingLeaveBalance
                ? Container(
                    margin: EdgeInsets.only(
                      right: ResponsiveUtils.w(16, context),
                    ),
                    width: ResponsiveUtils.w(24, context),
                    height: ResponsiveUtils.h(24, context),
                    child: CircularProgressIndicator(
                      strokeWidth: ResponsiveUtils.w(2, context),
                      color: HexColor('#004ADB'),
                    ),
                  )
                : Container(
                    margin: EdgeInsets.only(
                      right: ResponsiveUtils.w(16, context),
                    ),
                    decoration: BoxDecoration(
                      color: HexColor('#004ADB').withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.r(8, context),
                      ),
                    ),
                    child: IconButton(
                      onPressed: () => controller.getLeaveBalance(),
                      icon: Icon(
                        Icons.refresh,
                        color: HexColor('#004ADB'),
                        size: ResponsiveUtils.iconSize(20, context),
                      ),
                    ),
                  ),
          ),
        ],
      ),
      body: Container(
        color: ThemeColors.background,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        padding: ResponsiveUtils.padding(
          context: context,
          horizontal: 20,
          vertical: 20,
        ),
        child: Container(
          padding: ResponsiveUtils.padding(context: context, all: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
            boxShadow: [
              BoxShadow(
                color: HexColor('#4F4F4F1A').withValues(alpha: 0.1),
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(1, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GetBuilder<ProfileController>(
                builder: (controller) {
                  if (controller.loadingLeaveBalance) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(
                              color: HexColor('#004ADB'),
                            ),
                            ResponsiveUtils.sizedBoxH(16, context),
                            Text(
                              'loading'.tr,
                              style: AppTextStyle.montserraRegular.copyWith(
                                fontSize: ResponsiveUtils.sp(14, context),
                                color: ThemeColors.gry,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (controller.errorMessage.isNotEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.error_outline,
                              size: ResponsiveUtils.iconSize(48, context),
                              color: Colors.red,
                            ),
                            ResponsiveUtils.sizedBoxH(16, context),
                            Text(
                              controller.errorMessage,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.montserraRegular.copyWith(
                                fontSize: ResponsiveUtils.sp(14, context),
                                color: Colors.red,
                              ),
                            ),
                            ResponsiveUtils.sizedBoxH(20, context),
                            Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(
                                  ResponsiveUtils.r(8, context),
                                ),
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
                              child: ElevatedButton(
                                onPressed: () => controller.getLeaveBalance(),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: ResponsiveUtils.w(24, context),
                                    vertical: ResponsiveUtils.h(12, context),
                                  ),
                                ),
                                child: Text(
                                  'retry'.tr,
                                  style: AppTextStyle.montserraSemiBold
                                      .copyWith(
                                        fontSize: ResponsiveUtils.sp(
                                          14,
                                          context,
                                        ),
                                        color: Colors.white,
                                      ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  if (controller.leaveBalanceList.isEmpty) {
                    return Expanded(
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.event_busy,
                              size: ResponsiveUtils.iconSize(48, context),
                              color: ThemeColors.gry,
                            ),
                            ResponsiveUtils.sizedBoxH(16, context),
                            Text(
                              'no_leave_balance_data'.tr,
                              textAlign: TextAlign.center,
                              style: AppTextStyle.montserraRegular.copyWith(
                                fontSize: ResponsiveUtils.sp(14, context),
                                color: ThemeColors.gry,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }

                  return Expanded(
                    child: ListView.separated(
                      itemCount: controller.leaveBalanceList.length,
                      separatorBuilder: (context, index) => Divider(
                        color: Colors.grey.withValues(alpha: 0.3),
                        height: 1,
                      ),
                      itemBuilder: (context, index) {
                        TimeOffModel item = controller.leaveBalanceList[index];
                        return _buildLeaveBalanceItem(context, item);
                      },
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLeaveBalanceItem(BuildContext context, TimeOffModel timeOff) {
    return Container(
      padding: ResponsiveUtils.padding(
        context: context,
        horizontal: 12,
        vertical: 16,
      ),
      margin: EdgeInsets.symmetric(vertical: ResponsiveUtils.h(4, context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.r(8, context)),
        border: Border.all(color: HexColor('#EEEEEE'), width: 1),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            flex: 3,
            child: Text(
              timeOff.timeoffType ?? 'not_specified'.tr,
              style: AppTextStyle.montserraSemiBold.copyWith(
                fontSize: ResponsiveUtils.sp(16, context),
                color: ThemeColors.black,
              ),
            ),
          ),
          Container(
            padding: ResponsiveUtils.padding(
              context: context,
              horizontal: 12,
              vertical: 8,
            ),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [HexColor('#004ADB'), HexColor('#02A4BF')],
                begin: const FractionalOffset(0.0, 0.0),
                end: const FractionalOffset(0.8, 0.0),
                stops: const [0.0, 1.0],
                tileMode: TileMode.clamp,
              ),
              borderRadius: BorderRadius.circular(
                ResponsiveUtils.r(8, context),
              ),
            ),
            child: Text(
              '${timeOff.balance?.toStringAsFixed(1) ?? '0.0'} ${"days".tr}',
              style: AppTextStyle.montserraSemiBold.copyWith(
                fontSize: ResponsiveUtils.sp(14, context),
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
