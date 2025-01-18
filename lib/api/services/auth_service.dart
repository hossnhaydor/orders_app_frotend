import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:orders/api/services/server.dart';
import '../../models/User.dart';

class AuthService {
  final String baseUrl = Server.baseUrl;
  Future<Map<String, dynamic>> register(name, password, passwordConfirmation,
      phoneNumber, location, isAdmin) async {
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
            "Location": location,
            "is_admin": isAdmin
          }));
      final jsonResponse = jsonDecode(res.body);
      print(jsonResponse);
      if (res.statusCode == 201) {
        final auth = AuthResponse.fromJson(jsonResponse['data']);
        return {'token': auth.token, 'user': auth.user};
      }
      final errors = jsonResponse['errors'] ?? {};

      return {
        "message": "Register faild",
        "error": true,
        'errors': {
          "phone": (errors['phone_number'] != null && errors['phone_number'] is List)
              ? errors['phone_number'][0]
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
      print(jsonResponse);
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
      print(err);
      print("login error");
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
        "Authorization": "Bearer $token",
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

  Future<Map<String, dynamic>> addToWallet(token, amount, password) async {
    try {
      var res = await http.post(Uri.parse("${baseUrl}user/wallet"),
          headers: {
            "Content-Type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $token",
          },
          body: jsonEncode({
            "ammount": amount,
            "password": password,
          }));
      final jsonResponse = jsonDecode(res.body);
      print(jsonResponse);
      if (res.statusCode == 200) {
        return {'success': 'amount added to wallet'};
      }
      final errors = jsonResponse['errors'] ?? {};

      return {
        "message": "operation faild",
        "error": true,
        'errors': {
          "ammount": (errors['ammount'] != null && errors['ammount'] is List)
              ? errors['ammount'][0]
              : "",
          "password": (errors['password'] != null && errors['password'] is List)
              ? errors['password'][0]
              : "",
        },
      };
    } catch (err) {
      print(err);
      return {"error": true, "user": null};
    }
  }
}
