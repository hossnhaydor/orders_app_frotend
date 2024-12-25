class User {
  final int id;
  final String name;
  final String phone;
  final int isAdmin;
  User(
      {required this.phone,
      required this.id,
      required this.name,
      required this.isAdmin});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phone: "${json['phone_number']}",
      id: json['id'],
      name: json['name'],
      isAdmin: json['is_admin'] == true ? 1 : 0,
    );
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
