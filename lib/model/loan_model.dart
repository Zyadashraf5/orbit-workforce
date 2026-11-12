import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoanModel {
  final int? id;
  final String? employeeId;
  final String? loanAction;
  final String? startDate;
  final String? endDate;
  final double? amount;
  final double? balance;
  final String? state;

  LoanModel({
    this.id,
    this.employeeId,
    this.loanAction,
    this.startDate,
    this.endDate,
    this.amount,
    this.balance,
    this.state,
  });

  factory LoanModel.fromJson(Map<String, dynamic> json) {
    return LoanModel(
      id: json['id'],
      employeeId: json['employee_id'] is List
          ? json['employee_id'][1]
          : json['employee_id']?.toString(),
      loanAction: json['loan_action']?.toString(),
      startDate: json['start_date']?.toString(),
      endDate: json['end_date']?.toString(),
      amount: json['amount'] is num ? (json['amount'] as num).toDouble() : 0.0,
      balance: json['balance'] is num
          ? (json['balance'] as num).toDouble()
          : 0.0,
      state: json['state']?.toString(),
    );
  }

  // دالة مساعدة للحصول على لون الحالة
  Color getStateColor() {
    switch (state?.toLowerCase()) {
      case 'draft':
        return Colors.grey;
      case 'submit':
        return Colors.orange;
      case 'approved1':
        return Colors.blue;
      case 'approved2':
        return Colors.green;
      case 'cancel':
        return Colors.red;
      case 'terminated':
        return Colors.red.shade800;
      default:
        return Colors.grey;
    }
  }

  // دالة مساعدة للحصول على نص الحالة باللغة العربية
  String getStateText() {
    switch (state?.toLowerCase()) {
      case 'draft':
        return 'draft'.tr;
      case 'submit':
        return 'submitted'.tr;
      case 'approved1':
        return 'approved_1'.tr;
      case 'approved2':
        return 'approved_2'.tr;
      case 'cancel':
        return 'cancelled'.tr;
      case 'terminated':
        return 'terminated'.tr;
      default:
        return state ?? 'unknown_status'.tr;
    }
  }

  // دالة مساعدة للحصول على نص نوع القرض باللغة العربية
  String getLoanActionText() {
    switch (loanAction?.toLowerCase()) {
      case 'personal':
        return 'personal_loan'.tr;
      case 'eos':
        return 'end_of_service_loan'.tr;
      default:
        return loanAction ?? 'personal_loan'.tr;
    }
  }

  // دالة مساعدة للحصول على لون نوع القرض
  Color getLoanActionColor() {
    switch (loanAction?.toLowerCase()) {
      case 'personal':
        return Colors.blue;
      case 'eos':
        return Colors.purple;
      default:
        return Colors.blue;
    }
  }

  // دالة مساعدة للحصول على تاريخ الانتهاء أو رسالة "لم يتم تحديد بعد"
  String getEndDateText() {
    if (endDate == null || endDate == '' || endDate == 'false') {
      return 'not_determined_yet'.tr;
    }
    return endDate!;
  }
}
