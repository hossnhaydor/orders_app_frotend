import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:orders/api/services/server.dart';
import 'package:orders/models/Notification.dart';

class NotificationService {
  final String baseUrl = Server.baseUrl;

  Future<List<NotificationModel>> getNotificaiotns(token) async {
    try {
      var res = await http.get(
        Uri.parse("${baseUrl}notifications/show"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      final Map<String, dynamic> jsonRes = jsonDecode(res.body);
      if (res.statusCode == 200) {
        List<NotificationModel> notifications = jsonRes['notifications']
            .map((item) => NotificationModel.fromJson(item))
            .toList()
            .cast<NotificationModel>();
        return notifications;
      }
      if (res.statusCode == 400) {
        return [];
      }
      return [];
    } catch (err) {
      print(err);
      return [];
    }
  }

  Future<Map<String, dynamic>> removeOrder(token, id) async {
    try {
      var res = await http.delete(
        Uri.parse("${baseUrl}order/$id"),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      if (res.statusCode == 201) {
        return {
          'success': true,
          'message': 'order removed successfully',
        };
      }
      return {
        'success': false,
        'message': 'failed to remove order',
      };
    } catch (err) {
      print(err);
      return {
        'success': false,
        'message': 'failed remove successfully',
      };
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
