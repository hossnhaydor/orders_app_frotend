import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/api/services/wishlist_service.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/pages/product_info.dart';
import 'package:orders/providers/wlist_ids.dart';
import 'package:provider/provider.dart';

class ProductCard extends StatelessWidget {
  final Product p;
  const ProductCard({super.key, required this.p});

  Future<String?> getToken() async {
    var box = Hive.box('myBox'); // Open the box
    String? token = box.get('token'); // Retrieve the token with the key 'token'
    return token;
  }

  void addToWishList(BuildContext context) async {
    final ws = WishlistService();
    String? token = await getToken();
    final res = await ws.addProductToWishlist(token, p.id);
    if (res['success'] != null) {
      // ignore: use_build_context_synchronously
      Provider.of<WishListIdsProvider>(context, listen: false).addId(p.id);
    }
  }

  void removeFromWishList(BuildContext context) async {
    final ws = WishlistService();
    String? token = await getToken();
    final res = await ws.removeFromWishlist(token, p.id);
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
      child: SizedBox(
        height: 200,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Stack(
              alignment: Alignment.topRight,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8.0),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Productinfo(product: p),
                        ),
                      );
                    },
                    child: Image.network(
                      'https://images.squarespace-cdn.com/content/v1/59da11e98419c28f51bab499/1550098469650-ZZ3JVUW5MOSE2BUQWO8J/1182_0027.jpg?format=750w',
                      height: 170,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                IconButton(
                  onPressed: () => isInWishlist
                      ? removeFromWishList(context)
                      : addToWishList(context),
                  icon: Icon(
                    isInWishlist
                        ? Icons.favorite
                        : Icons.favorite_border_rounded,
                  ),
                ),
              ],
            ),
            const Spacer(),
            GestureDetector(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Productinfo(product: p),
                  ),
                );
              },
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(p.name, style: const TextStyle(fontSize: 16)),
                    Text("price:${p.price}",
                        style: const TextStyle(fontSize: 14)),
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
