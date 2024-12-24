import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: const [],
        title: const Text("Admin Page"),
      ),
      body: const Center(
        child: Text('admin'),
      ),
    );
  }
}
