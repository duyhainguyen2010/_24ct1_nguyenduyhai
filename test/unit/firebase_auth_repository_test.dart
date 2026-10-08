import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:_24ct1_nguyenduyhai/features/auth/data/firebase_auth_repository.dart';
import 'package:_24ct1_nguyenduyhai/features/auth/domain/models/app_user.dart';
import 'package:_24ct1_nguyenduyhai/features/auth/domain/models/user_role.dart';

void main() {
  group('FirebaseAuthRepository Model Mapping & Serialization Tests', () {
    test('toFirestore converts AppUser to Firestore map properly', () {
      final now = DateTime(2026, 10, 6, 10, 0);
      final user = AppUser(
        uid: 'user-123',
        email: 'tenant@example.com',
        fullName: 'Nguyễn Văn Thuê',
        role: UserRole.tenant,
        isEmailVerified: true,
        createdAt: now,
      );

      final map = FirebaseAuthRepository.toFirestore(user);

      expect(map['fullName'], 'Nguyễn Văn Thuê');
      expect(map['email'], 'tenant@example.com');
      expect(map['role'], 'tenant');
      expect(map['phone'], '');
      expect(map['avatarUrl'], isNull);
      expect(map['createdAt'], isA<Timestamp>());
      expect((map['createdAt'] as Timestamp).toDate(), now);
    });

    test('fromFirestore deserializes Firestore map correctly for owner', () {
      final now = DateTime(2026, 10, 6, 11, 30);
      final firestoreData = <String, dynamic>{
        'fullName': 'Trần Văn Chủ',
        'email': 'owner@example.com',
        'role': 'owner',
        'phone': '0905 123 456',
        'avatarUrl': 'https://example.com/avatar.jpg',
        'createdAt': Timestamp.fromDate(now),
      };

      final user = FirebaseAuthRepository.fromFirestore(
        firestoreData,
        'user-456',
        isEmailVerified: true,
      );

      expect(user.uid, 'user-456');
      expect(user.fullName, 'Trần Văn Chủ');
      expect(user.email, 'owner@example.com');
      expect(user.role, UserRole.owner);
      expect(user.isEmailVerified, isTrue);
      expect(user.createdAt, now);
    });

    test('fromFirestore safely handles empty or fallback values', () {
      final emptyData = <String, dynamic>{};
      final user = FirebaseAuthRepository.fromFirestore(
        emptyData,
        'user-789',
        fallbackEmail: 'fallback@example.com',
        fallbackName: 'Tên Dự Phòng',
        isEmailVerified: false,
      );

      expect(user.uid, 'user-789');
      expect(user.fullName, 'Tên Dự Phòng');
      expect(user.email, 'fallback@example.com');
      expect(user.role, UserRole.tenant); // default fallback
      expect(user.isEmailVerified, isFalse);
      expect(user.createdAt, isA<DateTime>());
    });

    test('fromFirestore defaults to tenant when role is unrecognized', () {
      final dataWithUnknownRole = <String, dynamic>{
        'fullName': 'Người Dùng',
        'email': 'unknown@example.com',
        'role': 'super_admin_custom',
      };

      final user = FirebaseAuthRepository.fromFirestore(
        dataWithUnknownRole,
        'user-999',
      );

      expect(user.role, UserRole.tenant);
    });
  });

  group('FirebaseAuthRepository Error Mapping Tests', () {
    test('maps common FirebaseAuthException error codes to Vietnamese messages', () {
      final testCases = <String, String>{
        'invalid-email': 'Địa chỉ email không đúng định dạng.',
        'user-not-found': 'Không tìm thấy tài khoản với email này.',
        'wrong-password': 'Mật khẩu không chính xác.',
        'invalid-credential': 'Email hoặc mật khẩu không chính xác.',
        'email-already-in-use': 'Email này đã được sử dụng bởi một tài khoản khác.',
        'weak-password': 'Mật khẩu quá yếu. Vui lòng nhập tối thiểu 6 ký tự.',
        'too-many-requests': 'Quá nhiều yêu cầu không hợp lệ. Vui lòng thử lại sau.',
        'network-request-failed': 'Lỗi kết nối mạng. Vui lòng kiểm tra lại đường truyền Internet.',
        'requires-recent-login': 'Phiên đăng nhập đã cũ. Vui lòng đăng nhập lại để thực hiện thao tác này.',
        'user-disabled': 'Tài khoản của bạn đã bị vô hiệu hóa.',
      };

      for (final entry in testCases.entries) {
        final exception = FirebaseAuthException(code: entry.key);
        final message = FirebaseAuthRepository.mapAuthException(exception);
        expect(message, entry.value);
      }
    });

    test('maps generic exceptions safely', () {
      final genericException = Exception('Có lỗi bất ngờ xảy ra.');
      final message = FirebaseAuthRepository.mapAuthException(genericException);
      expect(message, 'Có lỗi bất ngờ xảy ra.');
    });

    test('signInWithGoogle throws friendly Unsupported exception without crashing', () async {
      final repo = FirebaseAuthRepository();
      expect(
        () => repo.signInWithGoogle(),
        throwsA(isA<Exception>().having(
          (e) => e.toString(),
          'message',
          contains('Google hiện chưa được hỗ trợ'),
        )),
      );
    });
  });
}
