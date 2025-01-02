import 'package:flutter/material.dart';
import 'package:orders/api/product_api_response.dart';
import 'package:orders/api/services/cart_service.dart';
import 'package:orders/api/services/product_service.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/providers/cart.dart';
import 'package:orders/providers/token.dart';
import 'package:orders/widgets/product_info/product_details.dart';
import 'package:provider/provider.dart';

class Productinfo extends StatefulWidget {
  final int id;
  const Productinfo({super.key, required this.id});

  @override
  State<Productinfo> createState() => _ProductinfoState();
}

class _ProductinfoState extends State<Productinfo> {
  late Future<ProductApiResponse<Product>> product;

  @override
  void initState() {
    super.initState();
    product = ProductServices().getProductInfo(widget.id);
  }

  void addProductToCart(context, id) async {
    final cs = CartService();
    String? token = Provider.of<TokenProvider>(context, listen: false).token;
    final res = await cs.addProductToCart(token, id);
    if (res['success'] != null) {
      // ignore: use_build_context_synchronously
      Provider.of<CartIdsProvider>(context, listen: false).addId(id);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
        future: product,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError || !snapshot.hasData) {
            return const Center(
              child: Text('check your network'),
            );
          } else if (snapshot.data!.hasError) {
            return Center(
              child: Text(snapshot.data!.getError),
            );
          } else {
            return ProductDetails(
                product: snapshot.data!.getProduct,
                addToCart: addProductToCart);
          }
        });
  }
}
