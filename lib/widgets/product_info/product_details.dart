import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/api/services/wishlist_service.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/models/User.dart';
import 'package:orders/pages/cart.dart';
import 'package:orders/pages/signin.dart';
import 'package:orders/pages/signup.dart';
import 'package:orders/pages/store_page.dart';
import 'package:orders/providers/cart.dart';
import 'package:orders/providers/user.dart';
import 'package:orders/providers/wlist_ids.dart';
import 'package:provider/provider.dart';

class ProductDetails extends StatelessWidget {
  final Product product;
  final Function(BuildContext, int) addToCart;
  const ProductDetails({
    super.key,
    required this.product,
    required this.addToCart,
  });

  Future<String?> getToken() async {
    var box = Hive.box('myBox'); // Open the box
    String? token = box.get('token'); // Retrieve the token with the key 'token'
    return token;
  }

  void navigate(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SignIn(),
      ),
    );
  }

  void addToWishList(BuildContext context) async {
    final ws = WishlistService();
    String? token = await getToken();
    if (token == null) {
      navigate(context);
      return;
    }
    final res = await ws.addProductToWishlist(token, product.id);
    if (res['success'] != null) {
      // ignore: use_build_context_synchronously
      Provider.of<WishListIdsProvider>(context, listen: false)
          .addId(product.id);
    }
  }

  void removeFromWishList(BuildContext context) async {
    final ws = WishlistService();
    String? token = await getToken();
    if (token == null) {
      navigate(context);
      return;
    }
    final res = await ws.removeFromWishlist(token, product.id);
    if (res['success'] != null) {
      // ignore: use_build_context_synchronously
      Provider.of<WishListIdsProvider>(context, listen: false)
          .removeId(product.id);
    }
  }

  @override
  Widget build(BuildContext context) {
    final wishListProvider = Provider.of<WishListIdsProvider>(context);
    bool isInWishlist = wishListProvider.ids.contains(product.id);
    final cartIdsProvider = Provider.of<CartIdsProvider>(context);
    final cartIds = cartIdsProvider.ids;
    bool inCart = cartIds.contains(product.id);
    User? user = Provider.of<UserProvider>(context).user;
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => isInWishlist
                ? removeFromWishList(context)
                : addToWishList(context),
            icon: Icon(
              isInWishlist ? Icons.favorite : Icons.favorite_border_rounded,
            ),
          ),
        ],
      ),
      body: SizedBox(
        width: screenWidth,
        height: screenHeight,
        child: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: Image.network(
                    'https://images.squarespace-cdn.com/content/v1/59da11e98419c28f51bab499/1550098469650-ZZ3JVUW5MOSE2BUQWO8J/1182_0027.jpg?format=750w',
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          TextButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => StorePage(
                                      storeId: product.storeId,
                                      storeName: product.storeName,
                                    ),
                                  ));
                            },
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: const Text(
                              'go to store',
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                          Row(
                            children: [
                              const Icon(
                                Icons.star_rounded,
                                color: Color.fromARGB(255, 241, 197, 52),
                              ),
                              Text("${product.rating}/5 ratings"),
                            ],
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(
                          product.name,
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
                bottom: 0,
                child: SizedBox(
                  width: screenWidth,
                  child: Padding(
                    padding: const EdgeInsets.all(
                      32,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${product.price}\$',
                          style: const TextStyle(
                            fontSize: 25,
                            color: Color.fromARGB(255, 48, 214, 134),
                          ),
                        ),
                        SizedBox(
                          width: 160,
                          child: inCart
                              ? TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.black,
                                  ),
                                  onPressed: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => const CartPage(),
                                      ),
                                    );
                                  },
                                  child: const Text(
                                    'product in cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              : TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.blue,
                                  ),
                                  onPressed: () {
                                    if (user == null) {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => const SignUp(),
                                        ),
                                      );
                                      return;
                                    }
                                    addToCart(context, product.id);
                                  },
                                  child: const Text(
                                    'add to cart',
                                    style: TextStyle(
                                      color: Colors.white,
                                    ),
                                  ),
                                ),
                        )
                      ],
                    ),
                  ),
                ))
          ],
        ),
      ),
    );
  }
}
