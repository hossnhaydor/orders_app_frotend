import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/widgets/home/product_card.dart';

class ListW extends StatelessWidget {
  final List<Product> prodcuts;
  const ListW({super.key, required this.prodcuts});
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: ListView.builder(
        itemCount: prodcuts.length,
        itemBuilder: (context, i) {
          Product p = prodcuts[i];
          return ProductCard(p: p);
        },
      ),
    );
  }
}
