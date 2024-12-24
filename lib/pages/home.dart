import 'package:flutter/material.dart';
import 'package:orders/pages/cart.dart';
import 'package:orders/pages/signup.dart';
import 'package:orders/providers/user.dart';
import 'package:orders/widgets/home/products_list.dart';
import 'package:orders/widgets/home/search_delegate.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: true,
        title: user != null ? Text(user.name) : const Text("Orders App"),
        leading: IconButton(
          onPressed: () {},
          icon: const Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            onPressed: () {
              showSearch(context: context, delegate: CustomSearchDelegate());
            },
            icon: const Icon(Icons.search),
          ),
          user != null
              ? IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const CartPage()),
                    );
                  },
                  icon: const Icon(Icons.shopping_bag_outlined),
                )
              : IconButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const SignUp(),
                      ),
                    );
                  },
                  icon: const Icon(Icons.login_outlined),
                ),
        ],
      ),
      body: const Center(
        child: ProductsList(),
      ),
    );
  }
}
