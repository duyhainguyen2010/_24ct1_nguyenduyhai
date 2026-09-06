import 'user_role.dart';

/// Clean user entity representing an authenticated user.
class AppUser {
  final String uid;
  final String email;
  final String fullName;
  final UserRole role;
  final bool isEmailVerified;
  final DateTime createdAt;

  const AppUser({
    required this.uid,
    required this.email,
    required this.fullName,
    required this.role,
    this.isEmailVerified = false,
    required this.createdAt,
  });

  AppUser copyWith({
    String? uid,
    String? email,
    String? fullName,
    UserRole? role,
    bool? isEmailVerified,
    DateTime? createdAt,
  }) {
    return AppUser(
      uid: uid ?? this.uid,
      email: email ?? this.email,
      fullName: fullName ?? this.fullName,
      role: role ?? this.role,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'email': email,
      'fullName': fullName,
      'role': role.name,
      'isEmailVerified': isEmailVerified,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  factory AppUser.fromMap(Map<String, dynamic> map) {
    return AppUser(
      uid: map['uid'] as String? ?? '',
      email: map['email'] as String? ?? '',
      fullName: map['fullName'] as String? ?? '',
      role: UserRole.fromString(map['role'] as String?),
      isEmailVerified: map['isEmailVerified'] as bool? ?? false,
      createdAt: map['createdAt'] != null
          ? DateTime.tryParse(map['createdAt'] as String) ?? DateTime.now()
          : DateTime.now(),
    );
  }
}
