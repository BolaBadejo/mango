import 'package:flutter/material.dart';
import 'package:mango/Models/animation.dart';
import 'package:mango/Screens/Auth/signin.dart';
import 'package:mango/Screens/Auth/signup.dart';
import '../../constants.dart';

class Authenticate extends StatefulWidget {
  const Authenticate({Key? key}) : super(key: key);


  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(35.0),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ReverseFadeAnimation(
                1,
                const Text(
                  'this is',
                  style: splashText2,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ReverseFadeAnimation(
                1.5,
                const Text(
                  'mango',
                  style: splashText,
                ),
              ),
              const SizedBox(
                height: 6,
              ),
              ReverseFadeAnimation(
                2,
                const Text(
                  "Create your space.\n\nConnect with people you can bond with. Don't believe all you read, see for yourself!",
                  textWidthBasis: TextWidthBasis.longestLine,
                  overflow: TextOverflow.fade,
                  maxLines: 4,
                  textAlign: TextAlign.left,
                  style: labelBody,
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ReverseFadeAnimation(
                    2.5,
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SignUpPage()));
                      },
                      child: Container(
                        width: (_width / 2.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              bottom: BorderSide(color: Colors.black, width: 2),
                              top: BorderSide(color: Colors.black, width: 2),
                              left: BorderSide(color: Colors.black, width: 2),
                              right: BorderSide(color: Colors.black, width: 2),
                            ),
                            color: Colors.transparent),
                        child: const Text(
                          'Sign Up',
                          style: labelBody,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  ReverseFadeAnimation(
                    3,
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const LoginPage()));
                      },
                      child: Container(
                        width: (_width / 2.5),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(25),
                            border: const Border(
                              bottom: BorderSide(color: Colors.black, width: 2),
                              top: BorderSide(color: Colors.black, width: 2),
                              left: BorderSide(color: Colors.black, width: 2),
                              right: BorderSide(color: Colors.black, width: 2),
                            ),
                            color: Colors.black),
                        child: const Text(
                          'Sign In',
                          style: labelBody_,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ]),
      ),
    );
  }
}
