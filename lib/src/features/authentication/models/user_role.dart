enum UserRole {
  owner(1),
  admin(2),
  manager(3),
  waiter(4);

  const UserRole(this.userRoleId);

  final int userRoleId;
}

extension UserRoleEx on UserRole {
  static UserRole fromId(int? id) {
    switch (id) {
      case 1:
        return UserRole.owner;
      case 2:
        return UserRole.admin;
      case 3:
        return UserRole.manager;
      case 4:
        return UserRole.waiter;
      default:
        return UserRole.admin;
    }
  }
}
