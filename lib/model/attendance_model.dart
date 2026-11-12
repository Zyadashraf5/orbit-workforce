class AttendanceModel {
  final int id;
  final int employeeId;
  final String checkIn;
  final String checkOut;

  final double workedHours;
  final double workedExtraHours;
  final double externalHours;
  final double overtimeHours;
  final String createDate;
  final String writeDate;
  final int dayNumber;
  final String kbDate;
  final String inIpAddress;
  final String inBrowser;
  final String inCountryName;
  final String inCity;
  final String outIpAddress;
  final String outBrowser;
  final String outCountryName;
  final String outCity;
  final double outLatitude;
  final double outLongitude;
  final double inLatitude;
  final double inLongitude;

  AttendanceModel({
    required this.id,
    required this.employeeId,
    required this.checkIn,
    required this.checkOut,
    required this.workedHours,
    required this.workedExtraHours,
    required this.externalHours,
    required this.overtimeHours,
    required this.createDate,
    required this.writeDate,
    required this.dayNumber,
    required this.kbDate,
    required this.inIpAddress,
    required this.inBrowser,
    required this.inCountryName,
    required this.inCity,
    required this.outIpAddress,
    required this.outBrowser,
    required this.outCountryName,
    required this.outCity,
    required this.outLatitude,
    required this.outLongitude,
    required this.inLatitude,
    required this.inLongitude,
  });

  // Convert from JSON response
  factory AttendanceModel.fromJson(Map<String, dynamic> json) {
    String parseString(dynamic value) {
      if (value == null) return '';
      if (value is bool) {
        return value ? 'true' : '';
      }
      return value.toString();
    }

    double parseDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    return AttendanceModel(
      id: json['id'],
      employeeId: json['employee_id'] is List
          ? json['employee_id'][0]
          : json['employee_id'],
      checkIn: parseString(json['check_in']),
      checkOut: parseString(json['check_out']),
      workedHours: parseDouble(json['worked_hours']),
      workedExtraHours: parseDouble(json['overtime_hours']),
      externalHours: parseDouble(json['validated_overtime_hours']),
      overtimeHours: parseDouble(json['overtime_hours']),
      createDate: parseString(json['create_date']),
      writeDate: parseString(json['write_date']),
      dayNumber: json['day_number'] ?? 0,
      kbDate: parseString(json['kb_date']),
      inIpAddress: parseString(json['in_ip_address']),
      inBrowser: parseString(json['in_browser']),
      inCountryName: parseString(json['in_country_name']),
      inCity: parseString(json['in_city']),
      outIpAddress: parseString(json['out_ip_address']),
      outBrowser: parseString(json['out_browser']),
      outCountryName: parseString(json['out_country_name']),
      outCity: parseString(json['out_city']),
      outLatitude: parseDouble(json['out_latitude']),
      outLongitude: parseDouble(json['out_longitude']),
      inLatitude: parseDouble(json['in_latitude']),
      inLongitude: parseDouble(json['in_longitude']),
    );
  }
}
