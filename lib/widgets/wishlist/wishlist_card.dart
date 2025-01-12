import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';

class WishListCard extends StatelessWidget {
  final Product item;
  final Function(BuildContext, int) removeItem;
  const WishListCard({super.key, required this.item, required this.removeItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(10),
        child: Stack(
          children: [
            Row(
              children: [
                SizedBox(
                  width: 150,
                  height: 150,
                  child: Image.network(
                    'https://images.squarespace-cdn.com/content/v1/59da11e98419c28f51bab499/1550098469650-ZZ3JVUW5MOSE2BUQWO8J/1182_0027.jpg?format=750w',
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      //  mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        Text(
                          item.name,
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Text(
                          'product price: ${item.price}\$',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                      ]),
                )
              ],
            ),
            Positioned(
              bottom: 0,
              right: 0,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () {
                      removeItem(context, item.id);
                    },
                    icon: const Icon(Icons.delete),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
