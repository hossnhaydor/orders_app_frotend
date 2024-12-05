import 'package:flutter/material.dart';
import 'package:orders/pages/home.dart';
import 'package:orders/pages/user.dart';
import 'package:orders/pages/wishlist.dart';
import 'package:orders/providers/cart.dart';
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
  int _currentIndex = 1;
  final PageController _pageController = PageController(initialPage: 1);
  final List<Widget> _pages = [
    const Wishlist(),
    const HomePage(),
    const UserPage(),
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final wishListProvider =
          Provider.of<WishListIdsProvider>(context, listen: false);
      final cartProvider = Provider.of<CartIdsProvider>(context, listen: false);
      wishListProvider.getIds("token");
      cartProvider.getIds("token");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
          child: PageView(
        controller: _pageController,
        onPageChanged: (index) {
          setState(() {
            _currentIndex = index;
          });
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
          currentIndex: _currentIndex,
          showSelectedLabels: false,
          showUnselectedLabels: false,
          type: BottomNavigationBarType.fixed,
          selectedItemColor: const Color.fromARGB(255, 0, 173, 181),
          unselectedItemColor: const Color.fromARGB(255, 238, 238, 238),
          elevation: 0,
          backgroundColor: Colors.transparent,
          onTap: (index) => {
            setState(() {
              _pageController.jumpToPage(index);
              _currentIndex = index;
            })
          },
          items: [
            ...navIcons.map(
                (icon) => BottomNavigationBarItem(icon: Icon(icon), label: "")),
          ],
        ),
      ),
    );
  }
}
