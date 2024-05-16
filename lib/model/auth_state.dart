class AuthState {
  // final User? user;
  final bool isAuthenticated;
  final String? id;
  final String? username;
  final String? email;
  final String? apiToken;
  final role;
  final String isArtist;

  const AuthState(
      {this.id,
      this.username,
      this.email,
      this.apiToken,
      this.role,
      this.isArtist = "user",
      this.isAuthenticated = false});
}
