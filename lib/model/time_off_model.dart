class TimeOffModel {
  final String? employeeId;
  final int? timeoffId;
  final String? timeoffType;
  final double? balance;

  TimeOffModel({
    this.employeeId,
    this.timeoffId,
    this.timeoffType,
    this.balance,
  });

  factory TimeOffModel.fromJson(Map<String, dynamic> json) {
    return TimeOffModel(
      employeeId: json['employee_id'],
      timeoffId: json['timeoff_id'],
      timeoffType: json['timeoff_type'],
      balance: json['balance'] is int
          ? (json['balance'] as int).toDouble()
          : json['balance'],
    );
  }
}
