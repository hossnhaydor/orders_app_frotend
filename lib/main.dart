import 'package:flutter/material.dart';
import 'package:orders/pages/order.dart';
import 'package:orders/widgets/Layout.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
        colorScheme: ColorScheme.fromSwatch().copyWith(
          background: const Color.fromARGB(255, 238, 238, 238),
        ),
      ),
      home: const Order(),
    );
  }
}
