import 'package:flutter/material.dart';
import 'package:orders/pages/product_info.dart';
import 'package:orders/pages/store_page.dart';

class SearchList extends StatefulWidget {
  final stores;
  final products;
  final Function(BuildContext, dynamic item) click;
  const SearchList({
    super.key,
    required this.click,
    required this.stores,
    required this.products,
  });

  @override
  State<SearchList> createState() => _SearchListState();
}

class _SearchListState extends State<SearchList> {
  bool showStores = false;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        !showStores
            ? Expanded(
                child: ListView.builder(
                  itemCount: widget.products.length,
                  itemBuilder: (context, index) {
                    final item = widget.products[index];
                    return ListTile(
                      title: Text(item.name), // Use appropriate field
                      onTap: () {
                        // widget.click(context, item);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Productinfo(product: item),
                          ),
                        );
                      },
                    );
                  },
                ),
              )
            : Expanded(
                child: ListView.builder(
                  itemCount: widget.stores.length,
                  itemBuilder: (context, index) {
                    final item = widget.stores[index];
                    return ListTile(
                      title: Text(item.name), // Use appropriate field
                      onTap: () {
                        // widget.click(context, item);
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => StorePage(
                              storeId: item.id,
                              storeName: item.name,
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton(
                onPressed: () {
                  setState(() {
                    showStores = false;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: !showStores ? Colors.blue : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "products",
                    style: TextStyle(
                      color: !showStores ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  setState(() {
                    showStores = true;
                  });
                },
                style: TextButton.styleFrom(
                  backgroundColor: showStores ? Colors.blue : Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "stores",
                    style: TextStyle(
                      color: showStores ? Colors.white : Colors.black,
                    ),
                  ),
                ),
              ),
            ],
          ),
        )
      ],
    );
  }
}
