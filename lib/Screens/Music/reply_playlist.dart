import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:mango/Models/customModel/playlist.dart';

class MangoPlaylistComment {
  final String id;
  final String text;
  final String postCreator;
  final String? repliedCommentID;
  final Timestamp timeStamp;
  final bool repost;
  final bool reply;
  int likeCount;
  int replyCount;
  int repostCount;

  MangoPlaylistComment({
    required this.repliedCommentID,
    required this.reply,
    required this.repost,
    required this.likeCount,
    required this.replyCount,
    required this.repostCount,
    required this.text,
    required this.postCreator,
    required this.timeStamp,
    required this.id});
}
