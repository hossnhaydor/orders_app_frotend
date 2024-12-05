import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/widgets/wishlist/wishlist_card.dart';

class WishListItems extends StatelessWidget {
  final List<Product> items;
  final Function(BuildContext, int) removeItem;
  const WishListItems({
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
        return WishListCard(
          item: items[i],
          removeItem: removeItem,
        );
      },
    );
  }
}
