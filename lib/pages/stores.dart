import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Stores extends StatefulWidget {
  const Stores({super.key});

  @override
  State<Stores> createState() => _StoresState();
}

class _StoresState extends State<Stores> {
  List stores = [
    {"title": "Food"},
    {"title": "Make up"},
    {"title": "Clothes"},
    {"title": "Shoes"},
    {"title": "Food"},
    {"title": "Make up"},
    {"title": "Clothes"},
    {"title": "Shoes"}
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Stores"),
      ),
      body: Container(
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: stores.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: SizedBox(
                      height: 100,
                      child: InkWell(
                        onTap: (){

                        },
                        child: Card(
                          child: ListTile(
                            leading: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Container(
                                width: 100, // عيّن عرض الصورة
                                height: 500, // زيادة ارتفاع الصورة
                                child: Image.asset(
                                  "images/zz.jpg",
                                  fit: BoxFit.cover, // يتأكد من ملء المساحة
                                ),
                              ),
                            ),
                            title: Text(stores[index]['title']),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
