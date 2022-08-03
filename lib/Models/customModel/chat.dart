import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

class ChatUsers {
  String name;
  String messageText;
  String imageURL;
  String time;
  ChatUsers(
      {required this.name,
      required this.messageText,
      required this.imageURL,
      required this.time});
}

class ChatMessage {
  String messageContent;
  String messageType;
  ChatMessage({required this.messageContent, required this.messageType});
}

class Message {
  final String receiver;
  final String sender;
  final String text;
  final String? replyMessage;
  final Timestamp timeStamp;
  Message({required this.receiver, required this.sender, required this.text, this.replyMessage, required this.timeStamp});
}
