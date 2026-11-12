import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:get/get_utils/get_utils.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/screens/home_screen/domin/home_controller.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';

void showAttendanceDialog(BuildContext context, HomeController homeController) {
  // تحديث حالة الـ dropdown حسب حالة الموظف الحالية
  homeController.updatePunchState(homeController.checkIn);

  showDialog(
    context: context,
    builder: (BuildContext context) {
      // طلب الموقع تلقائياً عند فتح الحوار (بعد تأخير بسيط لضمان أن الحوار جاهز)
      WidgetsBinding.instance.addPostFrameCallback((_) {
        homeController.getCurrentLocation();
      });
      return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ResponsiveUtils.r(20, context)),
        ),
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery.of(context).size.width * 0.9,
            maxHeight: MediaQuery.of(context).size.height * 0.9,
          ),
          padding: ResponsiveUtils.padding(context: context, all: 20),
          child: SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // رأس الحوار مع اسم المستخدم
                Row(
                  children: [
                    IconButton(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: Icon(
                        Icons.close,
                        size: ResponsiveUtils.iconSize(24, context),
                      ),
                    ),
                  ],
                ),

                ResponsiveUtils.sizedBoxH(20, context),

                // الخريطة الحقيقية
                Container(
                  height: ResponsiveUtils.h(200, context),
                  width: double.infinity,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.r(12, context),
                    ),
                    border: Border.all(color: Colors.grey[300]!),
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.r(12, context),
                    ),
                    child: Stack(
                      children: [
                        // Google Map
                        Obx(
                          () => homeController.currentLocation.value != null
                              ? GoogleMap(
                                  onMapCreated:
                                      (GoogleMapController controller) {
                                        homeController.mapController =
                                            controller;
                                      },
                                  initialCameraPosition: CameraPosition(
                                    target:
                                        homeController.currentLocation.value!,
                                    zoom: 16.0,
                                  ),
                                  markers: {
                                    Marker(
                                      markerId: MarkerId('current_location'.tr),
                                      position:
                                          homeController.currentLocation.value!,
                                      infoWindow: InfoWindow(
                                        title: 'current_location'.tr,
                                      ),
                                    ),
                                  },
                                  myLocationEnabled: true,
                                  myLocationButtonEnabled: false,
                                )
                              : Container(
                                  width: double.infinity,
                                  height: double.infinity,
                                  color: Colors.grey[200],
                                  child: Center(
                                    child: Obx(
                                      () =>
                                          homeController.isLoadingLocation.value
                                          ? Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                const CircularProgressIndicator(),
                                                ResponsiveUtils.sizedBoxH(
                                                  8,
                                                  context,
                                                ),
                                                Text(
                                                  'loading_location'.tr,
                                                  style: AppTextStyle
                                                      .montserraSemiBold
                                                      .copyWith(
                                                        fontSize:
                                                            ResponsiveUtils.sp(
                                                              14,
                                                              context,
                                                            ),
                                                        color: Colors.grey[600],
                                                      ),
                                                ),
                                              ],
                                            )
                                          : Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Icon(
                                                  Icons.location_off,
                                                  size:
                                                      ResponsiveUtils.iconSize(
                                                        40,
                                                        context,
                                                      ),
                                                  color: Colors.grey,
                                                ),
                                                ResponsiveUtils.sizedBoxH(
                                                  8,
                                                  context,
                                                ),
                                                Text(
                                                  'location_not_found'.tr,
                                                  style: AppTextStyle
                                                      .montserraSemiBold
                                                      .copyWith(
                                                        fontSize:
                                                            ResponsiveUtils.sp(
                                                              14,
                                                              context,
                                                            ),
                                                        color: Colors.grey[600],
                                                      ),
                                                ),
                                              ],
                                            ),
                                    ),
                                  ),
                                ),
                        ),

                        // زر تحديث الموقع
                        Positioned(
                          bottom: ResponsiveUtils.h(10, context),
                          left: ResponsiveUtils.w(10, context),
                          child: Obx(
                            () => ElevatedButton(
                              onPressed: homeController.isLoadingLocation.value
                                  ? null
                                  : () => homeController.getCurrentLocation(),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(
                                    ResponsiveUtils.r(8, context),
                                  ),
                                ),
                                padding: EdgeInsets.symmetric(
                                  horizontal: ResponsiveUtils.w(16, context),
                                  vertical: ResponsiveUtils.h(8, context),
                                ),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (homeController
                                      .isLoadingLocation
                                      .value) ...[
                                    SizedBox(
                                      width: ResponsiveUtils.w(16, context),
                                      height: ResponsiveUtils.h(16, context),
                                      child: const CircularProgressIndicator(
                                        strokeWidth: 2,
                                        color: Colors.white,
                                      ),
                                    ),
                                    ResponsiveUtils.sizedBoxW(8, context),
                                  ],
                                  Text(
                                    homeController.isLoadingLocation.value
                                        ? 'loading_fast'.tr
                                        : 'update_location'.tr,
                                    style: AppTextStyle.montserraSemiBold
                                        .copyWith(
                                          fontSize: ResponsiveUtils.sp(
                                            12,
                                            context,
                                          ),
                                          color: Colors.white,
                                        ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                ResponsiveUtils.sizedBoxH(20, context),

                // Punch State Dropdown
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.symmetric(
                    horizontal: ResponsiveUtils.w(16, context),
                    vertical: ResponsiveUtils.h(4, context),
                  ),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.grey[300]!),
                    borderRadius: BorderRadius.circular(
                      ResponsiveUtils.r(8, context),
                    ),
                  ),
                  child: Obx(
                    () => DropdownButton<String>(
                      value: homeController.selectedPunchState.value,
                      isExpanded: true,
                      underline: const SizedBox(),
                      icon: Icon(
                        Icons.keyboard_arrow_down,
                        color: Colors.grey[600],
                      ),
                      items: [
                        DropdownMenuItem(
                          value: 'Check In',
                          child: Row(
                            children: [
                              Icon(
                                Icons.login,
                                color: Colors.green,
                                size: ResponsiveUtils.iconSize(20, context),
                              ),
                              ResponsiveUtils.sizedBoxW(8, context),
                              Text(
                                'check_in'.tr,
                                style: AppTextStyle.montserraSemiBold.copyWith(
                                  fontSize: ResponsiveUtils.sp(14, context),
                                  color: ThemeColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        DropdownMenuItem(
                          value: 'Check Out',
                          child: Row(
                            children: [
                              Icon(
                                Icons.logout,
                                color: Colors.red,
                                size: ResponsiveUtils.iconSize(20, context),
                              ),
                              ResponsiveUtils.sizedBoxW(8, context),
                              Text(
                                'check_out'.tr,
                                style: AppTextStyle.montserraSemiBold.copyWith(
                                  fontSize: ResponsiveUtils.sp(14, context),
                                  color: ThemeColors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                      onChanged: (String? newValue) {
                        if (newValue != null) {
                          homeController.selectedPunchState.value = newValue;
                        }
                      },
                    ),
                  ),
                ),

                ResponsiveUtils.sizedBoxH(16, context),

                // أزرار Cancel و Add
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(color: Colors.grey[400]!),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.r(8, context),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.h(12, context),
                          ),
                        ),
                        child: Text(
                          'cancel'.tr,
                          style: AppTextStyle.montserraSemiBold.copyWith(
                            fontSize: ResponsiveUtils.sp(14, context),
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ),
                    ResponsiveUtils.sizedBoxW(16, context),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async {
                          // التحقق من صحة العملية
                          if (homeController.validatePunchAction(
                            homeController.selectedPunchState.value,
                            homeController.checkIn,
                          )) {
                            Navigator.of(context).pop();
                            await homeController.startTimer();
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(
                              ResponsiveUtils.r(8, context),
                            ),
                          ),
                          padding: EdgeInsets.symmetric(
                            vertical: ResponsiveUtils.h(12, context),
                          ),
                        ),
                        child: Text(
                          'confirm'.tr,
                          style: AppTextStyle.montserraSemiBold.copyWith(
                            fontSize: ResponsiveUtils.sp(14, context),
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      );
    },
  );
}
