import 'package:flutter/material.dart';
import 'package:orders/widgets/store/store_products.dart';

class StorePage extends StatefulWidget {
  final storeId;
  final storeName;
  const StorePage({super.key, required this.storeId, required this.storeName});

  @override
  State<StorePage> createState() => _StorePageState();
}

class _StorePageState extends State<StorePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.storeName),
        actions: const [],
      ),
      body: StoreProducts(storeId: widget.storeId),
    );
  }
}
