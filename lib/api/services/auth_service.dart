import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../models/User.dart';

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000/api/";
  Future<Map<String, dynamic>> register(
      name, password, passwordConfirmation, phoneNumber) async {
    try {
      var res = await http.post(Uri.parse("${baseUrl}register"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode({
            "password": password,
            "password_confirmation": passwordConfirmation,
            "email": phoneNumber,
            "name": name,
          }));
      if (res.statusCode == 201) {
        final jsonResponse = jsonDecode(res.body);
        final auth = AuthResponse.fromJson(jsonResponse['data']);
        return {'token': auth.token, 'user': auth.user};
      }
      final jsonResponse = jsonDecode(res.body);
      final errors = jsonResponse['errors'] ?? {};

      return {
        "message": "Register faild",
        "error": true,
        'errors': {
          "email": (errors['email'] != null && errors['email'] is List)
              ? errors['email'][0]
              : "",
          "name": (errors['name'] != null && errors['name'] is List)
              ? errors['name'][0]
              : "",
          "password": (errors['password'] != null && errors['password'] is List)
              ? errors['password'][0]
              : "",
        },
        "user": null
      };
    } catch (err) {
      return {"error": true, "user": null};
    }
  }

  Future<Map<String, dynamic>> login(email, password) async {
    try {
      var res = await http.post(Uri.parse("${baseUrl}login"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode({
            "password": password,
            "email": email,
          }));
      if (res.statusCode == 200) {
        final jsonResponse = jsonDecode(res.body);
        final auth = AuthResponse.fromJson(jsonResponse['data']);
        return {'token': auth.token, 'user': auth.user};
      }
      final jsonResponse = jsonDecode(res.body);
      return {
        "message": jsonResponse['message'],
        "error": true,
        'errors': {"error": jsonResponse['message']},
        "user": null
      };
    } catch (err) {
      return {"error": true, "user": null};
    }
  }

  Future<dynamic> getUserByToken(token) async {
    final res = await http.get(Uri.parse("${baseUrl}user"), headers: {
      "Content-Type": "application/json",
      "Accept": "application/json",
      "Authorization": "Bearer $token",
    });
    if (res.statusCode == 200) {
      final jsonRes = jsonDecode(res.body);
      User user = User.fromJson(jsonRes);
      return user;
    }
    return null;
  }

  Future<void> logout(token) async {
    await http.get(Uri.parse("${baseUrl}user"), headers: {
      "Authorization": "Bearer $token",
    });
  }
}
