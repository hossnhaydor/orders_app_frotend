import 'package:flutter/material.dart';
import 'package:orders/models/User.dart';
import 'package:orders/providers/user.dart';
import 'package:orders/widgets/admin/admin_add_product.dart';
import 'package:orders/widgets/admin/admin_add_store.dart';
import 'package:orders/widgets/admin/admin_edit_product.dart';
import 'package:orders/widgets/admin/admin_edit_store.dart';
import 'package:provider/provider.dart';

class AdminList extends StatelessWidget {
  const AdminList({super.key});

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

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  user!.name,
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 20),
                buildButton(
                  context: context,
                  text: "Add Store",
                  icon: Icons.add,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminAddStore()),
                  ),
                ),
                buildButton(
                  context: context,
                  text: "Edit Store",
                  icon: Icons.edit,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminEditStore()),
                  ),
                ),
                buildButton(
                  context: context,
                  text: "Add Product",
                  icon: Icons.add,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminAddProduct()),
                  ),
                ),
                buildButton(
                  context: context,
                  text: "Edit Product",
                  icon: Icons.edit,
                  onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AdminEditProduct()),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
