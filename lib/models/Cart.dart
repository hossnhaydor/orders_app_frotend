import 'package:orders/models/Product.dart';

class Cart {
  final List<Map<String, dynamic>>? items;
  double? price;
  Cart({required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> items = json['products'].forEach(());
    return Cart(items: items);
  }
}
