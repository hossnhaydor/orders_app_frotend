import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';

class CartListCard extends StatelessWidget {
  final Product item;
  final Function(BuildContext, int) removeItem;
  const CartListCard({super.key, required this.item, required this.removeItem});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 150,
        margin: const EdgeInsets.all(10),
        child: Row(
          children: [
            Container(
              height: 120,
              width: 130,
              margin: const EdgeInsets.only(right: 10),
              decoration: BoxDecoration(
                  color: Colors.grey[400],
                  borderRadius: const BorderRadius.all(Radius.circular(20))),
            ),
            Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                //  mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const Padding(padding: EdgeInsets.all(6)),
                  Text(
                    item.name,
                    style: const TextStyle(
                        fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    "980",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
                  ),
                  const Row(
                    children: [
                      Text(
                        "567.9 (1)",
                        style: TextStyle(fontWeight: FontWeight.bold),
                      )
                    ],
                  ),
                  SizedBox(
                    height: 76,
                    width: 170,
                    child: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Positioned(
                          child: IconButton(
                              onPressed: () {
                                removeItem(context, item.id);
                              },
                              icon: const Icon(
                                Icons.cancel_outlined,
                              )),
                        )
                      ],
                    ),
                  )
                ])
          ],
        ),
      ),
    );
  }
}
