import 'package:flutter/material.dart';
import 'package:orders/api/services/wishlist_service.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/pages/product_info.dart';
import 'package:orders/providers/wlist_ids.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product p;
  const ProductCard({super.key, required this.p});

  void addToWishList(BuildContext context) async {
    final ws = WishlistService();
    final res = await ws.addProductToWishlist("2", p.id);
    if (res['success'] != null) {
      // ignore: use_build_context_synchronously
      Provider.of<WishListIdsProvider>(context, listen: false).addId(p.id);
    }
  }

  void removeFromWishList(BuildContext context) async {
    final ws = WishlistService();
    final res = await ws.removeFromWishlist("2", p.id);
    if (res['success'] != null) {
      // ignore: use_build_context_synchronously
      Provider.of<WishListIdsProvider>(context, listen: false).removeId(p.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListIdsProvider>(context);
    bool isInWishlist = wishListProvider.ids.contains(p.id);

    return Card(
      color: Colors.white,
      elevation: 10,
      margin: const EdgeInsets.symmetric(horizontal: 6, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Stack(
          children: [
            Positioned(
              top: 0,
              right: 0,
              child: !isInWishlist
                  ? IconButton(
                      onPressed: () => {addToWishList(context)},
                      icon: const Icon(Icons.favorite_border_rounded),
                    )
                  : IconButton(
                      onPressed: () => {removeFromWishList(context)},
                      icon: const Icon(Icons.favorite),
                    ),
            ),
            GestureDetector(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Productinfo(product: p)));
              },
              child: SizedBox(
                height: double.infinity,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name),
                    Text("price :${p.price}"),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
