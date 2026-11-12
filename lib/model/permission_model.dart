import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PermissionModel {
  final int id;
  final String name;
  final List<dynamic> employeeId;
  final List<dynamic> typeId;
  final String date;
  final double hours;
  final String state;

  PermissionModel({
    required this.id,
    required this.name,
    required this.employeeId,
    required this.typeId,
    required this.date,
    required this.hours,
    required this.state,
  });

  factory PermissionModel.fromJson(Map<String, dynamic> json) {
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

    return PermissionModel(
      id: json['id'] ?? 0,
      name: nameValue,
      employeeId: json['employee_id'] ?? [],
      typeId: json['type_id'] ?? [],
      date: json['date'] ?? '',
      hours: (json['hours'] ?? 0.0).toDouble(),
      state: json['state'] ?? '',
    );
  }

  // للحصول على اسم الموظف
  String get employeeName {
    if (employeeId.isNotEmpty && employeeId.length > 1) {
      return employeeId[1].toString();
    }
    return 'not_specified'.tr;
  }

  // للحصول على نوع الإذن
  String get typeName {
    if (typeId.isNotEmpty && typeId.length > 1) {
      return typeId[1].toString();
    }
    return 'not_specified'.tr;
  }

  // للحصول على لون الحالة
  Color get statusColor {
    switch (state) {
      case 'draft':
        return Colors.orange;
      case 'approved':
        return Colors.green;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.grey;
    }
  }

  // للحصول على نص الحالة مترجم
  String get statusText {
    switch (state) {
      case 'draft':
        return 'draft'.tr;
      case 'approved':
        return 'approved'.tr;
      case 'cancelled':
        return 'cancelled'.tr;
      default:
        return state;
    }
  }

  // تنسيق التاريخ
  String get formattedDate {
    if (date.isEmpty) return 'not_specified'.tr;
    try {
      final dateTime = DateTime.parse(date);
      return '${dateTime.day}/${dateTime.month}/${dateTime.year}';
    } catch (e) {
      return date;
    }
  }

  // تنسيق الساعات
  String get formattedHours {
    final locale = Get.locale?.languageCode ?? 'ar';
    if (locale == 'en') {
      if (hours == hours.toInt()) {
        return '${hours.toInt()} hour${hours.toInt() == 1 ? '' : 's'}';
      } else {
        return '${hours.toStringAsFixed(1)} hours';
      }
    } else {
      if (hours == hours.toInt()) {
        return '${hours.toInt()} ساعة';
      } else {
        return '${hours.toStringAsFixed(1)} ساعة';
      }
    }
  }

  // للحصول على رقم الطلب
  String get requestNumber {
    return 'PRM${id.toString().padLeft(5, '0')}';
  }
}
