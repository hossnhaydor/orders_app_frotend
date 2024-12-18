import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/widgets/cart/cart_list_card.dart';

class CartListItems extends StatelessWidget {
  final List<Product> items;
  final Function(BuildContext, int) removeItem;
  const CartListItems({
    super.key,
    required this.items,
    required this.removeItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, i) {
        return CartListCard(
          item: items[i],
          removeItem: removeItem,
        );
      },
    );
  }
}
