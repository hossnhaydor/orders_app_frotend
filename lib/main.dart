import 'package:flutter/material.dart';
import 'package:orders/providers/cart.dart';
import 'package:orders/providers/page_index.dart';
import 'package:orders/providers/token.dart';
import 'package:orders/providers/user.dart';
import 'package:orders/providers/wlist_ids.dart';
import 'package:orders/widgets/Layout.dart';
import 'package:provider/provider.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  await Hive.initFlutter();
  await Hive.openBox('myBox');
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => WishListIdsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => CartIdsProvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => PageIndexPorvider(),
        ),
        ChangeNotifierProvider(
          create: (_) => TokenProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: const Color.fromARGB(255, 238, 238, 238),
          colorScheme: ColorScheme.fromSwatch().copyWith(
            background: const Color.fromARGB(255, 238, 238, 238),
          ),
        ),
        home: const Layout(),
      ),
    );
  }
}
