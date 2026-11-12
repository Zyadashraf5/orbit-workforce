import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/screens/home_screen/domin/home_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

class DocumentaionScreen extends GetView<HomeController> {
  const DocumentaionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    Get.put(HomeController());
    final bool isTablet = ResponsiveUtils.isTablet(context);
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'reports'.tr,
          style: AppTextStyle.montserraBold.copyWith(
            fontSize: ResponsiveUtils.sp(20, context),
            color: ThemeColors.black,
          ),
        ),
      ),
      body: GetBuilder<HomeController>(
        builder: (controller) {
          return Directionality(
            textDirection: TextDirection.rtl,
            child: Container(
              color: ThemeColors.background,
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height,
              child: Align(
                alignment: isTablet ? Alignment.center : Alignment.topCenter,
                child: Container(
                  constraints: BoxConstraints(
                    maxWidth: ResponsiveUtils.getMaxContentWidth(context),
                  ),
                  padding: EdgeInsets.symmetric(
                    horizontal: 20,
                    vertical: isTablet ? 20 : 16,
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'current_month_statistics'.tr,
                              style: AppTextStyle.montserraBold.copyWith(
                                fontSize: ResponsiveUtils.sp(16, context),
                                color: ThemeColors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showDateFilterDialog();
                              },
                              child: Row(
                                children: [
                                  Text(
                                    controller.getDateDisplayText(),
                                    style: AppTextStyle.montserraSemiBold
                                        .copyWith(
                                          fontSize: ResponsiveUtils.sp(
                                            16,
                                            context,
                                          ),
                                          color: ThemeColors.black,
                                        ),
                                  ),
                                  const Icon(
                                    Icons.arrow_drop_down_outlined,
                                    color: ThemeColors.black,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 20),
                        // استخدام Row مع Expanded للتكيف مع جميع أحجام الشاشات
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // الصناديق الصغيرة
                            Expanded(
                              flex: 7,
                              child: Column(
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: boxDocumentaionFlexible(
                                          context,
                                          'assets/images/tabler_clock-up.png',
                                          'attendance_days'.tr,
                                          '${controller.getFilteredAttendanceDays()}',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: boxDocumentaionFlexible(
                                          context,
                                          'assets/images/tabler_clock-down.png',
                                          'late_days'.tr,
                                          '${controller.getFilteredLateDays()}',
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: boxDocumentaionFlexible(
                                          context,
                                          'assets/images/tabler_clock-x.png',
                                          'absent_days'.tr,
                                          '${controller.getFilteredAbsentDays()}',
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Expanded(
                                        child: boxDocumentaionFlexible(
                                          context,
                                          'assets/images/requestes.png',
                                          'overtime_hours'.tr,
                                          controller
                                              .getFilteredOvertimeHours()
                                              .toStringAsFixed(1),
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: boxDocumentaionFlexible(
                                          context,
                                          'assets/images/requestes2.png',
                                          'permission_hours'.tr,
                                          controller
                                              .getFilteredPermissionHours()
                                              .toStringAsFixed(1),
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      // صندوق فارغ للحفاظ على التخطيط
                                      const Expanded(
                                        child: SizedBox(height: 75),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 10),
                            // صندوق ساعات العمل
                            Expanded(
                              flex: 3,
                              child: Container(
                                height: 172,
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 8,
                                  vertical: 12,
                                ),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
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
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Flexible(
                                      child: Text(
                                        'number'.tr,
                                        style: AppTextStyle.montserraBold
                                            .copyWith(
                                              fontSize: ResponsiveUtils.sp(
                                                14,
                                                context,
                                              ),
                                              color: ThemeColors.white,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    Flexible(
                                      child: Text(
                                        'working_hours'.tr,
                                        style: AppTextStyle.montserraBold
                                            .copyWith(
                                              fontSize: ResponsiveUtils.sp(
                                                14,
                                                context,
                                              ),
                                              color: ThemeColors.white,
                                            ),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    const SizedBox(height: 8),
                                    Flexible(
                                      child: FittedBox(
                                        fit: BoxFit.scaleDown,
                                        child: Text(
                                          controller
                                              .getFilteredTotalWorkedHours()
                                              .toStringAsFixed(0),
                                          style: AppTextStyle.montserraSemiBold
                                              .copyWith(
                                                fontSize: ResponsiveUtils.sp(
                                                  28,
                                                  context,
                                                ),
                                                color: ThemeColors.white,
                                              ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),

                        const SizedBox(height: 20),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'month_details'.tr,
                              style: AppTextStyle.montserraBold.copyWith(
                                fontSize: ResponsiveUtils.sp(16, context),
                                color: ThemeColors.black,
                              ),
                            ),
                            GestureDetector(
                              onTap: () {
                                _showFilterDialog();
                              },
                              child: Container(
                                height: 36,
                                width: 130,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6),
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
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Image.asset(
                                      'assets/images/filter.png',
                                      height: ResponsiveUtils.sp(18, context),
                                      width: ResponsiveUtils.sp(18, context),
                                    ),
                                    ResponsiveUtils.sizedBoxW(5, context),
                                    Flexible(
                                      child: Text(
                                        'filter_factors'.tr,
                                        style: AppTextStyle.montserraSemiBold
                                            .copyWith(
                                              fontSize: ResponsiveUtils.sp(
                                                12,
                                                context,
                                              ),
                                              color: ThemeColors.white,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: controller.getFilteredHistoryList().length,
                          itemBuilder: (context, index) {
                            final historyItem = controller
                                .getFilteredHistoryList()[index];

                            // تحديد لون الحالة حسب الكود
                            Color statusColor;
                            Color bgColor;

                            switch (historyItem.code) {
                              case 'ATT':
                                statusColor = HexColor('#0B40FD');
                                bgColor = HexColor('#F1F4FF');
                                break;
                              case 'LATE':
                                statusColor = HexColor('#FF6B35');
                                bgColor = HexColor('#FFF1ED');
                                break;
                              case 'ABS':
                                statusColor = HexColor('#E53E3E');
                                bgColor = HexColor('#FED7D7');
                                break;
                              case 'OVT':
                                statusColor = HexColor('#38A169');
                                bgColor = HexColor('#F0FFF4');
                                break;
                              case 'PERM':
                                statusColor = HexColor('#9F7AEA');
                                bgColor = HexColor('#FAF5FF');
                                break;
                              default:
                                statusColor = HexColor('#718096');
                                bgColor = HexColor('#F7FAFC');
                            }

                            return Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 10,
                                vertical: 10,
                              ),
                              margin: const EdgeInsets.only(bottom: 12),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: [
                                  BoxShadow(
                                    color: HexColor(
                                      '#4F4F4F1A',
                                    ).withValues(alpha: 0.1),
                                    spreadRadius: 1,
                                    blurRadius: 3,
                                    offset: const Offset(
                                      1,
                                      2,
                                    ), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Text(
                                          controller.getDayFromDate(
                                            historyItem.date,
                                          ),
                                          style: AppTextStyle.montserraSemiBold
                                              .copyWith(
                                                fontSize: ResponsiveUtils.sp(
                                                  18,
                                                  context,
                                                ),
                                                color: ThemeColors.black,
                                              ),
                                        ),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                historyItem.dayName ??
                                                    'غير محدد',
                                                style: AppTextStyle
                                                    .montserraSemiBold
                                                    .copyWith(
                                                      fontSize:
                                                          ResponsiveUtils.sp(
                                                            16,
                                                            context,
                                                          ),
                                                      color: ThemeColors.black,
                                                    ),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                controller.getFormattedDateText(
                                                  historyItem.date,
                                                ),
                                                style: AppTextStyle
                                                    .montserraRegular
                                                    .copyWith(
                                                      fontSize:
                                                          ResponsiveUtils.sp(
                                                            12,
                                                            context,
                                                          ),
                                                      color: ThemeColors.gry,
                                                    ),
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: bgColor,
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      historyItem.name ?? 'غير محدد',
                                      style: AppTextStyle.montserraSemiBold
                                          .copyWith(
                                            fontSize: ResponsiveUtils.sp(
                                              12,
                                              context,
                                            ),
                                            color: statusColor,
                                          ),
                                    ),
                                  ),
                                ],
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget boxDocumentaion(
    BuildContext context,
    String icon,
    String name,
    String number,
  ) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.25,
      height: 81,
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HexColor('#EEEEEE')),
        boxShadow: [
          BoxShadow(
            color: HexColor('#4F4F4F1A').withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  icon,
                  height: ResponsiveUtils.sp(18, context),
                  width: ResponsiveUtils.sp(18, context),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    name,
                    style: AppTextStyle.montserraSemiBold.copyWith(
                      fontSize: ResponsiveUtils.sp(11, context),
                      color: ThemeColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 3,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 8.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  number,
                  style: AppTextStyle.montserraBold.copyWith(
                    fontSize: ResponsiveUtils.sp(16, context),
                    color: ThemeColors.black,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// صندوق إحصائيات مرن - يتكيف مع عرض الشاشة
  Widget boxDocumentaionFlexible(
    BuildContext context,
    String icon,
    String name,
    String number,
  ) {
    return Container(
      height: 75,
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: HexColor('#EEEEEE')),
        boxShadow: [
          BoxShadow(
            color: HexColor('#4F4F4F1A').withValues(alpha: 0.1),
            spreadRadius: 0,
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Image.asset(
                  icon,
                  height: ResponsiveUtils.sp(16, context),
                  width: ResponsiveUtils.sp(16, context),
                ),
                const SizedBox(height: 2),
                Flexible(
                  child: Text(
                    name,
                    style: AppTextStyle.montserraSemiBold.copyWith(
                      fontSize: ResponsiveUtils.sp(10, context),
                      color: ThemeColors.black,
                    ),
                    overflow: TextOverflow.ellipsis,
                    maxLines: 2,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 4.0),
            child: Text(
              number,
              style: AppTextStyle.montserraBold.copyWith(
                fontSize: ResponsiveUtils.sp(14, context),
                color: ThemeColors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showDateFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: Text(
          'select_year'.tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: _buildYearMonthSelector(),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: HexColor('#004ADB').withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'close'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: HexColor('#004ADB'),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildYearMonthSelector() {
    return GetBuilder<HomeController>(
      builder: (controller) {
        return Column(
          children: [
            // اختيار السنة
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: HexColor('#004ADB').withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                '${"select_year".tr}: ${controller.selectedDate.year}',
                style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 15),
            Expanded(
              child: ListView.builder(
                itemCount: 10, // سنوات من 2020 إلى 2029
                itemBuilder: (context, index) {
                  int year = DateTime.now().year - 5 + index;
                  bool isSelected = controller.selectedDate.year == year;

                  return Container(
                    margin: const EdgeInsets.symmetric(vertical: 1),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? HexColor('#004ADB').withValues(alpha: 0.15)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(8),
                      border: isSelected
                          ? Border.all(color: HexColor('#004ADB'), width: 1)
                          : null,
                    ),
                    child: ListTile(
                      dense: true,
                      title: Text(
                        year.toString(),
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: isSelected
                              ? FontWeight.bold
                              : FontWeight.normal,
                          color: isSelected
                              ? HexColor('#004ADB')
                              : Colors.black,
                        ),
                      ),
                      leading: RadioGroup<int>(
                        groupValue: controller.selectedDate.year,
                        onChanged: (int? value) {
                          if (value != null) {
                            controller.setSelectedYear(value);
                            _showMonthSelector(value);
                          }
                        },
                        child: Radio<int>(
                          value: year,
                          activeColor: HexColor('#004ADB'),
                        ),
                      ),
                      onTap: () {
                        controller.setSelectedYear(year);
                        _showMonthSelector(year);
                      },
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showMonthSelector(int selectedYear) {
    Get.back(); // إغلاق نافذة السنة
    Get.dialog(
      AlertDialog(
        title: Text(
          'select_month'.tr,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: GetBuilder<HomeController>(
            builder: (controller) {
              List<String> monthKeys = [
                'january',
                'february',
                'march',
                'april',
                'may',
                'june',
                'july',
                'august',
                'september',
                'october',
                'november',
                'december',
              ];

              return Column(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: HexColor('#004ADB').withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      '${"select_month".tr} - $selectedYear',
                      style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 15),
                  Expanded(
                    child: ListView.builder(
                      itemCount: 12,
                      itemBuilder: (context, index) {
                        String monthKey = monthKeys[index];
                        String monthName = monthKey.tr;
                        bool isSelected =
                            controller.selectedDate.year == selectedYear &&
                            controller.selectedDate.month == index + 1;

                        return Container(
                          margin: const EdgeInsets.symmetric(vertical: 1),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? HexColor('#004ADB').withValues(alpha: 0.15)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(8),
                            border: isSelected
                                ? Border.all(
                                    color: HexColor('#004ADB'),
                                    width: 1,
                                  )
                                : null,
                          ),
                          child: ListTile(
                            dense: true,
                            title: Text(
                              monthName,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: isSelected
                                    ? FontWeight.bold
                                    : FontWeight.normal,
                                color: isSelected
                                    ? HexColor('#004ADB')
                                    : Colors.black,
                              ),
                            ),
                            leading: RadioGroup<int>(
                              groupValue: controller.selectedDate.month,
                              onChanged: (int? value) {
                                if (value != null) {
                                  controller.setSelectedYearAndMonth(
                                    selectedYear,
                                    value,
                                  );
                                  Get.back();
                                }
                              },
                              child: Radio<int>(
                                value: index + 1,
                                activeColor: HexColor('#004ADB'),
                              ),
                            ),
                            onTap: () {
                              controller.setSelectedYearAndMonth(
                                selectedYear,
                                index + 1,
                              );
                              Get.back();
                            },
                          ),
                        );
                      },
                    ),
                  ),
                ],
              );
            },
          ),
        ),
        actions: [
          SizedBox(
            width: double.infinity,
            child: TextButton(
              onPressed: () => Get.back(),
              style: TextButton.styleFrom(
                backgroundColor: HexColor('#004ADB').withValues(alpha: 0.1),
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
              child: Text(
                'close'.tr,
                style: TextStyle(
                  fontSize: 16,
                  color: HexColor('#004ADB'),
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showFilterDialog() {
    Get.dialog(
      AlertDialog(
        title: Text('filter_data'.tr),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildFilterOption('ALL', 'all_data'.tr),
            _buildFilterOption('ATT', 'attendance_days'.tr),
            _buildFilterOption('LATE', 'late_days'.tr),
            _buildFilterOption('ABS', 'absent_days'.tr),
            _buildFilterOption('OVT', 'overtime_hours'.tr),
            _buildFilterOption('PERM', 'permission_hours'.tr),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Get.back(), child: Text('close'.tr)),
        ],
      ),
    );
  }

  Widget _buildFilterOption(String value, String label) {
    return GetBuilder<HomeController>(
      builder: (controller) => RadioGroup<String>(
        groupValue: controller.selectedFilter,
        onChanged: (String? value) {
          if (value != null) {
            controller.setFilter(value);
            Get.back();
          }
        },
        child: RadioListTile<String>(title: Text(label), value: value),
      ),
    );
  }
}
