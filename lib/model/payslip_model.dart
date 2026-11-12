class PayslipModel {
  final int id;
  final String empSeq;
  final int employeeId;
  final String employeeName; // إضافة اسم الموظف
  final int payslipRunId;
  final double basicWage;
  final double grossWage;
  final double netWage;
  final String state;

  PayslipModel({
    required this.id,
    required this.empSeq,
    required this.employeeId,
    required this.employeeName,
    required this.payslipRunId,
    required this.basicWage,
    required this.grossWage,
    required this.netWage,
    required this.state,
  });

  factory PayslipModel.fromJson(Map<String, dynamic> json) {
    // دالة مساعدة لتحويل القيم إلى int بشكل آمن
    int safeInt(dynamic value) {
      if (value == null) return 0;
      if (value is int) return value;
      if (value is bool) return 0; // إذا كان bool (false) نرجع 0
      if (value is String) return int.tryParse(value) ?? 0;
      if (value is double) return value.toInt();
      return 0;
    }

    // استخراج اسم الموظف من employee_id
    String employeeName = '';
    if (json['employee_id'] is List &&
        (json['employee_id'] as List).length > 1) {
      employeeName = json['employee_id'][1]?.toString() ?? '';
    } else if (json['employee_name'] is String) {
      employeeName = json['employee_name'];
    }

    // معالجة employee_id
    int employeeId = 0;
    if (json['employee_id'] is List &&
        (json['employee_id'] as List).isNotEmpty) {
      employeeId = safeInt((json['employee_id'] as List)[0]);
    } else if (json['employee_id'] != null && json['employee_id'] is! bool) {
      employeeId = safeInt(json['employee_id']);
    }

    // معالجة payslip_run_id
    int payslipRunId = 0;
    if (json['payslip_run_id'] is List &&
        (json['payslip_run_id'] as List).isNotEmpty) {
      payslipRunId = safeInt((json['payslip_run_id'] as List)[0]);
    } else if (json['payslip_run_id'] != null &&
        json['payslip_run_id'] is! bool) {
      payslipRunId = safeInt(json['payslip_run_id']);
    }

    return PayslipModel(
      id: safeInt(json['id']),
      empSeq: json['emp_seq']?.toString() ?? '',
      employeeId: employeeId,
      employeeName: employeeName,
      payslipRunId: payslipRunId,
      basicWage: (json['basic_wage'] ?? 0.0).toDouble(),
      grossWage: (json['gross_wage'] ?? 0.0).toDouble(),
      netWage: (json['net_wage'] ?? 0.0).toDouble(),
      state: json['state']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'emp_seq': empSeq,
      'employee_id': employeeId,
      'employee_name': employeeName,
      'payslip_run_id': payslipRunId,
      'basic_wage': basicWage,
      'gross_wage': grossWage,
      'net_wage': netWage,
      'state': state,
    };
  }
}
