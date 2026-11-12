class PayslipRunModel {
  final String name;
  final String dateStart;
  final String dateEnd;
  final String state;
  final int payslipCount;

  PayslipRunModel({
    required this.name,
    required this.dateStart,
    required this.dateEnd,
    required this.state,
    required this.payslipCount,
  });

  factory PayslipRunModel.fromJson(Map<String, dynamic> json) {
    return PayslipRunModel(
      name: json['name']?.toString() ?? '',
      dateStart: json['date_start']?.toString() ?? '',
      dateEnd: json['date_end']?.toString() ?? '',
      state: json['state']?.toString() ?? '',
      payslipCount: json['payslip_count'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'date_start': dateStart,
      'date_end': dateEnd,
      'state': state,
      'payslip_count': payslipCount,
    };
  }
}
