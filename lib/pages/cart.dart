import 'package:flutter/material.dart';
import 'package:orders/api/products_api_response.dart';
import 'package:orders/api/services/cart_service.dart'; // Updated service import
import 'package:orders/models/Product.dart';
import 'package:orders/providers/cart.dart';
import 'package:orders/widgets/cart/cart_list_items.dart';
import 'package:orders/widgets/shared/retry_button.dart';
import 'package:provider/provider.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late Future<ProductsApiResponse<List<Product>>> _productsFuture;

  // Fetch user cart items
  Future<ProductsApiResponse<List<Product>>> _fetchUserCart() async {
    final cartService = CartService();
    // final userProvider = Provider.of<UserProvider>(context, listen: false);
    // final userId = userProvider.user?.id;

    // if (userId == null) {
    //   return ProductsApiResponse(error: "User not logged in");
    // }

    return await cartService.getUserCart('token');
  }

  void _removeItem(context, id) async {
    final cs = CartService();
    final res = await cs.removeFromCart("token", id);
    if (res['success'] != null) {
      setState(() {
        _productsFuture = _productsFuture.then((response) {
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
      Provider.of<CartIdsProvider>(context, listen: false).removeId(id);
    }
  }

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchUserCart();
  }

  void _refreshCart() {
    setState(() {
      _productsFuture = _fetchUserCart();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<ProductsApiResponse<List<Product>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return RetryButton(
              message: "Something went wrong. Please try again.",
              retry: _refreshCart,
            );
          } else if (snapshot.hasData && snapshot.data!.hasError) {
            return RetryButton(
              message: snapshot.data!.getError,
              retry: _refreshCart,
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No products to show."));
          } else {
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: CartListItems(
                items: snapshot.data!.getProducts,
                removeItem: _removeItem,
              ),
            );
          }
        },
      ),
    );
  }
}
