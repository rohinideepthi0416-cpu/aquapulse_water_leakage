import 'package:flutter_test/flutter_test.dart';
import 'package:aquapulse_water_leakage/core/utils/password_hasher.dart';

void main() {
  group('PasswordHasher Unit Tests', () {
    const password = 'SecurePassword@123';
    const salt = 'unique_salt_987';

    test('Hashes password into SHA-256 non-empty hex string', () {
      final hash = PasswordHasher.hashPassword(password, salt);
      expect(hash, isNotEmpty);
      expect(hash.length, 64); // SHA-256 hex string is 64 chars
    });

    test('Different salts yield different hashes for identical passwords', () {
      final hash1 = PasswordHasher.hashPassword(password, 'salt1');
      final hash2 = PasswordHasher.hashPassword(password, 'salt2');
      expect(hash1, isNot(equals(hash2)));
    });

    test('Verification returns true for correct credentials', () {
      final hash = PasswordHasher.hashPassword(password, salt);
      final isMatch = PasswordHasher.verifyPassword(
        password: password,
        salt: salt,
        expectedHash: hash,
      );
      expect(isMatch, isTrue);
    });

    test('Verification returns false for incorrect credentials', () {
      final hash = PasswordHasher.hashPassword(password, salt);
      final isMatch = PasswordHasher.verifyPassword(
        password: 'WrongPassword',
        salt: salt,
        expectedHash: hash,
      );
      expect(isMatch, isFalse);
    });
  });
}
