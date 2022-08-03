import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/mang0_episodes.dart';
import 'package:mango/Models/customModel/post.dart';
import 'package:mango/Models/customModel/reply_books.dart';
import 'package:mango/Models/customModel/timeago.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Models/widgets.dart';
import 'package:mango/Screens/Auth/signin.dart';
import 'package:mango/Screens/Auth/signup.dart';
import 'package:mango/Screens/Music/web_viewer.dart';
import 'package:mango/Screens/PDFReader/widget/comment_book.dart';
import 'package:mango/Screens/Posts/reply_post.dart';
import 'package:mango/Screens/Posts/view_post.dart';
import 'package:mango/Services/photo_viewer.dart';
import 'package:provider/provider.dart';

import '../../Models/customModel/library.dart';
import '../Profile/profile.dart';

class LibraryCommentList extends StatefulWidget {
  final scrollController;
  final MangoLibrary mangoLibrary;
  const LibraryCommentList({Key? key, this.scrollController, required this.mangoLibrary}) : super(key: key);

  @override
  _LibraryCommentListState createState() => _LibraryCommentListState();
}

class _LibraryCommentListState extends State<LibraryCommentList> {
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      displayName: '',
      username: '',
      dob: '',
      id: '',
      password: '',
      gender: '',
      profileImage: '',
      email: '', fcmToken: '', verified: false);
  @override
  Widget build(BuildContext context) {
    final comments = Provider.of<List<MangoBookComment>>(context);
    return ListView.builder(
      controller: widget.scrollController,
      padding: MediaQuery.of(context).padding.copyWith(
        top: 0,
        left: 0,
        right: 0,
        bottom: 50,
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: comments.length,
      itemBuilder: (context, index) {
        final comment = comments[index];
        double actualTime = comment.timeStamp
            .toDate()
            .difference(DateTime.now())
            .inMinutes
            .toDouble();
        actualTime *= 1;
        String timeString = '';
        double apprTime = 0;
        if ((actualTime / 60) >= 0 && 24 > (actualTime / 60)) {
          apprTime = actualTime / 60;
          timeString = "$apprTime";
        } else if ((actualTime / 1440) >= 1 && 1000 > (actualTime / 1440)) {
          apprTime = actualTime / 1440;
          timeString = "$apprTime";
        }
        return mainPost(comment);
      },
    );
  }

  StreamBuilder<MangoUser?> mainPost(MangoBookComment? post) {
    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream: _userService.getUserInfo(post!.postCreator),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          return PostItem(
            post: post,
            postService: _postService,
            snapshot: snapshot,
          );
        });
  }
}

class PostItem extends StatefulWidget {
  const PostItem({
    Key? key,
    required this.post,
    required this.snapshot,
    required PostService postService,
  })  : _postService = postService,
        super(key: key);

  final MangoBookComment post;
  final AsyncSnapshot<MangoUser?> snapshot;
  final PostService _postService;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  @override
  Widget build(BuildContext context) {
    if (!widget.snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return !widget.post.repost
        ? Container(
          padding: const EdgeInsets.symmetric(vertical: 5),
          margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(15)),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              widget.post.repost ? Row(
                children: const [
                  Icon(
                    Icons.repeat,
                    color: Colors.grey,
                    size: 15,
                  ),
                  Text('reposted', style: TextStyle(
                    color: Colors.grey,
                    fontSize: 15,
                  ),),
                ],
              ) : Container(),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                    onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(userId: widget.snapshot.data!.id))),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundColor: Colors.white,
                          radius: 18.0,
                          backgroundImage: NetworkImage(
                            widget.snapshot.data?.profileImage ?? '',
                          ),
                        ),
                        const SizedBox(
                          width: 10,
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text(
                                  widget.snapshot.data?.displayName ?? '',
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                                widget.snapshot.data!.verified ? const Padding(
                                  padding: EdgeInsets.only(
                                      left:
                                      2.0),
                                  child:
                                  Icon(
                                    Icons
                                        .verified,
                                    size:
                                    14,
                                  ),
                                ) : Container(),
                              ],
                            ),
                            Text(
                              '@ ${widget.snapshot.data?.username}',
                              style: const TextStyle(
                                color: Colors.grey,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  Theme(
                    data: Theme.of(context).copyWith(
                        textTheme:
                        TextTheme().apply(bodyColor: Colors.black),
                        dividerColor: Colors.white,
                        iconTheme:
                        const IconThemeData(color: Colors.black)),
                    child: PopupMenuButton<int>(
                      color: Colors.black,
                      itemBuilder: (context) => [
                        const PopupMenuItem<int>(
                            value: 0, child: Text("view")),
                        const PopupMenuItem<int>(
                            value: 1, child: Text("Share")),
                        PopupMenuItem<int>(
                            value: 2,
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.delete_forever,
                                  color: Colors.orange,
                                ),
                                SizedBox(
                                  width: 7,
                                ),
                                Text("Delete")
                              ],
                            )),
                      ],
                      onSelected: (item) => SelectedItem(context, item),
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Text(
                widget.post.text,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                ),
                maxLines: 6,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(
                height: 15,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    // timeString,
                    timeAgo(widget.post.timeStamp.toDate()),
                    // "${post.timeStamp.toDate().difference(DateTime.now()).inMinutes.toString()} minutes ago",
                    style: const TextStyle(
                        color: Colors.blueGrey, fontSize: 12),
                  ),
                  Row(
                    children: [
                      StreamBuilder<bool?>(
                          initialData: null,
                          stream: widget._postService
                              .hasLikedPost(widget.post.id),
                          builder: (BuildContext context,
                              AsyncSnapshot<bool?> snapshot) {
                            if (snapshot.data == true) {
                              return InkWell(
                                  onTap: () {
                                    widget._postService
                                        .unlikePost(widget.post.id);
                                  },
                                  child: const Icon(
                                    Icons.favorite,
                                    color: Colors.deepOrange,
                                    size: 20,
                                  ));
                            }
                            return InkWell(
                                onTap: () async {
                                  widget._postService
                                      .likeBook(widget.post.id, widget.post.postCreator);
                                },
                                child: const Icon(
                                  Icons.favorite_border,
                                  color: Colors.grey,
                                  size: 20,
                                ));
                          }),
                      // InkWell(
                      //     onTap: () async {
                      //       final post = widget.post;
                      //       showModalBottomSheet(
                      //           backgroundColor: Colors.transparent,
                      //           isScrollControlled: true,
                      //           context: context,
                      //           builder: (context) => CommentBook(
                      //             mangoLibrary: post,
                      //           ));
                      //     },
                      //     child: Icon(
                      //       Icons.message_outlined,
                      //       color: widget.post.repost
                      //           ? Colors.lightGreen
                      //           : Colors.grey,
                      //       size: 20,
                      //     ))
                    ],
                  )
                ],
              )
            ],
          ),
        )
        : FutureBuilder(
        future: widget._postService.getBookCommentById(widget.post.repliedCommentID),
        builder:
            (BuildContext context, AsyncSnapshot<MangoPost?> snapshotPost) {
          if (!snapshotPost.hasData) {
            return Container();
          } else {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin:
              const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  widget.post.repost ? Row(
                    children: const [
                      Icon(
                        Icons.repeat,
                        color: Colors.grey,
                        size: 15,
                      ),
                      Text('reposted', style: TextStyle(
                        color: Colors.grey,
                        fontSize: 15,
                      ),),
                    ],
                  ) : Container(),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: ()=> Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(userId: widget.snapshot.data!.id))),
                        child: Row(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.white,
                              radius: 18.0,
                              backgroundImage: NetworkImage(
                                widget.snapshot.data?.profileImage ?? '',
                              ),
                            ),
                            const SizedBox(
                              width: 10,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      widget.snapshot.data?.displayName ?? '',
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    widget.snapshot.data!.verified ? const Padding(
                                      padding: EdgeInsets.only(
                                          left:
                                          2.0),
                                      child:
                                      Icon(
                                        Icons
                                            .verified,
                                        size:
                                        14,
                                      ),
                                    ) : Container(),
                                  ],
                                ),
                                Text(
                                  '@ ${widget.snapshot.data?.username}',
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 13,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Theme(
                        data: Theme.of(context).copyWith(
                            textTheme: TextTheme()
                                .apply(bodyColor: Colors.black),
                            dividerColor: Colors.white,
                            iconTheme:
                            const IconThemeData(color: Colors.black)),
                        child: PopupMenuButton<int>(
                          color: Colors.black,
                          itemBuilder: (context) => [
                            const PopupMenuItem<int>(
                                value: 0, child: Text("view")),
                            const PopupMenuItem<int>(
                                value: 1, child: Text("Share")),
                            PopupMenuItem<int>(
                                value: 2,
                                child: Row(
                                  children: const [
                                    Icon(
                                      Icons.delete_forever,
                                      color: Colors.orange,
                                    ),
                                    SizedBox(
                                      width: 7,
                                    ),
                                    Text("Delete")
                                  ],
                                )),
                          ],
                          onSelected: (item) =>
                              SelectedItem(context, item),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Text(
                    snapshotPost.data!.text,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  GestureDetector(
                    onTap: () {
                      showModalBottomSheet(
                          backgroundColor: Colors.transparent,
                          isScrollControlled: true,
                          context: context,
                          builder: (context) => PhotoViewer(
                            post: widget.post, username: widget.snapshot.data?.username,
                          ));
                    },
                    child: snapshotPost.data!.image! == null
                        ? Container()
                        : CachedNetworkImage(
                      height: 200,
                      imageUrl: snapshotPost.data!.image!,
                      imageBuilder: (context, imageProvider) =>
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              image: DecorationImage(
                                image: imageProvider,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                      placeholder: (context, url) => Container(
                        height: 200,
                        child: Center(
                            child: Icon(
                              Icons.image,
                              size: 80,
                              color: Colors.grey.withOpacity(0.3),
                            )),
                      ),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        // timeString,
                        timeAgo(snapshotPost.data!.timeStamp!.toDate()),
                        // "${post.timeStamp.toDate().difference(DateTime.now()).inMinutes.toString()} minutes ago",
                        style: const TextStyle(
                            color: Colors.blueGrey, fontSize: 12),
                      ),
                      Row(
                        children: [
                          StreamBuilder<bool?>(
                              initialData: null,
                              stream: widget._postService
                                  .hasLikedPost(snapshotPost.data!.id),
                              builder: (BuildContext context,
                                  AsyncSnapshot<bool?> snapshot) {
                                if (snapshot.data == true) {
                                  return InkWell(
                                      onTap: () {
                                        widget._postService.unlikePost(
                                            snapshotPost.data!.id);
                                      },
                                      child: const Icon(
                                        Icons.favorite,
                                        color: Colors.deepOrange,
                                        size: 20,
                                      ));
                                }
                                return InkWell(
                                    onTap: () async {
                                      widget._postService.likeBook(
                                          snapshotPost.data!.id, snapshotPost.data!.postCreator);
                                    },
                                    child: const Icon(
                                      Icons.favorite_border,
                                      color: Colors.grey,
                                      size: 20,
                                    ));
                              }),
                          // const SizedBox(
                          //   width: 10,
                          // ),
                          // InkWell(
                          //     onTap: () async {
                          //       widget._postService.repostPost(
                          //           snapshotPost.data!,
                          //           widget.post.repost);
                          //     },
                          //     child: Icon(
                          //       Icons.repeat,
                          //       color: widget.post.repost
                          //           ? Colors.lightGreen
                          //           : Colors.grey,
                          //       size: 20,
                          //     )),
                          const SizedBox(
                            width: 10,
                          ),
                          // InkWell(
                          //     onTap: () async {
                          //       final post = widget.post;
                          //       showModalBottomSheet(
                          //           backgroundColor: Colors.white,
                          //           isScrollControlled: true,
                          //           context: context,
                          //           builder: (context) => CommentBook(
                          //             mangoLibrary: post,
                          //           ));
                          //     },
                          //     child: Icon(
                          //       Icons.message_outlined,
                          //       color: widget.post.repost
                          //           ? Colors.lightGreen
                          //           : Colors.grey,
                          //       size: 20,
                          //     ))
                        ],
                      )
                    ],
                  )
                ],
              ),
            );
          }
        });
  }
}

void SelectedItem(BuildContext context, item) {
  switch (item) {
    case 0:
      Navigator.of(context)
          .push(MaterialPageRoute(builder: (context) => const SignUpPage()));
      break;
    case 1:
      print("Privacy Clicked");
      break;
    case 2:
      print("User Logged out");
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const LoginPage()),
              (route) => false);
      break;
  }
}
