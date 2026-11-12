import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/model/attendance_model.dart';
import 'package:orbit_workforce/screens/home_screen/domin/home_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';
import 'package:intl/intl.dart';

Widget buildAttendanceSection(HomeController homeController) {
  return Builder(
    builder: (context) => Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(ResponsiveUtils.r(20, context)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 10,
            spreadRadius: 2,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        children: [
          // العنوان
          Padding(
            padding: ResponsiveUtils.padding(context: context, all: 20),
            child: Row(
              children: [
                Icon(
                  Icons.access_time,
                  color: HexColor('#004ADB'),
                  size: ResponsiveUtils.iconSize(24, context),
                ),
                ResponsiveUtils.sizedBoxW(10, context),
                Text(
                  'recent_activity'.tr,
                  style: AppTextStyle.montserraBold.copyWith(
                    fontSize: ResponsiveUtils.sp(20, context),
                    color: ThemeColors.black,
                  ),
                ),
                // const Spacer(),
                // تم حذف زر عرض الكل بناءً على طلب العميل
              ],
            ),
          ),

          // قائمة الحضور
          SizedBox(
            height: ResponsiveUtils.h(300, context), // ارتفاع ثابت للقائمة
            child: GetBuilder<HomeController>(
              builder: (homeController) {
                if (homeController.loading) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (homeController.attendanceList.isEmpty) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.schedule_outlined,
                          size: ResponsiveUtils.iconSize(60, context),
                          color: Colors.grey[400],
                        ),
                        ResponsiveUtils.sizedBoxH(16, context),
                        Text(
                          'no_attendance_records'.tr,
                          style: AppTextStyle.montserraSemiBold.copyWith(
                            fontSize: ResponsiveUtils.sp(16, context),
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  );
                }

                // عرض جميع السجلات بدون حد
                return ListView.builder(
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.w(20, context),
                  ),
                  itemCount: homeController.attendanceList.length,
                  itemBuilder: (context, index) {
                    final attendance = homeController.attendanceList[index];
                    return _buildAttendanceCard(context, attendance);
                  },
                );
              },
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _buildAttendanceCard(BuildContext context, AttendanceModel attendance) {
  return Container(
    margin: EdgeInsets.only(bottom: ResponsiveUtils.h(16, context)),
    padding: ResponsiveUtils.padding(context: context, all: 16),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(ResponsiveUtils.r(12, context)),
      border: Border.all(color: HexColor('#EEEEEE')),
      boxShadow: [
        BoxShadow(
          color: HexColor('#4F4F4F1A').withValues(alpha: 0.05),
          spreadRadius: 0,
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ],
    ),
    child: Column(
      children: [
        // Check In
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: ResponsiveUtils.w(8, context),
                  height: ResponsiveUtils.h(8, context),
                  decoration: const BoxDecoration(
                    color: Colors.green,
                    shape: BoxShape.circle,
                  ),
                ),
                ResponsiveUtils.sizedBoxW(12, context),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'check_in'.tr,
                      style: AppTextStyle.montserraSemiBold.copyWith(
                        fontSize: ResponsiveUtils.sp(14, context),
                        color: ThemeColors.black,
                      ),
                    ),
                    if (attendance.checkIn.isNotEmpty)
                      Text(
                        _formatDate(attendance.checkIn),
                        style: AppTextStyle.montserraRegular.copyWith(
                          fontSize: ResponsiveUtils.sp(12, context),
                          color: Colors.grey[600],
                        ),
                      ),
                  ],
                ),
              ],
            ),
            if (attendance.checkIn.isNotEmpty)
              Text(
                _formatTime(attendance.checkIn),
                style: AppTextStyle.montserraBold.copyWith(
                  fontSize: ResponsiveUtils.sp(16, context),
                  color: ThemeColors.black,
                ),
              ),
          ],
        ),

        if (attendance.checkOut.isNotEmpty) ...[
          ResponsiveUtils.sizedBoxH(12, context),
          // Check Out
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: ResponsiveUtils.w(8, context),
                    height: ResponsiveUtils.h(8, context),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  ResponsiveUtils.sizedBoxW(12, context),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'check_out'.tr,
                        style: AppTextStyle.montserraSemiBold.copyWith(
                          fontSize: ResponsiveUtils.sp(14, context),
                          color: ThemeColors.black,
                        ),
                      ),
                      Text(
                        _formatDate(attendance.checkOut),
                        style: AppTextStyle.montserraRegular.copyWith(
                          fontSize: ResponsiveUtils.sp(12, context),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                _formatTime(attendance.checkOut),
                style: AppTextStyle.montserraBold.copyWith(
                  fontSize: ResponsiveUtils.sp(16, context),
                  color: ThemeColors.black,
                ),
              ),
            ],
          ),
        ] else ...[
          ResponsiveUtils.sizedBoxH(12, context),
          // Check Out Placeholder
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: ResponsiveUtils.w(8, context),
                    height: ResponsiveUtils.h(8, context),
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                  ResponsiveUtils.sizedBoxW(12, context),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'check_out'.tr,
                        style: AppTextStyle.montserraSemiBold.copyWith(
                          fontSize: ResponsiveUtils.sp(14, context),
                          color: ThemeColors.black,
                        ),
                      ),
                      Text(
                        'loading'.tr, // أو "لم يتم تسجيل الخروج بعد"
                        style: AppTextStyle.montserraRegular.copyWith(
                          fontSize: ResponsiveUtils.sp(12, context),
                          color: Colors.grey[600],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Text(
                '--:--',
                style: AppTextStyle.montserraBold.copyWith(
                  fontSize: ResponsiveUtils.sp(16, context),
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ],

        // إحصائيات إضافية
        if (attendance.workedHours > 0) ...[
          ResponsiveUtils.sizedBoxH(12, context),
          Divider(color: Colors.grey[200], height: 1),
          ResponsiveUtils.sizedBoxH(12, context),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _buildStatChip(
                context,
                'worked_hours'.tr,
                '${attendance.workedHours.toStringAsFixed(1)}h',
                Colors.blue,
              ),
              if (attendance.overtimeHours != 0)
                _buildStatChip(
                  context,
                  'overtime'.tr,
                  '${attendance.overtimeHours.toStringAsFixed(1)}h',
                  attendance.overtimeHours > 0 ? Colors.green : Colors.orange,
                ),
            ],
          ),
        ],
      ],
    ),
  );
}

Widget _buildStatChip(
  BuildContext context,
  String label,
  String value,
  Color color,
) {
  return Container(
    padding: ResponsiveUtils.padding(
      context: context,
      horizontal: 12,
      vertical: 6,
    ),
    decoration: BoxDecoration(
      color: color.withValues(alpha: 0.1),
      borderRadius: BorderRadius.circular(ResponsiveUtils.r(20, context)),
      border: Border.all(color: color.withValues(alpha: 0.3)),
    ),
    child: Column(
      children: [
        Text(
          label,
          style: AppTextStyle.montserraRegular.copyWith(
            fontSize: ResponsiveUtils.sp(10, context),
            color: color,
          ),
        ),
        Text(
          value,
          style: AppTextStyle.montserraBold.copyWith(
            fontSize: ResponsiveUtils.sp(12, context),
            color: color,
          ),
        ),
      ],
    ),
  );
}

String _formatDate(String dateString) {
  if (dateString.isEmpty) return '--/--/----';
  try {
    DateTime dateTime = DateTime.parse(dateString);
    return DateFormat('d MMM yyyy').format(dateTime);
  } catch (e) {
    return dateString; // Return original string if parsing fails
  }
}

String _formatTime(String timeString) {
  if (timeString.isEmpty) return '--:--';
  try {
    DateTime dateTime = DateTime.parse(
      timeString,
    ).add(const Duration(hours: 3));
    return DateFormat('hh:mm a').format(dateTime); // 24 ساعة
  } catch (e) {
    return '--:--';
  }
}
