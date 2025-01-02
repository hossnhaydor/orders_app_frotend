import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:orders/api/services/server.dart';
import 'package:orders/api/stores_api_response.dart';
import 'package:orders/models/Store.dart';

class StoreService {
  final String baseUrl = Server.baseUrl;
  Future<StoresApiResponse<List<Store>>> getStores() async {
    try {
      final res = await http.get(
        Uri.parse('${baseUrl}store'),
        headers: {
          "Content-type": "application/json",
          "Accept": "application/json",
        },
      );
      final jsonRes = await jsonDecode(res.body);
      if (res.statusCode == 200) {
        final List<dynamic> storesJson = jsonRes['data'];
        List<Store> stores = storesJson
            .map((store) => Store.fromJson(store))
            .toList()
            .cast<Store>();
        return StoresApiResponse(error: null, stores: stores);
      }
      return StoresApiResponse(error: null, stores: []);
    } catch (error) {
      print('returning error');
      return StoresApiResponse(error: 'check your network', stores: null);
    }
  }

  Future<Map<String, dynamic>> addStore(
      token, name, location, type, number, desc, image) async {
    try {
      final res = await http.post(
        Uri.parse('${Server.baseUrl}store'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(
          {
            "name": name,
            "location": location,
            "type": type,
            "number": number,
            "description": desc,
            "image": image,
          },
        ),
      );
      Map<String, dynamic> jsonRes = await jsonDecode(res.body);
      print(jsonRes);
      if (res.statusCode == 201) {
        return {
          "message": 'Store added successfully',
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
          "location": (errors['location'] != null && errors['location'] is List)
              ? errors['location'][0]
              : "",
          "type": (errors['type'] != null && errors['type'] is List)
              ? errors['type'][0]
              : "",
          "number": (errors['number'] != null && errors['number'] is List)
              ? errors['price'][0]
              : "",
          "description":
              (errors['description'] != null && errors['description'] is List)
                  ? errors['description'][0]
                  : "",
        },
      };
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map<String, dynamic>> editStore(
      token, id, name, location, type, number, desc, image) async {
    try {
      final res = await http.put(
        Uri.parse('${Server.baseUrl}store/${id}'),
        headers: {
          "Content-Type": "application/json",
          "Accept": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode(
          {
            "name": name,
            "location": location,
            "type": type,
            "number": number,
            "description": desc,
            "image": image,
          },
        ),
      );
      Map<String, dynamic> jsonRes = await jsonDecode(res.body);
      print(jsonRes);
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
          "message": 'Store edit successfully',
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
          "location": (errors['location'] != null && errors['location'] is List)
              ? errors['location'][0]
              : "",
          "type": (errors['type'] != null && errors['type'] is List)
              ? errors['type'][0]
              : "",
          "number": (errors['number'] != null && errors['number'] is List)
              ? errors['price'][0]
              : "",
          "description":
              (errors['description'] != null && errors['description'] is List)
                  ? errors['description'][0]
                  : "",
        },
      };
    } catch (err) {
      print(err);
      return {};
    }
  }

  Future<Map<String, dynamic>> deleteStore(token, id) async {
    try {
      final res = await http.delete(
        Uri.parse('${Server.baseUrl}store/${id}'),
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
          'error': 'store not found',
        };
      }
      if (res.statusCode == 200) {
        return {
          "message": 'Store deleted successfully',
        };
      }
      return {
        "message": "deleting store failed",
        "error": 'something went wrong',
      };
    } catch (err) {
      print(err);
      return {};
    }
  }
}
