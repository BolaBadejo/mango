import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/chat.dart';
import 'package:mango/Screens/Auth/signin.dart';
import 'package:mango/Screens/Auth/signup.dart';
import 'package:provider/provider.dart';
import 'package:swipe_to/swipe_to.dart';

class ListMessages extends StatefulWidget {
  const ListMessages({Key? key}) : super(key: key);

  @override
  _ListMessagesState createState() => _ListMessagesState();
}

class _ListMessagesState extends State<ListMessages> {
  final UserService _userService = UserService();
  String? idUser;
  ValueChanged<Message>? onSwipedMessage;

  bool isExpanded = false;
  @override
  Widget build(BuildContext context) {
    final chat = Provider.of<List<Message>>(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 40.0),
      child: ListView.builder(
        reverse: true,
        itemCount: chat.length,
        shrinkWrap: true,
        padding: const EdgeInsets.only(top: 10, bottom: 10),
        physics: const BouncingScrollPhysics(),
        itemBuilder: (context, index) {
          final chats = chat[index];
          Size size = MediaQuery.of(context).size;
          return Container(
            padding:
                const EdgeInsets.only(left: 14, right: 14, top: 10, bottom: 10),
            child: Align(
              alignment: (chats.sender == FirebaseAuth.instance.currentUser!.uid
                  ? Alignment.topLeft
                  : Alignment.topRight),
              child: chats.sender == FirebaseAuth.instance.currentUser!.uid
                  ? SwipeTo(
                onRightSwipe: () => onSwipedMessage!(chats),
                    child: Row(
                        children: [
                          // const CircleAvatar(
                          //   backgroundImage: NetworkImage(
                          //       "https://randomuser.me/api/portraits/men/5.jpg"),
                          //   maxRadius: 20,
                          // ),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: size.width / 1.4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: (chats.sender ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: GestureDetector(
                                onTap: () => setState(() {
                                      isExpanded = !isExpanded;
                                    }),
                                child: Text(
                                  chats.text,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                  maxLines: isExpanded ? 100 : 10,
                                  overflow: TextOverflow.fade,
                                )),
                          ),
                        ],
                      ),
                  )
                  : SwipeTo(
                onRightSwipe: () => onSwipedMessage!(chats),
                    child: Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          Container(
                            constraints: BoxConstraints(
                              maxWidth: size.width / 1.4,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: (chats.sender ==
                                      FirebaseAuth.instance.currentUser!.uid
                                  ? Colors.grey.shade200
                                  : Colors.blue[200]),
                            ),
                            padding: const EdgeInsets.all(16),
                            child: GestureDetector(
                                onTap: () => setState(() {
                                      isExpanded = !isExpanded;
                                    }),
                                child: Text(
                                  chats.text,
                                  style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
                                  maxLines: isExpanded ? 100 : 10,
                                  overflow: TextOverflow.fade,
                                )),
                          ),
                          const SizedBox(
                            width: 10,
                          ),
                          const CircleAvatar(
                            backgroundImage: NetworkImage(
                                "https://randomuser.me/api/portraits/women/12.jpg"),
                            maxRadius: 20,
                          ),
                        ],
                      ),
                  ),
            ),
          );
        },
      ),
    );
  }
}

void SelectedItem(BuildContext context, item) {
  switch (item) {
    case 0:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => SignUpPage()));
      break;
    case 1:
      print("Privacy Clicked");
      break;
    case 2:
      print("User Logged out");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => LoginPage()),
          (route) => false);
      break;
  }
}
