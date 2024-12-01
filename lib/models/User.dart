class User {
  final int id;
  final String name;
  final String email;
  User({required this.email, required this.id, required this.name});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(email: json['email'], id: json['id'], name: json['name']);
  }
}

class AuthResponse {
  final User user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
        user: User.fromJson(json['user']), token: json['token']);
  }
}
