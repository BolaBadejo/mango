import 'package:cloud_firestore/cloud_firestore.dart';

class MangoPlaylist {
  final String id;
  final String title;
  final String text;
  final String link;
  final String postCreator;
  final String image;
  final Timestamp timeStamp;
  final String? repliedPlaylistID;
  final String originalID;
  final List<dynamic> tags;
  final bool repost;
  final bool reply;


  int replyCount;
  int likeCount;
  int plays;
  int repostCount;

  MangoPlaylist({required this.reply, this.repliedPlaylistID, required this.tags, required this.replyCount, required this.plays, required this.originalID, required this.repost, required this.repostCount, required this.likeCount, required this.title, required this.text, required this.link, required this.postCreator, required this.image, required this.timeStamp, required this.id});
}