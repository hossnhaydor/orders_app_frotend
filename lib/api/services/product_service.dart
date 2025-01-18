import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:orders/api/product_api_response.dart';
import 'package:orders/api/products_api_response.dart';
import 'package:orders/api/services/server.dart';
import 'package:orders/models/Product.dart';

class ProductServices {
  final String baseUrl = Server.baseUrl;
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
      print(err);
      return ProductsApiResponse(error: 'check network connection');
    }
  }

  Future<ProductsApiResponse<List<Product>>> getStoreProducts(storeId) async {
    try {
      final res =
          await http.get(Uri.parse('${baseUrl}store/products/$storeId'));
      final Map<String, dynamic> jsonRes = jsonDecode(res.body);
      print(jsonRes);
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
      print(err);
      return ProductsApiResponse(error: 'check network connection');
    }
  }

  Future<ProductsApiResponse<List<Product>>> getUserCart(id, token) async {
    try {
      final res = await http.get(Uri.parse('${baseUrl}cart/items'), headers: {
        "Content-Type": "application/json",
        "Accept": "application/json",
        "Authorization": "Bearer $token",
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

  Future<ProductApiResponse<Product>> getProductInfo(id) async {
    try {
      final res = await http.get(Uri.parse('${baseUrl}products/$id'));
      Map<String, dynamic> jsonRes = await json.decode(res.body);
      print(jsonRes);
      if (res.statusCode == 200) {
        Product product = Product.fromJson(
          jsonRes['product'],
        );
        return ProductApiResponse(
          error: null,
          product: product,
        );
      }
      return ProductApiResponse(
        error: 'product is not avilable',
        product: null,
      );
    } catch (err) {
      print(err);
      return ProductApiResponse(
        error: 'check your network connection',
        product: null,
      );
    }
  }

  Future<Map<String, dynamic>> addProduct(
      token, name, store, stock, price, desc, image) async {
    try {
      final res = await http.post(
        Uri.parse('${Server.baseUrl}products'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(
          {
            "name": name,
            "store_id": store,
            "stock": stock,
            "price": price,
            "desc": desc,
            "image": image,
          },
        ),
      );
      Map<String, dynamic> jsonRes = await jsonDecode(res.body);
      if (res.statusCode == 201) {
        return {
          "message": 'product added successfully',
        };
      }
      final errors = jsonRes['errors'] ?? {};
      return {
        "message": "Adding product faild",
        "error": true,
        'errors': {
          "name": (errors['name'] != null && errors['name'] is List)
              ? errors['name'][0]
              : "",
          "stock": (errors['stock'] != null && errors['stock'] is List)
              ? errors['stock'][0]
              : "",
          "store_id": (errors['store_id'] != null && errors['store_id'] is List)
              ? errors['store_id'][0]
              : "",
          "price": (errors['price'] != null && errors['price'] is List)
              ? errors['price'][0]
              : "",
        },
      };
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map<String, dynamic>> editProduct(
      token, id, name, stock, price, desc, image) async {
    try {
      final res = await http.put(
        Uri.parse('${Server.baseUrl}products/$id'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(
          {
            "name": name,
            "stock": stock,
            "price": price,
            "desc": desc,
            "image": image,
          },
        ),
      );
      Map<String, dynamic> jsonRes = await jsonDecode(res.body);
      if (res.statusCode == 404) {
        return {
          'meesage': 'failed',
          'error': true,
          'errors': {
            "id": 'product not found',
          }
        };
      }
      if (res.statusCode == 201) {
        return {
          "message": 'product edited successfully',
        };
      }
      final errors = jsonRes['errors'] ?? {};
      return {
        "message": "Adding product faild",
        "error": true,
        'errors': {
          "name": (errors['name'] != null && errors['name'] is List)
              ? errors['name'][0]
              : "",
          "stock": (errors['stock'] != null && errors['stock'] is List)
              ? errors['stock'][0]
              : "",
          "price": (errors['price'] != null && errors['price'] is List)
              ? errors['price'][0]
              : "",
        },
      };
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map<String, dynamic>> deleteProduct(token, id) async {
    try {
      final res = await http.delete(
        Uri.parse('${Server.baseUrl}products/${id}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
      );
      Map<String, dynamic> jsonRes = await jsonDecode(res.body);
      print(jsonRes);
      if (res.statusCode == 404) {
        return {
          'meesage': 'failed',
          'error': 'product not found',
        };
      }
      if (res.statusCode == 200) {
        return {
          "message": 'product deleted successfully',
        };
      }
      return {
        "message": "deleting product failed",
        "error": 'something went wrong',
      };
    } catch (err) {
      print(err);
      return {};
    }
  }
}
