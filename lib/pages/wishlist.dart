import 'package:flutter/material.dart';

class Wishlist extends StatefulWidget {
  const Wishlist({super.key});
  @override
  State<Wishlist> createState() => _ExampleState();
}

class _ExampleState extends State<Wishlist> {
  int salectedIndex = 0;
  bool state = false;
  List items = [
    {"name": "ear phone wirier", "price ": "698"},
    {
      "name": "ear phone wireless",
      "price": "123",
    },
    {
      "name": "ear phone",
      "price": "567",
    },
    {
      "name": "ear phone",
      "price": "334",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: const Text(
            "Wishlist",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25),
          ),
        ),
        body: Container(
            height: 800,
            padding: EdgeInsets.all(10),
            child: ListView.builder(
              scrollDirection: Axis.vertical,
              itemCount: items.length,
              itemBuilder: (context, i) {
                return Card(
                  child: Container(
                    height: 150,
                    margin: EdgeInsets.all(10),
                    child: Row(
                      children: [
                        Container(
                          height: 120,
                          width: 130,
                          margin: EdgeInsets.only(right: 10),
                          decoration: BoxDecoration(
                              color: Colors.grey[400],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20))),
                        ),
                        Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            //  mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(padding: EdgeInsets.all(6)),
                              Text(
                                items[i]['name'],
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Text(
                                "980",
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold),
                              ),
                              Row(
                                children: [
                                  Text(
                                    "567.9 (1)",
                                    style:
                                        TextStyle(fontWeight: FontWeight.bold),
                                  )
                                ],
                              ),
                              Container(
                                height: 76,
                                width: 170,
                                child: Stack(
                                  alignment: Alignment.bottomRight,
                                  children: [
                                    Positioned(
                                      child: IconButton(
                                          onPressed: () {},
                                          icon: Icon(
                                            Icons.cancel_outlined,
                                          )),
                                    )
                                  ],
                                ),
                              )
                            ])
                      ],
                    ),
                  ),
                );
              },
            )));

    // Center( child:Text("no items"))),
  }
}
