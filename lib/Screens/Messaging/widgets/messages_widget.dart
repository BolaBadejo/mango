import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/chat.dart';
import 'package:swipe_to/swipe_to.dart';
// import 'package:swipe_to/swipe_to.dart';

import 'message_widget.dart';

class MessagesWidget extends StatelessWidget {
  String? idUser;
  ValueChanged<Message>? onSwipedMessage;
  final UserService _userService = UserService();

   MessagesWidget({
    this.idUser,
    this.onSwipedMessage,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) => StreamBuilder<List<Message>>(
    stream: _userService
        .getMessages(idUser),
    builder: (context, snapshot) {
      switch (snapshot.connectionState) {
        case ConnectionState.waiting:
          return Center(child: CircularProgressIndicator());
        default:
          if (snapshot.hasError) {
            return buildText('Something Went Wrong Try later');
          } else {
            final messages = snapshot.data;

            return ListView.builder(
              physics: const BouncingScrollPhysics(),
              reverse: true,
              itemCount: messages?.length,
              itemBuilder: (context, index) {
                final message = messages![index];

                return SwipeTo(
                  onRightSwipe: () => onSwipedMessage!(message),
                  child: MessageWidget(
                    message: message,
                    isMe: message.sender == FirebaseAuth.instance.currentUser!.uid,
                  ),
                );
              },
            );
          }
      }
    },
  );

  Widget buildText(String text) => Center(
    child: Text(
      text,
      style: TextStyle(fontSize: 24),
    ),
  );
}