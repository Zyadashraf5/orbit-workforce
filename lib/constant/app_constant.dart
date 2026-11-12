import 'package:flutter/foundation.dart';
import 'package:get_storage/get_storage.dart';
import 'package:odoo_rpc/odoo_rpc.dart';

class AppConstant {
  // Initial admin database URL for fetching databases list
  static const String adminDatabaseUrl = 'https://erp.example.invalid';

  static final GetStorage _box = GetStorage();

  // Client will be initialized dynamically based on stored database URL
  static OdooClient? _client;
  static String? _baseUrl;

  /// Get or initialize client with stored database URL
  static OdooClient get client {
    if (_client == null) {
      // Try to get stored database URL
      final storedUrl = _box.read<String>('database_url');

      if (storedUrl != null && storedUrl.isNotEmpty) {
        // Initialize with stored URL (base URL without /odoo for OdooClient)
        final baseUrl = _extractBaseUrl(storedUrl);
        _client = OdooClient(baseUrl);
        _baseUrl = baseUrl;

        if (kDebugMode) {
          print('✅ [CLIENT] تم تهيئة Client من Database URL المحفوظ: $baseUrl');
        }
      } else {
        // No stored URL, use admin database URL as fallback
        _client = OdooClient(adminDatabaseUrl);
        _baseUrl = adminDatabaseUrl;

        if (kDebugMode) {
          print(
            '⚠️ [CLIENT] لا يوجد Database URL محفوظ، استخدام Admin Database: $adminDatabaseUrl',
          );
        }
      }
    } else {
      // Client already exists - verify it's using the correct URL
      final storedUrl = _box.read<String>('database_url');
      if (storedUrl != null && storedUrl.isNotEmpty) {
        final expectedBaseUrl = _extractBaseUrl(storedUrl);
        if (_baseUrl != expectedBaseUrl) {
          // Client is using wrong URL - recreate it
          if (kDebugMode) {
            print('🔄 [CLIENT] Client يستخدم URL خاطئ - إعادة إنشاء...');
            print('   📋 URL الحالي: $_baseUrl');
            print('   📋 URL المطلوب: $expectedBaseUrl');
          }
          _client = OdooClient(expectedBaseUrl);
          _baseUrl = expectedBaseUrl;
        }
      }
    }
    return _client!;
  }

  /// Get base URL (without /odoo)
  static String get baseUrl {
    if (_baseUrl == null) {
      // Try to get from storage first
      final storedUrl = _box.read<String>('database_url');
      if (storedUrl != null && storedUrl.isNotEmpty) {
        _baseUrl = _extractBaseUrl(storedUrl);
        if (kDebugMode) {
          print('📦 استخراج Base URL من التخزين: $_baseUrl');
        }
      } else {
        // Initialize client which will set _baseUrl
        client;
      }
    }

    // Final fallback to admin URL if still null
    if (_baseUrl == null) {
      _baseUrl = adminDatabaseUrl;
      if (kDebugMode) {
        print('⚠️ استخدام Admin URL كـ fallback: $_baseUrl');
      }
    }

    return _baseUrl!;
  }

  /// Update client and baseUrl with new database URL
  static void updateDatabaseUrl(String databaseUrl) {
    // Extract base URL (without /odoo) for OdooClient
    final baseUrl = _extractBaseUrl(databaseUrl);

    // Log current state before update
    if (kDebugMode) {
      print('🔄 [UPDATE] تحديث Database URL...');
      print('   📋 URL القديم: ${_baseUrl ?? "null"}');
      print('   📋 URL الجديد: $baseUrl');
      print('   📋 Client موجود: ${_client != null}');
    }

    // Save original URL to storage
    _box.write('database_url', databaseUrl);

    // Force recreate client with new base URL (OdooClient needs URL without /odoo)
    _client = OdooClient(baseUrl);
    _baseUrl = baseUrl;

    if (kDebugMode) {
      print('✅ [UPDATE] تم تحديث Database URL: $databaseUrl');
      print('🌐 [UPDATE] OdooClient URL: $baseUrl');
      print('📦 [UPDATE] Base URL: $_baseUrl');
      print('✅ [UPDATE] تم إنشاء Client جديد');
    }
  }

  /// Reset client (clear stored URL and reset to admin)
  static void resetClient() {
    _box.remove('database_url');
    _client = null;
    _baseUrl = null;

    if (kDebugMode) {
      print('🔄 تم إعادة تعيين Client');
    }
  }

  /// Extract base URL (without /odoo)
  static String _extractBaseUrl(String databaseUrl) {
    if (databaseUrl.contains('/odoo')) {
      return databaseUrl.split('/odoo')[0];
    } else {
      return databaseUrl.endsWith('/')
          ? databaseUrl.substring(0, databaseUrl.length - 1)
          : databaseUrl;
    }
  }
}
