import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/screens/request_screen/domin/request_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class CreateLoansOrder extends GetView<RequestController> {
  const CreateLoansOrder({super.key});

  @override
  RequestController get controller => Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: AppBar(
        title: Text(
          'new_loan_request'.tr,
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
        builder: (controller) => SingleChildScrollView(
          padding: ResponsiveUtils.padding(context: context, all: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // رأس الصفحة
              Container(
                width: double.infinity,
                padding: ResponsiveUtils.padding(context: context, all: 20),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [HexColor('#004ADB'), HexColor('#02A4BF')],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  borderRadius: BorderRadius.circular(
                    ResponsiveUtils.r(15, context),
                  ),
                ),
                child: Column(
                  children: [
                    Icon(
                      Icons.account_balance_wallet,
                      color: Colors.white,
                      size: ResponsiveUtils.iconSize(40, context),
                    ),
                    ResponsiveUtils.sizedBoxH(10, context),
                    Text(
                      'new_loan_request'.tr,
                      style: AppTextStyle.montserraBold.copyWith(
                        color: Colors.white,
                        fontSize: ResponsiveUtils.sp(20, context),
                      ),
                    ),
                    ResponsiveUtils.sizedBoxH(5, context),
                    Text(
                      'fill_required_data'.tr,
                      style: AppTextStyle.montserraRegular.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: ResponsiveUtils.sp(14, context),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),

              ResponsiveUtils.sizedBoxH(30, context),

              // نوع القرض
              _buildSectionTitle('loan_type'.tr, context),
              ResponsiveUtils.sizedBoxH(10, context),
              _buildDropdownField(
                value: controller.selectedLoanType,
                items: controller.loanTypesDisplayList,
                onChanged: (value) {
                  if (value != null) {
                    controller.selectedLoanType = value;
                    controller.update();
                  }
                },
                loading: controller.loadingLoanTypes,
                hint: 'select_loan_type'.tr,
                context: context,
              ),

              ResponsiveUtils.sizedBoxH(20, context),

              // نوع العملية (Loan Action)
              // _buildSectionTitle("نوع العملية"),
              // ResponsiveUtils.sizedBoxH(10, context),
              // _buildDropdownField(
              //   value: controller.selectedLoanAction,
              //   items: controller.loanActionsList,
              //   onChanged: (value) {
              //     if (value != null) {
              //       controller.selectedLoanAction = value;
              //       controller.update();
              //     }
              //   },
              //   hint: "اختر نوع العملية",
              // ),

              // ResponsiveUtils.sizedBoxH(20, context),

              // المبلغ المطلوب
              _buildSectionTitle('loan_amount'.tr, context),
              ResponsiveUtils.sizedBoxH(10, context),
              _buildTextField(
                controller: controller.loanAmountController,
                hint: 'enter_loan_amount'.tr,
                context: context,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.attach_money,
                suffix: 'currencysar'.tr,
              ),

              ResponsiveUtils.sizedBoxH(20, context),

              // تاريخ البداية
              _buildSectionTitle('loan_start_date'.tr, context),
              ResponsiveUtils.sizedBoxH(10, context),
              _buildDateField(
                value: controller.formattedLoanStartDate,
                onTap: () => controller.selectLoanStartDate(context),
                icon: Icons.calendar_today,
                context: context,
              ),

              ResponsiveUtils.sizedBoxH(20, context),

              // عدد الأشهر
              _buildSectionTitle('number_of_months'.tr, context),
              ResponsiveUtils.sizedBoxH(10, context),
              _buildTextField(
                controller: controller.loanMonthsController,
                hint: 'enter_number_of_months'.tr,
                context: context,
                keyboardType: TextInputType.number,
                prefixIcon: Icons.schedule,
                suffix: 'month'.tr,
              ),

              ResponsiveUtils.sizedBoxH(20, context),

              // السبب
              _buildSectionTitle('loan_reason'.tr, context),
              ResponsiveUtils.sizedBoxH(10, context),
              _buildTextField(
                controller: controller.loanReasonController,
                hint: 'enter_loan_reason_optional'.tr,
                context: context,
                maxLines: 3,
                prefixIcon: Icons.notes,
              ),

              ResponsiveUtils.sizedBoxH(40, context),

              // زر الإرسال
              SizedBox(
                width: double.infinity,
                height: ResponsiveUtils.h(50, context),
                child: ElevatedButton(
                  onPressed: controller.loadingCreateLoan
                      ? null
                      : () => controller.createLoanRequest(),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: HexColor('#004ADB'),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        ResponsiveUtils.r(12, context),
                      ),
                    ),
                    elevation: 2,
                  ),
                  child: controller.loadingCreateLoan
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: ResponsiveUtils.w(20, context),
                              height: ResponsiveUtils.h(20, context),
                              child: const CircularProgressIndicator(
                                color: Colors.white,
                                strokeWidth: 2,
                              ),
                            ),
                            ResponsiveUtils.sizedBoxW(10, context),
                            Text(
                              'sending'.tr,
                              style: AppTextStyle.montserraSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: ResponsiveUtils.sp(16, context),
                              ),
                            ),
                          ],
                        )
                      : Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.send,
                              color: Colors.white,
                              size: ResponsiveUtils.iconSize(20, context),
                            ),
                            ResponsiveUtils.sizedBoxW(8, context),
                            Text(
                              'send_loan_request'.tr,
                              style: AppTextStyle.montserraSemiBold.copyWith(
                                color: Colors.white,
                                fontSize: ResponsiveUtils.sp(16, context),
                              ),
                            ),
                          ],
                        ),
                ),
              ),

              ResponsiveUtils.sizedBoxH(30, context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title, BuildContext context) {
    return Text(
      title,
      style: AppTextStyle.montserraSemiBold.copyWith(
        fontSize: ResponsiveUtils.sp(16, context),
        color: Colors.black87,
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required BuildContext context,
    TextInputType? keyboardType,
    IconData? prefixIcon,
    String? suffix,
    int? maxLines,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        maxLines: maxLines ?? 1,
        style: AppTextStyle.montserraRegular.copyWith(
          fontSize: ResponsiveUtils.sp(14, context),
          color: Colors.black87,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: AppTextStyle.montserraRegular.copyWith(
            fontSize: ResponsiveUtils.sp(14, context),
            color: Colors.grey[500],
          ),
          prefixIcon: prefixIcon != null
              ? Icon(prefixIcon, color: HexColor('#004ADB'))
              : null,
          suffixText: suffix,
          suffixStyle: AppTextStyle.montserraRegular.copyWith(
            fontSize: ResponsiveUtils.sp(14, context),
            color: Colors.grey[600],
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
            borderSide: BorderSide.none,
          ),
          filled: true,
          fillColor: Colors.white,
          contentPadding: EdgeInsets.symmetric(
            horizontal: ResponsiveUtils.w(16, context),
            vertical: ResponsiveUtils.h(16, context),
          ),
        ),
      ),
    );
  }

  Widget _buildDropdownField({
    required String value,
    required List<String> items,
    required Function(String?) onChanged,
    required String hint,
    required BuildContext context,
    bool loading = false,
  }) {
    return Container(
      width: double.infinity,
      padding: ResponsiveUtils.padding(
        context: context,
        horizontal: 16,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: items.contains(value) ? value : null,
          isExpanded: true,
          hint: Text(
            hint,
            style: AppTextStyle.montserraRegular.copyWith(
              fontSize: ResponsiveUtils.sp(14, context),
              color: Colors.grey[500],
            ),
          ),
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(
                item,
                style: AppTextStyle.montserraRegular.copyWith(
                  fontSize: ResponsiveUtils.sp(14, context),
                  color: Colors.black87,
                ),
              ),
            );
          }).toList(),
          onChanged: loading ? null : onChanged,
          icon: loading
              ? SizedBox(
                  width: ResponsiveUtils.w(16, context),
                  height: ResponsiveUtils.h(16, context),
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      HexColor('#004ADB'),
                    ),
                  ),
                )
              : Icon(Icons.keyboard_arrow_down, color: HexColor('#004ADB')),
          dropdownColor: Colors.white,
          style: AppTextStyle.montserraRegular.copyWith(
            fontSize: ResponsiveUtils.sp(14, context),
            color: Colors.black87,
          ),
        ),
      ),
    );
  }

  Widget _buildDateField({
    required String value,
    required VoidCallback onTap,
    required IconData icon,
    required BuildContext context,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: ResponsiveUtils.padding(context: context, all: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(icon, color: HexColor('#004ADB')),
            ResponsiveUtils.sizedBoxW(12, context),
            Expanded(
              child: Text(
                value,
                style: AppTextStyle.montserraRegular.copyWith(
                  fontSize: ResponsiveUtils.sp(14, context),
                  color: Colors.black87,
                ),
              ),
            ),
            Icon(Icons.keyboard_arrow_down, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}
