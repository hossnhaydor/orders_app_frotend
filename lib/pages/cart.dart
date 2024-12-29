import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/api/products_api_response.dart';
import 'package:orders/api/services/cart_service.dart'; // Updated service import
import 'package:orders/api/services/order_service.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/models/User.dart';
import 'package:orders/providers/cart.dart';
import 'package:orders/providers/token.dart';
import 'package:orders/providers/user.dart';
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

  Future<String?> getToken() async {
    var box = Hive.box('myBox'); // Open the box
    String? token = box.get('token'); // Retrieve the token with the key 'token'
    return token;
  }

  // Fetch user cart items
  Future<ProductsApiResponse<List<Product>>> _fetchUserCart() async {
    final cartService = CartService();
    String? token = await getToken();
    return await cartService.getUserCart(token);
  }

  void _addItem(context, id) async {
    final cs = CartService();
    String? token = await getToken();
    final res = await cs.removeFromCart(token, id);
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

  void _removeItem(context, id) async {
    final cs = CartService();
    String? token = await getToken();
    final res = await cs.removeFromCart(token, id);
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

  double calculateTotal(List<Product> products) {
    double total = 0;
    for (var product in products) {
      total += product.price;
    }
    return total;
  }

  void placeOrder(context, total) async {
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    try {
      final orderService = OrderService();
      final res = await orderService.placeOrder(token);
      if (res['error'] != null && res['error'] == true) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(res['message']),
          ),
        );
        throw ();
      }
      User? user = Provider.of<UserProvider>(context, listen: false).user;
      Provider.of<UserProvider>(context, listen: false)
          .increaseAmmount(user!.ammount - total);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('order created successfully'),
        ),
      );
      Provider.of<CartIdsProvider>(context, listen: false).clearList();
      _refreshCart();
      // ignore: empty_catches
    } catch (err) {
      print(err);
    }
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
            double total = calculateTotal(snapshot.data!.getProducts);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: CartListItems(
                    items: snapshot.data!.getProducts,
                    removeItem: _removeItem,
                    addItem: _addItem,
                  ),
                ),
                Positioned(
                    bottom: 10,
                    child: Align(
                      alignment: Alignment.center,
                      child: SizedBox(
                        width: MediaQuery.of(context).size.width,
                        child: Padding(
                          padding:
                              const EdgeInsets.only(left: 10.0, right: 10.0),
                          child: TextButton(
                            onPressed: (() {
                              placeOrder(context,
                                  calculateTotal(snapshot.data!.getProducts));
                            }),
                            style: TextButton.styleFrom(
                              backgroundColor: Colors.blue,
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                'checkout: $total\$',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ))
              ]),
            );
          }
        },
      ),
    );
  }
}
