import 'dart:convert';

import 'package:http/http.dart' as http;
import '../../models/User.dart';

class AuthService {
  final String baseUrl = "http://127.0.0.1:8000/api/";
  Future<Map<String, dynamic>> register(
      name, password, passwordConfirmation, phoneNumber, location) async {
    try {
      var res = await http.post(Uri.parse("${baseUrl}register"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode({
            "password": password,
            "password_confirmation": passwordConfirmation,
            "name": name,
            "phone_number": phoneNumber,
            "Location": location
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
          "phone": (errors['phone'] != null && errors['phone'] is List)
              ? errors['phone'][0]
              : "",
          "name": (errors['name'] != null && errors['name'] is List)
              ? errors['name'][0]
              : "",
          "password": (errors['password'] != null && errors['password'] is List)
              ? errors['password'][0]
              : "",
          "location": (errors['location'] != null && errors['location'] is List)
              ? errors['location'][0]
              : "",
        },
        "user": null
      };
    } catch (err) {
      return {"error": true, "user": null};
    }
  }

  Future<Map<String, dynamic>> login(phone_number, password) async {
    try {
      var res = await http.post(Uri.parse("${baseUrl}login"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json"
          },
          body: jsonEncode({
            "password": password,
            "phone_number": phone_number,
          }));
      final jsonResponse = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final auth = AuthResponse.fromJson(jsonResponse['data']);
        return {'token': auth.token, 'user': auth.user};
      }
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
    try {
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
    } catch (err) {
      return null;
    }
  }

  Future<void> logout(token) async {
    await http.get(Uri.parse("${baseUrl}user"), headers: {
      "Authorization": "Bearer $token",
    });
  }

  Future<dynamic> changeUserInfo(token, name, phone, location) async {
    final res = await http.post(
      Uri.parse("${baseUrl}user/changeInfo"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization":
            "Bearer 6|7XZzxfXonjXY9ornkVNDuGiL0F61cwv8SPWyN5Zr77a9dad8",
      },
      body: jsonEncode({
        "name": name,
        "phone_number": phone,
        "Location": location,
      }),
    );
    final jsonRes = jsonDecode(res.body);
    if (res.statusCode == 200) {
      User user = User.fromJson(jsonRes);
      return user;
    }
    return null;
  }
}
