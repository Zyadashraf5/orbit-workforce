class WorkLocationModel {
  final int id;
  final String name;

  WorkLocationModel({required this.id, required this.name});

  factory WorkLocationModel.fromJson(Map<String, dynamic> json) {
    return WorkLocationModel(id: json['id'] ?? 0, name: json['name'] ?? '');
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
