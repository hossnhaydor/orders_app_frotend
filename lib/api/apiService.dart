import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:orders/models/Product.dart';
import '../models/User.dart';

class ApiService {
  final String baseUrl = "http://127.0.0.1:8000/api/";

  Future<Map<String, dynamic>> login(email, password) async {
    var res = await http.post(
      Uri.parse("${baseUrl}login"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: json.encode({"email": email, "password": password}),
    );
    if (res.statusCode == 200) {
      final jsonResponse = jsonDecode(res.body);
      final auth = AuthResponse.fromJson(jsonResponse);
      return {"message": "success", "res": auth};
    }
    return {
      "message": "Login failed. Please check your credentials",
      "user": null
    };
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

  Future<List<Product>> getProducts() async {
    try {
      final res = await http.get(Uri.parse('${baseUrl}products'));
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonRes = jsonDecode(res.body);
        if (jsonRes['success'] == true) {
          final List<dynamic> productsJson = jsonRes['product'];
          List<Product> products = productsJson
              .map((product) => Product.fromJson(product))
              .toList()
              .cast<Product>();
          return products;
        } else {
          return [];
        }
      }
      return [];
    } catch (err) {
      return [];
    }
  }

  // Future<Product> ProdcutInfo(int id) async {
  //   try {
  //     final res = await http.get(Uri.parse('${baseUrl}product/$id'));
  //     if (res.statusCode == 200) {
  //       final List<dynamic> jsonRes = jsonDecode(res.body);
  //       Product product =
  //           jsonRes.map((product) => product.fromJson(product)).toList().cast<Product>();
  //       return product;
  //     }
  //     return new Product();
  //   } catch (err) {
  //     print(err);
  //     return new Product();
  //   }
  // }
}
