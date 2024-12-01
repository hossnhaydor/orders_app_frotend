import 'package:flutter/material.dart';

class Order extends StatefulWidget {
  const Order({super.key});

  @override
  State<Order> createState() => _OrderState();
}

class _OrderState extends State<Order> {
   late final String date;
  late final String name;
  late final String shd;
  List order =[
    {
      "date" :"01 Sep 2023",
      "name":"CWT0012",
      "shd":"shipping date: 09 Sep 2023"
    },
    {
      "date" :"01 Sep 2023",
      "name":"CWT0012",
      "shd":"shipping date: 09 Sep 2023"
    },
    {
      "date" :"01 Sep 2023",
      "name":"CWT0012",
      "shd":"shipping date: 09 Sep 2023"
    },
    {
      "date" :"01 Sep 2023",
      "name":"CWT0012",
      "shd":"shipping date: 09 Sep 2023"
    },
    {
      "date" :"01 Sep 2023",
      "name":"CWT0012",
      "shd":"shipping date: 09 Sep 2023"
    },
    {
      "date" :"01 Sep 2023",
      "name":"CWT0012",
      "shd":"shipping date: 09 Sep 2023"
    },
    {
      "date" :"01 Sep 2023",
      "name":"CWT0012",
      "shd":"shipping date: 09 Sep 2023"
    },
    {
      "date" :"01 Sep 2023",
      "name":"CWT0012",
      "shd":"shipping date: 09 Sep 2023"
    },
    {
      "date" :"01 Sep 2023",
      "name":"CWT0012",
      "shd":"shipping date: 09 Sep 2023"
    }
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(

        title: Text("My Orders",style: TextStyle(
          color: Colors.black,
          fontSize: 20,
          fontWeight: FontWeight.bold
        ),),
      ),
      body: ListView.builder(
     
        itemCount: order.length,
        itemBuilder: (context,i){
          
          return Card(
            child: ListTile(
              title: Center(child: Text(order[i]["date"])),
              subtitle:Column(
                children: [
                  Text(order[i]["name"]),
                  Text(order[i]["shd"])
                ],
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(onPressed: (){},
                      icon: Icon(Icons.edit)),
                  IconButton(onPressed: (){
                    
                  }, icon: Icon(Icons.delete))
                ],
              )
            ),
          );
        },
      )
      
    );
  }
}
