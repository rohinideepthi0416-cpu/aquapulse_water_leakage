import 'dart:math';
import '../database/app_database.dart';
import '../models/user_model.dart';
import '../core/utils/password_hasher.dart';

class AuthRepository {
  final AppDatabase _dbInstance;

  AuthRepository({AppDatabase? dbInstance})
    : _dbInstance = dbInstance ?? AppDatabase();

  /// Register a new user with duplicate email prevention and salted hashing
  Future<UserModel> registerUser({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
    String role = 'citizen',
  }) async {
    final adapter = _dbInstance.adapter;
    final normalizedEmail = email.toLowerCase().trim();

    // Check if email already exists
    final existing = await adapter.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );
    if (existing.isNotEmpty) {
      throw Exception('An account with this email address already exists.');
    }

    // Generate random salt
    final random = Random.secure();
    final salt = List<int>.generate(8, (_) => random.nextInt(256)).join('');
    final passwordHash = PasswordHasher.hashPassword(password, salt);
    final now = DateTime.now().toIso8601String();

    final userMap = {
      'name': name.trim(),
      'email': normalizedEmail,
      'phone': phone.trim(),
      'password_hash': passwordHash,
      'salt': salt,
      'role': role,
      'address': address.trim(),
      'created_at': now,
    };

    final id = await adapter.insert('users', userMap);
    return UserModel.fromMap({...userMap, 'id': id});
  }

  /// Authenticate user credentials and verify role
  Future<UserModel> loginUser({
    required String email,
    required String password,
    String? requiredRole,
  }) async {
    final adapter = _dbInstance.adapter;
    final normalizedEmail = email.toLowerCase().trim();

    final results = await adapter.query(
      'users',
      where: 'email = ?',
      whereArgs: [normalizedEmail],
    );

    if (results.isEmpty) {
      throw Exception('No account found with this email address.');
    }

    final user = UserModel.fromMap(results.first);

    // Verify password against salt
    final isValid = PasswordHasher.verifyPassword(
      password: password,
      salt: user.salt,
      expectedHash: user.passwordHash,
    );

    if (!isValid) {
      throw Exception('Invalid password. Please check your credentials.');
    }

    if (requiredRole != null && user.role != requiredRole) {
      if (requiredRole == 'admin') {
        throw Exception(
          'Access denied. This account does not possess administrative privileges.',
        );
      }
    }

    return user;
  }

  /// Get user by ID
  Future<UserModel?> getUserById(int id) async {
    final adapter = _dbInstance.adapter;
    final results = await adapter.query(
      'users',
      where: 'id = ?',
      whereArgs: [id],
    );
    if (results.isEmpty) return null;
    return UserModel.fromMap(results.first);
  }

  /// Update user profile details
  Future<void> updateProfile({
    required int id,
    required String name,
    required String phone,
    required String address,
  }) async {
    final adapter = _dbInstance.adapter;
    await adapter.update(
      'users',
      {'name': name.trim(), 'phone': phone.trim(), 'address': address.trim()},
      where: 'id = ?',
      whereArgs: [id],
    );
  }
}
