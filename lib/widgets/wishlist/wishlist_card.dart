import 'package:flutter/material.dart';
import 'package:orders/models/Product.dart';
import 'package:orders/pages/product_info.dart';

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
            GestureDetector(
              onTap: (){
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Productinfo(id: item.id),
                  ),
                );
              },
              child: Row(
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
                        ]),
                  )
                ],
              ),
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
