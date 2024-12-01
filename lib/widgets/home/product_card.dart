import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/pages/product_info.dart';

class ProductCard extends StatelessWidget {
  final Product p;
  const ProductCard({super.key, required this.p});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => Productinfo(product: p),
          ),
        );
      },
      child: Card(
        color: Colors.white,
        elevation: 10,
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(p.name),
              Text("price :${p.price}"),
            ],
          ),
        ),
      ),
    );
  }
}
