import '../models/app_user.dart';
import '../models/user_role.dart';

/// Abstract contract for authentication.
///
/// Both MockAuthRepository and the future FirebaseAuthRepository implement
/// this identical interface so UI and State layers remain completely decoupleable.
abstract class AuthRepository {
  /// Stream emitting auth state changes (null when logged out).
  Stream<AppUser?> get authStateChanges;

  /// Current signed-in user snapshot.
  AppUser? get currentUser;

  /// Signs in using email and password.
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  });

  /// Registers a new user with full name, email, password, and chosen role.
  Future<AppUser> registerWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  });

  /// Initiates Google Sign-In.
  Future<AppUser> signInWithGoogle({UserRole? defaultRole});

  /// Sends a password reset email.
  Future<void> sendPasswordResetEmail({required String email});

  /// Changes password for the currently authenticated user.
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  });

  /// Sends email verification to the currently authenticated user.
  Future<void> sendEmailVerification();

  /// Reloads user data to check email verification status.
  Future<AppUser?> reloadUser();

  /// Signs out safely.
  Future<void> signOut();
}
