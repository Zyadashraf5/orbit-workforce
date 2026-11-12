import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/model/loan_model.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:orbit_workforce/screens/request_screen/domin/request_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';
import 'package:intl/intl.dart';

class HistoryOfLoansScreen extends GetView<RequestController> {
  const HistoryOfLoansScreen({super.key});

  @override
  RequestController get controller => Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      controller.getLoansByEmployeeId();
    });

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'employee_loans'.tr,
          style: AppTextStyle.montserraBold.copyWith(
            color: Colors.black,
            fontSize: ResponsiveUtils.sp(18, context),
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: GetBuilder<RequestController>(
        builder: (controller) {
          if (controller.loadingLoans) {
            return const Center(child: CircularProgressIndicator());
          }

          if (controller.loansList.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.account_balance_wallet_outlined,
                    size: ResponsiveUtils.iconSize(80, context),
                    color: Colors.grey[400],
                  ),
                  ResponsiveUtils.sizedBoxH(20, context),
                  Text(
                    'no_loans_found'.tr,
                    style: AppTextStyle.montserraRegular.copyWith(
                      fontSize: ResponsiveUtils.sp(18, context),
                      color: Colors.grey[600],
                    ),
                  ),
                  ResponsiveUtils.sizedBoxH(10, context),
                  Text(
                    'no_loans_yet'.tr,
                    style: AppTextStyle.montserraRegular.copyWith(
                      fontSize: ResponsiveUtils.sp(14, context),
                      color: Colors.grey[500],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              await controller.getLoansByEmployeeId();
            },
            child: Padding(
              padding: ResponsiveUtils.padding(context: context, all: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // قسم الفلترة
                  _buildFilterSection(context, controller),
                  ResponsiveUtils.sizedBoxH(20, context),

                  // عداد القروض
                  Container(
                    width: double.infinity,
                    padding: ResponsiveUtils.padding(context: context, all: 16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [HexColor('#004ADB'), HexColor('#02A4BF')],
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                      ),
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.r(12, context),
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.account_balance_wallet,
                          color: Colors.white,
                          size: ResponsiveUtils.iconSize(24, context),
                        ),
                        ResponsiveUtils.sizedBoxW(12, context),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'total_loans'.tr,
                              style: AppTextStyle.montserraRegular.copyWith(
                                color: Colors.white,
                                fontSize: ResponsiveUtils.sp(14, context),
                              ),
                            ),
                            Text(
                              "${controller.filteredLoansList.length} ${"loan".tr}",
                              style: AppTextStyle.montserraBold.copyWith(
                                color: Colors.white,
                                fontSize: ResponsiveUtils.sp(18, context),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  ResponsiveUtils.sizedBoxH(20, context),

                  // قائمة القروض
                  Expanded(
                    child: controller.filteredLoansList.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.filter_list_off,
                                  size: ResponsiveUtils.iconSize(80, context),
                                  color: Colors.grey[400],
                                ),
                                ResponsiveUtils.sizedBoxH(16, context),
                                Text(
                                  'no_loans_found'.tr,
                                  style: AppTextStyle.montserraSemiBold
                                      .copyWith(
                                        fontSize: ResponsiveUtils.sp(
                                          18,
                                          context,
                                        ),
                                        color: Colors.grey[600],
                                      ),
                                ),
                                ResponsiveUtils.sizedBoxH(8, context),
                                Text(
                                  'no_loans_match_filter'.tr,
                                  style: AppTextStyle.montserraRegular.copyWith(
                                    fontSize: ResponsiveUtils.sp(14, context),
                                    color: Colors.grey[500],
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.builder(
                            itemCount: controller.filteredLoansList.length,
                            itemBuilder: (context, index) {
                              final loan = controller.filteredLoansList[index];
                              return _buildLoanCard(context, loan);
                            },
                          ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
      floatingActionButton: Container(
        width: 56,
        height: 56,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
          gradient: LinearGradient(
            colors: [Color(0xFF2196F3), Color(0xFF0D47A1)], // blue gradient
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: FloatingActionButton(
          onPressed: () {
            Get.toNamed(Routes.createLoansOrder);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildLoanCard(BuildContext context, LoanModel loan) {
    return Card(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.h(12, context)),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
      ),
      child: Container(
        padding: ResponsiveUtils.padding(context: context, all: 16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
          color: Colors.white,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // رأس البطاقة
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        loan.getLoanActionText(),
                        style: AppTextStyle.montserraBold.copyWith(
                          fontSize: ResponsiveUtils.sp(16, context),
                          color: loan.getLoanActionColor(),
                        ),
                      ),
                      ResponsiveUtils.sizedBoxH(4, context),
                      Text(
                        'ID: ${loan.id}',
                        style: AppTextStyle.montserraRegular.copyWith(
                          fontSize: ResponsiveUtils.sp(12, context),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.w(12, context),
                    vertical: ResponsiveUtils.h(6, context),
                  ),
                  decoration: BoxDecoration(
                    color: loan.getStateColor(),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.r(20, context),
                    ),
                  ),
                  child: Text(
                    loan.getStateText(),
                    style: AppTextStyle.montserraSemiBold.copyWith(
                      color: Colors.white,
                      fontSize: ResponsiveUtils.sp(12, context),
                    ),
                  ),
                ),
              ],
            ),

            ResponsiveUtils.sizedBoxH(16, context),

            // معلومات المبلغ والرصيد
            Row(
              children: [
                Expanded(
                  child: _buildInfoItem(
                    context: context,
                    title: 'original_amount'.tr,
                    value:
                        "${loan.amount?.toStringAsFixed(2) ?? '0.00'} ${"sar".tr}",
                    icon: Icons.attach_money,
                    color: Colors.green,
                  ),
                ),
                ResponsiveUtils.sizedBoxW(12, context),
                Expanded(
                  child: _buildInfoItem(
                    context: context,
                    title: 'remaining_balance'.tr,
                    value:
                        "${loan.balance?.toStringAsFixed(2) ?? '0.00'} ${"sar".tr}",
                    icon: Icons.account_balance,
                    color: Colors.orange,
                  ),
                ),
              ],
            ),

            ResponsiveUtils.sizedBoxH(16, context),

            // معلومات التواريخ
            Row(
              children: [
                Expanded(
                  child: _buildDateItem(
                    context: context,
                    title: 'start_date'.tr,
                    date: loan.startDate,
                    icon: Icons.start,
                  ),
                ),
                ResponsiveUtils.sizedBoxW(12, context),
                Expanded(
                  child: _buildDateItem(
                    context: context,
                    title: 'end_date'.tr,
                    date: loan.getEndDateText(),
                    icon: Icons.event,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoItem({
    required BuildContext context,
    required String title,
    required String value,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: ResponsiveUtils.padding(context: context, all: 12),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.r(8, context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: ResponsiveUtils.iconSize(16, context),
                color: color,
              ),
              ResponsiveUtils.sizedBoxW(4, context),
              Text(
                title,
                style: AppTextStyle.montserraRegular.copyWith(
                  fontSize: ResponsiveUtils.sp(12, context),
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          ResponsiveUtils.sizedBoxH(4, context),
          Text(
            value,
            style: AppTextStyle.montserraSemiBold.copyWith(
              fontSize: ResponsiveUtils.sp(14, context),
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateItem({
    required BuildContext context,
    required String title,
    required String? date,
    required IconData icon,
  }) {
    String formattedDate;
    if (date == null || date.isEmpty) {
      formattedDate = 'date_not_selected_yet'.tr;
    } else {
      try {
        final parsedDate = DateTime.parse(date);
        formattedDate = DateFormat('dd/MM/yyyy', 'ar').format(parsedDate);
      } catch (e) {
        formattedDate = date;
      }
    }

    return Container(
      padding: ResponsiveUtils.padding(context: context, all: 12),
      decoration: BoxDecoration(
        color: Colors.blue.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(ResponsiveUtils.r(8, context)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: ResponsiveUtils.iconSize(16, context),
                color: Colors.blue,
              ),
              ResponsiveUtils.sizedBoxW(4, context),
              Expanded(
                child: Text(
                  title,
                  style: AppTextStyle.montserraRegular.copyWith(
                    fontSize: ResponsiveUtils.sp(12, context),
                    color: Colors.grey[600],
                  ),
                ),
              ),
            ],
          ),
          ResponsiveUtils.sizedBoxH(4, context),
          Text(
            formattedDate,
            style: AppTextStyle.montserraSemiBold.copyWith(
              fontSize: ResponsiveUtils.sp(14, context),
              color: Colors.blue,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    RequestController controller,
  ) {
    return Container(
      padding: ResponsiveUtils.padding(context: context, all: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(
                Icons.filter_list,
                color: Colors.blue,
                size: ResponsiveUtils.r(20, context),
              ),
              ResponsiveUtils.sizedBoxW(8, context),
              Text(
                'filter_loans'.tr,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16, context),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              if (controller.selectedLoanTypeFilter != 'all_loan_types'.tr ||
                  controller.selectedLoanStateFilter != 'all_loan_statuses'.tr)
                TextButton(
                  onPressed: () => controller.clearLoanFilters(),
                  child: Text(
                    'clear_filter'.tr,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(12, context),
                      fontFamily: 'Cairo',
                      color: Colors.red,
                    ),
                  ),
                ),
            ],
          ),
          ResponsiveUtils.sizedBoxH(16, context),
          Row(
            children: [
              // فلتر نوع القرض
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'loan_type'.tr,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14, context),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                        color: Colors.grey[700],
                      ),
                    ),
                    ResponsiveUtils.sizedBoxH(8, context),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.w(12, context),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.r(8, context),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedLoanTypeFilter,
                          isExpanded: true,
                          items: controller.loanTypeFilterOptions
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.sp(13, context),
                                      fontFamily: 'Cairo',
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setLoanTypeFilter(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ResponsiveUtils.sizedBoxW(12, context),
              // فلتر الحالة
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'loan_status'.tr,
                      style: TextStyle(
                        fontSize: ResponsiveUtils.sp(14, context),
                        fontWeight: FontWeight.w600,
                        fontFamily: 'Cairo',
                        color: Colors.grey[700],
                      ),
                    ),
                    ResponsiveUtils.sizedBoxH(8, context),
                    Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: ResponsiveUtils.w(12, context),
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey[300]!),
                        borderRadius: BorderRadius.circular(
                          ResponsiveUtils.r(8, context),
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: controller.selectedLoanStateFilter,
                          isExpanded: true,
                          items: controller.loanStateFilterOptions
                              .map<DropdownMenuItem<String>>((String value) {
                                return DropdownMenuItem<String>(
                                  value: value,
                                  child: Text(
                                    value,
                                    style: TextStyle(
                                      fontSize: ResponsiveUtils.sp(13, context),
                                      fontFamily: 'Cairo',
                                      color: Colors.black87,
                                    ),
                                  ),
                                );
                              })
                              .toList(),
                          onChanged: (String? newValue) {
                            if (newValue != null) {
                              controller.setLoanStateFilter(newValue);
                            }
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
