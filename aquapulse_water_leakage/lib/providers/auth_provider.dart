import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../repositories/auth_repository.dart';
import '../services/session_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthRepository _authRepository;
  final SessionService _sessionService;

  UserModel? _currentUser;
  bool _isLoading = false;
  String? _errorMessage;

  AuthProvider({AuthRepository? authRepository, SessionService? sessionService})
    : _authRepository = authRepository ?? AuthRepository(),
      _sessionService = sessionService ?? SessionService();

  UserModel? get currentUser => _currentUser;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  bool get isAuthenticated => _currentUser != null;
  bool get isAdmin => _currentUser?.isAdmin ?? false;

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  /// Check if a session is saved in SharedPreferences
  Future<bool> checkExistingSession() async {
    _isLoading = true;
    notifyListeners();

    try {
      final savedId = await _sessionService.getSavedUserId();
      if (savedId != null) {
        final user = await _authRepository.getUserById(savedId);
        if (user != null) {
          _currentUser = user;
          _isLoading = false;
          notifyListeners();
          return true;
        }
      }
    } catch (_) {
      // Clear invalid session
      await _sessionService.clearSession();
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// Login for Citizen or Admin
  Future<bool> login({
    required String email,
    required String password,
    String? requiredRole,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.loginUser(
        email: email,
        password: password,
        requiredRole: requiredRole,
      );

      _currentUser = user;
      await _sessionService.saveUserSession(
        userId: user.id!,
        role: user.role,
        email: user.email,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Register Citizen
  Future<bool> register({
    required String name,
    required String email,
    required String phone,
    required String password,
    required String address,
  }) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final user = await _authRepository.registerUser(
        name: name,
        email: email,
        phone: phone,
        password: password,
        address: address,
        role: 'citizen',
      );

      _currentUser = user;
      await _sessionService.saveUserSession(
        userId: user.id!,
        role: user.role,
        email: user.email,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  /// Logout
  Future<void> logout() async {
    _currentUser = null;
    _errorMessage = null;
    await _sessionService.clearSession();
    notifyListeners();
  }

  /// Update Profile
  Future<bool> updateProfile({
    required String name,
    required String phone,
    required String address,
  }) async {
    if (_currentUser == null) return false;

    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      await _authRepository.updateProfile(
        id: _currentUser!.id!,
        name: name,
        phone: phone,
        address: address,
      );

      _currentUser = _currentUser!.copyWith(
        name: name,
        phone: phone,
        address: address,
      );

      _isLoading = false;
      notifyListeners();
      return true;
    } catch (e) {
      _errorMessage = e.toString().replaceFirst('Exception: ', '');
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }
}
