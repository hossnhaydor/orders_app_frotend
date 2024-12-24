import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:orders/api/products_api_response.dart';
import 'package:orders/models/Product.dart';

class ProductServices {
  final String baseUrl = "http://127.0.0.1:8000/api/";
  Future<ProductsApiResponse<List<Product>>> getProducts() async {
    try {
      final res = await http.get(Uri.parse('${baseUrl}products'));
      final Map<String, dynamic> jsonRes = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final List<dynamic> productsJson = jsonRes['product'];
        List<Product> products = productsJson
            .map((product) => Product.fromJson(product))
            .toList()
            .cast<Product>();
        return ProductsApiResponse(products: products);
      }
      return ProductsApiResponse(products: []);
    } catch (err) {
      return ProductsApiResponse(error: 'check network connection');
    }
  }

  Future<ProductsApiResponse<List<Product>>> getStoreProducts(storeId) async {
    try {
      final res =
          await http.get(Uri.parse('${baseUrl}store/products/$storeId'));
      final Map<String, dynamic> jsonRes = jsonDecode(res.body);
      if (res.statusCode == 200) {
        final List<dynamic> productsJson = jsonRes['products'];
        List<Product> products = productsJson
            .map((product) => Product.fromJson(product))
            .toList()
            .cast<Product>();
        return ProductsApiResponse(products: products);
      }
      return ProductsApiResponse(products: []);
    } catch (err) {
      return ProductsApiResponse(error: 'check network connection');
    }
  }

  Future<ProductsApiResponse<List<Product>>> getUserCart(id) async {
    try {
      final res = await http.get(Uri.parse('${baseUrl}cart/items'), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization":
            "Bearer 1|itTs7qT8KjEJYPb58odpR0ISKO8lyIV2VPWuaXxu444d46ca",
      });
      if (res.statusCode == 200) {
        final Map<String, dynamic> jsonRes = jsonDecode(res.body);
        final List<dynamic> productsJson = jsonRes['cart_items'];
        List<Product> products = productsJson
            .map((product) => Product.fromJson(product['product']))
            .toList()
            .cast<Product>();
        return ProductsApiResponse(products: products);
      }
      return ProductsApiResponse(products: []);
    } catch (err) {
      return ProductsApiResponse(error: 'check network connection');
    }
  }
}
