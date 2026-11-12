class OrbitHistoryModel {
  int? id;
  String? name;
  String? code;
  String? date;
  String? dayName;
  int? day;
  double? hours;
  int? employeeId;
  String? employeeName;

  OrbitHistoryModel({
    this.id,
    this.name,
    this.code,
    this.date,
    this.dayName,
    this.day,
    this.hours,
    this.employeeId,
    this.employeeName,
  });

  factory OrbitHistoryModel.fromJson(Map<String, dynamic> json) {
    return OrbitHistoryModel(
      id: json['id'],
      name: json['name'],
      code: json['code'],
      date: json['date'],
      dayName: json['day_name'],
      day: json['days'],
      hours: json['hours']?.toDouble(),
      employeeId: json['employee_id'] is List
          ? json['employee_id'][0]
          : json['employee_id'],
      employeeName: json['employee_id'] is List ? json['employee_id'][1] : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'code': code,
      'date': date,
      'day_name': dayName,
      'days': day,
      'hours': hours,
      'employee_id': employeeId,
    };
  }

  @override
  String toString() {
    return 'OrbitHistoryModel(id: $id, name: $name, code: $code, date: $date, day_name: $dayName, day: $day, hours: $hours, employeeId: $employeeId, employeeName: $employeeName)';
  }
}
