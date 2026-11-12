class LoanTypeModel {
  final int? id;
  final String? name;
  final String? description;
  final String? loanPolicy;
  final int? policyId;

  LoanTypeModel({
    this.id,
    this.name,
    this.description,
    this.loanPolicy,
    this.policyId,
  });

  factory LoanTypeModel.fromJson(Map<String, dynamic> json) {
    return LoanTypeModel(
      id: json['id'],
      name: json['name']?.toString(),
      description: json['description']?.toString(),
      loanPolicy: json['loan_policy'] is List
          ? json['loan_policy'][1]
          : json['loan_policy']?.toString(),
      policyId: json['policy_id'] is List
          ? json['policy_id'][0]
          : json['policy_id'],
    );
  }

  // دالة للحصول على النص المعروض في الـ dropdown
  String get displayText => description ?? name ?? 'نوع قرض';

  @override
  String toString() {
    return displayText;
  }
}
