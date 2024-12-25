import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:orders/models/User.dart';
import 'package:orders/pages/admin.dart';
import 'package:orders/pages/edit_info.dart';
import 'package:orders/pages/guest.dart';
import 'package:orders/pages/order.dart';
import 'package:orders/providers/cart.dart';
import 'package:orders/providers/page_index.dart';
import 'package:orders/providers/user.dart';
import 'package:orders/providers/wlist_ids.dart';
import 'package:provider/provider.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  void logout(context) {
    PageIndexPorvider pageIndexPorvider =
        Provider.of<PageIndexPorvider>(context, listen: false);
    var box = Hive.box('myBox');
    box.delete('token');
    Provider.of<UserProvider>(context, listen: false).setUser(null);
    Provider.of<WishListIdsProvider>(context, listen: false).clearList();
    Provider.of<CartIdsProvider>(context, listen: false).clearList();
    pageIndexPorvider.changePage(1);
  }

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    User? user = userProvider.user;
    return user == null
        ? const Guest()
        : Scaffold(
            backgroundColor: Colors.white,
            appBar: AppBar(
              title: const Text("Profile Page"),
            ),
            body: Center(
              child: Column(
                children: [
                  const CircleAvatar(
                    radius: 50,
                    backgroundImage: AssetImage("images/zz.jpg"),
                  ),
                  const SizedBox(height: 20),
                  const Text(
                    "hossn",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const EditInfo(),
                        ),
                      );
                    },
                    child: Container(
                        height: 70,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.edit),
                            ),
                            Center(
                                child: Text(
                              "Edit profile",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ))
                          ],
                        )),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const Order(),
                        ),
                      );
                    },
                    child: Container(
                        height: 70,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.shopping_cart),
                            ),
                            Center(
                                child: Text(
                              "Track order",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ))
                          ],
                        )),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const AdminPage(),
                        ),
                      );
                    },
                    child: Container(
                        height: 70,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.admin_panel_settings),
                            ),
                            Center(
                                child: Text(
                              "Admin",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ))
                          ],
                        )),
                  ),
                  const SizedBox(height: 20),
                  InkWell(
                    onTap: () {
                      logout(context);
                    },
                    child: Container(
                        height: 70,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.grey[200],
                          borderRadius: BorderRadius.circular(50),
                        ),
                        child: const Row(
                          children: [
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Icon(Icons.logout),
                            ),
                            Center(
                                child: Text(
                              "LogOut",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold, fontSize: 20),
                            ))
                          ],
                        )),
                  ),
                ],
              ),
            ),
          );
  }
}
