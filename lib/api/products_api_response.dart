import 'package:orders/models/Product.dart';

class ProductsApiResponse<T>{
  final String? error;
  final List<Product>? products;
  ProductsApiResponse({this.error, this.products});

  List<Product> get getProducts => products!;

  bool get hasError => error != null;
  bool get isEmpty => (products == null || products!.isEmpty);
  String get getError => error!;
}
