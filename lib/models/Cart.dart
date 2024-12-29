class Cart {
  final List<Map<String, dynamic>>? items;
  double? price;
  Cart({required this.items});

  factory Cart.fromJson(Map<String, dynamic> json) {
    List<Map<String, dynamic>> items = json['products']
        .forEach((product) => {'name': product.name, 'count': product.count});
    return Cart(items: items);
  }
}
