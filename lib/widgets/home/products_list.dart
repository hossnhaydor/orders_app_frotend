import 'package:flutter/material.dart';
import 'package:orders/api/apiService.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/widgets/home/list.dart';

class ProductsList extends StatefulWidget {
  const ProductsList({super.key});

  @override
  State<ProductsList> createState() => _ProductsListState();
}

class _ProductsListState extends State<ProductsList> {
  final apiService = ApiService();
  late Future<List<Product>> products;

  @override
  void initState() {
    super.initState();
    _getProducts(); // Initialize the future in initState
  }

  void _getProducts() {
    setState(() {
      products = apiService.getProducts();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        FutureBuilder<List<Product>>(
          future: products,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return const Center(
                child: Text("Error getting products"),
              );
            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return const Center(
                child: Text("No products to show"),
              );
            } else {
              return ListW(prodcuts: snapshot.data!);
            }
          },
        ),
      ],
    );
  }
}
