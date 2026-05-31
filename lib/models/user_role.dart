class UserRole {
  final String userId;
  final String roleId;
  final String scopeId;
  final String userRoleId;
  final int districtId;
  final int municipalId;
  final String schoolId;

  UserRole({
    required this.userId,
    required this.roleId,
    required this.scopeId,
    required this.userRoleId,
    required this.districtId,
    required this.municipalId,
    required this.schoolId,
  });

  factory UserRole.fromMap(Map<String, dynamic> json) {
    return UserRole(
      userId: json['user_id'],
      roleId: json['role_id'],
      scopeId: json['scope_id'],
      userRoleId: json['user_role_id'],
      districtId: json['district_id'],
      municipalId: json['municipal_id'],
      schoolId: json['school_id'],
    );
  }
}
