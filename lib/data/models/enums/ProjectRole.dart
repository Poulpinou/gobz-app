enum ProjectRole { OWNER, CONTRIBUTOR, VIEWER }

extension ProjectRoleExtensions on ProjectRole {
  String get displayName {
    switch (this) {
      case ProjectRole.OWNER:
        return "Propriétaire";
      case ProjectRole.CONTRIBUTOR:
        return "Contributeur";
      case ProjectRole.VIEWER:
        return "Spectateur";
    }
  }
}
