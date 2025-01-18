class Product {
  final int id;
  final String name;
  final double price;
  final int rating;
  final int storeId;
  final String storeName;
  final String image;
  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.rating,
    required this.storeId,
    required this.storeName,
    required this.image,

  });
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      price: json['price'],
      rating: json['rating'] != null ? json['rating'] : 0,
      name: json['name'],
      storeId: json['store_id'],
      image: json['image'],
      storeName: "store name",
    );
  }
}