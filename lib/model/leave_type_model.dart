class LeaveTypeModel {
  final int id;
  final String displayName;
  final String allocationType;
  final List<dynamic> workEntryTypeId;

  LeaveTypeModel({
    required this.id,
    required this.displayName,
    required this.allocationType,
    required this.workEntryTypeId,
  });

  factory LeaveTypeModel.fromJson(Map<String, dynamic> json) {
    // معالجة حقل work_entry_type_id الذي قد يأتي كـ bool (false) وليس قائمة
    List<dynamic> workEntryTypeIdValue = [];
    final workEntryField = json['work_entry_type_id'];

    if (workEntryField != null) {
      if (workEntryField is List) {
        workEntryTypeIdValue = workEntryField;
      } else if (workEntryField is bool && workEntryField == false) {
        // إذا كان القيمة false، نضع قائمة فارغة
        workEntryTypeIdValue = [];
      } else {
        // محاولة تحويل أي نوع آخر لقائمة
        workEntryTypeIdValue = [workEntryField];
      }
    }

    return LeaveTypeModel(
      id: json['id'] ?? 0,
      displayName: json['display_name'] ?? '',
      allocationType: json['allocation_validation_type'] ?? '',
      workEntryTypeId: workEntryTypeIdValue,
    );
  }

  // للحصول على اسم نوع العمل
  String get workEntryTypeName {
    if (workEntryTypeId.isNotEmpty && workEntryTypeId.length > 1) {
      return workEntryTypeId[1].toString();
    }
    return 'غير محدد';
  }
}
