import 'package:orders/models/CartItem.dart';

class CartItemsApiResponse<T> {
  final String? error;
  final List<CartItem>? products;  
  CartItemsApiResponse({this.error, this.products});

  List<CartItem> get getProducts => products!;


  bool get hasError => error != null;
  bool get isEmpty => (products == null || products!.isEmpty);
  String get getError => error!;
}
