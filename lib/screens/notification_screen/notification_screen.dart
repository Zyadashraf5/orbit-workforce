import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:hexcolor/hexcolor.dart';
import 'package:orbit_workforce/utils/responsive_utils.dart';
import 'domin/notification_controller.dart';

class NotificationScreen extends StatelessWidget {
  const NotificationScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<NotificationController>();

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.grey[50],
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          title: Text(
            'notifications'.tr,
            style: TextStyle(
              fontFamily: 'Cairo',
              fontSize: ResponsiveUtils.sp(18, context),
              fontWeight: FontWeight.bold,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          actions: [
            Obx(
              () => controller.unreadCount.value > 0
                  ? PopupMenuButton<String>(
                      icon: const Icon(Icons.more_vert, color: Colors.white),
                      onSelected: (value) {
                        if (value == 'mark_all_read') {
                          controller.markAllAsRead();
                          Get.snackbar(
                            'success'.tr,
                            'all_notifications_marked_read'.tr,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        } else if (value == 'delete_read') {
                          controller.deleteAllRead();
                          Get.snackbar(
                            'success'.tr,
                            'all_read_notifications_deleted'.tr,
                            backgroundColor: Colors.green,
                            colorText: Colors.white,
                          );
                        }
                      },
                      itemBuilder: (context) => [
                        PopupMenuItem(
                          value: 'mark_all_read',
                          child: Row(
                            children: [
                              const Icon(
                                Icons.mark_email_read,
                                color: Colors.blue,
                              ),
                              const SizedBox(width: 8),
                              Text('mark_all_read'.tr),
                            ],
                          ),
                        ),
                        PopupMenuItem(
                          value: 'delete_read',
                          child: Row(
                            children: [
                              const Icon(Icons.delete_sweep, color: Colors.red),
                              const SizedBox(width: 8),
                              Text('delete_read'.tr),
                            ],
                          ),
                        ),
                      ],
                    )
                  : const SizedBox.shrink(),
            ),
          ],
        ),
        body: Obx(() {
          if (controller.isLoading.value) {
            return Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(HexColor('#004ADB')),
              ),
            );
          }

          if (controller.notifications.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset(
                    'assets/images/notification.png',
                    width: ResponsiveUtils.w(80, context),
                    height: ResponsiveUtils.h(40, context),
                    fit: BoxFit.contain,
                  ),
                  ResponsiveUtils.sizedBoxH(2, context),
                  Text(
                    'no_notifications'.tr,
                    style: TextStyle(
                      fontFamily: 'Cairo',
                      fontSize: ResponsiveUtils.sp(16, context),
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: controller.refreshNotifications,
            color: HexColor('#004ADB'),
            child: ListView.builder(
              padding: ResponsiveUtils.padding(context: context, all: 2),
              itemCount: controller.notifications.length,
              itemBuilder: (context, index) {
                final notification = controller.notifications[index];
                return NotificationCard(
                  notification: notification,
                  onTap: () => controller.markAsRead(notification['id']),
                  onDelete: () =>
                      controller.deleteNotification(notification['id']),
                );
              },
            ),
          );
        }),
      ),
    );
  }
}

class NotificationCard extends StatelessWidget {
  final Map<String, dynamic> notification;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const NotificationCard({
    super.key,
    required this.notification,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final isRead = notification['isRead'] as bool;
    final type = notification['type'] as String;

    return Container(
      margin: EdgeInsets.only(bottom: ResponsiveUtils.h(2, context)),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(12),
          child: Padding(
            padding: ResponsiveUtils.padding(context: context, all: 4),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // أيقونة الإشعار
                Container(
                  width: ResponsiveUtils.w(12, context),
                  height: ResponsiveUtils.w(12, context),
                  decoration: BoxDecoration(
                    color: _getNotificationColor(type).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(
                    _getNotificationIcon(type),
                    color: _getNotificationColor(type),
                    size: ResponsiveUtils.w(6, context),
                  ),
                ),
                ResponsiveUtils.sizedBoxW(4, context),

                // محتوى الإشعار
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              notification['title'],
                              style: TextStyle(
                                fontFamily: 'Cairo',
                                fontSize: ResponsiveUtils.sp(14, context),
                                fontWeight: isRead
                                    ? FontWeight.normal
                                    : FontWeight.bold,
                                color: isRead
                                    ? Colors.grey[600]
                                    : Colors.black87,
                              ),
                            ),
                          ),
                          if (!isRead)
                            Container(
                              width: ResponsiveUtils.w(2, context),
                              height: ResponsiveUtils.w(2, context),
                              decoration: BoxDecoration(
                                color: HexColor('#004ADB'),
                                shape: BoxShape.circle,
                              ),
                            ),
                        ],
                      ),
                      ResponsiveUtils.sizedBoxH(1, context),
                      Text(
                        notification['message'],
                        style: TextStyle(
                          fontFamily: 'Cairo',
                          fontSize: ResponsiveUtils.sp(12, context),
                          color: Colors.grey[600],
                          height: 1.4,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                      ResponsiveUtils.sizedBoxH(1, context),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            notification['date'],
                            style: TextStyle(
                              fontFamily: 'Cairo',
                              fontSize: ResponsiveUtils.sp(10, context),
                              color: Colors.grey[500],
                            ),
                          ),
                          IconButton(
                            icon: Icon(
                              Icons.delete_outline,
                              color: Colors.red[400],
                              size: ResponsiveUtils.w(5, context),
                            ),
                            onPressed: () {
                              Get.dialog(
                                AlertDialog(
                                  title: Text(
                                    'confirm_delete'.tr,
                                    style: const TextStyle(fontFamily: 'Cairo'),
                                  ),
                                  content: Text(
                                    'confirm_delete_notification'.tr,
                                    style: const TextStyle(fontFamily: 'Cairo'),
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () => Get.back(),
                                      child: Text(
                                        'cancel'.tr,
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                        ),
                                      ),
                                    ),
                                    TextButton(
                                      onPressed: () {
                                        Get.back();
                                        onDelete();
                                      },
                                      child: Text(
                                        'delete'.tr,
                                        style: const TextStyle(
                                          fontFamily: 'Cairo',
                                          color: Colors.red,
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
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getNotificationColor(String type) {
    switch (type) {
      case 'leave_approval':
        return Colors.green;
      case 'attendance_reminder':
        return Colors.orange;
      case 'loan_rejection':
        return Colors.red;
      case 'payslip_available':
        return Colors.blue;
      case 'system_update':
        return Colors.purple;
      default:
        return HexColor('#004ADB');
    }
  }

  IconData _getNotificationIcon(String type) {
    switch (type) {
      case 'leave_approval':
        return Icons.check_circle;
      case 'attendance_reminder':
        return Icons.access_time;
      case 'loan_rejection':
        return Icons.cancel;
      case 'payslip_available':
        return Icons.description;
      case 'system_update':
        return Icons.system_update;
      default:
        return Icons.notifications;
    }
  }
}
