class Store {
  final int id;
  final String name;
  final String type;
  final String number;
  final String location;
  final String description;
  final String image;
  Store(
      {required this.id,
      required this.name,
      required this.type,
      required this.number,
      required this.image,
        required this.location,
      required this.description});
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
      name: json['name'],
      id: json['id'],
      location: json['location'],
      type: json['type'],
      image: json['image'],
      number: "${json['number']}",
      description: json['description'],
    );
  }
}
