import 'package:flutter/material.dart';
import 'package:orders/api/services/cart_service.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/providers/cart.dart';
import 'package:provider/provider.dart';

class Productinfo extends StatelessWidget {
  final Product product;

  const Productinfo({super.key, required this.product});

  void addProductToCart(context) async {
    final cs = CartService();
    final res = await cs.addProductToCart("2", product.id);
    if (res['success'] != null) {
      // ignore: use_build_context_synchronously
      Provider.of<CartIdsProvider>(context, listen: false).addId(product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final cartIdsProvider = Provider.of<CartIdsProvider>(context);
    final cartIds = cartIdsProvider.ids;
    bool inCart = cartIds.contains(product.id);
    return Scaffold(
      appBar: AppBar(
        actions: const [],
      ),
      backgroundColor: Colors.transparent,
      body: Center(
        child: Column(
          children: [
            Text(product.name),
            !inCart
                ? TextButton(
                    onPressed: () {
                      addProductToCart(context);
                    },
                    child: const Text("add to cart"))
                : const Text("product in cart")
          ],
        ),
      ),
    );
  }
}
