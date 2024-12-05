import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/widgets/shared/product_card.dart';

class HomeList extends StatelessWidget {
  final List<Product> prodcuts;
  const HomeList({super.key, required this.prodcuts});
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 2.5,
        crossAxisSpacing: 2.5,
        childAspectRatio: .9,
      ),
      itemCount: prodcuts.length,
      itemBuilder: (context, i) {
        Product p = prodcuts[i];
        return ProductCard(p: p);
      },
    );
  }
}
