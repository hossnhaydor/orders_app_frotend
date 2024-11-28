import 'package:flutter/material.dart';

class SignUp extends StatefulWidget {
  const SignUp({super.key});

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  final FocusNode f=FocusNode();
  final TextEditingController phonecon=TextEditingController();
  Color bor=Colors.orange;
  final formsignup=GlobalKey<FormState>();
  void initState(){
    super.initState();
    f.addListener(() {
      setState(() {
        if(f.hasFocus){
          bor=Colors.orange;
        }else{
          bor=Colors.orange;
        }
      });
    });
  }
  void dispose()
  {
  f.dispose();
  super.dispose();
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
                  flex: 1,
                  child: SizedBox(height: 10,)
              ),
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
                        key: formsignup,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text('Login here',style: TextStyle(
                                fontSize: 30,
                                fontWeight: FontWeight.w900,
                              color: Colors.orange
                            ),),
                            Container(height: 10,),
                        /*   TextFormField(
                              validator: (value){
                                if(value==null || value.isEmpty){
                                  return 'please enter name';
                                }
                                return null;
                              },
                              decoration: InputDecoration(
                                  label:  Text('Full name'),
                                  hintStyle: TextStyle(
                                      color: Colors.black
                                  ),
                                  border: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: Colors.black
                                      )
                                  )
                              ),
                            ),*/
                            Container(height: 10,),
                            TextFormField(
                              controller: phonecon,
                              keyboardType: TextInputType.phone,
                              focusNode: f,
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
                                          color: bor
                                      ),
                                      borderRadius: BorderRadius.circular(10)
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                          color: bor
                                      )
                                  )
                              ),
                            ),
                            Container(height: 30,),
                            TextFormField(
                              obscureText: true,
                              obscuringCharacter: '*',
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
                           /* GestureDetector(
                               child: Text('                                                      Forget your password?',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold
                                ),),
                            ),*/
                            Container(height: 50,),
                            Container(
                              width: double.infinity,
                              child: ElevatedButton(
                                onPressed: (){
                                  if(formsignup.currentState!.validate() ){
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
                                child: Text('Sign in'),
                              ),

                            ),
                            SizedBox(height: 150,),
                      /*      Row(
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
                                        color: Colors.orange,
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
                        /*    Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('Already have an account?',style: TextStyle(
                                    color: Colors.black
                                ),),
                                InkWell(
                                  onTap: (){
                                    Navigator.push(context, MaterialPageRoute(builder: (e)=>SignIn()
                                    )
                                    );
                                  },
                                  child: Text('Sign Up',
                                    style: TextStyle(
                                        color: Colors.blue
                                    ),),
                                )
                              ],
                            )*/
                          ],
                        ),
                      ),
                    ),
              ))

     ],
          ))
          ,]
    )
    );
  }
}

