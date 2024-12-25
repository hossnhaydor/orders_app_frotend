import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/pages/home.dart';
import 'package:orders/pages/user.dart';
import 'package:orders/pages/wishlist.dart';
import 'package:orders/providers/cart.dart';
import 'package:orders/providers/page_index.dart';
import 'package:orders/providers/user.dart';
import 'package:orders/providers/wlist_ids.dart';
import 'package:provider/provider.dart';

class Layout extends StatefulWidget {
  const Layout({super.key});

  @override
  State<Layout> createState() => _LayoutState();
}

List<IconData> navIcons = [Icons.favorite, Icons.home, Icons.person];
List<String> navTitle = ["Wishlist", "Home", "Settings"];

class _LayoutState extends State<Layout> {
  bool loading = false;
  final List<Widget> _pages = [
    const Wishlist(),
    const HomePage(),
    const UserPage(),
  ];

  Future<String?> getToken() async {
    var box = Hive.box('myBox'); // Open the box
    String? token = box.get('token'); // Retrieve the token with the key 'token'
    print('Token retrieved: $token');
    return token;
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      try {
        final wishListProvider =
            Provider.of<WishListIdsProvider>(context, listen: false);
        final cartProvider =
            Provider.of<CartIdsProvider>(context, listen: false);
        final userProvider = Provider.of<UserProvider>(context, listen: false);
        String? token = await getToken();
        if (token != null) {
          setState(() {
            loading = true;
          });
          await userProvider.getUserByToken(token);
          await wishListProvider.getIds(token);
          await cartProvider.getIds(token);
        }
        setState(() {
          loading = false;
        });
      } catch (err) {
        setState(() {
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    PageIndexPorvider pageIndexPorvider =
        Provider.of<PageIndexPorvider>(context);
    int currentIndex = pageIndexPorvider.currentindex;
    final PageController pageController = pageIndexPorvider.pageController;

    return loading
        ? const Center(
            child: CircularProgressIndicator(),
          )
        : Scaffold(
            body: Center(
                child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                pageIndexPorvider.changePage(index);
              },
              children: _pages,
            )),
            bottomNavigationBar: Container(
              margin: const EdgeInsets.only(left: 24.0, right: 24, bottom: 24),
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 283, 283, 283),
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 2,
                    blurRadius: 10,
                    offset: const Offset(0, -3), // Shadow position
                  ),
                ],
              ),
              child: BottomNavigationBar(
                currentIndex: currentIndex,
                showSelectedLabels: false,
                showUnselectedLabels: false,
                type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color.fromARGB(255, 0, 173, 181),
                unselectedItemColor: const Color.fromARGB(255, 238, 238, 238),
                elevation: 0,
                backgroundColor: Colors.transparent,
                onTap: (index) => {pageIndexPorvider.changePage(index)},
                items: [
                  ...navIcons.map((icon) =>
                      BottomNavigationBarItem(icon: Icon(icon), label: "")),
                ],
              ),
            ),
          );
  }
}
