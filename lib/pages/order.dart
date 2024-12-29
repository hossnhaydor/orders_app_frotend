import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/api/services/order_service.dart';
import 'package:orders/models/Order.dart';
import 'package:orders/widgets/shared/retry_button.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
  late Future<List<OrderModel>> _ordersFuture;

  Future<String?> getToken() async {
    var box = Hive.box('myBox'); // Open the box
    String? token = box.get('token'); // Retrieve the token with the key 'token'
    return token;
  }

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchUserOrders();
  }

  Future<List<OrderModel>> _fetchUserOrders() async {
    final orderService = OrderService();
    String? token = await getToken();
    print('getting ordes');
    return await orderService.getOrders(token);
  }

  void _refreshOrders() {
    setState(() {
      _ordersFuture = _fetchUserOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Orders",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<OrderModel>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return RetryButton(
              message: "Something went wrong. Please try again.",
              retry: _refreshOrders,
            );
          } else if (snapshot.hasError) {
            return RetryButton(
              message: snapshot.error.toString(),
              retry: _refreshOrders,
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No orders to show."));
          } else {
            final orders = snapshot.data;
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60.0),
                child: ListView.builder(
                  itemCount: orders!.length,
                  itemBuilder: (context, i) {
                    return Card(
                      child: ListTile(
                        title: Center(child: Text(orders[i].toString())),
                        subtitle: Column(
                          children: [
                            Text(orders[i].toString()),
                            Text(orders[i].toString())
                          ],
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                                onPressed: () {}, icon: const Icon(Icons.edit)),
                            IconButton(
                                onPressed: () {},
                                icon: const Icon(Icons.delete))
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
