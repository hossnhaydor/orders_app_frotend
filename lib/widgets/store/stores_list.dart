import 'package:flutter/material.dart';
import 'package:orders/api/services/store_service.dart';
import 'package:orders/api/stores_api_response.dart';
import 'package:orders/models/Store.dart';
import 'package:orders/widgets/shared/retry_button.dart';
import 'package:orders/widgets/store/store_card.dart';

class StoresList extends StatefulWidget {
  const StoresList({super.key});

  @override
  State<StoresList> createState() => _StoresListState();
}

class _StoresListState extends State<StoresList> {
  late Future<StoresApiResponse<List<Store>>> stores;

  @override
  void initState() {
    super.initState();
    StoreService ss = StoreService();
    stores = ss.getStores();
  }

  void refreshStores() {
    StoreService ss = StoreService();
    stores = ss.getStores();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<StoresApiResponse<List<Store>>>(
        future: stores,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CircularProgressIndicator();
          } else if (snapshot.hasError || snapshot.data!.hasError) {
            return RetryButton(
              message: 'check your connection',
              retry: refreshStores,
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Text('no stores to show');
          } else {
            List<Store> items = snapshot.data!.stores!;
            return ListView.builder(
              itemCount: items.length,
              itemBuilder: (context, i) {
                Store store = items[i];
                return StoreCard(store: store);
              },
            );
          }
        });
  }
}
