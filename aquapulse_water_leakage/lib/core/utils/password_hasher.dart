import 'dart:convert';
import 'package:crypto/crypto.dart';

/// Password Hasher utility.
/// Never stores plaintext passwords in the database.
/// Uses SHA-256 hashing with a cryptographic salt.
///
/// NOTE ON LOCAL DEMO AUTHENTICATION:
/// In production, password hashing should be handled by a secure remote
/// identity provider (e.g. Argon2, PBKDF2 with high iterations, or OAuth2 / Firebase).
/// For this offline practical demo, SHA-256 with user-specific salt provides
/// offline security without external dependencies.
class PasswordHasher {
  PasswordHasher._();

  static const String _defaultSaltPrefix = 'aquapulse_salt_v1_';

  /// Hash a plaintext password with a salt (e.g. user email or random salt)
  static String hashPassword(String password, String salt) {
    final salted = '$_defaultSaltPrefix${salt.toLowerCase()}:$password';
    final bytes = utf8.encode(salted);
    final digest = sha256.convert(bytes);
    return digest.toString();
  }

  /// Verify a plaintext password against an existing hash and salt
  static bool verifyPassword({
    required String password,
    required String salt,
    required String expectedHash,
  }) {
    final computedHash = hashPassword(password, salt);
    return computedHash == expectedHash;
  }
}
