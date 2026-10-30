import 'package:flutter_test/flutter_test.dart';
import 'package:aquapulse_water_leakage/core/utils/validators.dart';

void main() {
  group('Validators Unit Tests', () {
    test('Required validator returns error for null or empty values', () {
      expect(Validators.required(null, 'Name'), 'Name is required');
      expect(Validators.required('', 'Name'), 'Name is required');
      expect(Validators.required('   ', 'Name'), 'Name is required');
      expect(Validators.required('Valid text', 'Name'), isNull);
    });

    test('Email validator verifies standard email pattern', () {
      expect(Validators.email(null), isNotNull);
      expect(Validators.email(''), isNotNull);
      expect(
        Validators.email('invalid-email'),
        'Please enter a valid email address',
      );
      expect(Validators.email('test@'), 'Please enter a valid email address');
      expect(Validators.email('citizen@aquapulse.org'), isNull);
      expect(Validators.email('admin@citywater.gov.in'), isNull);
    });

    test('Phone validator enforces 10 to 13 digits', () {
      expect(Validators.phone(null), isNotNull);
      expect(Validators.phone('123'), 'Enter a valid 10-digit mobile number');
      expect(Validators.phone('9876543210'), isNull);
      expect(Validators.phone('+91 9876543210'), isNull);
    });

    test('Password validator enforces minimum length', () {
      expect(Validators.password(null), isNotNull);
      expect(
        Validators.password('12345'),
        'Password must be at least 6 characters long',
      );
      expect(Validators.password('Pass@123'), isNull);
    });

    test('Confirm password validator checks equality', () {
      expect(
        Validators.confirmPassword('Mismatch', 'Secret123'),
        'Passwords do not match',
      );
      expect(Validators.confirmPassword('Secret123', 'Secret123'), isNull);
    });

    test('MinLength validator checks character boundary', () {
      expect(
        Validators.minLength('ab', 5, 'Title'),
        'Title must be at least 5 characters',
      );
      expect(Validators.minLength('Valid title text', 5, 'Title'), isNull);
    });
  });
}
