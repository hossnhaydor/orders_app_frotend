import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';

class Productinfo extends StatelessWidget {
  final Product product;

  const Productinfo({super.key, required this.product});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: Icon(Icons.arrow_back),
          )
        ],
      ),
      body: Center(
        child: Text(product.name),
      ),
    );
  }
}
