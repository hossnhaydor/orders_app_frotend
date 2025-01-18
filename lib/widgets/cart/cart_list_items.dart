import 'package:flutter/material.dart';
import 'package:orders/models/CartItem.dart';
import 'package:orders/widgets/cart/cart_list_card.dart';

class CartListItems extends StatelessWidget {
  final List<CartItem> items;
  final Function(BuildContext, int, int) removeItem;
  final Function(BuildContext, int) addItem;

  const CartListItems({
    super.key,
    required this.items,
    required this.removeItem,
    required this.addItem,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      scrollDirection: Axis.vertical,
      itemCount: items.length,
      itemBuilder: (context, i) {
        return CartListCard(
          item: items[i].product,
          count: items[i].count,
          removeItem: removeItem,
          addItem: addItem,
        );
      },
    );
  }
}
