import 'package:cloud_firestore/cloud_firestore.dart';

class MangoPost {
  final String id;
  final String text;
  final List<dynamic> multiImage;
  final String postCreator;
  final String? image;
  final String? video;
  final String? originalID;
  final String? repliedPostID;
  final String? link;
  final String? replyTo;
  final String? linkType;
  final Timestamp? timeStamp;
  final bool repost;
  final bool multiMedia;
  final bool reply;
  final bool isLinked;
  int likeCount;
  int replyCount;
  int repostCount;

  MangoPost({required this.link, required this.video, required this.multiImage,  required this.multiMedia, required this.replyTo, required this.linkType, required this.isLinked, this.repliedPostID, required this.reply, required this.repost, this.originalID, required this.likeCount,  required this.replyCount, required this.repostCount,required this.text, required this.postCreator, required this.image, required this.timeStamp, required this.id});
}
