import 'dart:collection';
import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:orders/api/products_api_response.dart';
import 'package:orders/models/Product.dart';

class WishlistService {
  final String baseUrl = "http://127.0.0.1:8000/api/";

  Future<ProductsApiResponse<List<Product>>> getUserWishlist(token) async {
    try {
      final res =
          await http.get(Uri.parse('${baseUrl}wishlist/items'), headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization":
            "Bearer 23|zOPjJRr0Ynleta3UXyR3ATMPCm7MbEnPm7QlJ4gWb7f868c1",
      });
      final Map<String, dynamic> jsonRes = await jsonDecode(res.body);
      if (res.statusCode == 200) {
        final List<dynamic> items = jsonRes['wishlist'];
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

  Future<Map<String, dynamic>> addProductToWishlist(
      user_token, product_id) async {
    try {
      final res = await http.post(
        Uri.parse('${baseUrl}wishlist'),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "Bearer 23|zOPjJRr0Ynleta3UXyR3ATMPCm7MbEnPm7QlJ4gWb7f868c1",
        },
        body: jsonEncode({'product_id': product_id}),
      );
      if (res.statusCode == 201) {
        return {'message': 'added successfully', 'success': true};
      }
      return {'error': true, 'message': 'failed to add item to ishlist'};
    } catch (err) {
      print(err);
      return {
        "error": true,
      };
    }
  }

  Future<Map<String, dynamic>> removeFromWishlist(
      user_token, product_id) async {
    try {
      final res = await http.delete(
        Uri.parse('${baseUrl}wishlist/delete'),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
          "Authorization":
              "Bearer 23|zOPjJRr0Ynleta3UXyR3ATMPCm7MbEnPm7QlJ4gWb7f868c1",
        },
        body: jsonEncode({'item_id': product_id}),
      );
      if (res.statusCode == 200) {
        return {'message': 'product removed successfully', 'success': true};
      }
      return {'error': true, 'message': 'failed to remove item from ishlist'};
    } catch (err) {
      return {
        "error": true,
      };
    }
  }

  Future<Map<String, dynamic>> getUserWishlistIds(token) async {
    try {
      final res = await http.get(Uri.parse('${baseUrl}wishlist/ids'), headers: {
        "Content-type": "application/json",
        "Accept": "application/json",
        "Authorization":
            "Bearer 23|zOPjJRr0Ynleta3UXyR3ATMPCm7MbEnPm7QlJ4gWb7f868c1",
      });
      Map<String, dynamic> jsonRes = jsonDecode(res.body);
      if (res.statusCode == 200) {
        HashSet result = HashSet();
        jsonRes['wishlist_ids']
            .forEach((item) => {result.add(item['product_id'])});
        return {'ids': result};
      }
      return {'ids': HashSet()};
    } catch (err) {
      return {"error": err};
    }
  }
}
