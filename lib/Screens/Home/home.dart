import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/Screens/Home/search.dart';
import 'package:mango/Screens/Messaging/messages.dart';
import 'package:mango/Screens/Notifications/notifications.dart';
import 'package:mango/Screens/Profile/profile.dart';

import 'feedspage.dart';
import 'mediahome.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  refresh() {
    setState(() {});
  }
  bool isVisible = false;
  @override
  Widget build(BuildContext context) {
    // double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    DateTime _lastExitTime = DateTime.now();
    return WillPopScope(
      onWillPop: () async {
        if (DateTime.now().difference(_lastExitTime) >= const Duration(seconds: 2)) {
          //showing message to user
          const snack =  SnackBar(
            content:  Text("Press the back button again to exit Mango"),
            duration: Duration(seconds: 2),
          );
          ScaffoldMessenger.of(context).showSnackBar(snack);
          _lastExitTime = DateTime.now();
          return false; // disable back press
        } else {
          return true; //  exit the app
        }
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          shadowColor: Colors.transparent,
          title: Center(
            child: Stack(
              children: [
                AnimatedContainer(duration: const Duration(seconds: 1),
                curve: Curves.fastOutSlowIn,
                  width: isVisible ? _width : 0,
                  height: 45,
                  decoration: const ShapeDecoration(
                    shape: StadiumBorder(),
                    color: Colors.black
                  ),
                ),
                SizedBox(
                width: _width,
                child: Row(
                  children: [
                    Padding(
                      padding: isVisible ? const EdgeInsets.only(left: 20.0) : const EdgeInsets.only(left: 0.0),
                      child: GestureDetector(
                        onTap: () => setState((){
                          isVisible = !isVisible;
                      }),
                        child: Icon(
                          isVisible ? Icons.close : Icons.menu,
                        color: isVisible ? Colors.white : Colors.black,
                        size: isVisible ? 20 : 30,),
                      ),
                    ),
                    Expanded(
                      child: AnimatedOpacity(
                        duration: const Duration(seconds: 1),
                        opacity: isVisible ? 1 : 0,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            InkWell(child: const CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(Icons.home_filled, size: 20, color: Colors.white,)), onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const HomePage()));
                            }),
                            InkWell(child: const CircleAvatar(
                                backgroundColor: Colors.black,
                                child: Icon(Icons.mail_rounded, size: 20, color: Colors.white,)), onTap: (){
                              Navigator.push(context, MaterialPageRoute(builder: (context)=> const Messages()));
                            },),
                            InkWell(
                                onTap: (){
                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (context) => const NotificationsPage()));
                                },
                                child: const CircleAvatar(
                                    backgroundColor: Colors.black,
                                    child: Icon(Icons.notifications, size: 20, color: Colors.white,))),
                            InkWell(
                                child: const CircleAvatar(
                                  backgroundColor: Colors.black,
                                  child: Icon(
                                    Icons.person,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ), onTap: (){
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) =>  ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid,)));
                            }
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              ]
            ),
          ),

        ),
        extendBodyBehindAppBar: true,
        body: PageView(
              children: const [
                // MangoCam(),
                HomePages(),
                Feeds(),
              ],
          ),
      ),
    );

  }
}

