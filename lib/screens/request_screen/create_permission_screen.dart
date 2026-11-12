import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/screens/request_screen/domin/permission_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class CreatePermissionScreen extends GetView<PermissionController> {
  const CreatePermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: ThemeColors.background,
        elevation: 0,
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back_ios,
            color: ThemeColors.black,
            size: ResponsiveUtils.iconSize(20, context),
          ),
          onPressed: () => Get.back(),
        ),
        title: Text(
          'create_permission'.tr,
          style: AppTextStyle.montserraBold.copyWith(
            fontSize: ResponsiveUtils.sp(20, context),
            color: ThemeColors.black,
          ),
        ),
      ),
      body: GetBuilder<PermissionController>(
        builder: (controller) {
          return Container(
            color: ThemeColors.background,
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // قسم الموظف
                  _buildEmployeeSection(context, controller),
                  const SizedBox(height: 20),

                  // قسم اختيار نوع الإذن
                  _buildPermissionTypeSection(context, controller),
                  const SizedBox(height: 20),

                  // قسم اختيار التاريخ
                  _buildDateSection(controller, context),
                  const SizedBox(height: 30),

                  // قسم عدد الساعات
                  _buildHoursSection(context, controller),
                  const SizedBox(height: 20),

                  // أزرار الإجراءات
                  SizedBox(height: MediaQuery.of(context).size.height * 0.15),
                  _buildActionButtons(context, controller),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildPermissionTypeSection(
    BuildContext context,
    PermissionController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'permission_type'.tr,
            style: AppTextStyle.montserraSemiBold.copyWith(
              fontSize: ResponsiveUtils.sp(16, context),
              color: ThemeColors.black,
            ),
          ),
          const SizedBox(height: 12),
          _buildTypeDropdown(context, controller),
          if (controller.permissionTypesList.isEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Text(
                'no_permission_types_available'.tr,
                style: AppTextStyle.montserraRegular.copyWith(
                  fontSize: ResponsiveUtils.sp(12, context),
                  color: Colors.red,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildEmployeeSection(
    BuildContext context,
    PermissionController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'employee'.tr,
            style: AppTextStyle.montserraSemiBold.copyWith(
              fontSize: ResponsiveUtils.sp(16, context),
              color: ThemeColors.black,
            ),
          ),
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Colors.grey[50],
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.grey[300]!),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.person,
                  color: ThemeColors.blue,
                  size: ResponsiveUtils.iconSize(20, context),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    controller.employeeName,
                    style: AppTextStyle.montserraSemiBold.copyWith(
                      fontSize: ResponsiveUtils.sp(14, context),
                      color: ThemeColors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTypeDropdown(
    BuildContext context,
    PermissionController controller,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey[300]!),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: controller.selectedPermissionType.isEmpty
              ? null
              : controller.selectedPermissionType,
          isExpanded: true,
          hint: Text(
            controller.permissionTypesList.isEmpty
                ? 'loading_permission_types'.tr
                : 'choose_permission_type'.tr,
            style: AppTextStyle.montserraRegular.copyWith(
              fontSize: ResponsiveUtils.sp(14, context),
              color: Colors.grey[500],
            ),
          ),
          style: AppTextStyle.montserraRegular.copyWith(
            fontSize: ResponsiveUtils.sp(14, context),
            color: ThemeColors.black,
          ),
          items: controller.permissionTypesList.map((type) {
            return DropdownMenuItem<String>(
              value: type['name'],
              child: Text(type['name']),
            );
          }).toList(),
          onChanged: controller.permissionTypesList.isEmpty
              ? null
              : (String? newValue) {
                  if (newValue != null) {
                    final selectedType = controller.permissionTypesList
                        .firstWhere((type) => type['name'] == newValue);
                    controller.setSelectedPermissionType(
                      newValue,
                      selectedType['hours'],
                    );
                  }
                },
        ),
      ),
    );
  }

  Widget _buildDateSection(
    PermissionController controller,
    BuildContext context,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'permission_date'.tr,
            style: AppTextStyle.montserraSemiBold.copyWith(
              fontSize: ResponsiveUtils.sp(16, context),
              color: ThemeColors.black,
            ),
          ),
          const SizedBox(height: 12),
          GestureDetector(
            onTap: () => controller.selectPermissionDate(context),
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[50],
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey[300]!),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.calendar_today,
                    color: ThemeColors.blue,
                    size: ResponsiveUtils.iconSize(20, context),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      controller.formattedPermissionDate,
                      style: AppTextStyle.montserraRegular.copyWith(
                        fontSize: ResponsiveUtils.sp(14, context),
                        color: ThemeColors.black,
                      ),
                    ),
                  ),
                  Icon(
                    Icons.arrow_drop_down,
                    color: ThemeColors.gry,
                    size: ResponsiveUtils.iconSize(20, context),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHoursSection(
    BuildContext context,
    PermissionController controller,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
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
          Text(
            'number_of_hours'.tr,
            style: AppTextStyle.montserraSemiBold.copyWith(
              fontSize: ResponsiveUtils.sp(16, context),
              color: ThemeColors.black,
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: controller.permissionHoursController,
            keyboardType: const TextInputType.numberWithOptions(decimal: true),
            decoration: InputDecoration(
              hintText: '0.00',
              hintStyle: AppTextStyle.montserraRegular.copyWith(
                fontSize: ResponsiveUtils.sp(14, context),
                color: Colors.grey[500],
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: Colors.grey[300]!),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide(color: ThemeColors.blue),
              ),
              contentPadding: const EdgeInsets.all(12),
              prefixIcon: Icon(
                Icons.schedule,
                color: ThemeColors.blue,
                size: ResponsiveUtils.iconSize(20, context),
              ),
            ),
            style: AppTextStyle.montserraRegular.copyWith(
              fontSize: ResponsiveUtils.sp(14, context),
              color: ThemeColors.black,
            ),
            onChanged: (value) {
              controller.updatePermissionHours(value);
            },
          ),
        ],
      ),
    );
  }

  Widget _buildActionButtons(
    BuildContext context,
    PermissionController controller,
  ) {
    return Row(
      children: [
        // زر الموافقة
        Expanded(
          child: ElevatedButton(
            onPressed: controller.isCreatingPermission
                ? null
                : () => controller.createPermissionRequest(),
            style: ElevatedButton.styleFrom(
              backgroundColor: ThemeColors.blue,
              foregroundColor: Colors.white,
              elevation: 0,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            child: controller.isCreatingPermission
                ? const SizedBox(
                    height: 20,
                    width: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    'request_permission'.tr,
                    style: AppTextStyle.montserraSemiBold.copyWith(
                      fontSize: ResponsiveUtils.sp(16, context),
                      color: Colors.white,
                    ),
                  ),
          ),
        ),
      ],
    );
  }
}
