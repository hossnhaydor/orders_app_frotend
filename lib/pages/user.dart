import 'package:flutter/material.dart';

class UserPage extends StatelessWidget {
  const UserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text("Profile Page"),
      ),
      body: Center(
        child: Column(
          children: [
            CircleAvatar(radius: 50, // نصف قطر الدائرة
              backgroundImage: AssetImage("images/zz.jpg"), ),
            SizedBox(height: 20),
            Text(
              "hossn",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),

            SizedBox(height: 20),
            InkWell(
              onTap: (){},
              child: Container(
                height: 70,
                width: 350,
                decoration: BoxDecoration(
                  color: Colors.grey[200], // لون الخلفية
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Row(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Icon(Icons.edit),
                    ),
                    Center(child: Text("      Edit profile",style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20
                    ),))
                  ],
                )
              ),
            ),
            SizedBox(height: 20),
            InkWell(
              onTap: (){},
              child: Container(
                  height: 70,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // لون الخلفية
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.shopping_cart),
                      ),
                      Center(child: Text("      Track order",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),))
                    ],
                  )
              ),
            ),   SizedBox(height: 20),
            InkWell(
              onTap: (){},
              child: Container(
                  height: 70,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // لون الخلفية
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.admin_panel_settings),
                      ),
                      Center(child: Text("      Admin",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),))
                    ],
                  )
              ),
            ),

            SizedBox(height: 20),
            InkWell(
              onTap: (){},
              child: Container(
                  height: 70,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.grey[200], // لون الخلفية
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Icon(Icons.logout),
                      ),
                      Center(child: Text("      Sign Out",style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 20
                      ),))
                    ],
                  )
              ),
            ),

          ],
        ),
      ),
    );
  }
}
