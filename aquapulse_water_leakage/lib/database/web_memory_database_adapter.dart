import 'dart:async';
import 'database_adapter.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/password_hasher.dart';

/// Database adapter for Web, Desktop and Test environments.
/// Provides a clean, zero-native-dependency SQLite emulation.
class WebMemoryDatabaseAdapter implements DatabaseAdapter {
  final Map<String, List<Map<String, dynamic>>> _tables = {
    'users': [],
    'complaints': [],
    'complaint_status_history': [],
    'notifications': [],
  };

  int _autoUserId = 1;
  int _autoHistoryId = 1;
  int _autoNotificationId = 1;

  @override
  Future<void> init() async {
    if (_tables['users']!.isNotEmpty) return;
    await _seedInitialData();
  }

  Future<void> _seedInitialData() async {
    final now = DateTime.now().toIso8601String();

    // Demo Citizen
    final userSalt = 'citizen_salt';
    final userHash = PasswordHasher.hashPassword(
      AppConstants.demoUserPassword,
      userSalt,
    );
    final citizenId = _autoUserId++;
    _tables['users']!.add({
      'id': citizenId,
      'name': AppConstants.demoUserName,
      'email': AppConstants.demoUserEmail.toLowerCase(),
      'phone': AppConstants.demoUserPhone,
      'password_hash': userHash,
      'salt': userSalt,
      'role': AppConstants.roleCitizen,
      'address': AppConstants.demoUserAddress,
      'created_at': now,
    });

    // Demo Admin
    final adminSalt = 'admin_salt';
    final adminHash = PasswordHasher.hashPassword(
      AppConstants.demoAdminPassword,
      adminSalt,
    );
    final adminId = _autoUserId++;
    _tables['users']!.add({
      'id': adminId,
      'name': AppConstants.demoAdminName,
      'email': AppConstants.demoAdminEmail.toLowerCase(),
      'phone': AppConstants.demoAdminPhone,
      'password_hash': adminHash,
      'salt': adminSalt,
      'role': AppConstants.roleAdmin,
      'address': AppConstants.demoAdminAddress,
      'created_at': now,
    });

    // Initial Complaints
    const c1Id = 'AP-2026-0001';
    _tables['complaints']!.add({
      'id': c1Id,
      'user_id': citizenId,
      'user_name': AppConstants.demoUserName,
      'user_phone': AppConstants.demoUserPhone,
      'title': 'High Pressure Main Pipe Burst',
      'description':
          'Substantial clean water gushing onto the road near the metro pillar.',
      'leakage_type': 'Pipeline Leak',
      'location': '8th Main Road, 4th Block, Jayanagar',
      'landmark': 'Opposite Metro Pillar 142',
      'severity': 'Critical',
      'status': 'In Progress',
      'created_at': now,
      'updated_at': now,
      'resolution_details': null,
      'image_path': null,
    });

    _tables['complaint_status_history']!.add({
      'id': _autoHistoryId++,
      'complaint_id': c1Id,
      'status': 'Pending',
      'remarks': 'Complaint logged by citizen.',
      'updated_by_name': AppConstants.demoUserName,
      'updated_at': now,
    });

    _tables['complaint_status_history']!.add({
      'id': _autoHistoryId++,
      'complaint_id': c1Id,
      'status': 'In Progress',
      'remarks': 'Emergency maintenance crew dispatched with repair clamp.',
      'updated_by_name': AppConstants.demoAdminName,
      'updated_at': now,
    });

    const c2Id = 'AP-2026-0002';
    _tables['complaints']!.add({
      'id': c2Id,
      'user_id': citizenId,
      'user_name': AppConstants.demoUserName,
      'user_phone': AppConstants.demoUserPhone,
      'title': 'Public Park Overhead Tank Overflowing',
      'description':
          'Automated float valve malfunction causing continuous tank overflow for 4 hours.',
      'leakage_type': 'Overflowing Tank',
      'location': 'Lalbagh West Gate Public Garden',
      'landmark': 'Next to Children Play Area',
      'severity': 'High',
      'status': 'Resolved',
      'created_at': now,
      'updated_at': now,
      'resolution_details':
          'Replaced damaged mechanical float valve and secured overflow diversion pipe.',
      'image_path': null,
    });

    _tables['complaint_status_history']!.add({
      'id': _autoHistoryId++,
      'complaint_id': c2Id,
      'status': 'Resolved',
      'remarks': 'Valve replaced and inspected for leaks.',
      'updated_by_name': AppConstants.demoAdminName,
      'updated_at': now,
    });

    _tables['notifications']!.add({
      'id': _autoNotificationId++,
      'user_id': citizenId,
      'complaint_id': c2Id,
      'title': 'Complaint Resolved: AP-2026-0002',
      'message':
          'Your complaint AP-2026-0002 has been resolved. Resolution: Replaced damaged mechanical float valve. Thank you for helping us save water!',
      'is_read': 0,
      'created_at': now,
    });
  }

  @override
  Future<int> insert(String table, Map<String, dynamic> values) async {
    final list = _tables[table] ??= [];
    final copy = Map<String, dynamic>.from(values);

    if (table == 'users' && copy['id'] == null) {
      copy['id'] = _autoUserId++;
    } else if (table == 'complaint_status_history' && copy['id'] == null) {
      copy['id'] = _autoHistoryId++;
    } else if (table == 'notifications' && copy['id'] == null) {
      copy['id'] = _autoNotificationId++;
    }

    // Check unique email for users
    if (table == 'users') {
      final existing = list.any(
        (r) =>
            (r['email'] as String).toLowerCase() ==
            (copy['email'] as String).toLowerCase(),
      );
      if (existing) {
        throw Exception('Email already registered');
      }
    }

    // If ID already exists (e.g. replacing complaint), replace it
    if (copy['id'] != null) {
      final idx = list.indexWhere((r) => r['id'] == copy['id']);
      if (idx != -1) {
        list[idx] = copy;
        return 1;
      }
    }

    list.add(copy);
    return (copy['id'] is int) ? copy['id'] as int : 1;
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final list = _tables[table] ?? [];
    var results = List<Map<String, dynamic>>.from(list);

    if (where != null && whereArgs != null && whereArgs.isNotEmpty) {
      // Basic matching for WHERE col = ? OR WHERE col = ? AND col = ?
      results = results.where((row) {
        if (where.contains('email = ?')) {
          final arg = whereArgs[0]?.toString().toLowerCase();
          return (row['email']?.toString().toLowerCase()) == arg;
        }
        if (where.contains('user_id = ?')) {
          final arg = whereArgs[0];
          return row['user_id'] == arg;
        }
        if (where.contains('complaint_id = ?')) {
          final arg = whereArgs[0]?.toString();
          return row['complaint_id'] == arg;
        }
        if (where.contains('id = ?')) {
          final arg = whereArgs[0];
          return row['id'] == arg;
        }
        return true;
      }).toList();
    }

    if (orderBy != null) {
      if (orderBy.contains('created_at DESC')) {
        results.sort(
          (a, b) => (b['created_at']?.toString() ?? '').compareTo(
            a['created_at']?.toString() ?? '',
          ),
        );
      } else if (orderBy.contains('updated_at DESC')) {
        results.sort(
          (a, b) => (b['updated_at']?.toString() ?? '').compareTo(
            a['updated_at']?.toString() ?? '',
          ),
        );
      }
    }

    if (limit != null && results.length > limit) {
      results = results.sublist(0, limit);
    }

    return results;
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    // If raw query is querying a single table
    if (sql.toLowerCase().contains('from users')) {
      return query('users');
    }
    if (sql.toLowerCase().contains('from complaints')) {
      return query('complaints');
    }
    if (sql.toLowerCase().contains('from notifications')) {
      return query('notifications');
    }
    return [];
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final list = _tables[table] ?? [];
    int count = 0;

    for (int i = 0; i < list.length; i++) {
      bool matches = false;
      if (where != null && whereArgs != null && whereArgs.isNotEmpty) {
        if (where.contains('id = ?')) {
          matches = list[i]['id'] == whereArgs[0];
        } else if (where.contains('user_id = ?')) {
          matches = list[i]['user_id'] == whereArgs[0];
        }
      } else {
        matches = true;
      }

      if (matches) {
        list[i] = {...list[i], ...values};
        count++;
      }
    }

    return count;
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final list = _tables[table] ?? [];
    final before = list.length;
    if (where != null && whereArgs != null && whereArgs.isNotEmpty) {
      if (where.contains('id = ?')) {
        list.removeWhere((item) => item['id'] == whereArgs[0]);
      }
    } else {
      list.clear();
    }
    return before - list.length;
  }

  @override
  Future<void> close() async {}
}
