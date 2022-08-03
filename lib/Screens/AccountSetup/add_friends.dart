import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Screens/Home/home.dart';
import 'package:provider/provider.dart';

import '../../Models/customModel/user.dart';
import '../../Services/shimmer_widget.dart';
import '../../constants.dart';

class MakeFriends extends StatefulWidget {
  final String? uid;
  const MakeFriends({Key? key, required this.uid}) : super(key: key);

  @override
  _MakeFriendsState createState() => _MakeFriendsState();
}

class _MakeFriendsState extends State<MakeFriends> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  List<DocumentSnapshot>? users;


  @override
  void initState() {
    fetchUsers();
    super.initState();
  }

  fetchUsers() async{
    QuerySnapshot snapshot = await db.collection("users").get();
    setState((){
      users = snapshot.docs;
    });
  }

  final List  _friends = List .filled(500, 0, growable: true);
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const HomePage()));
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              Icon(
                Icons.done,
                color: Colors.black,
                size: 22,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Ok, I'm done",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              SizedBox(
                width: 10.0,
              ),
            ]),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 130,
            ),
            const Text(
              "make friends",
              style: postTextBoxText2,
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent
                    ],
                    stops: [
                      0.0,
                      0.1,
                      0.9,
                      1.0
                    ], // 10% purple, 80% transparent, 10% purple
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child: AnimationLimiter(
                  child: StreamProvider.value(
                      initialData:const <MangoUser>[],
                      value: _userService
                          .getAllUsers(FirebaseAuth.instance.currentUser!.uid),
                      child: AddFriends()
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


}

class AddFriends extends StatelessWidget {
  AddFriends({Key? key}) : super(key: key);

  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      username: '',
      dob: '',
      id: '',
      password: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      gender: '',
      profileImage: '',
      email: '', fcmToken: '', verified: false);

  @override
  Widget build(BuildContext context) {
    final UserService _userService = UserService();
    final users = Provider.of<List<MangoUser>>(context);
    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream: _userService.getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder:
            (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          String token = snapshot.data!.fcmToken;
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        return ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: users.length,
          itemBuilder: (context, index) {
            var user = users[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10),
                    // margin: EdgeInsets.symmetric(vertical: 5,),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                        border: Border.symmetric(
                            horizontal: BorderSide(
                                color: Colors.grey.shade100))),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: CachedNetworkImage(
                            height: 50,
                            imageUrl: user.profileImage,
                            imageBuilder: (context, imageProvider) => Material(
                              borderRadius: BorderRadius.circular(50),
                              // elevation: 1,
                              child: CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 25,
                              ),
                            ),
                            placeholder: (context, url) => const ShimmerWidget.circular(width: 50, height: 50),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                        ),
                        const SizedBox(width: 15,),
                        Expanded(
                          flex: 3,
                          child: Column(
                            crossAxisAlignment:
                            CrossAxisAlignment.start,
                            mainAxisAlignment:
                            MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                user.displayName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                "@${user.username}",
                                style: const TextStyle(
                                  color: Colors.grey,
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 10,),
                        StreamBuilder<bool>(
                            initialData: false,
                            stream:
                            _userService.isFollowing(
                                FirebaseAuth.instance.currentUser!.uid,
                                user.id),
                            builder:
                                (BuildContext context, AsyncSnapshot<bool> followingSnapshot) {
                              if (!followingSnapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                            return Expanded(
                              flex: 2,
                              child: !followingSnapshot.data! ? TextButton(
                                  onPressed: () {
                                    // users.removeAt(index);
                                    _userService.followUser(user.id);
                                    _userService.sendNotification('','user',"${snapshot.data!.username} just followed you", "New Follower", user.id, Provider.of<MangoUser>(context).fcmToken);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              28.0),
                                        )),
                                    padding:
                                    MaterialStateProperty.all(
                                        const EdgeInsets
                                            .symmetric(
                                            vertical: 5.0,
                                            horizontal: 20.0)),
                                    backgroundColor:
                                    MaterialStateProperty.all<
                                        Color>(kCoral),
                                  ),
                                  child: const Text(
                                    "follow",
                                    style: postTextBoxText4,
                                  )) : TextButton(
                                  onPressed: () {
                                    // users.removeAt(index);
                                    _userService.unfollowUser(user.id);
                                    // _userService.sendNotification('','user',"${snapshot.data!.username} just followed you", "New Follower", user.id, Provider.of<MangoUser>(context).fcmToken);
                                  },
                                  style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                        RoundedRectangleBorder(
                                          borderRadius:
                                          BorderRadius.circular(
                                              28.0),
                                        )),
                                    padding:
                                    MaterialStateProperty.all(
                                        const EdgeInsets
                                            .symmetric(
                                            vertical: 5.0,
                                            horizontal: 20.0)),
                                    backgroundColor: MaterialStateProperty.all<
                                        Color>(
                                      Colors.black,
                                    ),
                                  ),
                                  child: const Text(
                                    "unfollow",
                                    style: postTextBoxText4,
                                  )),
                            );
                          }
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        );
      }
    );
  }
}

