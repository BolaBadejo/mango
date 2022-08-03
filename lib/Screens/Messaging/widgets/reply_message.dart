import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/chat.dart';

import '../../../Models/customModel/user.dart';

class ReplyMessageWidget extends StatelessWidget {
  Message? message;
  VoidCallback? onCancelReply;

  ReplyMessageWidget( {
    this.message, this.onCancelReply,
    Key? key,
  }) : super(key: key);

  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      username: '',
      dob: '',
      id: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      password: '',
      gender: '',
      profileImage: '',
      email: '',
      fcmToken: '',
      verified: false);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      children: [
        Container(
          color: Colors.green,
          width: 4,
        ),
        const SizedBox(width: 8),
        Expanded(child: buildReplyMessage()),
      ],
    ),
  );

  Widget buildReplyMessage() => StreamBuilder<MangoUser?>(
      initialData: _user,
      stream: UserService().getUserInfo(message?.sender),
      builder:
          (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  '@${snapshot.data!.username}',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              if (onCancelReply != null)
                GestureDetector(
                  child: Icon(Icons.close, size: 16),
                  onTap: onCancelReply,
                )
            ],
          ),
          const SizedBox(height: 8),
          Text(message!.text, style: TextStyle(color: Colors.black54)),
        ],
      );
    }
  );
}

class RepliedMessageWidget extends StatelessWidget {
  Message? message;
  VoidCallback? onCancelReply;

  RepliedMessageWidget( {
    this.message, this.onCancelReply,
    Key? key,
  }) : super(key: key);

  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      username: '',
      dob: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      id: '',
      password: '',
      gender: '',
      profileImage: '',
      email: '',
      fcmToken: '',
      verified: false);

  @override
  Widget build(BuildContext context) => IntrinsicHeight(
    child: Row(
      children: [
        Container(
          color: Colors.green,
          width: 4,
        ),
        const SizedBox(width: 8),
        Expanded(child: buildReplyMessage()),
      ],
    ),
  );

  Widget buildReplyMessage() => StreamBuilder<MangoUser?>(
      initialData: _user,
      stream: UserService().getUserInfo(message?.sender),
      builder:
          (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      return Container(
        padding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          color: Colors.white
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                '@${snapshot.data!.username}',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
            ),
            const SizedBox(height: 8),
            Text(message!.replyMessage ?? '', style: TextStyle(color: Colors.black54)),
          ],
        ),
      );
    }
  );
}