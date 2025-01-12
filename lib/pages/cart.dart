import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/api/cartItems_api_response.dart';
import 'package:orders/api/services/cart_service.dart'; // Updated service import
import 'package:orders/api/services/order_service.dart';
import 'package:orders/models/CartItem.dart';
import 'package:orders/models/Product.dart';
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
  late Future<CartItemsApiResponse<List<Product>>> _productsFuture;
  List<CartItem> _localProducts = [];

  @override
  void initState() {
    super.initState();
    _productsFuture = _fetchUserCart();
    _productsFuture.then((res) {
      if (!res.hasError) {
        setState(() {
          _localProducts = res.getProducts;
        });
      }
    });
  }

  Future<String?> getToken() async {
    var box = Hive.box('myBox');
    String? token = box.get('token');
    return token;
  }

  // Fetch user cart items
  Future<CartItemsApiResponse<List<Product>>> _fetchUserCart() async {
    final cartService = CartService();
    String? token = await getToken();
    return await cartService.getUserCart(token);
  }

  void _addItem(context, id) async {
    final cs = CartService();
    String? token = await getToken();
    final res = await cs.addProductToCart(token, id);
    if (res['error'] == true) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res['message'])),
      );
      return;
    } else if (res['success'] != null) {
      setState(() {
        _localProducts = _localProducts
            .map((item) {
              if (item.product.id == id) {
                item.count += 1;
              }
              return item;
            })
            .cast<CartItem>()
            .toList();
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('item added successfully'),
        ),
      );
      // ignore: use_build_context_synchronously
      Provider.of<CartIdsProvider>(context, listen: false).removeId(id);
    }
  }

  void _removeItem(context, id, count) async {
    final cs = CartService();
    String? token = await getToken();
    final res = await cs.removeFromCart(token, id);
    if (res['success'] != null) {
      if (count == 1) {
        _localProducts.removeWhere((item) => item.product.id == id);
      } else {
        setState(() {
          _localProducts = _localProducts
              .map((item) {
                print("${item.product.id} ${id}");
                if (item.product.id == id) {
                  item.count -= 1;
                }
                return item;
              })
              .cast<CartItem>()
              .toList();
        });
      }
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('item removed successfully'),
        ),
      );
      // ignore: use_build_context_synchronously
      Provider.of<CartIdsProvider>(context, listen: false).removeId(id);
    }
  }

  void _refreshCart() {
    setState(() {
      _productsFuture = _fetchUserCart();
    });
  }

  double calculateTotal(List<CartItem> items) {
    double total = 0;
    for (var item in items) {
      total += item.count * item.getProduct.price;
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
      Provider.of<UserProvider>(context, listen: false).decrement(total);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('order created successfully'),
        ),
      );
      Provider.of<CartIdsProvider>(context, listen: false).clearList();
      _refreshCart();
      // ignore: empty_catches
    } catch (err) {
      return;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Cart"),
        backgroundColor: Colors.transparent,
      ),
      body: FutureBuilder<CartItemsApiResponse<List<Product>>>(
        future: _productsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _localProducts.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError && _localProducts.isEmpty) {
            return RetryButton(
              message: "Something went wrong. Please try again.",
              retry: _refreshCart,
            );
          } else if (snapshot.hasData &&
              snapshot.data!.hasError &&
              _localProducts.isEmpty) {
            return RetryButton(
              message: snapshot.data!.getError,
              retry: _refreshCart,
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty ||
              _localProducts.isEmpty) {
            return const Center(child: Text("No products to show."));
          } else {
            double total = calculateTotal(_localProducts);
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Stack(children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 60.0),
                  child: CartListItems(
                    items: _localProducts,
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
