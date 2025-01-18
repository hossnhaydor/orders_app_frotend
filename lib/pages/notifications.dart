import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/api/services/notifications_servce.dart';
import 'package:orders/models/Notification.dart';
import 'package:orders/widgets/shared/retry_button.dart';

class Notifications extends StatefulWidget {
  const Notifications({super.key});

  @override
  State<Notifications> createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  late Future<List<NotificationModel>> _notificationsFuture;
  List<NotificationModel> _localNotifications = [];
  Future<String?> getToken() async {
    var box = Hive.box('myBox'); // Open the box
    String? token = box.get('token'); // Retrieve the token with the key 'token'
    return token;
  }

  @override
  void initState() {
    super.initState();
    _notificationsFuture = _fetchUserNotifications();
    _notificationsFuture.then((res) {
      if (res.isNotEmpty) {
        setState(() {
          _localNotifications = res;
        });
      }
    });
  }

  Future<List<NotificationModel>> _fetchUserNotifications() async {
    final notificationsService = NotificationService();
    String? token = await getToken();
    return await notificationsService.getNotificaiotns(token);
  }

  void _refreshOrders() {
    setState(() {
      _notificationsFuture = _fetchUserNotifications();
    });
  }

  // void _removeOrder(id) async {
  //   final orderService = OrderService();
  //   String? token = await getToken();
  //   final res = await orderService.removeOrder(token, id);
  //   if (res['success'] == true) {
  //     setState(() {
  //       _localOrders.removeWhere((item) => item.id == id);
  //     });
  //   }
  //   // ignore: use_build_context_synchronously
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(res['message']),
  //     ),
  //   );
  // }

  // void _editOrder(id) async {
  //   final orderService = OrderService();
  //   String? token = await getToken();
  //   final res = await orderService.removeOrder(token, id);
  //   if (res['success'] == true) {
  //     setState(() {
  //       _localOrders.removeWhere((item) => item.id == id);
  //     });
  //   }
  //   // ignore: use_build_context_synchronously
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     SnackBar(
  //       content: Text(res['message']),
  //     ),
  //   );
  // }

  String convertToLocalDate(String isoDate) {
    DateTime parsedDate = DateTime.parse(isoDate);
    return parsedDate.toLocal().toString(); // Display the local datetime
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "My Notifiactions",
          style: TextStyle(
              color: Colors.black, fontSize: 20, fontWeight: FontWeight.bold),
        ),
      ),
      body: FutureBuilder<List<NotificationModel>>(
        future: _notificationsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting &&
              _localNotifications.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError && _localNotifications.isEmpty) {
            return RetryButton(
              message: "Something went wrong. Please try again.",
              retry: _refreshOrders,
            );
          } else if (!snapshot.hasData ||
              snapshot.data!.isEmpty && _localNotifications.isEmpty) {
            return const Center(child: Text("No notifactions to show."));
          } else {
            final notifications = _localNotifications;
            return Padding(
              padding: const EdgeInsets.all(4.0),
              child: ListView.builder(
                itemCount: notifications.length,
                itemBuilder: (context, i) {
                  NotificationModel notification = notifications[i];
                  return Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Row(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment
                                .start, // Align text to the left
                            children: [
                              Text(
                                "content: ${notification.content}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 4),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "created at: ${convertToLocalDate(notification.getDate)}",
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            );
          }
        },
      ),
    );
  }
}
