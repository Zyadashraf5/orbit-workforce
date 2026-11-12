class UserModel {
  int? id;
  String? name;
  String? email;
  String? jobTitle;
  String? phone;
  String? empSeq;
  List<dynamic>? workLocationId;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.jobTitle,
    required this.phone,
    this.empSeq,
    this.workLocationId,
  });

  // Method to create a User object from a JSON object
  factory UserModel.fromJson(Map<String, dynamic> json) {
    // معالجة حقل work_location_ids الذي قد يأتي كـ bool (false) أو list أو null
    List<dynamic>? workLocationIdValue;
    final workLocationField = json['work_location_ids'];

    if (workLocationField != null) {
      if (workLocationField is List) {
        workLocationIdValue = workLocationField;
      } else if (workLocationField is bool && workLocationField == false) {
        // إذا كان القيمة false، نضع null
        workLocationIdValue = null;
      } else {
        // محاولة تحويل أي نوع آخر لقائمة
        workLocationIdValue = [workLocationField];
      }
    }

    return UserModel(
      id: json['id'],
      name: json['name'],
      email: json['work_email'],
      jobTitle: json['job_title'],
      phone: json['work_phone'] ?? '',
      empSeq: json['emp_seq'] ?? '',
      workLocationId: workLocationIdValue,
    );
  }

  // Method to convert a User object to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'work_email': email,
      'job_title': jobTitle,
      'work_phone': phone,
      'emp_seq': empSeq,
      'work_location_ids': workLocationId,
    };
  }

  // Optional: Method to print the User object in a readable way
  @override
  String toString() {
    return 'User(name: $name, email: $email, id:$id, jobTitle:$jobTitle, phone:$phone, empSeq:$empSeq, workLocationId:$workLocationId)';
  }

  // دالة للحصول على اسم موقع العمل
  String get workLocationName {
    if (workLocationId != null &&
        workLocationId!.isNotEmpty &&
        workLocationId!.length > 1) {
      return workLocationId![1].toString();
    }
    return 'غير محدد';
  }

  // دالة للحصول على ID موقع العمل
  int? get workLocationIdNumber {
    if (workLocationId != null && workLocationId!.isNotEmpty) {
      return workLocationId![0] is int
          ? workLocationId![0]
          : int.tryParse(workLocationId![0].toString());
    }
    return null;
  }
}
