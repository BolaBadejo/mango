import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mango/Models/animation.dart';
import 'package:mango/Screens/AccountSetup/biodata_page.dart';
import 'package:mango/Screens/Auth/signin.dart';
import 'package:mango/Services/auth.dart';

import '../../constants.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({Key? key}) : super(key: key);

  @override
  _SignUpPageState createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        body: Padding(
          padding: const EdgeInsets.all(30.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ReverseFadeAnimation(
                1,
                const Text(
                  'welcome',
                  style: textHeader2,
                ),
              ),
              ReverseFadeAnimation(
                1.1,
                const Text(
                  'Sign Up',
                  style: textHeader,
                ),
              ),
              const SizedBox(height: 40.0),
              // Text(
              //   'username',
              //   style: labelBody,
              // ),
              // SizedBox(height: 20.0),

              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    ReverseFadeAnimation(
                      1.2,
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    offset: Offset(6, 2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0),
                                BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 0.9),
                                    offset: Offset(-6, -2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 6.0,
                            ),
                            child: TextFormField(
                              keyboardType: TextInputType.emailAddress,
                              controller: emailController,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  focusColor: Colors.orangeAccent,
                                  prefixIcon: const Icon(
                                    Icons.person,
                                    size: 14,
                                  ),
                                  hintText: 'your email',
                                  hintStyle: TextStyle(
                                      color: Colors.grey[400], fontSize: 14)),
                            ),
                          )),
                    ),

                    const SizedBox(height: 40.0),

                    ReverseFadeAnimation(
                      1.2,
                      Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(100.0),
                              boxShadow: const [
                                BoxShadow(
                                    color: Color.fromRGBO(0, 0, 0, 0.1),
                                    offset: Offset(6, 2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0),
                                BoxShadow(
                                    color: Color.fromRGBO(255, 255, 255, 0.9),
                                    offset: Offset(-6, -2),
                                    blurRadius: 6.0,
                                    spreadRadius: 3.0)
                              ]),
                          child: Padding(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6.0,
                              vertical: 6.0,
                            ),
                            child: TextField(
                              keyboardType: TextInputType.visiblePassword,
                              controller: passwordController,
                              obscureText: true,
                              decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: '*******',
                                  focusColor: Colors.orangeAccent,
                                  prefixIcon: const Icon(
                                    Icons.lock,
                                    size: 14,
                                  ),
                                  hintStyle: TextStyle(
                                      color: Colors.grey[400], fontSize: 14)),
                            ),
                          )),
                    ),
                    const SizedBox(height: 30.0),

                    ReverseFadeAnimation(
                        1.6,
                        Container(
                          padding: const EdgeInsets.only(top: 3, left: 3),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(50),
                              border: const Border(
                                bottom: BorderSide(color: Colors.black),
                                top: BorderSide(color: Colors.black),
                                left: BorderSide(color: Colors.black),
                                right: BorderSide(color: Colors.black),
                              )),
                          child: MaterialButton(
                            minWidth: double.infinity,
                            height: 60,
                            onPressed: () {
                              if (emailController.text.isNotEmpty &&
                                  passwordController.text.isNotEmpty) {
                                _auth
                                    .signUp(emailController.text.trim(),
                                        passwordController.text.trim(), context)
                                    .whenComplete(() async {
                                  User? user =
                                      FirebaseAuth.instance.currentUser!;
                                  String? email = user.email;
                                  Navigator.of(context).pushReplacement(
                                    MaterialPageRoute(
                                      builder: (context) => BioDataPage(
                                        uid: user.uid,
                                        email: email,
                                      ),
                                    ),
                                  );
                                });
                              } else if(emailController.text.isNotEmpty && passwordController.text.isEmpty) {
                                SnackBar snack = const SnackBar(
                                  content: Text( "Provide password to complete sign up"),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snack);
                              } else if(emailController.text.isEmpty && passwordController.text.isNotEmpty){
                                SnackBar snack = const SnackBar(
                                  content: Text( "Provide email address to complete sign up"),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snack);
                              } else {
                                SnackBar snack = const SnackBar(
                                  content: Text( "provide email and password"),
                                  duration: Duration(seconds: 2),
                                );
                                ScaffoldMessenger.of(context).showSnackBar(snack);
                              }
                            },
                            color: Colors.orangeAccent,
                            elevation: 0,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50)),
                            child: const Text(
                              "Sign Up",
                              style: TextStyle(
                                  fontWeight: FontWeight.w600, fontSize: 18),
                            ),
                          ),
                        )),

                    // new Container(
                    //     padding: const EdgeInsets.only(left: 150.0, top: 40.0),
                    //     child: new RaisedButton(
                    //       child: const Text('Submit'),
                    //       onPressed: null,
                    //     )),
                  ],
                ),
              ),
              const SizedBox(height: 20.0),
              ReverseFadeAnimation(
                  1.7,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children:  <Widget>[
                      const Text("Already have an account?", style: bodyText),
                      const SizedBox(width: 3),
                      GestureDetector(
                          onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> LoginPage())),
                          child: const Text("Sign in", style: textBody3)),
                    ],
                  ))
            ],
          ),
        ));
  }
}
