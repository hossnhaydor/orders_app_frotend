import 'package:flutter/foundation.dart';

class OrderModel {
  final String price;
  final String date;
  OrderModel({required this.price, required this.date});
  String? get getPrice => price;
  String? get getDate => date;

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(price: json['price'], date: json['date']);
  }
}
