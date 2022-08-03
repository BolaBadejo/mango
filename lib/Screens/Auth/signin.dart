import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:mango/Models/animation.dart';
import 'package:mango/Models/cloud/google_signIn.dart';
import 'package:mango/Screens/Auth/signup.dart';
import 'package:mango/Screens/Home/home.dart';
import 'package:mango/Services/auth.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final AuthService _auth = AuthService();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    var _pageSize = MediaQuery.of(context).size.height;
    var _notifySize = MediaQuery.of(context).padding.top;
    var _appBarSize = AppBar().preferredSize.height;

    return Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Container(
            height: _pageSize,
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.end,
                children: <Widget>[
                  Expanded(child: Container()),
                  FadeAnimation(
                    1,
                    const Text(
                      'welcome',
                      style: textHeader2,
                    ),
                  ),
                  FadeAnimation(
                    1.1,
                    const Text(
                      'Sign In',
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
                        FadeAnimation(
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
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.9),
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
                                          color: Colors.grey[400],
                                          fontSize: 14)),
                                ),
                              )),
                        ),
                        const SizedBox(height: 40.0),
                        FadeAnimation(
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
                                        color:
                                            Color.fromRGBO(255, 255, 255, 0.9),
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
                                          color: Colors.grey[400],
                                          fontSize: 14)),
                                ),
                              )),
                        ),
                        const SizedBox(height: 30.0),
                        FadeAnimation(
                          1.3,
                          const Text(
                            'Forgot Password',
                            style: textBody2,
                          ),
                        ),
                        const SizedBox(height: 20.0),
                        FadeAnimation(
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
                                onPressed: () async {
                                  if (emailController.text.isNotEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    _auth
                                        .signIn(
                                            emailController.text.trim(),
                                            passwordController.text.trim(),
                                            context)
                                        .whenComplete(() async {
                                      if (FirebaseAuth.instance.currentUser!.uid
                                          .isNotEmpty) {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  const HomePage()),
                                        );
                                      } else {
                                        SnackBar snack = const SnackBar(
                                          content: Text("could not complete sign up"),
                                          duration: Duration(seconds: 2),
                                        );
                                        ScaffoldMessenger.of(context).showSnackBar(snack);
                                      }
                                    });
                                  } else if (emailController.text.isNotEmpty &&
                                      passwordController.text.isEmpty) {
                                    SnackBar snack = const SnackBar(
                                      content: Text( "Provide password to complete sign up"),
                                      duration: Duration(seconds: 2),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snack);
                                  } else if (emailController.text.isEmpty &&
                                      passwordController.text.isNotEmpty) {
                                    SnackBar snack = const SnackBar(
                                      content: Text("Provide email address to complete sign up"),
                                      duration: Duration(seconds: 2),
                                    );
                                    ScaffoldMessenger.of(context).showSnackBar(snack);
                                  } else {
                                    SnackBar snack = const SnackBar(
                                      content: Text("provide email and password to complete sign up"),
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
                                  "Sign In",
                                  style: TextStyle(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 18),
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20.0,
                  ),
                  FadeAnimation(
                    1.7,
                    Center(
                      child: Column(
                        children: [
                          const Text("alternative login", style: bodyText),
                          const SizedBox(
                            height: 5.0,
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              IconButton(
                                  onPressed: () {
                                    final provider =
                                        Provider.of<GoogleSignInProvider>(
                                            context,
                                            listen: false);
                                    provider.googleLogin();
                                  },
                                  icon: Image.asset("asset/images/google.png")),
                              IconButton(
                                  onPressed: () {
                                    // handleLogin();
                                  },
                                  icon:
                                      Image.asset("asset/images/facebook.png")),
                              IconButton(
                                  onPressed: () {
                                    final provider =
                                        Provider.of<GoogleSignInProvider>(
                                            context,
                                            listen: false);
                                    provider.googleLogin();
                                  },
                                  icon:
                                      Image.asset("asset/images/twitter.png")),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  FadeAnimation(
                      1.7,
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          const Text("Don't have an account?", style: bodyText),
                          const SizedBox(width: 3),
                          GestureDetector(
                              onTap: () => Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SignUpPage())),
                              child: const Text("Sign up", style: textBody3)),
                        ],
                      ))
                ],
              ),
            ),
          ),
        ));
  }
}
