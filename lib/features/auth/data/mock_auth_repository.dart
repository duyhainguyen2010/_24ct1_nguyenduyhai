import 'dart:async';
import '../domain/models/app_user.dart';
import '../domain/models/user_role.dart';
import '../domain/repositories/auth_repository.dart';

/// In-memory mock authentication repository simulating full auth behavior,
/// role persistence, email verification, and password updates without external APIs.
class MockAuthRepository implements AuthRepository {
  final StreamController<AppUser?> _authStateController =
      StreamController<AppUser?>.broadcast();

  // Internal mock accounts storage: email -> password
  final Map<String, String> _credentials = {
    'tenant@example.com': 'password123',
    'owner@example.com': 'password123',
  };

  // Internal user data storage: email -> AppUser
  final Map<String, AppUser> _users = {
    'tenant@example.com': AppUser(
      uid: 'mock-uid-tenant',
      email: 'tenant@example.com',
      fullName: 'Nguyễn Văn Thuê (Demo)',
      role: UserRole.tenant,
      isEmailVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 10)),
    ),
    'owner@example.com': AppUser(
      uid: 'mock-uid-owner',
      email: 'owner@example.com',
      fullName: 'Trần Thị Chủ Trọ (Demo)',
      role: UserRole.owner,
      isEmailVerified: true,
      createdAt: DateTime.now().subtract(const Duration(days: 5)),
    ),
  };

  AppUser? _currentUser;

  MockAuthRepository({AppUser? initialUser}) {
    _currentUser = initialUser;
  }

  @override
  Stream<AppUser?> get authStateChanges => _authStateController.stream;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600)); // Simulate network latency

    final normalizedEmail = email.trim().toLowerCase();
    if (!_credentials.containsKey(normalizedEmail) ||
        _credentials[normalizedEmail] != password) {
      throw 'Email hoặc mật khẩu không chính xác.';
    }

    final user = _users[normalizedEmail]!;
    _currentUser = user;
    _authStateController.add(_currentUser);
    return user;
  }

  @override
  Future<AppUser> registerWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    await Future.delayed(const Duration(milliseconds: 700));

    final normalizedEmail = email.trim().toLowerCase();
    if (_credentials.containsKey(normalizedEmail)) {
      throw 'Email này đã được đăng ký trong hệ thống.';
    }

    final newUser = AppUser(
      uid: 'mock-uid-${DateTime.now().millisecondsSinceEpoch}',
      email: normalizedEmail,
      fullName: fullName.trim(),
      role: role,
      isEmailVerified: false, // Requires verification after registration
      createdAt: DateTime.now(),
    );

    _credentials[normalizedEmail] = password;
    _users[normalizedEmail] = newUser;
    _currentUser = newUser;
    _authStateController.add(_currentUser);
    return newUser;
  }

  @override
  Future<AppUser> signInWithGoogle({UserRole? defaultRole}) async {
    await Future.delayed(const Duration(milliseconds: 800));

    const googleEmail = 'google.user@example.com';
    var user = _users[googleEmail];
    if (user == null) {
      user = AppUser(
        uid: 'mock-google-uid-12345',
        email: googleEmail,
        fullName: 'Google Demo User',
        role: defaultRole ?? UserRole.tenant,
        isEmailVerified: true, // Google users are typically verified
        createdAt: DateTime.now(),
      );
      _users[googleEmail] = user;
      _credentials[googleEmail] = 'google_authenticated';
    }

    _currentUser = user;
    _authStateController.add(_currentUser);
    return user;
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final normalizedEmail = email.trim().toLowerCase();
    if (!_users.containsKey(normalizedEmail)) {
      throw 'Không tìm thấy tài khoản với email này.';
    }
    // Simulation: Password reset email sent successfully
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    await Future.delayed(const Duration(milliseconds: 600));
    if (_currentUser == null) {
      throw 'Chưa đăng nhập.';
    }

    final email = _currentUser!.email;
    if (_credentials[email] != currentPassword) {
      throw 'Mật khẩu hiện tại không chính xác.';
    }

    _credentials[email] = newPassword;
  }

  @override
  Future<void> sendEmailVerification() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_currentUser == null) {
      throw 'Chưa đăng nhập.';
    }
    // Simulation: Verification email dispatched
  }

  @override
  Future<AppUser?> reloadUser() async {
    await Future.delayed(const Duration(milliseconds: 400));
    if (_currentUser == null) return null;

    // Simulation toggle: when reloaded, mark as verified
    final updated = _currentUser!.copyWith(isEmailVerified: true);
    _currentUser = updated;
    _users[updated.email] = updated;
    _authStateController.add(_currentUser);
    return _currentUser;
  }

  @override
  Future<void> signOut() async {
    await Future.delayed(const Duration(milliseconds: 300));
    _currentUser = null;
    _authStateController.add(null);
  }

  void dispose() {
    _authStateController.close();
  }
}
