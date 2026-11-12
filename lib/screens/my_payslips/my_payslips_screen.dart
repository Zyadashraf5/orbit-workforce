import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/screens/my_payslips/domin/my_payslips_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class MyPayslipsScreen extends GetView<MyPayslipsController> {
  const MyPayslipsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(MyPayslipsController());
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        backgroundColor: ThemeColors.background,
        elevation: 0,
        title: Text(
          'my_payslips'.tr,
          style: AppTextStyle.montserraBold.copyWith(
            fontSize: ResponsiveUtils.sp(20, context),
            color: ThemeColors.black,
          ),
        ),
        centerTitle: true,
        leading: IconButton(
          onPressed: () => Get.back(),
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeColors.black,
            size: ResponsiveUtils.iconSize(20, context),
          ),
        ),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: TextDirection.rtl,
          child: Column(
            children: [
              // Filter Section
              _buildFilterSection(context),

              // Payslips List
              Expanded(
                child: GetBuilder<MyPayslipsController>(
                  builder: (payslipsController) {
                    if (payslipsController.loading) {
                      return Center(
                        child: CircularProgressIndicator(
                          color: HexColor('#004ADB'),
                        ),
                      );
                    }

                    if (payslipsController.payslipsList.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.receipt_long,
                              size: ResponsiveUtils.iconSize(80, context),
                              color: Colors.grey[400],
                            ),
                            ResponsiveUtils.sizedBoxH(20, context),
                            Text(
                              payslipsController.isFilterActive
                                  ? 'no_payslips_for_selected_period'.tr
                                  : 'no_payslips'.tr,
                              style: AppTextStyle.montserraSemiBold.copyWith(
                                fontSize: ResponsiveUtils.sp(18, context),
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      );
                    }

                    return Padding(
                      padding: ResponsiveUtils.padding(
                        context: context,
                        all: 20,
                      ),
                      child: ListView.builder(
                        itemCount: payslipsController.payslipsList.length,
                        itemBuilder: (context, index) {
                          final payslip =
                              payslipsController.payslipsList[index];

                          return Container(
                            margin: EdgeInsets.only(
                              bottom: ResponsiveUtils.h(16, context),
                            ),
                            padding: ResponsiveUtils.padding(
                              context: context,
                              all: 20,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(color: HexColor('#EEEEEE')),
                              boxShadow: [
                                BoxShadow(
                                  color: HexColor(
                                    '#4F4F4F1A',
                                  ).withValues(alpha: 0.1),
                                  spreadRadius: 0,
                                  blurRadius: 8,
                                  offset: const Offset(0, 4),
                                ),
                              ],
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Header with ID and Status
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      "${"payslip_id".tr}: ${payslip.id}",
                                      style: AppTextStyle.montserraBold
                                          .copyWith(
                                            fontSize: ResponsiveUtils.sp(
                                              16,
                                              context,
                                            ),
                                            color: ThemeColors.black,
                                          ),
                                    ),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: ResponsiveUtils.w(
                                          12,
                                          context,
                                        ),
                                        vertical: ResponsiveUtils.h(6, context),
                                      ),
                                      decoration: BoxDecoration(
                                        color: payslipsController
                                            .getStateColor(payslip.state)
                                            .withValues(alpha: 0.1),
                                        borderRadius: BorderRadius.circular(20),
                                        border: Border.all(
                                          color: payslipsController
                                              .getStateColor(payslip.state),
                                          width: 1,
                                        ),
                                      ),
                                      child: Text(
                                        payslipsController.getStateText(
                                          payslip.state,
                                        ),
                                        style: AppTextStyle.montserraSemiBold
                                            .copyWith(
                                              fontSize: ResponsiveUtils.sp(
                                                12,
                                                context,
                                              ),
                                              color: payslipsController
                                                  .getStateColor(payslip.state),
                                            ),
                                      ),
                                    ),
                                  ],
                                ),

                                ResponsiveUtils.sizedBoxH(16, context),

                                // Employee Name - highlighted
                                if (payslip.employeeName.isNotEmpty)
                                  Container(
                                    width: double.infinity,
                                    padding: ResponsiveUtils.padding(
                                      context: context,
                                      all: 16,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          HexColor(
                                            '#004ADB',
                                          ).withValues(alpha: 0.1),
                                          HexColor(
                                            '#004ADB',
                                          ).withValues(alpha: 0.05),
                                        ],
                                        begin: Alignment.topLeft,
                                        end: Alignment.bottomRight,
                                      ),
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: HexColor(
                                          '#004ADB',
                                        ).withValues(alpha: 0.3),
                                        width: 1,
                                      ),
                                    ),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.person,
                                              color: HexColor('#004ADB'),
                                              size: ResponsiveUtils.iconSize(
                                                20,
                                                context,
                                              ),
                                            ),
                                            ResponsiveUtils.sizedBoxW(
                                              8,
                                              context,
                                            ),
                                            Text(
                                              'employee_name'.tr,
                                              style: AppTextStyle
                                                  .montserraRegular
                                                  .copyWith(
                                                    fontSize:
                                                        ResponsiveUtils.sp(
                                                          12,
                                                          context,
                                                        ),
                                                    color: HexColor('#004ADB'),
                                                  ),
                                            ),
                                          ],
                                        ),
                                        ResponsiveUtils.sizedBoxH(8, context),
                                        Text(
                                          payslip.employeeName,
                                          style: AppTextStyle.montserraBold
                                              .copyWith(
                                                fontSize: ResponsiveUtils.sp(
                                                  16,
                                                  context,
                                                ),
                                                color: ThemeColors.black,
                                              ),
                                        ),
                                      ],
                                    ),
                                  ),

                                // Add extra spacing if employee name exists
                                if (payslip.employeeName.isNotEmpty)
                                  ResponsiveUtils.sizedBoxH(16, context),

                                // Employee Info
                                if (payslip.empSeq.isNotEmpty)
                                  _buildInfoRow(
                                    context,
                                    'employee_id'.tr,
                                    payslip.empSeq,
                                  ),

                                ResponsiveUtils.sizedBoxH(8, context),

                                _buildInfoRow(
                                  context,
                                  'net_wage'.tr,
                                  payslipsController.formatCurrency(
                                    payslip.netWage,
                                  ),
                                  isHighlighted: true,
                                ),

                                ResponsiveUtils.sizedBoxH(16, context),

                                // Download Button
                                SizedBox(
                                  width: double.infinity,
                                  child: ElevatedButton.icon(
                                    onPressed: () {
                                      payslipsController.downloadPayslipPdf(
                                        payslip.id,
                                      );
                                    },
                                    icon: Icon(
                                      Icons.download,
                                      size: ResponsiveUtils.iconSize(
                                        20,
                                        context,
                                      ),
                                      color: Colors.white,
                                    ),
                                    label: Text(
                                      'download_pdf'.tr,
                                      style: AppTextStyle.montserraSemiBold
                                          .copyWith(
                                            fontSize: ResponsiveUtils.sp(
                                              14,
                                              context,
                                            ),
                                            color: Colors.white,
                                          ),
                                    ),
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: HexColor('#004ADB'),
                                      padding: EdgeInsets.symmetric(
                                        vertical: ResponsiveUtils.h(
                                          12,
                                          context,
                                        ),
                                      ),
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return GetBuilder<MyPayslipsController>(
      builder: (controller) {
        return Container(
          margin: ResponsiveUtils.padding(
            context: context,
            horizontal: 20,
            vertical: 10,
          ),
          padding: ResponsiveUtils.padding(context: context, all: 12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
            border: Border.all(color: HexColor('#EEEEEE')),
            boxShadow: [
              BoxShadow(
                color: HexColor('#4F4F4F1A').withValues(alpha: 0.1),
                spreadRadius: 0,
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Filter Header
              Row(
                children: [
                  // Container(
                  //   padding: ResponsiveUtils.padding(context: context, all: 8),
                  //   decoration: BoxDecoration(
                  //     color: HexColor("#004ADB").withOpacity(0.1),
                  //     borderRadius: BorderRadius.circular(8),
                  //   ),
                  //   child: Icon(
                  //     Icons.filter_list_rounded,
                  //     color: HexColor("#004ADB"),
                  //     size: ResponsiveUtils.iconSize(20, context),
                  //   ),
                  // ),
                  ResponsiveUtils.sizedBoxW(12, context),
                  Text(
                    'filter_by_month_year'.tr,
                    style: AppTextStyle.montserraBold.copyWith(
                      fontSize: ResponsiveUtils.sp(16, context),
                      color: ThemeColors.black,
                    ),
                  ),
                  const Spacer(),
                  if (controller.isFilterActive)
                    InkWell(
                      onTap: () => controller.clearFilter(),
                      child: Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.w(12, context),
                          vertical: ResponsiveUtils.h(6, context),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(24),
                          border: Border.all(
                            color: Colors.red.withValues(alpha: 0.3),
                            width: 1,
                          ),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              Icons.close,
                              color: Colors.red,
                              size: ResponsiveUtils.iconSize(16, context),
                            ),
                            ResponsiveUtils.sizedBoxW(4, context),
                            Text(
                              'clear_filter'.tr,
                              style: AppTextStyle.montserraSemiBold.copyWith(
                                fontSize: ResponsiveUtils.sp(12, context),
                                color: Colors.red,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),

              ResponsiveUtils.sizedBoxH(12, context),

              // Filter Controls
              if (controller.batchesLoading)
                Center(
                  child: Column(
                    children: [
                      CircularProgressIndicator(
                        color: HexColor('#004ADB'),
                        strokeWidth: 2,
                      ),
                      ResponsiveUtils.sizedBoxH(8, context),
                      Text(
                        'loading_data'.tr,
                        style: AppTextStyle.montserraRegular.copyWith(
                          fontSize: ResponsiveUtils.sp(14, context),
                          color: ThemeColors.gry,
                        ),
                      ),
                    ],
                  ),
                )
              else if (controller.payslipRunList.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Section title
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_rounded,
                          color: HexColor('#004ADB'),
                          size: ResponsiveUtils.iconSize(16, context),
                        ),
                        ResponsiveUtils.sizedBoxW(8, context),
                        Text(
                          'select_month_year'.tr,
                          style: AppTextStyle.montserraSemiBold.copyWith(
                            fontSize: ResponsiveUtils.sp(14, context),
                            color: ThemeColors.black,
                          ),
                        ),
                      ],
                    ),

                    ResponsiveUtils.sizedBoxH(8, context),

                    // Month and year in one row
                    Row(
                      children: [
                        // Month selection
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'month'.tr,
                                style: AppTextStyle.montserraSemiBold.copyWith(
                                  fontSize: ResponsiveUtils.sp(13, context),
                                  color: ThemeColors.gry,
                                ),
                              ),
                              ResponsiveUtils.sizedBoxH(6, context),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.w(12, context),
                                  vertical: ResponsiveUtils.h(2, context),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: HexColor('#EEEEEE'),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: DropdownButton<String>(
                                  value: controller.selectedMonth,
                                  hint: Text(
                                    'select'.tr,
                                    style: AppTextStyle.montserraRegular
                                        .copyWith(
                                          fontSize: ResponsiveUtils.sp(
                                            14,
                                            context,
                                          ),
                                          color: ThemeColors.gry,
                                        ),
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: HexColor('#004ADB'),
                                    size: ResponsiveUtils.iconSize(20, context),
                                  ),
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  items: controller
                                      .getAvailableMonthsOnly()
                                      .map((month) {
                                        return DropdownMenuItem<String>(
                                          value: month,
                                          child: Text(
                                            controller
                                                .getArabicMonthName(
                                                  '$month 2025',
                                                )
                                                .split(' ')[0],
                                            style: AppTextStyle
                                                .montserraSemiBold
                                                .copyWith(
                                                  fontSize: ResponsiveUtils.sp(
                                                    14,
                                                    context,
                                                  ),
                                                  color: ThemeColors.black,
                                                ),
                                          ),
                                        );
                                      })
                                      .toList(),
                                  onChanged: (String? newMonth) {
                                    controller.selectedMonth = newMonth;
                                    if (controller.selectedYear != null &&
                                        newMonth != null) {
                                      controller.applyFilterByMonthYear(
                                        newMonth,
                                        controller.selectedYear,
                                      );
                                    } else {
                                      controller.update();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),

                        ResponsiveUtils.sizedBoxW(8, context),

                        // Year selection
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'year'.tr,
                                style: AppTextStyle.montserraSemiBold.copyWith(
                                  fontSize: ResponsiveUtils.sp(13, context),
                                  color: ThemeColors.gry,
                                ),
                              ),
                              ResponsiveUtils.sizedBoxH(6, context),
                              Container(
                                width: double.infinity,
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.w(12, context),
                                  vertical: ResponsiveUtils.h(2, context),
                                ),
                                decoration: BoxDecoration(
                                  border: Border.all(
                                    color: HexColor('#EEEEEE'),
                                  ),
                                  borderRadius: BorderRadius.circular(12),
                                  color: Colors.white,
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withValues(
                                        alpha: 0.05,
                                      ),
                                      blurRadius: 4,
                                      offset: const Offset(0, 2),
                                    ),
                                  ],
                                ),
                                child: DropdownButton<String>(
                                  value: controller.selectedYear,
                                  hint: Text(
                                    'select'.tr,
                                    style: AppTextStyle.montserraRegular
                                        .copyWith(
                                          fontSize: ResponsiveUtils.sp(
                                            14,
                                            context,
                                          ),
                                          color: ThemeColors.gry,
                                        ),
                                  ),
                                  icon: Icon(
                                    Icons.keyboard_arrow_down,
                                    color: HexColor('#004ADB'),
                                    size: ResponsiveUtils.iconSize(20, context),
                                  ),
                                  isExpanded: true,
                                  underline: const SizedBox(),
                                  items: controller.getAvailableYearsOnly().map(
                                    (year) {
                                      return DropdownMenuItem<String>(
                                        value: year,
                                        child: Text(
                                          year,
                                          style: AppTextStyle.montserraSemiBold
                                              .copyWith(
                                                fontSize: ResponsiveUtils.sp(
                                                  14,
                                                  context,
                                                ),
                                                color: ThemeColors.black,
                                              ),
                                        ),
                                      );
                                    },
                                  ).toList(),
                                  onChanged: (String? newYear) {
                                    controller.selectedYear = newYear;
                                    if (controller.selectedMonth != null &&
                                        newYear != null) {
                                      controller.applyFilterByMonthYear(
                                        controller.selectedMonth,
                                        newYear,
                                      );
                                    } else {
                                      controller.update();
                                    }
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                )
              else
                Center(
                  child: Column(
                    children: [
                      Icon(
                        Icons.warning_amber_rounded,
                        color: Colors.orange,
                        size: ResponsiveUtils.iconSize(32, context),
                      ),
                      ResponsiveUtils.sizedBoxH(8, context),
                      Text(
                        'no_payroll_periods_available'.tr,
                        textAlign: TextAlign.center,
                        style: AppTextStyle.montserraSemiBold.copyWith(
                          fontSize: ResponsiveUtils.sp(14, context),
                          color: ThemeColors.gry,
                        ),
                      ),
                    ],
                  ),
                ),

              // Display active filter
              if (controller.isFilterActive &&
                  controller.selectedMonth != null &&
                  controller.selectedYear != null)
                Container(
                  margin: EdgeInsets.only(top: ResponsiveUtils.h(16, context)),
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.w(16, context),
                    vertical: ResponsiveUtils.h(12, context),
                  ),
                  decoration: BoxDecoration(
                    color: HexColor('#004ADB').withValues(alpha: 0.08),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: HexColor('#004ADB').withValues(alpha: 0.2),
                      width: 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: ResponsiveUtils.padding(
                          context: context,
                          all: 6,
                        ),
                        decoration: BoxDecoration(
                          color: HexColor('#004ADB').withValues(alpha: 0.2),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          Icons.check,
                          color: HexColor('#004ADB'),
                          size: ResponsiveUtils.iconSize(16, context),
                        ),
                      ),
                      ResponsiveUtils.sizedBoxW(12, context),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'filter_applied'.tr,
                              style: AppTextStyle.montserraBold.copyWith(
                                fontSize: ResponsiveUtils.sp(14, context),
                                color: HexColor('#004ADB'),
                              ),
                            ),
                            ResponsiveUtils.sizedBoxH(4, context),
                            Text(
                              "${"period".tr}: ${controller.getArabicMonthName('${controller.selectedMonth} ${controller.selectedYear}')}",
                              style: AppTextStyle.montserraRegular.copyWith(
                                fontSize: ResponsiveUtils.sp(13, context),
                                color: HexColor(
                                  '#004ADB',
                                ).withValues(alpha: 0.8),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildInfoRow(
    BuildContext context,
    String label,
    String value, {
    bool isHighlighted = false,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: AppTextStyle.montserraRegular.copyWith(
            fontSize: ResponsiveUtils.sp(14, context),
            color: ThemeColors.gry,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.montserraSemiBold.copyWith(
            fontSize: ResponsiveUtils.sp(14, context),
            color: isHighlighted ? HexColor('#004ADB') : ThemeColors.black,
          ),
        ),
      ],
    );
  }
}
