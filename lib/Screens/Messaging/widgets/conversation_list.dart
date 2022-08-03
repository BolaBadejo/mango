import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/chat.dart';
import 'package:mango/Models/customModel/timeago.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/Messaging/pages/chat_page.dart';
import 'package:mango/Services/shimmer_widget.dart';
import 'package:provider/provider.dart';

import '../messages.dart';

class ConversationList extends StatefulWidget {
  // String name;
  // String messageText;
  // String imageUrl;
  // String time;
  // bool isMessageRead;
  const ConversationList({Key? key}) : super(key: key);
  @override
  _ConversationListState createState() => _ConversationListState();
}

class _ConversationListState extends State<ConversationList> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    final users = Provider.of<List<Message>>(context);
    final UserService _userService = UserService();
    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        id: '',
        password: '',
        dob: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        gender: '',
        profileImage: '',
        email: '',
        fcmToken: '',
        verified: false);

    return SizedBox(
      child: ListView.builder(
        itemCount: users.length,
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          var user = users[index];
          String id;
          print(users.length);
          if (user.sender == FirebaseAuth.instance.currentUser!.uid){
            id = user.receiver;
          }
          else {id = user.sender;}
          return StreamBuilder<MangoUser?>(
              initialData: _user,
              stream: _userService.getUserInfo(id),
              builder:
                  (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ChatPage(
                                  user: snapshot.data!,
                                )));
                  },
                  child: Container(
                    width: _size.width,
                    height: 70,
                    padding: const EdgeInsets.only(
                        left: 16, right: 16, top: 10, bottom: 10),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: Row(
                            children: <Widget>[
                              CachedNetworkImage(
                                height: 70,
                                imageUrl: snapshot.data?.profileImage ?? '',
                                imageBuilder: (context, imageProvider) =>
                                    Material(
                                  borderRadius: BorderRadius.circular(50),
                                  // elevation: 1,
                                  child: CircleAvatar(
                                    backgroundImage: imageProvider,
                                    radius: 35,
                                  ),
                                ),
                                placeholder: (context, url) => const ShimmerWidget.circular(width: 70, height: 70),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                              const SizedBox(
                                width: 16,
                              ),
                              Expanded(
                                child: Container(
                                  color: Colors.transparent,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Text(
                                        snapshot.data?.displayName ?? '',
                                        style: const TextStyle(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.black),
                                      ),
                                      const SizedBox(
                                        height: 6,
                                      ),
                                      Text(
                                        user.text,
                                        style: TextStyle(
                                            fontSize: 13,
                                            color: Colors.grey.shade600,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          timeAgo(user.timeStamp.toDate()),
                          style: const TextStyle(
                              fontSize: 12, fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                );
              });
        },
      ),
    );
  }
}
