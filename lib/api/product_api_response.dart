import 'package:orders/models/Product.dart';

class ProductApiResponse<T> {
  String? error;
  Product? product;
  ProductApiResponse({required this.error, required this.product});

  bool get hasError => error != null;
  bool get hasProduct => product != null;
  String get getError => error!;
  Product get getProduct => product!;
}
