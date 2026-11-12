import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/model/permission_model.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:orbit_workforce/screens/request_screen/domin/permission_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class PermissionHistory extends GetView<PermissionController> {
  const PermissionHistory({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(PermissionController());

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
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
            'permission_history'.tr,
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
              child: Column(
                children: [
                  // قسم الفلاتر
                  _buildFilterSection(context, controller),
                  const SizedBox(height: 20),

                  // قسم البيانات
                  Expanded(
                    child: controller.loading
                        ? Center(
                            child: CircularProgressIndicator(
                              color: ThemeColors.blue,
                            ),
                          )
                        : controller.filteredPermissionRequestsList.isEmpty
                        ? _buildEmptyState(context)
                        : _buildPermissionList(controller),
                  ),
                ],
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
              colors: [Color(0xFF2196F3), Color(0xFF0D47A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: FloatingActionButton(
            onPressed: () {
              Get.toNamed(Routes.createPermission);
            },
            backgroundColor: Colors.transparent,
            elevation: 0,
            child: const Icon(Icons.add, color: Colors.white),
          ),
        ),
      ),
    );
  }

  Widget _buildFilterSection(
    BuildContext context,
    PermissionController controller,
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
                'filter_data'.tr,
                style: TextStyle(
                  fontSize: ResponsiveUtils.sp(16, context),
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Cairo',
                  color: Colors.black87,
                ),
              ),
              const Spacer(),
              if (controller.selectedTypeFilter != 'all_permission_types'.tr ||
                  controller.selectedStateFilter !=
                      'all_permission_statuses'.tr)
                TextButton(
                  onPressed: () => controller.clearFilters(),
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
              // فلتر نوع الإذن
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'permission_type'.tr,
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
                          value: controller.selectedTypeFilter,
                          isExpanded: true,
                          items: controller.typeFilterOptions
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
                              controller.setTypeFilter(newValue);
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
                      'permission_status'.tr,
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
                          value: controller.selectedStateFilter,
                          isExpanded: true,
                          items: controller.stateFilterOptions
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
                              controller.setStateFilter(newValue);
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

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.inbox_outlined,
            size: ResponsiveUtils.iconSize(80, context),
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            'no_permission_requests'.tr,
            style: AppTextStyle.montserraSemiBold.copyWith(
              fontSize: ResponsiveUtils.sp(18, context),
              color: Colors.grey[600],
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'no_permission_requests_found'.tr,
            style: AppTextStyle.montserraRegular.copyWith(
              fontSize: ResponsiveUtils.sp(14, context),
              color: Colors.grey[500],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPermissionList(PermissionController controller) {
    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: ThemeColors.blue,
      child: ListView.builder(
        itemCount: controller.filteredPermissionRequestsList.length,
        itemBuilder: (context, index) {
          final permission = controller.filteredPermissionRequestsList[index];
          return _buildPermissionCard(context, permission);
        },
      ),
    );
  }

  Widget _buildPermissionCard(
    BuildContext context,
    PermissionModel permission,
  ) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
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
          // الصف الأول: رقم الطلب والموظف
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                permission.requestNumber,
                style: AppTextStyle.montserraBold.copyWith(
                  fontSize: ResponsiveUtils.sp(14, context),
                  color: ThemeColors.blue,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: permission.statusColor.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  permission.statusText,
                  style: AppTextStyle.montserraSemiBold.copyWith(
                    fontSize: ResponsiveUtils.sp(10, context),
                    color: permission.statusColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // الصف الثاني: الموظف
          Row(
            children: [
              Icon(
                Icons.person_outline,
                size: ResponsiveUtils.iconSize(16, context),
                color: ThemeColors.gry,
              ),
              const SizedBox(width: 8),
              Text(
                permission.employeeName,
                style: AppTextStyle.montserraSemiBold.copyWith(
                  fontSize: ResponsiveUtils.sp(14, context),
                  color: ThemeColors.black,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // الصف الثالث: نوع الإذن والتاريخ
          Row(
            children: [
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.access_time,
                      size: ResponsiveUtils.iconSize(16, context),
                      color: ThemeColors.gry,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      permission.typeName,
                      style: AppTextStyle.montserraRegular.copyWith(
                        fontSize: ResponsiveUtils.sp(12, context),
                        color: ThemeColors.black,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Row(
                  children: [
                    Icon(
                      Icons.calendar_today,
                      size: ResponsiveUtils.iconSize(16, context),
                      color: ThemeColors.gry,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      permission.formattedDate,
                      style: AppTextStyle.montserraRegular.copyWith(
                        fontSize: ResponsiveUtils.sp(12, context),
                        color: ThemeColors.black,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),

          // الصف الرابع: عدد الساعات
          Row(
            children: [
              Icon(
                Icons.schedule,
                size: ResponsiveUtils.iconSize(16, context),
                color: ThemeColors.gry,
              ),
              const SizedBox(width: 8),
              Text(
                permission.formattedHours,
                style: AppTextStyle.montserraSemiBold.copyWith(
                  fontSize: ResponsiveUtils.sp(14, context),
                  color: ThemeColors.blue,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
