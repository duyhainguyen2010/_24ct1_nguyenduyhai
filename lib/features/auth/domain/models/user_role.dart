/// User roles supported in the Boarding House application.
enum UserRole {
  tenant,
  owner;

  String get label {
    switch (this) {
      case UserRole.tenant:
        return 'Khách thuê';
      case UserRole.owner:
        return 'Chủ trọ';
    }
  }

  static UserRole fromString(String? value) {
    if (value == null) return UserRole.tenant;
    switch (value.toLowerCase()) {
      case 'owner':
        return UserRole.owner;
      case 'tenant':
      default:
        return UserRole.tenant;
    }
  }
}
