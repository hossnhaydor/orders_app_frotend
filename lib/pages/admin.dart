import 'package:flutter/material.dart';
import 'package:orders/main.dart';
import 'package:orders/widgets/admin/admin_list.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (context) => const MyApp(),
                ),
              );
            },
            icon: const Icon(
              Icons.home_outlined,
            ),
          )
        ],
        title: const Text("Admin Page"),
      ),
      body: const AdminList(),
    );
  }
}
