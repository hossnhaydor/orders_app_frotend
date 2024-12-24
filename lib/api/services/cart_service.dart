import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:orders/api/products_api_response.dart';
import 'package:orders/models/Product.dart';

class CartService {
  final String baseUrl = "http://127.0.0.1:8000/api/";
  Future<ProductsApiResponse<List<Product>>> getUserCart(token) async {
    try {
      final res = await http.get(Uri.parse('${baseUrl}cart/items'), headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization":
            "Bearer 6|7XZzxfXonjXY9ornkVNDuGiL0F61cwv8SPWyN5Zr77a9dad8",
      });
      final Map<String, dynamic> jsonRes = await jsonDecode(res.body);
      if (res.statusCode == 200) {
        final List<dynamic> items = jsonRes['cart_items'];
        List<Product> products = items
            .map((product) => Product.fromJson(product['product']))
            .toList()
            .cast<Product>();
        return ProductsApiResponse(products: products);
      }
      return ProductsApiResponse(error: 'error getting items');
    } catch (err) {
      return ProductsApiResponse(error: 'check network connection');
    }
  }

  Future<Map<String, dynamic>> addProductToCart(user_token, product_id) async {
    try {
      final res = await http.post(Uri.parse('${baseUrl}cart'),
          headers: {
            "Content-type": "application/json",
            "Accept": "application/json",
            "Authorization":
                "Bearer 6|7XZzxfXonjXY9ornkVNDuGiL0F61cwv8SPWyN5Zr77a9dad8",
          },
          body: jsonEncode({'product_id': product_id, "product_count": 1}));
      if (res.statusCode == 201) {
        return {'message': 'added successfully', 'success': true};
      }
      return {'error': true, 'message': 'failed to add item to cart'};
    } catch (err) {
      print(err);
      return {
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
          "Authorization":
              "Bearer 6|7XZzxfXonjXY9ornkVNDuGiL0F61cwv8SPWyN5Zr77a9dad8",
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
        "Authorization":
            "Bearer 6|7XZzxfXonjXY9ornkVNDuGiL0F61cwv8SPWyN5Zr77a9dad8",
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
