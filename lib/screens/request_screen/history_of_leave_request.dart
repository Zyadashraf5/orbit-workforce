import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:orbit_workforce/routes/app_pages.dart';
import 'package:orbit_workforce/screens/request_screen/domin/request_controller.dart';

class HistoryOfLeaveRequest extends StatelessWidget {
  const HistoryOfLeaveRequest({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'leave_requests_history'.tr,
          style: const TextStyle(
            fontFamily: 'Cairo',
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 1,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Get.back(),
        ),
      ),
      body: Directionality(
        textDirection: TextDirection.rtl,
        child: SafeArea(
          child: Builder(
            builder: (context) => Column(
              children: [
                // قسم الفلترة
                _buildFilterSection(context),
                ResponsiveUtils.sizedBoxH(20, context),
                Expanded(
                  child: GetBuilder<RequestController>(
                    builder: (controller) {
                      if (controller.loading) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (controller.filteredLeaveRequestsList.isEmpty) {
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.event_busy,
                                size: ResponsiveUtils.r(80, context),
                                color: Colors.grey[400],
                              ),
                              ResponsiveUtils.sizedBoxH(16, context),
                              Text(
                                'no_leave_requests'.tr,
                                style: TextStyle(
                                  fontSize: ResponsiveUtils.sp(18, context),
                                  color: Colors.grey[600],
                                  fontFamily: 'Cairo',
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ],
                          ),
                        );
                      }

                      return ListView.builder(
                        padding: EdgeInsets.symmetric(
                          horizontal: ResponsiveUtils.w(16, context),
                        ),
                        itemCount: controller.filteredLeaveRequestsList.length,
                        itemBuilder: (context, index) {
                          final leaveRequest =
                              controller.filteredLeaveRequestsList[index];

                          return Card(
                            elevation: 3,
                            margin: EdgeInsets.only(
                              bottom: ResponsiveUtils.h(12, context),
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(
                                ResponsiveUtils.r(12, context),
                              ),
                              side: BorderSide(
                                color: leaveRequest.statusColor,
                                width: 1.5,
                              ),
                            ),
                            child: Padding(
                              padding: ResponsiveUtils.padding(
                                context: context,
                                all: 16,
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // رأس الكارد - نوع الإجازة والحالة
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Expanded(
                                        child: Text(
                                          leaveRequest.holidayStatusName,
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils.sp(
                                              16,
                                              context,
                                            ),
                                            fontWeight: FontWeight.bold,
                                            fontFamily: 'Cairo',
                                            color: Colors.black87,
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(
                                          horizontal: ResponsiveUtils.w(
                                            12,
                                            context,
                                          ),
                                          vertical: ResponsiveUtils.h(
                                            6,
                                            context,
                                          ),
                                        ),
                                        decoration: BoxDecoration(
                                          color: leaveRequest.statusColor
                                              .withValues(alpha: 0.2),
                                          borderRadius: BorderRadius.circular(
                                            ResponsiveUtils.r(20, context),
                                          ),
                                          border: Border.all(
                                            color: leaveRequest.statusColor,
                                            width: 1,
                                          ),
                                        ),
                                        child: Text(
                                          leaveRequest.statusText,
                                          style: TextStyle(
                                            fontSize: ResponsiveUtils.sp(
                                              12,
                                              context,
                                            ),
                                            fontWeight: FontWeight.w600,
                                            fontFamily: 'Cairo',
                                            color: leaveRequest.statusColor,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),

                                  ResponsiveUtils.sizedBoxH(12, context),

                                  // تفاصيل الطلب
                                  if (leaveRequest.name.isNotEmpty)
                                    _buildInfoRow(
                                      context: context,
                                      icon: Icons.description,
                                      label: 'description'.tr,
                                      value: leaveRequest.name,
                                    ),

                                  _buildInfoRow(
                                    context: context,
                                    icon: Icons.calendar_today,
                                    label: 'from_date'.tr,
                                    value: leaveRequest.formattedDateFrom,
                                  ),

                                  _buildInfoRow(
                                    context: context,
                                    icon: Icons.calendar_month,
                                    label: 'to_date'.tr,
                                    value: leaveRequest.formattedDateTo,
                                  ),

                                  if (leaveRequest.durationDisplay.isNotEmpty)
                                    _buildInfoRow(
                                      context: context,
                                      icon: Icons.access_time,
                                      label: 'duration'.tr,
                                      value: leaveRequest.durationDisplay,
                                    ),
                                ],
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
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
            Get.toNamed(Routes.createRequest);
          },
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: const Icon(Icons.add, color: Colors.white),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
    );
  }

  Widget _buildFilterSection(BuildContext context) {
    return GetBuilder<RequestController>(
      builder: (controller) {
        return Container(
          margin: ResponsiveUtils.padding(
            context: context,
            horizontal: 16,
            vertical: 8,
          ),
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
                    'filter_requests'.tr,
                    style: TextStyle(
                      fontSize: ResponsiveUtils.sp(16, context),
                      fontWeight: FontWeight.bold,
                      fontFamily: 'Cairo',
                      color: Colors.black87,
                    ),
                  ),
                  const Spacer(),
                  if (controller.selectedHolidayStatusFilter !=
                          'جميع الأنواع' ||
                      controller.selectedStateFilter != 'جميع الحالات')
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
                  // فلتر نوع الإجازة
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'leave_type_filter'.tr,
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
                              value: controller.selectedHolidayStatusFilter,
                              isExpanded: true,
                              items: controller.holidayStatusFilterOptions
                                  .map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontSize: ResponsiveUtils.sp(
                                            13,
                                            context,
                                          ),
                                          fontFamily: 'Cairo',
                                          color: Colors.black87,
                                        ),
                                      ),
                                    );
                                  })
                                  .toList(),
                              onChanged: (String? newValue) {
                                if (newValue != null) {
                                  controller.setHolidayStatusFilter(newValue);
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
                          'status_filter'.tr,
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
                                  .map<DropdownMenuItem<String>>((
                                    String value,
                                  ) {
                                    return DropdownMenuItem<String>(
                                      value: value,
                                      child: Text(
                                        value,
                                        style: TextStyle(
                                          fontSize: ResponsiveUtils.sp(
                                            13,
                                            context,
                                          ),
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
      },
    );
  }

  Widget _buildInfoRow({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    return Padding(
      padding: EdgeInsets.only(bottom: ResponsiveUtils.h(8, context)),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            icon,
            size: ResponsiveUtils.r(18, context),
            color: Colors.grey[600],
          ),
          ResponsiveUtils.sizedBoxW(8, context),
          Text(
            '$label: ',
            style: TextStyle(
              fontSize: ResponsiveUtils.sp(14, context),
              fontWeight: FontWeight.w600,
              fontFamily: 'Cairo',
              color: Colors.grey[700],
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14, context),
                fontFamily: 'Cairo',
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
