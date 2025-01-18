import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';

class CartListCard extends StatelessWidget {
  final Product item;
  final int count;
  final Function(BuildContext, int, int) removeItem;
  final Function(BuildContext, int) addItem;
  const CartListCard(
      {super.key,
      required this.count,
      required this.item,
      required this.addItem,
      required this.removeItem});

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
                    item.image,
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
                        Container(
                          width: 200,
                          child: Text(
                            item.name,
                            style: const TextStyle(fontSize: 16),
                            overflow: TextOverflow.ellipsis,  // Adds '...' if the text is too long
                            maxLines: 2,  // Ensures the text stays within one line
                          ),
                        ),
                        Text(
                          'product price: ${item.price}\$',
                          style: const TextStyle(
                              fontSize: 15, fontWeight: FontWeight.bold),
                        ),
                        Row(
                          children: [
                            Text(
                              "item count: $count",
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            )
                          ],
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
                      addItem(context, item.id);
                    },
                    icon: const Icon(Icons.add),
                  ),
                  Text("$count"),
                  IconButton(
                    onPressed: () {
                      removeItem(context, item.id, count);
                    },
                    icon: const Icon(Icons.remove),
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
