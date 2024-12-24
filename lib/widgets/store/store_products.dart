import 'package:flutter/material.dart';
import 'package:orders/api/products_api_response.dart';
import 'package:orders/api/services/product_service.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/widgets/home/home_list.dart';
import 'package:orders/widgets/shared/retry_button.dart';

class StoreProducts extends StatefulWidget {
  final storeId;
  const StoreProducts({super.key, required this.storeId});

  @override
  State<StoreProducts> createState() => _StoreProductsState();
}

class _StoreProductsState extends State<StoreProducts> {
  final productsService = ProductServices();
  late Future<ProductsApiResponse<List<Product>>> products;

  @override
  void initState() {
    super.initState();
    _getProducts();
  }

  void _getProducts() async {
    setState(() {
      products = productsService.getStoreProducts(widget.storeId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<ProductsApiResponse<List<Product>>>(
      future: products,
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
              retry: _getProducts,
            ),
          );
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(
            child: Text("No products to show"),
          );
        } else {
          return Padding(
            padding: const EdgeInsets.all(4.0),
            child: HomeList(prodcuts: snapshot.data!.getProducts),
          );
        }
      },
    );
  }
}
