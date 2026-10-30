import 'package:path/path.dart' as p;
import 'package:sqflite/sqflite.dart' as sqf;
import 'database_adapter.dart';
import '../core/constants/app_constants.dart';
import '../core/utils/password_hasher.dart';

class MobileDatabaseAdapter implements DatabaseAdapter {
  sqf.Database? _db;

  @override
  Future<void> init() async {
    if (_db != null) return;

    final dbPath = await sqf.getDatabasesPath();
    final path = p.join(dbPath, 'aquapulse.db');

    _db = await sqf.openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        await _createTables(db);
        await _seedInitialData(db);
      },
    );
  }

  Future<void> _createTables(sqf.DatabaseExecutor db) async {
    await db.execute('''
      CREATE TABLE users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name TEXT NOT NULL,
        email TEXT NOT NULL UNIQUE,
        phone TEXT NOT NULL,
        password_hash TEXT NOT NULL,
        salt TEXT NOT NULL,
        role TEXT NOT NULL DEFAULT 'citizen',
        address TEXT NOT NULL,
        created_at TEXT NOT NULL
      );
    ''');

    await db.execute('''
      CREATE TABLE complaints (
        id TEXT PRIMARY KEY,
        user_id INTEGER NOT NULL,
        user_name TEXT,
        user_phone TEXT,
        title TEXT NOT NULL,
        description TEXT NOT NULL,
        leakage_type TEXT NOT NULL,
        location TEXT NOT NULL,
        landmark TEXT NOT NULL,
        severity TEXT NOT NULL,
        status TEXT NOT NULL DEFAULT 'Pending',
        created_at TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        resolution_details TEXT,
        image_path TEXT,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE complaint_status_history (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        complaint_id TEXT NOT NULL,
        status TEXT NOT NULL,
        remarks TEXT NOT NULL,
        updated_by_name TEXT NOT NULL,
        updated_at TEXT NOT NULL,
        FOREIGN KEY (complaint_id) REFERENCES complaints(id) ON DELETE CASCADE
      );
    ''');

    await db.execute('''
      CREATE TABLE notifications (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        user_id INTEGER NOT NULL,
        complaint_id TEXT NOT NULL,
        title TEXT NOT NULL,
        message TEXT NOT NULL,
        is_read INTEGER NOT NULL DEFAULT 0,
        created_at TEXT NOT NULL,
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
      );
    ''');
  }

  Future<void> _seedInitialData(sqf.DatabaseExecutor db) async {
    final now = DateTime.now().toIso8601String();

    // Seed Demo Citizen
    final userSalt = 'citizen_salt';
    final userHash = PasswordHasher.hashPassword(
      AppConstants.demoUserPassword,
      userSalt,
    );
    final citizenId = await db.insert('users', {
      'name': AppConstants.demoUserName,
      'email': AppConstants.demoUserEmail.toLowerCase(),
      'phone': AppConstants.demoUserPhone,
      'password_hash': userHash,
      'salt': userSalt,
      'role': AppConstants.roleCitizen,
      'address': AppConstants.demoUserAddress,
      'created_at': now,
    });

    // Seed Demo Admin
    final adminSalt = 'admin_salt';
    final adminHash = PasswordHasher.hashPassword(
      AppConstants.demoAdminPassword,
      adminSalt,
    );
    await db.insert('users', {
      'name': AppConstants.demoAdminName,
      'email': AppConstants.demoAdminEmail.toLowerCase(),
      'phone': AppConstants.demoAdminPhone,
      'password_hash': adminHash,
      'salt': adminSalt,
      'role': AppConstants.roleAdmin,
      'address': AppConstants.demoAdminAddress,
      'created_at': now,
    });

    // Seed Initial Realistic Complaints
    const c1Id = 'AP-2026-0001';
    await db.insert('complaints', {
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

    await db.insert('complaint_status_history', {
      'complaint_id': c1Id,
      'status': 'Pending',
      'remarks': 'Complaint logged by citizen.',
      'updated_by_name': AppConstants.demoUserName,
      'updated_at': now,
    });
    await db.insert('complaint_status_history', {
      'complaint_id': c1Id,
      'status': 'In Progress',
      'remarks': 'Emergency maintenance crew dispatched with repair clamp.',
      'updated_by_name': AppConstants.demoAdminName,
      'updated_at': now,
    });

    const c2Id = 'AP-2026-0002';
    await db.insert('complaints', {
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

    await db.insert('complaint_status_history', {
      'complaint_id': c2Id,
      'status': 'Resolved',
      'remarks': 'Valve replaced and inspected for leaks.',
      'updated_by_name': AppConstants.demoAdminName,
      'updated_at': now,
    });

    // Seed Notification for Resolved Complaint
    await db.insert('notifications', {
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
    final db = _db;
    if (db == null) throw StateError('Database not initialized');
    return await db.insert(
      table,
      values,
      conflictAlgorithm: sqf.ConflictAlgorithm.replace,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> query(
    String table, {
    String? where,
    List<Object?>? whereArgs,
    String? orderBy,
    int? limit,
  }) async {
    final db = _db;
    if (db == null) throw StateError('Database not initialized');
    return await db.query(
      table,
      where: where,
      whereArgs: whereArgs,
      orderBy: orderBy,
      limit: limit,
    );
  }

  @override
  Future<List<Map<String, dynamic>>> rawQuery(
    String sql, [
    List<Object?>? arguments,
  ]) async {
    final db = _db;
    if (db == null) throw StateError('Database not initialized');
    return await db.rawQuery(sql, arguments);
  }

  @override
  Future<int> update(
    String table,
    Map<String, dynamic> values, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = _db;
    if (db == null) throw StateError('Database not initialized');
    return await db.update(table, values, where: where, whereArgs: whereArgs);
  }

  @override
  Future<int> delete(
    String table, {
    String? where,
    List<Object?>? whereArgs,
  }) async {
    final db = _db;
    if (db == null) throw StateError('Database not initialized');
    return await db.delete(table, where: where, whereArgs: whereArgs);
  }

  @override
  Future<void> close() async {
    await _db?.close();
    _db = null;
  }
}
