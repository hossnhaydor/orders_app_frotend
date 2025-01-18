class Product {
  final int id;
  final String name;
  final int price;
  final double? rating;
  final int storeId;
  final String storeName;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.storeId,
    required this.storeName,
  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'],
        price: json['price'],
        rating: json['rating'],
        name: json['name'],
        storeId: json['store_id'],
        storeName: 'store name');
  }
}
