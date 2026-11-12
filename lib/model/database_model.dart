class DatabaseModel {
  int? id;
  String? customerName;
  String? databaseUrl;
  String? expirationDate;
  int? usersCount;
  String? companyName;
  String? password;

  DatabaseModel({
    this.id,
    this.customerName,
    this.databaseUrl,
    this.expirationDate,
    this.usersCount,
    this.companyName,
    this.password,
  });

  factory DatabaseModel.fromJson(Map<String, dynamic> json) {
    // Handle field names - support both new and old naming conventions
    final customerName =
        json['name'] ??
        json['customer_name'] ??
        json['customer_name_display'] ??
        '';

    final databaseUrl =
        json['url'] ??
        json['database_url'] ??
        json['database_url_display'] ??
        '';

    final companyName =
        json['company_name'] ?? json['company_name_display'] ?? '';

    final password = json['password'] ?? json['pass'] ?? '';

    final usersCount = json['users_count'] ?? json['user_count'] ?? 0;

    final expirationDate =
        json['date'] ?? json['expiration_date'] ?? json['expiry_date'] ?? '';

    return DatabaseModel(
      id: json['id'],
      customerName: customerName.toString(),
      databaseUrl: databaseUrl.toString(),
      companyName: companyName.toString(),
      password: password.toString(),
      usersCount: usersCount is int
          ? usersCount
          : int.tryParse(usersCount.toString()),
      expirationDate: expirationDate.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': customerName,
      'url': databaseUrl,
      'date': expirationDate,
      'users_count': usersCount,
      'company_name': companyName,
      'password': password,
    };
  }

  @override
  String toString() {
    return 'DatabaseModel(id: $id, customerName: $customerName, databaseUrl: $databaseUrl, expirationDate: $expirationDate, usersCount: $usersCount, companyName: $companyName, password: $password)';
  }

  /// Check if expiration date is valid (not expired)
  bool get isExpirationDateValid {
    if (expirationDate == null || expirationDate!.isEmpty) {
      return false;
    }

    try {
      DateTime expiration;

      // Try to parse as ISO format first (YYYY-MM-DD) - Odoo standard format
      if (expirationDate!.contains('-')) {
        try {
          expiration = DateTime.parse(expirationDate!);
        } catch (e) {
          // If parsing fails, try DD/MM/YYYY format
          final parts = expirationDate!.split('-');
          if (parts.length == 3) {
            // Could be YYYY-MM-DD or DD-MM-YYYY
            // Try YYYY-MM-DD first
            try {
              final year = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final day = int.parse(parts[2]);
              expiration = DateTime(year, month, day);
            } catch (e2) {
              // Try DD-MM-YYYY
              final day = int.parse(parts[0]);
              final month = int.parse(parts[1]);
              final year = int.parse(parts[2]);
              expiration = DateTime(year, month, day);
            }
          } else {
            return false;
          }
        }
      } else if (expirationDate!.contains('/')) {
        // Parse DD/MM/YYYY format
        final parts = expirationDate!.split('/');
        if (parts.length != 3) return false;

        final day = int.parse(parts[0]);
        final month = int.parse(parts[1]);
        final year = int.parse(parts[2]);
        expiration = DateTime(year, month, day);
      } else {
        return false;
      }

      // Compare dates (without time)
      final today = DateTime.now();
      final todayOnly = DateTime(today.year, today.month, today.day);
      final expirationOnly = DateTime(
        expiration.year,
        expiration.month,
        expiration.day,
      );

      return expirationOnly.isAfter(todayOnly) ||
          expirationOnly.isAtSameMomentAs(todayOnly);
    } catch (e) {
      return false;
    }
  }

  /// Extract database name from URL
  /// Example: https://erp.example.invalid/odoo
  /// Returns: example-database
  String? get databaseName {
    if (databaseUrl == null || databaseUrl!.isEmpty) return null;

    try {
      final uri = Uri.parse(databaseUrl!);
      final host = uri.host;

      // Extract database name (before .dev.odoo.com)
      if (host.contains('.dev.odoo.com')) {
        return host.split('.dev.odoo.com').first;
      } else if (host.contains('.odoo.com')) {
        return host.split('.odoo.com').first;
      }

      return host;
    } catch (e) {
      return null;
    }
  }
}
