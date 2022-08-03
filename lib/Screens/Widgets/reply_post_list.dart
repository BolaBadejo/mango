import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/post.dart';
import 'package:mango/Models/customModel/timeago.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Models/widgets.dart';

import 'package:markdown/markdown.dart' as md;
import 'package:mango/Screens/Posts/reply_post.dart';
import 'package:mango/Screens/Posts/view_post.dart';
import 'package:mango/Services/photo_viewer.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../Models/customModel/library.dart';
import '../../Models/customModel/playlist.dart';
import '../../Services/shimmer_widget.dart';
import '../Music/playlist_page.dart';
import '../PDFReader/bookDetail.dart';
import '../Posts/Widgets/video_widget.dart';
import '../Profile/profile.dart';
import 'listPost.dart';

class PostReplyList extends StatefulWidget {
  final scrollController;
  const PostReplyList({Key? key, this.scrollController}) : super(key: key);

  @override
  _PostReplyListState createState() => _PostReplyListState();
}

class _PostReplyListState extends State<PostReplyList> {
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      username: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      id: '',
      password: '',
      dob: '',
      gender: '',
      profileImage: '',
      email: '',
      fcmToken: '',
      verified: false);
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<MangoPost>>(context);
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
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        double actualTime = post.timeStamp!
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
        return mainPost(post);
      },
    );
  }

  StreamBuilder<MangoUser?> mainPost(MangoPost? post) {
    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream: _userService.getUserInfo(post!.postCreator),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          return PostItem(
            post: post,
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
  }) : super(key: key);

  final MangoPost post;
  final AsyncSnapshot<MangoUser?> snapshot;

  @override
  State<PostItem> createState() => _PostItemState();
}

class _PostItemState extends State<PostItem> {
  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      username: '',
      id: '',
      password: '',
      dob: '',
      gender: '',
      profileImage: '',
      email: '',
      fcmToken: '',
      verified: false);
  final MangoPlaylist _playlist = MangoPlaylist(
      reply: false,
      replyCount: 0,
      originalID: '',
      repost: false,
      repostCount: 0,
      likeCount: 0,
      plays: 0,
      title: '',
      text: '',
      link: '',
      postCreator: '',
      image: '',
      timeStamp: Timestamp.fromMillisecondsSinceEpoch(3),
      id: '',
      tags: []);

  final MangoLibrary _library = MangoLibrary(
      reply: false,
      replyCount: 0,
      originalID: '',
      repost: false,
      repostCount: 0,
      likeCount: 0,
      title: '',
      text: '',
      link: '',
      postCreator: '',
      image: '',
      timeStamp: Timestamp.fromMillisecondsSinceEpoch(3),
      id: '',
      author: '',
      reads: 0,
      tags: []);

  @override
  Widget build(BuildContext context) {
    if (!widget.snapshot.hasData) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }
    return GestureDetector(
      onTap: () {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => ViewPost(
                      post: widget.post,
                      user: widget.snapshot.data,
                    )));
      },
      child: StreamBuilder<MangoUser?>(
          initialData: _user,
          stream: UserService().getUserInfo(widget.post.postCreator),
          builder: (BuildContext context,
              AsyncSnapshot<MangoUser?> receiverSnapshot) {
            String token = receiverSnapshot.data!.fcmToken;
            if (!receiverSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 5),
              margin: const EdgeInsets.only(left: 15, right: 15, bottom: 10),
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                ProfilePage(userId: receiverSnapshot.data!.id),
                          ),
                        ),
                        child: Row(
                          children: [
                            CachedNetworkImage(
                              height: 38,
                              imageUrl: receiverSnapshot.data!.profileImage,
                              imageBuilder: (context, imageProvider) =>
                                  Material(
                                borderRadius: BorderRadius.circular(50),
                                elevation: 1,
                                child: CircleAvatar(
                                  backgroundImage: imageProvider,
                                  radius: 18,
                                ),
                              ),
                              placeholder: (context, url) =>
                                  const ShimmerWidget.circular(
                                      width: 36, height: 36),
                              errorWidget: (context, url, error) =>
                                  const Icon(Icons.error),
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
                                      receiverSnapshot.data!.displayName,
                                      style: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w800,
                                      ),
                                    ),
                                    receiverSnapshot.data!.verified
                                        ? const Padding(
                                            padding: EdgeInsets.only(left: 2.0),
                                            child: Icon(
                                              Icons.verified,
                                              size: 14,
                                            ),
                                          )
                                        : Container(),
                                  ],
                                ),
                                Text(
                                  '@${receiverSnapshot.data!.username}',
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
                            textTheme: const TextTheme()
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
                          onSelected: (item) => selectedItem(context, item),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  StreamBuilder<MangoUser?>(
                      initialData: _user,
                      stream: UserService()
                          .getUserInfo(FirebaseAuth.instance.currentUser!.uid),
                      builder: (BuildContext context,
                          AsyncSnapshot<MangoUser?> senderMeSnapshot) {
                        if (!senderMeSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return FutureBuilder<List>(
                            initialData: const [],
                            future: UserService().getAllUserName(),
                            builder: (BuildContext context,
                                AsyncSnapshot<List> usernamesSnapshot) {
                              if (!usernamesSnapshot.hasData) {
                                print("check 2");
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return MarkdownBody(
                                data: _replaceMentions(widget.post.text,
                                        usernamesSnapshot.data!)
                                    .replaceAll('\n', '\\\n'),
                                onTapLink: (
                                  String? link,
                                  String? href,
                                  String title,
                                ) {
                                  print('Link clicked with $link');
                                },
                                builders: {
                                  "coloredBox":
                                      ColoredBoxMarkdownElementBuilder(
                                          context,
                                          usernamesSnapshot.data!,
                                          senderMeSnapshot.data!.username),
                                },
                                inlineSyntaxes: [
                                  ColoredBoxInlineSyntax(),
                                ],
                                styleSheet: MarkdownStyleSheet.fromTheme(
                                  Theme.of(context).copyWith(
                                    textTheme:
                                        Theme.of(context).textTheme.apply(
                                              bodyColor: Colors.black,
                                              fontSizeFactor: 1,
                                            ),
                                  ),
                                ),
                              );
                            });
                      }),
                  // Text(
                  //   widget.post.text,
                  //   style: const TextStyle(
                  //     fontSize: 14,
                  //     fontWeight: FontWeight.w700,
                  //   ),
                  //   maxLines: 6,
                  //   overflow: TextOverflow.ellipsis,
                  // ),
                  const SizedBox(
                    height: 10,
                  ),
                  widget.post.video!.isNotEmpty
                      ?
                      // VideoWebWidget(file: widget.post.video)
                      Container(
                          height: 400,
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          child: Stack(
                              fit: StackFit.expand,
                              clipBehavior: Clip.hardEdge,
                              alignment: Alignment.center,
                              children: <Widget>[
                                Positioned(
                                    left: 0,
                                    right: 0,
                                    child: VideoPostWidget(widget.post.video!)),
                                Positioned(
                                  right: 2,
                                  bottom: 5,
                                  child: IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => Scaffold(
                                                    extendBodyBehindAppBar:
                                                        true,
                                                    appBar: AppBar(
                                                      backgroundColor:
                                                          Colors.transparent,
                                                      shadowColor:
                                                          Colors.transparent,
                                                      leading:
                                                          const CloseButton(),
                                                    ),
                                                    body: Center(
                                                        child: VideoPostWidget(
                                                            widget.post
                                                                .video!)))));
                                      },
                                      icon: const Icon(
                                        Icons.fullscreen,
                                        color: Colors.white,
                                      )),
                                )
                              ]))
                      : widget.post.multiImage != null
                          ? SizedBox(
                              height: 200,
                              width: MediaQuery.of(context).size.width,
                              child: ListView.builder(
                                physics: const BouncingScrollPhysics(),
                                itemCount: widget.post.multiImage.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Padding(
                                    padding: const EdgeInsets.only(right: 15.0),
                                    child: CachedNetworkImage(
                                      height: 180,
                                      width: MediaQuery.of(context).size.width /
                                          1.2,
                                      imageUrl: widget.post.multiImage[index],
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: Icon(
                                          Icons.image,
                                          size: 80,
                                          color: Colors.grey.withOpacity(0.3),
                                        )),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: Icon(
                                          Icons.error,
                                          size: 80,
                                          color: Colors.grey.withOpacity(0.3),
                                        )),
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                          : GestureDetector(
                              onTap: () {
                                showModalBottomSheet(
                                    backgroundColor: Colors.transparent,
                                    isScrollControlled: true,
                                    context: context,
                                    builder: (context) => PhotoViewer(
                                          post: widget.post,
                                          username:
                                              receiverSnapshot.data!.username,
                                        ));
                                // Navigator.push(
                                //     context,
                                //     MaterialPageRoute(
                                //         builder: (context) => PhotoViewer(
                                //               post: widget.post,
                                //             )));
                              },
                              child: widget.post.image!.isEmpty
                                  ? Container()
                                  : CachedNetworkImage(
                                      height: 200,
                                      imageUrl: widget.post.image!,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                        decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          image: DecorationImage(
                                            image: imageProvider,
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                      placeholder: (context, url) => SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: Icon(
                                          Icons.image,
                                          size: 80,
                                          color: Colors.grey.withOpacity(0.3),
                                        )),
                                      ),
                                      errorWidget: (context, url, error) =>
                                          SizedBox(
                                        height: 200,
                                        child: Center(
                                            child: Icon(
                                          Icons.error,
                                          size: 80,
                                          color: Colors.grey.withOpacity(0.3),
                                        )),
                                      ),
                                    ),
                            ),
                  widget.post.linkType == 'Book'
                      ? widget.post.isLinked == true
                          ? StreamBuilder<MangoLibrary?>(
                              initialData: _library,
                              stream: PostService()
                                  .getBookWithId(widget.post.link!),
                              builder: (BuildContext context,
                                  AsyncSnapshot<MangoLibrary?>
                                      playListSnapshot) {
                                if (!playListSnapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                }
                                return GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => BookDetail(
                                                mangoLibrary:
                                                    playListSnapshot.data!)));
                                  },
                                  child: Container(
                                    width: MediaQuery.of(context).size.width,
                                    height: 80,
                                    margin: const EdgeInsets.only(
                                        left: 0, right: 0, bottom: 10, top: 10),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(10),
                                        color: Colors.black),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              top: 10.0,
                                              bottom: 10.0,
                                              left: 10,
                                              right: 15),
                                          child: CachedNetworkImage(
                                            height: 60,
                                            width: 45,
                                            imageUrl:
                                                playListSnapshot.data!.image,
                                            imageBuilder:
                                                (context, imageProvider) =>
                                                    Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(5),
                                                image: DecorationImage(
                                                  image: imageProvider,
                                                  fit: BoxFit.cover,
                                                ),
                                              ),
                                            ),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget
                                                        .rectangularCircular(
                                                    width: 80, height: 80),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                        ),
                                        Expanded(
                                          child: Padding(
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 20),
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Text(
                                                  playListSnapshot.data!.title,
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                                const SizedBox(
                                                  height: 5,
                                                ),
                                                Text(
                                                  playListSnapshot.data?.text ??
                                                      '',
                                                  style: const TextStyle(
                                                    color: Colors.grey,
                                                    fontSize: 10,
                                                    fontWeight: FontWeight.w700,
                                                  ),
                                                  maxLines: 2,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 15.0),
                                          child: Container(
                                            padding: const EdgeInsets.only(
                                                left: 8,
                                                right: 8,
                                                top: 2,
                                                bottom: 2),
                                            height: 30,
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(30),
                                              color: Colors.white,
                                            ),
                                            child: Row(
                                              children: const <Widget>[
                                                Text(
                                                  "Read",
                                                  style: TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                                SizedBox(
                                                  width: 5,
                                                ),
                                                Icon(
                                                  Icons.open_in_new,
                                                  color: Colors.orange,
                                                  size: 15,
                                                ),
                                              ],
                                            ),
                                          ),
                                        )
                                        // Expanded(
                                        //     flex: 1,
                                        //     child: IconButton(
                                        //       color: Colors.white,
                                        //       onPressed: () {
                                        //         setState(() {
                                        //           // selectedType = null;
                                        //           // selectedLink = null;
                                        //           // selected = false;
                                        //         });
                                        //       }, icon: Icon(Icons.view_agenda_outlined),
                                        //     )
                                        // )
                                      ],
                                    ),
                                  ),
                                );
                              })
                          : Container()
                      : widget.post.linkType == 'Playlist'
                          ? widget.post.isLinked == true
                              ? StreamBuilder<MangoPlaylist?>(
                                  initialData: _playlist,
                                  stream: PostService()
                                      .getPlaylistWithId(widget.post.link!),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<MangoPlaylist?>
                                          playListSnapshot) {
                                    if (!playListSnapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return GestureDetector(
                                      onTap: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    PlaylistPage(
                                                        mangoPost:
                                                            playListSnapshot
                                                                .data!)));
                                      },
                                      child: Container(
                                        width:
                                            MediaQuery.of(context).size.width,
                                        height: 80,
                                        margin: const EdgeInsets.only(
                                            left: 0,
                                            right: 0,
                                            bottom: 10,
                                            top: 10),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  top: 10.0,
                                                  bottom: 10.0,
                                                  left: 10,
                                                  right: 15),
                                              child: CachedNetworkImage(
                                                height: 60,
                                                width: 60,
                                                imageUrl: playListSnapshot
                                                    .data!.image,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            5),
                                                    image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover,
                                                    ),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const ShimmerWidget
                                                            .rectangularCircular(
                                                        width: 80, height: 80),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            Expanded(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      playListSnapshot
                                                          .data!.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      playListSnapshot
                                                              .data?.text ??
                                                          '',
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 10,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                      maxLines: 2,
                                                      overflow:
                                                          TextOverflow.ellipsis,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 15.0),
                                              child: Container(
                                                padding: const EdgeInsets.only(
                                                    left: 8,
                                                    right: 8,
                                                    top: 2,
                                                    bottom: 2),
                                                height: 30,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                  color: Colors.white,
                                                ),
                                                child: Row(
                                                  children: const <Widget>[
                                                    Text(
                                                      "Play",
                                                      style: TextStyle(
                                                          fontSize: 14,
                                                          fontWeight:
                                                              FontWeight.bold),
                                                    ),
                                                    SizedBox(
                                                      width: 5,
                                                    ),
                                                    Icon(
                                                      Icons.play_arrow_rounded,
                                                      color: Colors.orange,
                                                      size: 20,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            )
                                            // Expanded(
                                            //     flex: 1,
                                            //     child: IconButton(
                                            //       color: Colors.white,
                                            //       onPressed: () {
                                            //         setState(() {
                                            //           // selectedType = null;
                                            //           // selectedLink = null;
                                            //           // selected = false;
                                            //         });
                                            //       }, icon: Icon(Icons.view_agenda_outlined),
                                            //     )
                                            // )
                                          ],
                                        ),
                                      ),
                                    );
                                  })
                              : Container()
                          : Container(),
                  widget.post.isLinked == true
                      ? Container()
                      : const SizedBox(
                          height: 15,
                        ),
                  StreamBuilder<MangoUser?>(
                      initialData: _user,
                      stream:
                          UserService().getUserInfo(widget.post.postCreator),
                      builder: (BuildContext context,
                          AsyncSnapshot<MangoUser?> receiverSnapshot) {
                        if (!receiverSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              // timeString,
                              timeAgo(widget.post.timeStamp!.toDate()),
                              // "${post.timeStamp.toDate().difference(DateTime.now()).inMinutes.toString()} minutes ago",
                              style: const TextStyle(
                                  color: Colors.blueGrey, fontSize: 12),
                            ),
                            Row(
                              children: [
                                StreamBuilder<MangoUser?>(
                                    initialData: _user,
                                    stream: UserService().getUserInfo(
                                        FirebaseAuth.instance.currentUser!.uid),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<MangoUser?>
                                            senderSnapshot) {
                                      if (!senderSnapshot.hasData) {
                                        return const Center(
                                          child: CircularProgressIndicator(),
                                        );
                                      }
                                      return StreamBuilder<bool?>(
                                          initialData: null,
                                          stream: PostService()
                                              .hasLikedPost(widget.post.id),
                                          builder: (BuildContext context,
                                              AsyncSnapshot<bool?> snapshot) {
                                            if (snapshot.data == true) {
                                              return InkWell(
                                                  onTap: () {
                                                    PostService().unlikePost(
                                                        widget.post.id);
                                                  },
                                                  child: const Icon(
                                                    Icons.favorite,
                                                    color: Colors.deepOrange,
                                                    size: 20,
                                                  ));
                                            }
                                            return InkWell(
                                                onTap: () async {
                                                  PostService().likePost(
                                                      widget.post.id,
                                                      widget.post.postCreator);
                                                  UserService().sendNotification(
                                                      widget.post,
                                                      'post',
                                                      "@${senderSnapshot.data!.username} just liked your post",
                                                      "New Interaction",
                                                      widget.post.postCreator,
                                                      receiverSnapshot
                                                          .data!.fcmToken);
                                                },
                                                child: const Icon(
                                                  Icons.favorite_border,
                                                  color: Colors.grey,
                                                  size: 20,
                                                ));
                                          });
                                    }),
                                const SizedBox(
                                  width: 10,
                                ),
                                // StreamBuilder<bool?>(
                                //     initialData: null,
                                //     stream: widget._postService
                                //         .hasRepostedPost(widget.post),
                                //     builder: (BuildContext context,
                                //         AsyncSnapshot<bool?> snapshot) {
                                //       if (snapshot.data == true) {
                                //         return InkWell(
                                //             onTap: () {
                                //               widget._postService.unrepostPost(
                                //                   widget.post, widget.post.repost);
                                //             },
                                //             child: const Icon(
                                //               Icons.refresh,
                                //               color: Colors.lightGreen,
                                //               size: 20,
                                //             ));
                                //       }
                                //       return InkWell(
                                //           onTap: () async {
                                //             widget._postService.repostPost(
                                //                 widget.post, widget.post.repost);
                                //             UserService().sendNotification("@${senderSnapshot.data!.username} just reposted your post", "New Interaction", widget.post.postCreator, receiverSnapshot.data!.fcmToken);
                                //              },
                                //           child: const Icon(
                                //             Icons.refresh,
                                //             color: Colors.grey,
                                //             size: 20,
                                //           ));
                                //     }),
                                // const SizedBox(
                                //   width: 10,
                                // ),
                                StreamBuilder<bool?>(
                                    initialData: null,
                                    stream: PostService()
                                        .hasCommentedOnPost(widget.post.id),
                                    builder: (BuildContext context,
                                        AsyncSnapshot<bool?> snapshot) {
                                      if (snapshot.data == true) {
                                        return InkWell(
                                            onTap: () async {
                                              final post = widget.post;
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                      Colors.transparent,
                                                  isScrollControlled: true,
                                                  context: context,
                                                  builder: (context) =>
                                                      ReplyMessage(
                                                        post: post,
                                                      ));
                                            },
                                            child: const Icon(
                                              Icons.message_outlined,
                                              color: Colors.lightGreen,
                                              size: 20,
                                            ));
                                      }
                                      return InkWell(
                                          onTap: () async {
                                            final post = widget.post;
                                            showModalBottomSheet(
                                                backgroundColor:
                                                    Colors.transparent,
                                                isScrollControlled: true,
                                                context: context,
                                                builder: (context) =>
                                                    ReplyMessage(
                                                      post: post,
                                                    ));
                                          },
                                          child: const Icon(
                                            Icons.message_outlined,
                                            color: Colors.grey,
                                            size: 20,
                                          ));
                                    }),
                              ],
                            )
                          ],
                        );
                      })
                ],
              ),
            );
          }),
    );
  }
}

///Wrapping mentioned users with brackets to identify them easily
String _replaceMentions(String text, List usernames) {
  usernames.map((u) => u).toSet().forEach((userName) {
    text = text.replaceAll('@$userName', '[@$userName]');
  });
  return text;
}

class ColoredBoxInlineSyntax extends md.InlineSyntax {
  ColoredBoxInlineSyntax({
    String pattern = r'\[(.*?)\]',
  }) : super(pattern);

  @override
  bool onMatch(md.InlineParser parser, Match match) {
    /// This creates a new element with the tag name `coloredBox`
    /// The `textContent` of this new tag will be the
    /// pattern match with the @ symbol
    ///
    /// We can change how this looks by creating a custom
    /// [MarkdownElementBuilder] from the `flutter_markdown` package.
    final withoutBracket1 = match.group(0)?.replaceAll('[', "");
    final withoutBracket2 = withoutBracket1?.replaceAll(']', "");
    md.Element mentionedElement =
        md.Element.text("coloredBox", withoutBracket2!);
    print('Mentioned user ${mentionedElement.textContent}');
    parser.addNode(mentionedElement);
    return true;
  }
}

class ColoredBoxMarkdownElementBuilder extends MarkdownElementBuilder {
  final BuildContext context;
  final List mentionedUsers;
  final String myName;

  ColoredBoxMarkdownElementBuilder(
      this.context, this.mentionedUsers, this.myName);

  ///This method would help us figure out if the text element needs styling
  ///The background color of the text would be Color(0xffDCECF9) if it is the
  ///sender's name that is mentioned in the text, otherwise it would be transparent
  Color _backgroundColorForElement(String text) {
    Color color = Colors.transparent;
    if (mentionedUsers.contains(myName) && text.contains(myName)) {
      color = const Color(0xfffae7d9);
    } else {
      color = Colors.transparent;
    }
    return color;
  }

  ///This method would help us figure out if the text element needs styling
  ///The text color would be blue if the text is a user's name and is mentioned
  ///in the text _topboy_hq
  Color _textColorForBackground(Color backgroundColor, String textContent) {
    return checkIfFormattingNeeded(textContent) ? Colors.orange : Colors.black;
  }

  @override
  Widget visitElementAfter(md.Element element, TextStyle? preferredStyle) {
    return FutureBuilder<List<MangoUser>>(
        initialData: const <MangoUser>[],
        future: UserService().getUserbyUsername(element.textContent),
        builder: (BuildContext context,
            AsyncSnapshot<List<MangoUser>> usernameIdentity) {
          print(element.textContent);
          if (!usernameIdentity.hasData) {
            return Container();
          }
          return InkWell(
            onTap: () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) =>
                        ProfilePage(userId: usernameIdentity.data![0].id))),
            child: Container(
              margin:
                  const EdgeInsets.only(left: 0, right: 0, top: 2, bottom: 2),
              decoration: element.textContent.contains(myName)
                  ? BoxDecoration(
                      borderRadius:
                          const BorderRadius.all(Radius.circular(8.0)),
                      color: _backgroundColorForElement(element.textContent),
                    )
                  : null,
              child: Padding(
                padding: element.textContent.contains(myName)
                    ? EdgeInsets.all(4.0)
                    : EdgeInsets.all(0),
                child: Text(
                  element.textContent,
                  style: TextStyle(
                    color: _textColorForBackground(
                      _backgroundColorForElement(
                        element.textContent.replaceAll('@', ''),
                      ),
                      element.textContent.replaceAll('@', ''),
                    ),
                    fontWeight: checkIfFormattingNeeded(
                      element.textContent.replaceAll('@', ''),
                    )
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            ),
          );
        });
  }

  bool checkIfFormattingNeeded(String text) {
    var checkIfFormattingNeeded = false;
    if (mentionedUsers.isNotEmpty) {
      if (mentionedUsers.contains(text) || mentionedUsers.contains(myName)) {
        checkIfFormattingNeeded = true;
      } else {
        checkIfFormattingNeeded = false;
      }
    }
    return checkIfFormattingNeeded;
  }
}

void SelectedItem(BuildContext context, item) {
  switch (item) {
    case 0:
      // Navigator.of(context)
      //     .push(MaterialPageRoute(builder: (context) => const SignUpPage()));
      break;
    case 1:
      print("Post Shared Clicked");
      Share.share(
          'Check out this post on Mango. \n \n get the android app here \n http://tiny.cc/qhssuz',
          subject: "New Post On Mango");
      break;
    case 2:
      print("User Logged out");
      // Navigator.of(context).pushAndRemoveUntil(
      //     MaterialPageRoute(builder: (context) => const LoginPage()),
      //     (route) => false);
      break;
  }
}
