import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/api/products_api_response.dart';
import 'package:orders/api/services/wishlist_service.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/models/User.dart';
import 'package:orders/pages/guest.dart';
import 'package:orders/providers/user.dart';
import 'package:orders/providers/wlist_ids.dart';
import 'package:orders/widgets/shared/retry_button.dart';
import 'package:orders/widgets/wishlist/wishlist_items.dart';
import 'package:provider/provider.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});
  @override
  State<Wishlist> createState() => _ExampleState();
}

class _ExampleState extends State<Wishlist> {
  int salectedIndex = 0;
  bool state = false;
  late Future<ProductsApiResponse<List<Product>>> items;

  Future<String?> getToken() async {
    var box = Hive.box('myBox'); // Open the box
    String? token = box.get('token'); // Retrieve the token with the key 'token'
    return token;
  }

  Future<ProductsApiResponse<List<Product>>> _getItems() async {
    final wishlistService = WishlistService();
    String? token = await getToken();
    return await wishlistService.getUserWishlist(token);
  }

  void _removeItem(context, id) async {
    final ws = WishlistService();
    String? token = await getToken();
    final res = await ws.removeFromWishlist(token, id);
    if (res['success'] != null) {
      setState(() {
        items = items.then((response) {
          final updateProducts = response.getProducts
              .where((product) => product.id != id)
              .toList()
              .cast<Product>();
          return ProductsApiResponse(
            error: response.error,
            products: updateProducts,
          );
        });
      });
      // ignore: use_build_context_synchronously
      Provider.of<WishListIdsProvider>(context, listen: false).removeId(id);
    }
  }

  @override
  void initState() {
    super.initState();
    items = _getItems();
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.user;
    return user == null
        ? const Guest()
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              backgroundColor: Colors.transparent,
              actions: const [],
              title: const Text(
                "Wishlist",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
              ),
            ),
            body: FutureBuilder(
                future: items,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("Somthing went worng"),
                    );
                  } else if (snapshot.hasData && snapshot.data!.hasError) {
                    return Center(
                      child: RetryButton(
                        message: snapshot.data!.getError,
                        retry: _getItems,
                      ),
                    );
                  } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text("no items saved"),
                    );
                  } else {
                    return Padding(
                      padding: const EdgeInsets.all(4.0),
                      child: WishListItems(
                        items: snapshot.data!.getProducts,
                        removeItem: _removeItem,
                      ),
                    );
                  }
                }),
          );
  }
}
