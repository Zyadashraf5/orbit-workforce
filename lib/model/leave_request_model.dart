import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LeaveRequestModel {
  final int id;
  final List<dynamic> holidayStatusId;
  final String name;
  final String dateFrom;
  final String dateTo;
  final String durationDisplay;
  final String status;

  LeaveRequestModel({
    required this.id,
    required this.holidayStatusId,
    required this.name,
    required this.dateFrom,
    required this.dateTo,
    required this.durationDisplay,
    required this.status,
  });

  factory LeaveRequestModel.fromJson(Map<String, dynamic> json) {
    // معالجة حقل name الذي قد يأتي كـ bool (false) وليس string
    String nameValue = '';
    final nameField = json['name'];
    if (nameField != null) {
      if (nameField is String) {
        nameValue = nameField;
      } else if (nameField is bool && nameField == false) {
        nameValue = '';
      } else {
        nameValue = nameField.toString();
      }
    }

    return LeaveRequestModel(
      id: json['id'] ?? 0,
      holidayStatusId: json['holiday_status_id'] ?? [],
      name: nameValue,
      dateFrom: json['date_from'] ?? '',
      dateTo: json['date_to'] ?? '',
      durationDisplay: json['duration_display'] ?? '',
      status: json['state'] ?? '',
    );
  }

  // للحصول على اسم نوع الإجازة
  String get holidayStatusName {
    if (holidayStatusId.isNotEmpty && holidayStatusId.length > 1) {
      return holidayStatusId[1].toString();
    }
    return 'not_specified'.tr;
  }

  // للحصول على لون الحالة
  Color get statusColor {
    switch (status) {
      case 'confirm':
        return Colors.blue;
      case 'validate':
        return Colors.teal;
      case 'validate1':
        return Colors.green;
      case 'refuse':
        return Colors.red;
      case 'cancel':
        return Colors.black;
      default:
        return Colors.grey;
    }
  }

  // للحصول على نص الحالة مترجم
  String get statusText {
    switch (status) {
      case 'confirm':
        return 'submitted'.tr;
      case 'validate':
        return 'approved_2'.tr;
      case 'validate1':
        return 'approved_1'.tr;
      case 'refuse':
        return 'rejected'.tr;
      case 'cancel':
        return 'cancelled'.tr;
      default:
        return status;
    }
  }

  // تنسيق التاريخ من
  String get formattedDateFrom {
    if (dateFrom.isEmpty) return 'not_specified'.tr;
    try {
      final date = DateTime.parse(dateFrom);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateFrom;
    }
  }

  // تنسيق التاريخ إلى
  String get formattedDateTo {
    if (dateTo.isEmpty) return 'not_specified'.tr;
    try {
      final date = DateTime.parse(dateTo);
      return '${date.day}/${date.month}/${date.year}';
    } catch (e) {
      return dateTo;
    }
  }
}
