class User {
  final String? id;
  final String? username;
  final String? email;
  final String? apiToken;
  final String? role;

  User(
      {required this.id,
      required this.username,
      required this.email,
      this.apiToken,
      this.role});
}
