import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Screens/Profile/user_grid.dart';
import 'package:provider/provider.dart';

import '../../Models/customModel/user.dart';
import '../../constants.dart';

class FollowersPage extends StatefulWidget {
  final String uid;
  const FollowersPage({Key? key, required this.uid}) : super(key: key);

  @override
  _FollowersPageState createState() => _FollowersPageState();
}

class _FollowersPageState extends State<FollowersPage> {

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25,),
              child: Text("Followers", style: headingextStyle),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: (_width / 2) - 30,
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
                      color: Colors.transparent
                  ),
                  child: const Text('Private', style: labelBody,),
                ),
                Container(
                  width: (_width / 2) - 30,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      // border: Border(
                      //   bottom: BorderSide(color: Colors.black, width: 2),
                      //   top: BorderSide(color: Colors.black, width: 2),
                      //   left: BorderSide(color: Colors.black, width: 2),
                      //   right: BorderSide(color: Colors.black, width: 2),
                      // ),
                      color: Colors.transparent
                  ),
                  child: const Text('Public', style: labelBody,),
                ),
              ],
            ),
            const SizedBox(height: 20,),

            Center(
              child: Container(
                height: _height/1.3,
                // alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  // color: Colors.black12,
                  borderRadius: BorderRadius.circular(30),

                ),
                child: FutureProvider.value(
                  value: UserService().getFollowers(widget.uid),
                  initialData: const <MangoUser>[],
                  child: const UserGrid(),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}

class FollowingPage extends StatefulWidget {
  final String uid;
  const FollowingPage({Key? key, required this.uid}) : super(key: key);

  @override
  _FollowingPageState createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage> {

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 25,),
              child: Text("Following", style: headingextStyle),
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                Container(
                  width: (_width / 2) - 30,
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
                      color: Colors.transparent
                  ),
                  child: const Text('Private', style: labelBody,),
                ),
                Container(
                  width: (_width / 2) - 30,
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25),
                      // border: Border(
                      //   bottom: BorderSide(color: Colors.black, width: 2),
                      //   top: BorderSide(color: Colors.black, width: 2),
                      //   left: BorderSide(color: Colors.black, width: 2),
                      //   right: BorderSide(color: Colors.black, width: 2),
                      // ),
                      color: Colors.transparent
                  ),
                  child: const Text('Public', style: labelBody,),
                ),
              ],
            ),
            const SizedBox(height: 20,),

            Center(
              child: Container(
                height: _height/1.3,
                // alignment: Alignment.center,
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                decoration: BoxDecoration(
                  // color: Colors.black12,
                  borderRadius: BorderRadius.circular(30),

                ),
                child: FutureProvider.value(
                  value: UserService().getFollowing(widget.uid),
                  initialData: const <MangoUser>[],
                  child: const UserGrid(),
                ),
              ),
            )
          ],
        ),
      ),

    );
  }
}
