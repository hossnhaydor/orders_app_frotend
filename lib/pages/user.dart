import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/models/User.dart';
import 'package:orders/pages/admin.dart';
import 'package:orders/pages/edit_info.dart';
import 'package:orders/pages/guest.dart';
import 'package:orders/pages/order.dart';
import 'package:orders/pages/wallet.dart';
import 'package:orders/providers/cart.dart';
import 'package:orders/providers/page_index.dart';
import 'package:orders/providers/user.dart';
import 'package:orders/providers/wlist_ids.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  void logout(BuildContext context) {
    var box = Hive.box('myBox');
    box.delete('token');
    Provider.of<UserProvider>(context, listen: false).setUser(null);
    Provider.of<WishListIdsProvider>(context, listen: false).clearList();
    Provider.of<CartIdsProvider>(context, listen: false).clearList();
    Provider.of<PageIndexPorvider>(context, listen: false).changePage(1);
  }

  Widget buildButton({
    required BuildContext context,
    required String text,
    required IconData icon,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: Container(
        height: 70,
        width: double.infinity,
        margin: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(50),
        ),
        child: Row(
          children: [
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Icon(icon),
            ),
            Expanded(
              child: Center(
                child: Text(
                  text,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    User? user = Provider.of<UserProvider>(context).user;

    return user == null
        ? const Guest()
        : Scaffold(
            backgroundColor: Colors.transparent,
            appBar: AppBar(
              title: const Text("Profile Page"),
              backgroundColor: Colors.transparent,
              actions: const [],
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      const CircleAvatar(
                        radius: 50,
                        backgroundImage: AssetImage("images/zz.jpg"),
                      ),
                      const SizedBox(height: 20),
                      Text(
                        user.name,
                        style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 20),
                      buildButton(
                        context: context,
                        text: "Edit Profile",
                        icon: Icons.edit,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const EditInfo()),
                        ),
                      ),
                      buildButton(
                        context: context,
                        text: "Track Order",
                        icon: Icons.shopping_cart,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Order()),
                        ),
                      ),
                      buildButton(
                        context: context,
                        text: "Admin",
                        icon: Icons.admin_panel_settings,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AdminPage()),
                        ),
                      ),
                      buildButton(
                        context: context,
                        text: "Wallet",
                        icon: Icons.wallet,
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const Wallet()),
                        ),
                      ),
                      buildButton(
                        context: context,
                        text: "Logout",
                        icon: Icons.logout,
                        onTap: () => logout(context),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }
}
