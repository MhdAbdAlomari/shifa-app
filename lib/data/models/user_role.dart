enum UserRole {
  admin('admin'),
  coordinator('coordinator'),
  surgeon('surgeon');

  final String value;
  const UserRole(this.value);

  static UserRole fromString(String v) =>
      UserRole.values.firstWhere((r) => r.value == v);
}
