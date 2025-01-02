class OrderModel {
  final int id;
  final String date;
  final String status;
  final int totalAmount;
  OrderModel({
    required this.id,
    required this.date,
    required this.status,
    required this.totalAmount,
  });
  int get getId => id;
  String get getDate => date;
  int get getTotalAmount => totalAmount;
  String? get getStatus => status;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
        id: json['id'],
        date: json['created_at'],
        totalAmount: json['total_amount'],
        status: json['status']);
  }
}
