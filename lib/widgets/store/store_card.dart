import 'package:flutter/material.dart';
import 'package:orders/models/Store.dart';
import 'package:orders/pages/store_page.dart';

class StoreCard extends StatelessWidget {
  final Store store;
  const StoreCard({super.key, required this.store});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => StorePage(
              storeId: store.id,
              storeName: store.name,
            ),
          ),
        );
      },
      child: Card(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Image.network(
                  store.image,
                  height: double.infinity,
                  width: double.infinity,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                children: [
                  Text(
                    store.name,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(store.type)
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
