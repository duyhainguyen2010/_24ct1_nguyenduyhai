import 'dart:async';
import 'package:flutter/foundation.dart';
import '../../domain/models/app_user.dart';
import '../../domain/models/user_role.dart';
import '../../domain/repositories/auth_repository.dart';

/// Lightweight, native Flutter state management for Authentication using ChangeNotifier.
class AuthNotifier extends ChangeNotifier {
  final AuthRepository _repository;
  StreamSubscription<AppUser?>? _authSubscription;

  AppUser? _user;
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;

  AuthNotifier({required AuthRepository repository}) : _repository = repository {
    _user = _repository.currentUser;
    _authSubscription = _repository.authStateChanges.listen((user) {
      _user = user;
      notifyListeners();
    });
  }

  AppUser? get user => _user;
  bool get isAuthenticated => _user != null;
  bool get isEmailVerified => _user?.isEmailVerified ?? false;
  UserRole? get role => _user?.role;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;

  void clearMessages() {
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();
  }

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  Future<bool> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _user = await _repository.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> register({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _user = await _repository.registerWithEmailAndPassword(
        fullName: fullName,
        email: email,
        password: password,
        role: role,
      );
      // Attempt sending verification email
      try {
        await _repository.sendEmailVerification();
      } catch (_) {}
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> loginWithGoogle({UserRole? defaultRole}) async {
    _setLoading(true);
    _errorMessage = null;
    try {
      _user = await _repository.signInWithGoogle(defaultRole: defaultRole);
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendPasswordResetEmail({required String email}) async {
    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;
    try {
      await _repository.sendPasswordResetEmail(email: email);
      _successMessage = 'Đã gửi hướng dẫn đặt lại mật khẩu đến $email';
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;
    try {
      await _repository.changePassword(
        currentPassword: currentPassword,
        newPassword: newPassword,
      );
      _successMessage = 'Đổi mật khẩu thành công!';
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> sendEmailVerification() async {
    _setLoading(true);
    _errorMessage = null;
    _successMessage = null;
    try {
      await _repository.sendEmailVerification();
      _successMessage = 'Đã gửi lại email xác thực!';
      _setLoading(false);
      return true;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<bool> checkEmailVerification() async {
    _setLoading(true);
    _errorMessage = null;
    try {
      final updatedUser = await _repository.reloadUser();
      _user = updatedUser;
      _setLoading(false);
      return _user?.isEmailVerified ?? false;
    } catch (e) {
      _errorMessage = e.toString();
      _setLoading(false);
      return false;
    }
  }

  Future<void> logout() async {
    _setLoading(true);
    await _repository.signOut();
    _user = null;
    _errorMessage = null;
    _successMessage = null;
    _setLoading(false);
  }

  @override
  void dispose() {
    _authSubscription?.cancel();
    super.dispose();
  }
}
