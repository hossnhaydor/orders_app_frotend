import 'package:orders/models/Product.dart';

class CartItem {
  final int id;
  final int count;
  final Product product;

  Product get getProduct => product;

  CartItem({
    required this.count,
    required this.product,
    required this.id,
  });
  factory CartItem.fromJson(Map<String, dynamic> json) {
    return CartItem(
      product: Product.fromJson(json['product']),
      id: json['id'],
      count: json['product_count'],
    );
  }
}
