import 'dart:io';
import 'package:flutter/material.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/colors/colors.dart';
import 'package:orbit_workforce/screens/request_screen/domin/request_controller.dart';
import 'package:orbit_workforce/screens/request_screen/image_preview_screen.dart';
import 'package:orbit_workforce/styles/styles_manager.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as path;

class CreateRequestScreen extends GetView<RequestController> {
  CreateRequestScreen({super.key});

  final ImagePicker _picker = ImagePicker();
  @override
  final controller = Get.put(RequestController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: ThemeColors.background,
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'create_request'.tr,
          style: AppTextStyle.montserraBold.copyWith(
            fontSize: ResponsiveUtils.sp(20, context),
            color: ThemeColors.black,
          ),
        ),
      ),
      body: Container(
        color: ThemeColors.background,
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height,
        child: Center(
          child: Container(
            constraints: BoxConstraints(
              maxWidth: ResponsiveUtils.getMaxContentWidth(context),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'leave_request'.tr,
                    style: AppTextStyle.montserraBold.copyWith(
                      fontSize: ResponsiveUtils.sp(18, context),
                      color: ThemeColors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'leave_type'.tr,
                    style: AppTextStyle.montserraRegular.copyWith(
                      fontSize: ResponsiveUtils.sp(16, context),
                      color: ThemeColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  buildRequestType(context),
                  const SizedBox(height: 20),
                  Text(
                    'leave_start_date'.tr,
                    style: AppTextStyle.montserraRegular.copyWith(
                      fontSize: ResponsiveUtils.sp(16, context),
                      color: ThemeColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => controller.selectStartDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: HexColor('#EEEEEE')),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GetBuilder<RequestController>(
                        builder: (controller) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.formattedStartDate,
                              style: AppTextStyle.montserraSemiBold.copyWith(
                                fontSize: ResponsiveUtils.sp(18, context),
                                color: ThemeColors.black,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: HexColor('#004ADB'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'leave_end_date'.tr,
                    style: AppTextStyle.montserraRegular.copyWith(
                      fontSize: ResponsiveUtils.sp(16, context),
                      color: ThemeColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () => controller.selectEndDate(context),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: HexColor('#EEEEEE')),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: GetBuilder<RequestController>(
                        builder: (controller) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              controller.formattedEndDate,
                              style: AppTextStyle.montserraSemiBold.copyWith(
                                fontSize: ResponsiveUtils.sp(18, context),
                                color: ThemeColors.black,
                              ),
                            ),
                            Icon(
                              Icons.calendar_today,
                              color: HexColor('#004ADB'),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'note_optional'.tr,
                    style: AppTextStyle.montserraRegular.copyWith(
                      fontSize: ResponsiveUtils.sp(16, context),
                      color: ThemeColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextFormField(
                    keyboardType: TextInputType.text,
                    controller: controller.descriptionController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      contentPadding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                      filled: true,
                      fillColor: ThemeColors.white,
                      hintText: 'if_you_have_any_notes'.tr,
                      hintStyle: AppTextStyle.montserraSemiBold.copyWith(
                        fontSize: ResponsiveUtils.sp(16, context),
                        color: ThemeColors.black,
                      ),
                      errorBorder: const OutlineInputBorder(
                        borderRadius: BorderRadius.all(Radius.circular(10.0)),
                        borderSide: BorderSide(color: Colors.red),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(color: HexColor('#EEEEEE')),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(color: HexColor('#EEEEEE')),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: const BorderRadius.all(
                          Radius.circular(10.0),
                        ),
                        borderSide: BorderSide(color: HexColor('#EEEEEE')),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'attach_image'.tr,
                    style: AppTextStyle.montserraRegular.copyWith(
                      fontSize: ResponsiveUtils.sp(16, context),
                      color: ThemeColors.black,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildAttachmentButton(
                        context: context,
                        icon: Icons.camera_alt,
                        text: 'camera'.tr,
                        onTap: () => _getImage(ImageSource.camera),
                      ),
                      _buildAttachmentButton(
                        context: context,
                        icon: Icons.photo_library,
                        text: 'photo_gallery'.tr,
                        onTap: () => _getImage(ImageSource.gallery),
                      ),
                    ],
                  ),
                  const SizedBox(height: 15),
                  GetBuilder<RequestController>(
                    builder: (controller) {
                      return controller.attachments.isNotEmpty
                          ? Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      'attached_image_title'.tr,
                                      style: AppTextStyle.montserraSemiBold
                                          .copyWith(
                                            fontSize: ResponsiveUtils.sp(
                                              14,
                                              context,
                                            ),
                                            color: HexColor('#004ADB'),
                                          ),
                                    ),
                                    controller.uploadingAttachment
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                            ),
                                          )
                                        : const SizedBox(),
                                  ],
                                ),
                                const SizedBox(height: 10),
                                Container(
                                  padding: ResponsiveUtils.padding(
                                    context: context,
                                    all: 12,
                                  ),
                                  decoration: BoxDecoration(
                                    color: Colors.grey[100],
                                    borderRadius: BorderRadius.circular(
                                      ResponsiveUtils.r(8, context),
                                    ),
                                    border: Border.all(
                                      color: HexColor('#EEEEEE'),
                                    ),
                                  ),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Row(
                                        children: [
                                          const Icon(
                                            Icons.check_circle,
                                            color: Colors.green,
                                          ),
                                          ResponsiveUtils.sizedBoxW(
                                            10,
                                            context,
                                          ),
                                          Expanded(
                                            child: Text(
                                              'image_uploaded_successfully'.tr,
                                              style: TextStyle(
                                                fontSize: ResponsiveUtils.sp(
                                                  14,
                                                  context,
                                                ),
                                                fontWeight: FontWeight.bold,
                                                fontFamily: 'Cairo',
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                      const SizedBox(height: 10),
                                      // عرض صور المرفقات هنا
                                      Wrap(
                                        spacing: 10,
                                        runSpacing: 10,
                                        children: List.generate(
                                          controller.attachmentFiles.length,
                                          (index) => Stack(
                                            children: [
                                              Container(
                                                width: 80,
                                                height: 80,
                                                decoration: BoxDecoration(
                                                  color: HexColor(
                                                    '#004ADB',
                                                  ).withValues(alpha: 0.1),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                  border: Border.all(
                                                    color: HexColor('#EEEEEE'),
                                                  ),
                                                ),
                                                child: Stack(
                                                  children: [
                                                    // إذا كان الملف صورة، اعرضها
                                                    if (controller
                                                            .attachmentFiles[index]['isImage'] ==
                                                        true)
                                                      GestureDetector(
                                                        onTap: () {
                                                          Navigator.push(
                                                            context,
                                                            MaterialPageRoute(
                                                              builder: (context) =>
                                                                  ImagePreviewScreen(
                                                                    imagePath:
                                                                        controller
                                                                            .attachmentFiles[index]['path'],
                                                                    fileName:
                                                                        controller
                                                                            .attachmentFiles[index]['name'],
                                                                  ),
                                                            ),
                                                          );
                                                        },
                                                        child: Hero(
                                                          tag:
                                                              'image-${controller.attachmentFiles[index]['path']}',
                                                          child: ClipRRect(
                                                            borderRadius:
                                                                BorderRadius.circular(
                                                                  8,
                                                                ),
                                                            child: Image.file(
                                                              File(
                                                                controller
                                                                    .attachmentFiles[index]['path'],
                                                              ),
                                                              width: 80,
                                                              height: 80,
                                                              fit: BoxFit.cover,
                                                            ),
                                                          ),
                                                        ),
                                                      )
                                                    else
                                                      Center(
                                                        child: Icon(
                                                          Icons
                                                              .insert_drive_file,
                                                          size: 40,
                                                          color: HexColor(
                                                            '#004ADB',
                                                          ),
                                                        ),
                                                      ),
                                                    Positioned(
                                                      bottom: 0,
                                                      left: 0,
                                                      right: 0,
                                                      child: Container(
                                                        color: Colors.black54,
                                                        padding:
                                                            const EdgeInsets.symmetric(
                                                              vertical: 2,
                                                            ),
                                                        child: Text(
                                                          'attached_image'.tr,
                                                          textAlign:
                                                              TextAlign.center,
                                                          style: TextStyle(
                                                            fontSize:
                                                                ResponsiveUtils.sp(
                                                                  10,
                                                                  context,
                                                                ),
                                                            fontFamily: 'Cairo',
                                                            color: Colors.white,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              // زر حذف المرفق
                                              Positioned(
                                                right: -5,
                                                top: -5,
                                                child: GestureDetector(
                                                  onTap: () {
                                                    // تأكيد الحذف
                                                    Get.dialog(
                                                      AlertDialog(
                                                        title: Text(
                                                          'delete_attachment'
                                                              .tr,
                                                          style:
                                                              const TextStyle(
                                                                fontFamily:
                                                                    'Cairo',
                                                                fontWeight:
                                                                    FontWeight
                                                                        .bold,
                                                              ),
                                                        ),
                                                        content: Text(
                                                          'delete_attachment_question'
                                                              .tr,
                                                          style:
                                                              const TextStyle(
                                                                fontFamily:
                                                                    'Cairo',
                                                              ),
                                                        ),
                                                        actions: [
                                                          TextButton(
                                                            child: Text(
                                                              'cancel'.tr,
                                                              style:
                                                                  const TextStyle(
                                                                    fontFamily:
                                                                        'Cairo',
                                                                    color: Colors
                                                                        .grey,
                                                                  ),
                                                            ),
                                                            onPressed: () =>
                                                                Get.back(),
                                                          ),
                                                          TextButton(
                                                            child: Text(
                                                              'delete'.tr,
                                                              style:
                                                                  const TextStyle(
                                                                    fontFamily:
                                                                        'Cairo',
                                                                    color: Colors
                                                                        .red,
                                                                  ),
                                                            ),
                                                            onPressed: () {
                                                              controller
                                                                  .removeAttachment(
                                                                    index,
                                                                  );
                                                              Get.back();
                                                            },
                                                          ),
                                                        ],
                                                      ),
                                                    );
                                                  },
                                                  child: Container(
                                                    decoration:
                                                        const BoxDecoration(
                                                          color: Colors.red,
                                                          shape:
                                                              BoxShape.circle,
                                                        ),
                                                    child: const Icon(
                                                      Icons.close,
                                                      size: 18,
                                                      color: Colors.white,
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
                                ),
                              ],
                            )
                          : const SizedBox.shrink();
                    },
                  ),
                  SizedBox(height: ResponsiveUtils.sp(20, context)),
                  SizedBox(
                    height: ResponsiveUtils.h(60, context),
                    width: MediaQuery.of(context).size.width,
                    child: GestureDetector(
                      onTap: () async {
                        final success = await controller.createLeaveRequest();
                        if (success) {
                          Get.snackbar(
                            'success'.tr,
                            'request_sent_successfully'.tr,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                          Get.back(); // العودة للشاشة السابقة
                        } else {
                          Get.snackbar(
                            'error'.tr,
                            'error_sending_request'.tr,
                            backgroundColor: Colors.red,
                            colorText: Colors.white,
                            snackPosition: SnackPosition.BOTTOM,
                          );
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          gradient: LinearGradient(
                            colors: [HexColor('#004ADB'), HexColor('#02A4BF')],
                            begin: const FractionalOffset(0.0, 0.0),
                            end: const FractionalOffset(0.8, 0.0),
                            stops: const [0.0, 1.0],
                            tileMode: TileMode.clamp,
                          ),
                        ),
                        child: GetBuilder<RequestController>(
                          builder: (controller) => controller.loading
                              ? const Padding(
                                  padding: EdgeInsets.symmetric(vertical: 10),
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                  ),
                                )
                              : Text(
                                  'submit_request'.tr,
                                  style: AppTextStyle.montserraSemiBold
                                      .copyWith(
                                        color: ThemeColors.white,
                                        fontSize: ResponsiveUtils.sp(
                                          18,
                                          context,
                                        ),
                                      ),
                                ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  GetBuilder<RequestController> buildRequestType(BuildContext context) {
    return GetBuilder<RequestController>(
      builder: (controller) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          decoration: BoxDecoration(
            border: Border.all(color: HexColor('#EEEEEE')),
            borderRadius: BorderRadius.circular(10),
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              alignment: Alignment.centerRight,
              borderRadius: BorderRadius.circular(10),
              hint: Text(
                controller.requestType,
                style: TextStyle(color: HexColor('#000000'), fontSize: 14),
              ),
              style: AppTextStyle.montserraSemiBold.copyWith(
                fontSize: ResponsiveUtils.sp(18, context),
                color: ThemeColors.black,
              ),
              isExpanded: true,
              icon: const Icon(Icons.arrow_drop_down_outlined),
              items: controller.requestTypelist.map((request) {
                return DropdownMenuItem(
                  alignment: Alignment.centerRight,
                  value: request,
                  child: Text(
                    request,
                    style: AppTextStyle.montserraSemiBold.copyWith(
                      fontSize: ResponsiveUtils.sp(18, context),
                      color: ThemeColors.black,
                    ),
                  ),
                );
              }).toList(),
              onChanged: (String? value) {
                controller.requestType = value!;
                controller.update();
              },
            ),
          ),
        );
      },
    );
  }

  // دالة لإنشاء زر المرفقات
  Widget _buildAttachmentButton({
    required BuildContext context,
    required IconData icon,
    required String text,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        padding: ResponsiveUtils.padding(
          context: context,
          horizontal: 24,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(ResponsiveUtils.r(10, context)),
          border: Border.all(color: HexColor('#EEEEEE')),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.05),
              spreadRadius: 1,
              blurRadius: 5,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: ResponsiveUtils.r(36, context),
              color: HexColor('#004ADB'),
            ),
            ResponsiveUtils.sizedBoxH(8, context),
            Text(
              text,
              style: TextStyle(
                fontSize: ResponsiveUtils.sp(14, context),
                fontFamily: 'Cairo',
                color: ThemeColors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // دالة لاختيار الصورة من الكاميرا أو المعرض
  Future<void> _getImage(ImageSource source) async {
    // تحقق مما إذا كان هناك مرفق موجود بالفعل
    if (controller.attachments.isNotEmpty) {
      // استفسار المستخدم إذا كان يريد استبدال المرفق الحالي
      final replace = await Get.dialog<bool>(
        AlertDialog(
          title: Text(
            'current_attachment'.tr,
            style: const TextStyle(
              fontFamily: 'Cairo',
              fontWeight: FontWeight.bold,
            ),
          ),
          content: Text(
            'replace_attachment_question'.tr,
            style: const TextStyle(fontFamily: 'Cairo'),
          ),
          actions: [
            TextButton(
              child: Text(
                'cancel'.tr,
                style: const TextStyle(fontFamily: 'Cairo', color: Colors.grey),
              ),
              onPressed: () => Get.back(result: false),
            ),
            TextButton(
              child: Text(
                'replace'.tr,
                style: TextStyle(
                  fontFamily: 'Cairo',
                  color: HexColor('#004ADB'),
                ),
              ),
              onPressed: () => Get.back(result: true),
            ),
          ],
        ),
      );

      if (replace != true) {
        return; // إلغاء العملية إذا لم يرد المستخدم استبدال المرفق
      }
    }

    try {
      final pickedFile = await _picker.pickImage(
        source: source,
        imageQuality: 70, // ضغط الصورة لتقليل الحجم
      );

      if (pickedFile != null) {
        // عرض مؤشر التحميل
        Get.dialog(
          const Center(child: CircularProgressIndicator()),
          barrierDismissible: false,
        );

        final fileName = path.basename(pickedFile.path);
        // رفع الملف إلى الخادم
        final success = await controller.uploadAttachment(
          pickedFile.path,
          fileName,
        );

        // إغلاق مؤشر التحميل
        Get.back();

        if (success) {
          Get.snackbar(
            'image_uploaded'.tr,
            'image_uploaded_message'.tr,
            backgroundColor: Colors.green,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        } else {
          Get.snackbar(
            'error'.tr,
            'image_upload_failed'.tr,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            snackPosition: SnackPosition.BOTTOM,
          );
        }
      }
    } catch (e) {
      print('خطأ في اختيار الصورة: $e');
      Get.snackbar(
        'error'.tr,
        'error_selecting_image'.tr,
        backgroundColor: Colors.red,
        colorText: Colors.white,
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }
}
