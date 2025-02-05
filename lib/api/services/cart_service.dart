import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:orders/api/cartItems_api_response.dart';
import 'package:orders/api/services/server.dart';
import 'package:orders/models/CartItem.dart';
import 'package:orders/models/Product.dart';

class CartService {
  final String baseUrl = Server.baseUrl;
  Future<CartItemsApiResponse<List<Product>>> getUserCart(token) async {
    try {
      final res = await http.get(Uri.parse('${baseUrl}cart/items'), headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer ${token}",
      });
      final Map<String, dynamic> jsonRes = await jsonDecode(res.body);
      print(jsonRes);
      if (res.statusCode == 200) {
        final List<dynamic> items = jsonRes['cart_items'];
        List<CartItem> products = items
            .map((cartItem) => CartItem.fromJson(cartItem))
            .toList()
            .cast<CartItem>();
        return CartItemsApiResponse(products: products);
      }
      return CartItemsApiResponse(error: 'error getting items');
    } catch (err) {
      print('carttt error');
      print(err);
      return CartItemsApiResponse(error: 'check network connection');
    }
  }

  Future<Map<String, dynamic>> addProductToCart(user_token, product_id) async {
    try {
      final res = await http.post(Uri.parse('${baseUrl}cart'),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization": "Bearer $user_token",
          },
          body: jsonEncode({'product_id': product_id, "product_count": 1}));
      if (res.statusCode == 401) {
        return {'message': 'you must be logged in', 'error': true};
      }
      if (res.statusCode == 201) {
        return {'message': 'added successfully', 'success': true};
      }
      return {'error': true, 'message': 'item out of stock'};
    } catch (err) {
      return {
        'message': 'you must be logged in',
        "error": true,
      };
    }
  }

  Future<Map<String, dynamic>> removeFromCart(user_token, product_id) async {
    try {
      final res = await http.delete(
        Uri.parse('${baseUrl}cart/delete'),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer ${user_token}",
        },
        body: jsonEncode({'item_id': product_id}),
      );
      if (res.statusCode == 200) {
        return {'message': 'product removed successfully', 'success': true};
      }
      return {'error': true, 'message': 'failed to remove item from cart'};
    } catch (err) {
      return {
        "error": true,
      };
    }
  }

  Future<Map<String, dynamic>> getUserCartIds(token) async {
    try {
      final res = await http.get(Uri.parse('${baseUrl}cart/ids'), headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
      });
      Map<String, dynamic> jsonRes = jsonDecode(res.body);
      if (res.statusCode == 200) {
        Set result = {};
        jsonRes['cart_ids'].forEach((item) => {result.add(item['product_id'])});
        return {'ids': result};
      }
      return {'ids': {}};
    } catch (err) {
      return {"error": err};
    }
  }
}
