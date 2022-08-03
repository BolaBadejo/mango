import 'package:cloud_firestore/cloud_firestore.dart';

class MangoLibrary {
  final String id;
  final String title;
  final String text;
  final String link;
  final String postCreator;
  final String author;
  final String image;
  final List<dynamic> tags;
  final Timestamp timeStamp;


  final String? repliedBookID;
  final String originalID;
  final bool repost;
  final bool reply;

  int repostCount;
  int replyCount;
  int likeCount;
  int reads;

  MangoLibrary({required this.repostCount, required this.reads, required this.tags, required this.replyCount, required this.likeCount, this.repliedBookID, required this.originalID, required this.repost, required this.reply, required this.author, required this.title, required this.text, required this.link, required this.postCreator, required this.image, required this.timeStamp, required this.id});
}