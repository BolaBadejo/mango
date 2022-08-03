import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/customModel/chat.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/Messaging/widgets/messages_widget.dart';
import 'package:mango/Screens/Messaging/widgets/new_message_widget.dart';

class ChatPage extends StatefulWidget {
  MangoUser user;

  ChatPage({
    required this.user,
    Key? key,
  }) : super(key: key);

  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final focusNode = FocusNode();
  Message? replyMessage;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          elevation: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.white,
          flexibleSpace: SafeArea(
            child: Container(
              padding: const EdgeInsets.only(right: 16),
              child: Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    icon: const Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(
                    width: 2,
                  ),
                   CircleAvatar(
                    backgroundImage: NetworkImage(
                        widget.user.profileImage),
                    maxRadius: 20,
                  ),
                  const SizedBox(
                    width: 12,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          widget.user.displayName,
                          style: const TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ),
                        const SizedBox(
                          height: 6,
                        ),
                        Text(
                          '@${widget.user.username}',
                          style: TextStyle(
                              color: Colors.grey.shade600, fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.settings,
                    color: Colors.black54,
                  ),
                ],
              ),
            ),
          ),
        ),
        extendBodyBehindAppBar: true,
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Container(
                  padding: const EdgeInsets.all(10),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                  ),
                  child: MessagesWidget(
                    idUser: widget.user.id,
                    onSwipedMessage: (message) {
                      replyToMessage(message);
                      focusNode.requestFocus();
                    },
                  ),
                ),
              ),
              NewMessageWidget(
                focusNode: focusNode,
                idUser: widget.user.id,
                onCancelReply: cancelReply,
                replyMessage: replyMessage, mangoUser: widget.user,
              )
            ],
          ),
        ),
      );

  void replyToMessage(Message message) {
    setState(() {
      replyMessage = message;
    });
  }

  void cancelReply() {
    setState(() {
      replyMessage = null;
    });
  }
}
