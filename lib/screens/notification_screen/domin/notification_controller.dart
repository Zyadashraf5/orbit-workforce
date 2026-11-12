import 'package:get/get.dart';

class NotificationController extends GetxController {
  // قائمة الإشعارات
  final RxList<Map<String, dynamic>> notifications =
      <Map<String, dynamic>>[].obs;

  // حالة التحميل
  final RxBool isLoading = false.obs;

  // عدد الإشعارات غير المقروءة
  final RxInt unreadCount = 0.obs;

  @override
  void onInit() {
    super.onInit();
    loadNotifications();
  }

  // تحميل الإشعارات
  Future<void> loadNotifications() async {
    try {
      isLoading.value = true;

      // محاكاة تحميل البيانات من API
      await Future.delayed(const Duration(seconds: 1));

      // بيانات تجريبية للإشعارات
      notifications.value = [
        {
          'id': 1,
          'title': 'تم الموافقة على طلب الإجازة',
          'message': 'تم الموافقة على طلب إجازتك المقدم في 15 ديسمبر 2024',
          'date': '2024-12-20 10:30',
          'isRead': false,
          'type': 'leave_approval',
        },
        {
          'id': 2,
          'title': 'تذكير: تسجيل الحضور',
          'message': 'لا تنس تسجيل حضورك اليوم',
          'date': '2024-12-20 09:00',
          'isRead': true,
          'type': 'attendance_reminder',
        },
        {
          'id': 3,
          'title': 'تم رفض طلب القرض',
          'message': 'تم رفض طلب القرض المقدم في 10 ديسمبر 2024',
          'date': '2024-12-19 14:20',
          'isRead': false,
          'type': 'loan_rejection',
        },
        {
          'id': 4,
          'title': 'كشف المرتب متاح',
          'message': 'كشف مرتب شهر نوفمبر 2024 متاح الآن للتحميل',
          'date': '2024-12-18 16:45',
          'isRead': true,
          'type': 'payslip_available',
        },
        {
          'id': 5,
          'title': 'تحديث النظام',
          'message': 'سيتم تحديث النظام يوم الجمعة من الساعة 2-4 صباحاً',
          'date': '2024-12-17 11:15',
          'isRead': false,
          'type': 'system_update',
        },
      ];

      // حساب عدد الإشعارات غير المقروءة
      unreadCount.value = notifications
          .where((notification) => !notification['isRead'])
          .length;
    } catch (e) {
      print('خطأ في تحميل الإشعارات: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // تحديد الإشعار كمقروء
  void markAsRead(int notificationId) {
    final index = notifications.indexWhere(
      (notification) => notification['id'] == notificationId,
    );
    if (index != -1) {
      notifications[index]['isRead'] = true;
      notifications.refresh();
      unreadCount.value = notifications
          .where((notification) => !notification['isRead'])
          .length;
    }
  }

  // تحديد جميع الإشعارات كمقروءة
  void markAllAsRead() {
    for (var notification in notifications) {
      notification['isRead'] = true;
    }
    notifications.refresh();
    unreadCount.value = 0;
  }

  // حذف إشعار
  void deleteNotification(int notificationId) {
    notifications.removeWhere(
      (notification) => notification['id'] == notificationId,
    );
    unreadCount.value = notifications
        .where((notification) => !notification['isRead'])
        .length;
  }

  // حذف جميع الإشعارات المقروءة
  void deleteAllRead() {
    notifications.removeWhere((notification) => notification['isRead'] == true);
    unreadCount.value = notifications
        .where((notification) => !notification['isRead'])
        .length;
  }

  // تحديث الإشعارات
  Future<void> refreshNotifications() async {
    await loadNotifications();
  }
}
