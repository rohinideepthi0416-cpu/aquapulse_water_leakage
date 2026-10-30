import 'package:shared_preferences/shared_preferences.dart';

class SessionService {
  static const String _keyUserId = 'session_user_id';
  static const String _keyUserRole = 'session_user_role';
  static const String _keyUserEmail = 'session_user_email';
  static const String _keyOnboardingDone = 'onboarding_completed';

  Future<void> saveUserSession({
    required int userId,
    required String role,
    required String email,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_keyUserId, userId);
    await prefs.setString(_keyUserRole, role);
    await prefs.setString(_keyUserEmail, email);
  }

  Future<int?> getSavedUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_keyUserId);
  }

  Future<String?> getSavedUserRole() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_keyUserRole);
  }

  Future<bool> isOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_keyOnboardingDone) ?? false;
  }

  Future<void> setOnboardingCompleted() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_keyOnboardingDone, true);
  }

  Future<void> clearSession() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_keyUserId);
    await prefs.remove(_keyUserRole);
    await prefs.remove(_keyUserEmail);
  }
}
