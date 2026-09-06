import 'package:flutter_test/flutter_test.dart';
import 'package:_24ct1_nguyenduyhai/features/auth/data/mock_auth_repository.dart';
import 'package:_24ct1_nguyenduyhai/features/auth/domain/models/user_role.dart';

void main() {
  group('MockAuthRepository Tests', () {
    late MockAuthRepository repo;

    setUp(() {
      repo = MockAuthRepository();
    });

    test('Initial user is null', () {
      expect(repo.currentUser, isNull);
    });

    test('Login with valid seed tenant account succeeds', () async {
      final user = await repo.signInWithEmailAndPassword(
        email: 'tenant@example.com',
        password: 'password123',
      );
      expect(user.email, 'tenant@example.com');
      expect(user.role, UserRole.tenant);
      expect(user.isEmailVerified, isTrue);
      expect(repo.currentUser, isNotNull);
    });

    test('Login with wrong password throws error', () async {
      expect(
        () => repo.signInWithEmailAndPassword(
          email: 'tenant@example.com',
          password: 'wrongpassword',
        ),
        throwsA(anything),
      );
    });

    test('Register new Owner creates account with owner role and unverified email', () async {
      final user = await repo.registerWithEmailAndPassword(
        fullName: 'Chủ trọ mới',
        email: 'newowner@example.com',
        password: 'ownerpass123',
        role: UserRole.owner,
      );

      expect(user.email, 'newowner@example.com');
      expect(user.fullName, 'Chủ trọ mới');
      expect(user.role, UserRole.owner);
      expect(user.isEmailVerified, isFalse);

      // Reloading simulates user clicking email verification link
      final verifiedUser = await repo.reloadUser();
      expect(verifiedUser?.isEmailVerified, isTrue);
    });

    test('Sign out clears currentUser', () async {
      await repo.signInWithEmailAndPassword(
        email: 'tenant@example.com',
        password: 'password123',
      );
      expect(repo.currentUser, isNotNull);

      await repo.signOut();
      expect(repo.currentUser, isNull);
    });

    test('Google Sign-In creates verified user', () async {
      final user = await repo.signInWithGoogle(defaultRole: UserRole.tenant);
      expect(user.isEmailVerified, isTrue);
      expect(user.email, 'google.user@example.com');
    });
  });
}
