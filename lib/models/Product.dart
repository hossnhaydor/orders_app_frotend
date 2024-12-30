class Product {
  final int id;
  final String name;
  final  int price;
  final double rating;
  Product(
      {required this.id,
      required this.name,
      required this.price,
      required this.rating});
  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
        id: json['id'], price: json['price'], rating: 2, name: json['name']);
  }
}
