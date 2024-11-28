import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:orders/pages/signup.dart';

class SignIn extends StatefulWidget {
  const SignIn({super.key});

  @override
  State<SignIn> createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  final formsign=GlobalKey<FormState>();
  final TextEditingController phonecon=TextEditingController();
  final TextEditingController usernamecon=TextEditingController();
  bool rememberPassword=true;
  String? pass;
  String? conf;
  String? validateConfirmPassword(String? value){
    if(value==null || value.isEmpty){
      return "please confirm password";
    }else if(value!=pass){
      return "error";
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Back'),
          elevation: 0,
          backgroundColor: Colors.orange,
        ),
        extendBodyBehindAppBar: true,
        body: Stack(
            children: [
            /*  Image.asset('images/ff.jpeg',
                fit: BoxFit.cover,
                width: double.infinity,
                height: double.infinity,),*/
              Container(height: 300,color: Colors.white,),
            SafeArea(child: Column(
              children: [
                Expanded(
                  flex:1,
                    child:SizedBox(
                  height: 10,
                )),
                Expanded(
                  flex: 7,
                    child: Container(
                      padding: EdgeInsets.fromLTRB(25, 50, 25, 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(40),
                    topRight: Radius.circular(40))
                  ),
                      child: SingleChildScrollView(
                        child: Form(
                          key: formsign,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text('Creat Account',style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                                color: Colors.orange
                              ),),
                              Container(height: 10,),
                              TextFormField(
                                controller: usernamecon,
                                keyboardType: TextInputType.name,
                                validator: (value){
                                  if(value==null || value.isEmpty){
                                    return 'please enter user name';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    label:  Text('User Name'),
                                    hintStyle: TextStyle(
                                        color: Colors.black
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange
                                        )
                                    )
                                ),
                              ),
                              Container(height: 10,),
                              TextFormField(
                                controller: phonecon,
                                keyboardType: TextInputType.phone,
                                validator: (value){
                                  if(value==null || value.isEmpty){
                                    return 'please enter phone number';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                  label:  Text('Phone Number'),
                                  hintStyle: TextStyle(
                                    color: Colors.black
                                  ),
                                  border: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange
                                    ),
                                    borderRadius: BorderRadius.circular(10)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderSide: BorderSide(
                                      color: Colors.orange
                                    )
                                  )
                                ),
                              ),
                              Container(height: 10,),
                              TextFormField(
                                obscureText: true,
                                obscuringCharacter: '*',
                                onChanged: (value){
                                  pass=value;
                                },
                                validator: (value){
                                  if(value==null || value.isEmpty){
                                    return 'please enter password';
                                  }
                                  return null;
                                },
                                decoration: InputDecoration(
                                    label:  Text('Password'),
                                    hintStyle: TextStyle(
                                        color: Colors.black
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange
                                        )
                                    )
                                ),
                              ),
                              Container(height: 10,),
                              TextFormField(
                                obscureText: true,
                                obscuringCharacter: '*',
                                validator: validateConfirmPassword,
                                decoration: InputDecoration(
                                    label:  Text('confirm Password'),
                                    hintStyle: TextStyle(
                                        color: Colors.black
                                    ),
                                    border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange
                                        ),
                                        borderRadius: BorderRadius.circular(10)
                                    ),
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.orange
                                        )
                                    )
                                ),
                              ),
                              Container(height: 10,),
                           /*   Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(

                                    children: [
                                      Checkbox(
                                        value: rememberPassword,
                                        onChanged: (bool? value){
                                          setState(() {
                                            rememberPassword=value!;
                                          });
                                        },
                                        activeColor: Colors.cyan,
                                      ),
                                      Text('Remember me',style: TextStyle(
                                        color: Colors.black
                                      ),)
                                    ],
                                  ),
                                  GestureDetector(
                                    child: Text('Forget password',
                                    style: TextStyle(
                                      color: Colors.blue,
                                      fontWeight: FontWeight.bold
                                    ),),
                                  )
                                ],
                              ),*/
                              Container(height: 10,),
                              Container(
                                width: double.infinity,
                                child: ElevatedButton(
                                  onPressed: (){
                                    if(formsign.currentState!.validate()){
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('processing Data')),
                                      );

                                    }else {
                                      ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(content: Text('please agree to the processing of personaly'
                                            ))
                                      );
                                    }

                                  },
                                  child: Text('Sign up'),
                                ),

                              ),
                               Container(height: 50,),
                               Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text('Already have an account?',style: TextStyle(
                                    color: Colors.black
                                  ),),
                                  InkWell(
                                    onTap: (){
                                      Navigator.push(context, MaterialPageRoute(builder: (e)=>SignUp()
                                      )
                                      );
                                    },
                                    child: Text('Sign in',
                                    style: TextStyle(
                                      color: Colors.orange
                                    ),),
                                  )
                                ],
                              ),
                              SizedBox(height: 50,),
                          /*    Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Expanded(child: Divider(
                                    thickness: 0.7,
                                    color: Colors.grey.withOpacity(0.5),
                                  )
                                  ),
                                  Padding(padding: EdgeInsets.symmetric(
                                    vertical: 0,horizontal: 10
                                  ),
                                    child: Text('or continue with',
                                    style: TextStyle(
                                      color: Colors.orange
                                    ),),
                                  ),
                                  Expanded(child: Divider(
                                    thickness: 0.7,
                                    color: Colors.grey.withOpacity(0.5),
                                  )
                                  ),

                                ],
                              ),
                              Container(height: 50,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                children: [
                                  Logo(Logos.facebook_f),
                                  Logo(Logos.twitter),
                                  Logo(Logos.google),
                                  Logo(Logos.apple),

                                ],
                              ),*/
                              Container(height: 10,),



                            ],
                          ),
                        ),
                      ),
                ))
              ],
            ))


            ]
        ));
  }
}
