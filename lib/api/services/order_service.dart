import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:orders/api/services/server.dart';
import 'package:orders/models/Order.dart';

class OrderService {
  final String baseUrl = Server.baseUrl;

  Future<List<OrderModel>> getOrders(token) async {
    try {
      var res = await http.get(
        Uri.parse("${baseUrl}order/view"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonRes = jsonDecode(res.body);
        List<OrderModel> orders = jsonRes['orders']
            .map((order) => OrderModel.fromJson(order))
            .toList()
            .cast<OrderModel>();
        return orders;
      }
      if (res.statusCode == 400) {
        return [];
      }
      return [];
    } catch (err) {
      return [];
    }
  }

  Future<List<OrderModel>> removeOrder(token, id) async {
    try {
      var res = await http.get(
        Uri.parse("${baseUrl}order/view"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 201) {
        return [];
      }
      if (res.statusCode == 400) {
        return [];
      }
      return [];
    } catch (err) {
      return [];
    }
  }

  Future<Map<String, dynamic>> placeOrder(token) async {
    try {
      var res = await http.post(
        Uri.parse("${baseUrl}order"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 201) {
        return {'success': true};
      }
      if (res.statusCode == 400) {
        return {
          "message": "you dont have enough cash",
          "error": true,
        };
      }
      return {
        "message": "failed to create order",
        "error": true,
      };
    } catch (err) {
      return {"error": true, "user": null};
    }
  }
}
