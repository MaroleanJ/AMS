
enum UserRole {
  ADMIN,
  ASSET_MANAGER,
  EMPLOYEE;

  String get displayName {
    switch (this) {
      case UserRole.ADMIN:
        return 'Admin';
      case UserRole.ASSET_MANAGER:
        return 'Asset Manager';
      case UserRole.EMPLOYEE:
        return 'Employee';
    }
  }

  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
          (e) => e.name.toUpperCase() == role.toUpperCase(),
      orElse: () => UserRole.EMPLOYEE,
    );
  }
}


extension UserRoleExtension on UserRole {
  /// Returns the primary color associated with this role
  String get roleColor {
    switch (this) {
      case UserRole.ADMIN:
        return '#FF5722'; // Deep Orange
      case UserRole.ASSET_MANAGER:
        return '#2196F3'; // Blue
      case UserRole.EMPLOYEE:
        return '#4CAF50'; // Green
    }
  }

  /// Returns appropriate navigation route for role
  String get defaultRoute {
    switch (this) {
      case UserRole.ADMIN:
        return '/dashboard';
      case UserRole.ASSET_MANAGER:
        return '/dashboard';
      case UserRole.EMPLOYEE:
        return '/my-assets';
    }
  }

  /// Returns permissions level as integer
  int get permissionLevel {
    switch (this) {
      case UserRole.ADMIN:
        return 3;
      case UserRole.ASSET_MANAGER:
        return 2;
      case UserRole.EMPLOYEE:
        return 1;
    }
  }

  /// Check if role has admin privileges
  bool get hasAdminPrivileges => this == UserRole.ADMIN;

  /// Check if role can manage assets
  bool get canManageAssets => this == UserRole.ADMIN || this == UserRole.ASSET_MANAGER;
}