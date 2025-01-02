class User {
  final int id;
  final String name;
  final String phone;
  final int isAdmin;
  double ammount;
  User(
      {required this.phone,
      required this.id,
      required this.name,
      required this.isAdmin,
      required this.ammount});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      phone: "${json['phone_number']}",
      id: json['id'],
      name: json['name'],
      ammount: json['wallet'] != null ? double.parse("${json['wallet']}") : 0.0,
      isAdmin: json['is_admin'] == 1 || json['is_admin'] == true ? 1 : 0,
    );
  }
}

class AuthResponse {
  final User? user;
  final String token;

  AuthResponse({required this.user, required this.token});

  factory AuthResponse.fromJson(Map<String, dynamic> json) {
    return AuthResponse(
        user: User.fromJson(json['user']), token: json['token']);
  }
}
