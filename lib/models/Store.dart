class Store {
  final int id;
  final String name;
  final String type;
  final String number;
  final String location;
  final String description;
  Store(
      {required this.id,
      required this.name,
      required this.type,
      required this.number,
      required this.location,
      required this.description});
  factory Store.fromJson(Map<String, dynamic> json) {
    return Store(
        name: json['name'],
        id: json['id'],
        location: json['location'],
        type: json['type'],
        number: "${json['number']}",
        description: json['description']);
  }
}
