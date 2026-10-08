import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../domain/models/app_user.dart';
import '../domain/models/user_role.dart';
import '../domain/repositories/auth_repository.dart';

/// Production implementation of [AuthRepository] backed by Firebase Authentication
/// and Cloud Firestore for user profiles (collection 'users').
class FirebaseAuthRepository implements AuthRepository {
  final FirebaseAuth? _injectedFirebaseAuth;
  final FirebaseFirestore? _injectedFirestore;

  FirebaseAuth get _firebaseAuth => _injectedFirebaseAuth ?? FirebaseAuth.instance;
  FirebaseFirestore get _firestore => _injectedFirestore ?? FirebaseFirestore.instance;

  static const String usersCollection = 'users';

  AppUser? _currentUser;
  StreamController<AppUser?>? _authStateController;
  StreamSubscription<User?>? _fbAuthSubscription;

  FirebaseAuthRepository({
    FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
  })  : _injectedFirebaseAuth = firebaseAuth,
        _injectedFirestore = firestore;

  @override
  AppUser? get currentUser => _currentUser;

  @override
  Stream<AppUser?> get authStateChanges {
    _authStateController ??= StreamController<AppUser?>.broadcast(
      onListen: _startListeningAuthState,
      onCancel: _stopListeningAuthState,
    );
    return _authStateController!.stream;
  }

  void _startListeningAuthState() {
    _fbAuthSubscription = _firebaseAuth.authStateChanges().listen((user) async {
      if (user == null) {
        _currentUser = null;
        _authStateController?.add(null);
      } else {
        try {
          final profile = await _getUserProfileFromFirestore(user.uid);
          final appUser = fromFirestore(
            profile ?? {},
            user.uid,
            fallbackEmail: user.email ?? '',
            fallbackName: user.displayName ?? '',
            isEmailVerified: user.emailVerified,
          );
          _currentUser = appUser;
          _authStateController?.add(appUser);
        } catch (_) {
          final fallbackUser = AppUser(
            uid: user.uid,
            email: user.email ?? '',
            fullName: user.displayName ?? 'Người dùng',
            role: UserRole.tenant,
            isEmailVerified: user.emailVerified,
            createdAt: DateTime.now(),
          );
          _currentUser = fallbackUser;
          _authStateController?.add(fallbackUser);
        }
      }
    });
  }

  void _stopListeningAuthState() {
    _fbAuthSubscription?.cancel();
    _fbAuthSubscription = null;
  }

  /// Converts a Firestore map into an [AppUser].
  static AppUser fromFirestore(
    Map<String, dynamic> data,
    String uid, {
    String fallbackEmail = '',
    String fallbackName = '',
    bool isEmailVerified = false,
  }) {
    final rawCreatedAt = data['createdAt'];
    DateTime createdAt;
    if (rawCreatedAt is Timestamp) {
      createdAt = rawCreatedAt.toDate();
    } else if (rawCreatedAt is String) {
      createdAt = DateTime.tryParse(rawCreatedAt) ?? DateTime.now();
    } else {
      createdAt = DateTime.now();
    }

    return AppUser(
      uid: uid,
      email: (data['email'] as String?)?.isNotEmpty == true
          ? data['email'] as String
          : fallbackEmail,
      fullName: (data['fullName'] as String?)?.isNotEmpty == true
          ? data['fullName'] as String
          : (fallbackName.isNotEmpty ? fallbackName : 'Người dùng'),
      role: UserRole.fromString(data['role'] as String?),
      isEmailVerified: isEmailVerified,
      createdAt: createdAt,
    );
  }

  /// Converts an [AppUser] into a Firestore map representation.
  static Map<String, dynamic> toFirestore(
    AppUser user, {
    String phone = '',
    String? avatarUrl,
  }) {
    return {
      'fullName': user.fullName,
      'email': user.email,
      'role': user.role.name,
      'phone': phone,
      'avatarUrl': avatarUrl,
      'createdAt': Timestamp.fromDate(user.createdAt),
    };
  }

  /// Maps [FirebaseAuthException] and generic errors to clear Vietnamese messages.
  static String mapAuthException(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'Địa chỉ email không đúng định dạng.';
        case 'user-not-found':
          return 'Không tìm thấy tài khoản với email này.';
        case 'wrong-password':
          return 'Mật khẩu không chính xác.';
        case 'invalid-credential':
          return 'Email hoặc mật khẩu không chính xác.';
        case 'email-already-in-use':
          return 'Email này đã được sử dụng bởi một tài khoản khác.';
        case 'weak-password':
          return 'Mật khẩu quá yếu. Vui lòng nhập tối thiểu 6 ký tự.';
        case 'too-many-requests':
          return 'Quá nhiều yêu cầu không hợp lệ. Vui lòng thử lại sau.';
        case 'network-request-failed':
          return 'Lỗi kết nối mạng. Vui lòng kiểm tra lại đường truyền Internet.';
        case 'requires-recent-login':
          return 'Phiên đăng nhập đã cũ. Vui lòng đăng nhập lại để thực hiện thao tác này.';
        case 'user-disabled':
          return 'Tài khoản của bạn đã bị vô hiệu hóa.';
        case 'operation-not-allowed':
          return 'Phương thức đăng nhập này chưa được kích hoạt.';
        default:
          return error.message ?? 'Đã có lỗi xảy ra (${error.code}). Vui lòng thử lại.';
      }
    }
    return error.toString().replaceFirst(RegExp(r'^Exception:\s*'), '');
  }

  Future<Map<String, dynamic>?> _getUserProfileFromFirestore(String uid) async {
    final doc = await _firestore.collection(usersCollection).doc(uid).get();
    if (doc.exists && doc.data() != null) {
      return doc.data();
    }
    return null;
  }

  @override
  Future<AppUser> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final credential = await _firebaseAuth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );

      final user = credential.user;
      if (user == null) {
        throw Exception('Không nhận được thông tin người dùng từ Firebase.');
      }

      // Read profile from Firestore users/{uid}
      final profile = await _getUserProfileFromFirestore(user.uid);
      final appUser = fromFirestore(
        profile ?? {},
        user.uid,
        fallbackEmail: user.email ?? email.trim(),
        fallbackName: user.displayName ?? '',
        isEmailVerified: user.emailVerified,
      );

      _currentUser = appUser;
      return appUser;
    } catch (e) {
      throw Exception(mapAuthException(e));
    }
  }

  @override
  Future<AppUser> registerWithEmailAndPassword({
    required String fullName,
    required String email,
    required String password,
    required UserRole role,
  }) async {
    UserCredential? credential;
    try {
      credential = await _firebaseAuth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password,
      );
    } catch (e) {
      throw Exception(mapAuthException(e));
    }

    final user = credential.user;
    if (user == null) {
      throw Exception('Tạo tài khoản Firebase Auth không thành công.');
    }

    final now = DateTime.now();
    final newAppUser = AppUser(
      uid: user.uid,
      email: email.trim().toLowerCase(),
      fullName: fullName.trim(),
      role: role,
      isEmailVerified: false,
      createdAt: now,
    );

    // Save profile to Firestore users/{uid}
    try {
      await _firestore.collection(usersCollection).doc(user.uid).set(
            toFirestore(newAppUser),
          );
      await user.updateDisplayName(fullName.trim());
    } catch (firestoreError) {
      // Rollback: Delete newly created Firebase Auth account if profile persistence failed
      try {
        await user.delete();
      } catch (_) {}
      throw Exception(
        'Không thể lưu thông tin tài khoản vào cơ sở dữ liệu: ${firestoreError.toString()}',
      );
    }

    // Send email verification
    try {
      await user.sendEmailVerification();
    } catch (_) {
      // Non-fatal if verification email delivery fails immediately
    }

    _currentUser = newAppUser;
    return newAppUser;
  }

  @override
  Future<AppUser> signInWithGoogle({UserRole? defaultRole}) async {
    // Explicitly safe placeholder: Google Sign-In is out of scope for this task
    throw Exception('Đăng nhập Google hiện chưa được hỗ trợ. Vui lòng đăng nhập bằng Email và Mật khẩu.');
  }

  @override
  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email.trim());
    } catch (e) {
      throw Exception(mapAuthException(e));
    }
  }

  @override
  Future<void> changePassword({
    required String currentPassword,
    required String newPassword,
  }) async {
    final user = _firebaseAuth.currentUser;
    if (user == null || user.email == null) {
      throw Exception('Bạn cần đăng nhập để thực hiện đổi mật khẩu.');
    }

    try {
      // Re-authenticate with current password before updating
      final credential = EmailAuthProvider.credential(
        email: user.email!,
        password: currentPassword,
      );
      await user.reauthenticateWithCredential(credential);
      await user.updatePassword(newPassword);
    } catch (e) {
      throw Exception(mapAuthException(e));
    }
  }

  @override
  Future<void> sendEmailVerification() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) {
      throw Exception('Bạn chưa đăng nhập.');
    }
    try {
      await user.sendEmailVerification();
    } catch (e) {
      throw Exception(mapAuthException(e));
    }
  }

  @override
  Future<AppUser?> reloadUser() async {
    final user = _firebaseAuth.currentUser;
    if (user == null) return null;

    try {
      await user.reload();
      final refreshedUser = _firebaseAuth.currentUser;
      if (refreshedUser == null) return null;

      final profile = await _getUserProfileFromFirestore(refreshedUser.uid);
      final updatedAppUser = fromFirestore(
        profile ?? {},
        refreshedUser.uid,
        fallbackEmail: refreshedUser.email ?? '',
        fallbackName: refreshedUser.displayName ?? '',
        isEmailVerified: refreshedUser.emailVerified,
      );

      _currentUser = updatedAppUser;
      return updatedAppUser;
    } catch (e) {
      throw Exception(mapAuthException(e));
    }
  }

  @override
  Future<void> signOut() async {
    try {
      await _firebaseAuth.signOut();
      _currentUser = null;
    } catch (e) {
      throw Exception(mapAuthException(e));
    }
  }
}
