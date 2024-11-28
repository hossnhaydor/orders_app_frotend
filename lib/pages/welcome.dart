import 'package:flutter/material.dart';
import 'package:orders/pages/signin.dart';
import 'package:orders/pages/signup.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          Image.asset('images/km.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: 300),
          SafeArea(child: Column(
            children: [
             Container(height: 250,) ,
              Container(
                child: Center(
                  child: Text('  Discover Your\n Dream job here\n',
                  style: TextStyle(
                    fontSize: 45,
                    fontWeight: FontWeight.w600,
                    color: Colors.orange
                  ),

                  ),

                ),
              ),
              Container(
                child: Center(
                  child: Text('  Explore all the existing job roles based on your \n    '
                      '                  interest and study major\n',
                    style: TextStyle(
                        fontSize: 15,
                    ),
                  ),
                ),
              ),
              Container(
                height: 185
              ),
              Container(
                height: 40,
                child: Row(
                  children: [
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (e)=> SignUp()));
                        },
                        child: Container(

                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),

                              )
                          ),
                          child: Center(
                            child: Text('Login',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                              color: Colors.black
                            ),),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      child: InkWell(
                        onTap: (){
                          Navigator.push(context, MaterialPageRoute(builder: (e)=>SignIn()));
                        },
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.orange,
                              borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(50),

                              )
                          ),
                          child: Center(
                            child: Text('Register',
                              style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                color: Colors.white
                              ),),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              )
            ],
          ))
        ],
      ),
    );
  }
}
