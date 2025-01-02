import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:orders/api/services/server.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/models/Store.dart';

class SearchService {
  final String baseUrl = Server.baseUrl;
  Future<List<dynamic>> fetchResults(String query) async {
    try {
      final res = await http.get(
        Uri.parse('${baseUrl}search/$query'),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
        },
      );
      final jsonRes = await jsonDecode(res.body);
      print(jsonRes);
      if (res.statusCode == 200) {
        final List<dynamic> productsJson = jsonRes['data']['products'];
        List<Product> products = productsJson
            .map((product) => Product.fromJson(product))
            .toList()
            .cast<Product>();
        if (query == 'rated') {
          return products;
        } else {
          final List<dynamic> storesJson = jsonRes['data']['stores'];
          List<Store> stores = storesJson
              .map((store) => Store.fromJson(store))
              .toList()
              .cast<Store>();
          return [
            {
              "products": products,
              "stores": stores,
            }
          ];
        }
      }
      return [];
    } catch (error) {
      print(error);
      return [];
    }
  }
}
