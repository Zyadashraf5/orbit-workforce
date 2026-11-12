class WorkLocationDetailsModel {
  final int id;
  final String name;
  final dynamic addressId; // قد يكون int أو List
  final double lat;
  final double long;
  final double range;

  WorkLocationDetailsModel({
    required this.id,
    required this.name,
    required this.addressId,
    required this.lat,
    required this.long,
    required this.range,
  });

  factory WorkLocationDetailsModel.fromJson(Map<String, dynamic> json) {
    // دالة مساعدة لتحويل القيم إلى double بشكل آمن
    double parseToDouble(dynamic value) {
      if (value == null) return 0.0;
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) {
        return double.tryParse(value) ?? 0.0;
      }
      return 0.0;
    }

    return WorkLocationDetailsModel(
      id: json['id'] ?? 0,
      name: json['name'] ?? '',
      addressId: json['address_id'], // سيبقى كما هو
      lat: parseToDouble(json['lat']),
      long: parseToDouble(json['long']),
      range: parseToDouble(json['range']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'address_id': addressId,
      'lat': lat,
      'long': long,
      'range': range,
    };
  }

  // للحصول على اسم العنوان إذا كان addressId عبارة عن قائمة
  String get addressName {
    if (addressId is List && (addressId as List).length > 1) {
      return (addressId as List)[1].toString();
    }
    return addressId?.toString() ?? 'غير محدد';
  }
}
