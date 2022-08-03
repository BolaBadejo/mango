import 'package:audioplayers/audioplayers.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/playlist.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/Music/playlist_comment_list.dart';
import 'package:mango/Screens/Music/reply_playlist.dart';
import 'package:mango/Screens/Music/web_viewer.dart';
import 'package:mango/Screens/Profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../Services/shimmer_widget.dart';
import '../Posts/reply_post.dart';
import '../Tags/tags_page.dart';
import 'comment_playlist.dart';

class PlaylistPage extends StatefulWidget {
  final MangoPlaylist mangoPost;
  const PlaylistPage({Key? key, required this.mangoPost}) : super(key: key);

  @override
  _PlaylistPageState createState() => _PlaylistPageState();
}

class _PlaylistPageState extends State<PlaylistPage> {
  final PostService _postService = PostService();

  AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.MEDIA_PLAYER);
  bool isPlaying = false;
  String currentSong = '';
  void playMusic(String url) async {
    if (isPlaying && currentSong == url) {
      audioPlayer.pause();
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          currentSong = url;
        });
      }
    } else if (!isPlaying) {
      int result = await audioPlayer.play(url);
      if (result == 1) {
        setState(() {
          isPlaying = true;
        });
      }
    }
  }

  double currentSlider = 0;
  String currentTitle = '';
  String currentArtwork = '';
  String currentUrl = '';
  String currentArtist = '';
  IconData iconBtn = Icons.play_circle_fill;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    final UserService _userService = UserService();
    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        id: '',
        password: '',
        dob: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        gender: '',
        profileImage: '',
        email: '',
        fcmToken: '',
        verified: false);
    return MultiProvider(
      providers: [
        StreamProvider<bool>(
            create: (context) => _userService.isFollowing(
                FirebaseAuth.instance.currentUser!.uid,
                widget.mangoPost.postCreator),
            initialData: false),
      ],
      child: StreamBuilder<MangoUser?>(
          initialData: _user,
          stream:
              UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
          builder:
              (BuildContext context, AsyncSnapshot<MangoUser?> senderSnapshot) {
            if (!senderSnapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            }
            return Scaffold(
              backgroundColor: Colors.white,
              body: StreamBuilder<MangoUser?>(
                  initialData: _user,
                  stream:
                      UserService().getUserInfo(widget.mangoPost.postCreator),
                  builder: (BuildContext context,
                      AsyncSnapshot<MangoUser?> receiverSnapshot) {
                    String token = receiverSnapshot.data!.fcmToken;
                    if (!receiverSnapshot.hasData) {
                      return const Center(
                        child: CircularProgressIndicator(),
                      );
                    }
                    return Stack(
                      children: [
                        CustomScrollView(
                          slivers: [
                            SliverAppBar(
                              pinned: false,
                              leading: const CloseButton(
                                color: Colors.white,
                              ),
                              title: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.mangoPost.title,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 16,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    receiverSnapshot.data?.username ?? '',
                                    style: const TextStyle(
                                      color: Colors.grey,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w700,
                                    ),
                                  )
                                ],
                              ),
                              centerTitle: true,
                              expandedHeight: _height / 2.4,
                              stretch: true,
                              flexibleSpace: FlexibleSpaceBar(
                                // stretchModes: <StretchMode>[
                                //   StretchMode.zoomBackground
                                // ],
                                background: CachedNetworkImage(
                                  width: 300,
                                  imageUrl: widget.mangoPost.image,
                                  imageBuilder: (context, imageProvider) =>
                                      Stack(children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover)),
                                      child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 30,
                                            right: 30,
                                            bottom: 120,
                                            top: 130),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10),
                                            color: Colors.black),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: CachedNetworkImage(
                                                width: 300,
                                                imageUrl:
                                                    widget.mangoPost.image,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  margin: const EdgeInsets
                                                          .symmetric(
                                                      vertical: 20,
                                                      horizontal: 20),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const ShimmerWidget
                                                            .rectangularCircular(
                                                        width: 300,
                                                        height: 300),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        vertical: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.mangoPost.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 5,
                                                    ),
                                                    Text(
                                                      "@${receiverSnapshot.data?.username ?? ''}",
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w700,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    Row(
                                                      children: [
                                                        StreamBuilder<bool?>(
                                                            initialData: null,
                                                            stream: _postService
                                                                .hasLikedPlaylist(
                                                                    widget
                                                                        .mangoPost
                                                                        .id),
                                                            builder: (BuildContext
                                                                    context,
                                                                AsyncSnapshot<
                                                                        bool?>
                                                                    snapshot) {
                                                              if (snapshot
                                                                      .data ==
                                                                  true) {
                                                                return InkWell(
                                                                    onTap: () {
                                                                      _postService
                                                                          .unlikePlaylist(
                                                                              widget.mangoPost);
                                                                    },
                                                                    child:
                                                                        const Icon(
                                                                      Icons
                                                                          .favorite,
                                                                      color: Colors
                                                                          .deepOrange,
                                                                      size: 20,
                                                                    ));
                                                              }
                                                              return InkWell(
                                                                  onTap:
                                                                      () async {
                                                                    _postService
                                                                        .likePlaylist(
                                                                            widget.mangoPost);
                                                                    _userService.sendNotification(widget.mangoPost, 'playlist',
                                                                        "@${senderSnapshot.data!.username} just liked ${widget.mangoPost.title}",
                                                                        "New Interaction",
                                                                        widget
                                                                            .mangoPost
                                                                            .postCreator,
                                                                        token);
                                                                  },
                                                                  child:
                                                                      const Icon(
                                                                    Icons
                                                                        .favorite_border,
                                                                    color: Colors
                                                                        .grey,
                                                                    size: 20,
                                                                  ));
                                                            }),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                            onTap: () async {
                                                              Share.share(
                                                                  'Listen to ${widget.mangoPost.title} by @${receiverSnapshot.data!.username} on Mango. \n \n get the android app here \n http://tiny.cc/qhssuz',
                                                                  subject:
                                                                      "New Playlist On Mango");
                                                              // _postService.repostPlaylist(
                                                              //     widget.mangoPost, widget.mangoPost.repost);
                                                              // _userService.sendNotification("@${senderSnapshot.data!.username} just reposted ${widget.mangoPost.title}", "Repost Alert", widget.mangoPost.postCreator, token);
                                                            },
                                                            child: const Icon(
                                                              Icons.share,
                                                              color:
                                                                  Colors.grey,
                                                              size: 20,
                                                            )),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                            onTap: () async {
                                                              final mangoPost =
                                                                  widget
                                                                      .mangoPost;
                                                              showModalBottomSheet(
                                                                  backgroundColor: Colors
                                                                      .transparent,
                                                                  isScrollControlled:
                                                                      true,
                                                                  context:
                                                                      context,
                                                                  builder: (context) => CommentPlaylist(
                                                                      mangoPlaylist:
                                                                          mangoPost,
                                                                      userToken: receiverSnapshot
                                                                          .data!
                                                                          .fcmToken));
                                                            },
                                                            child: Icon(
                                                              Icons
                                                                  .message_outlined,
                                                              color: widget
                                                                      .mangoPost
                                                                      .repost
                                                                  ? Colors
                                                                      .lightGreen
                                                                  : Colors.grey,
                                                              size: 20,
                                                            ))
                                                      ],
                                                    )
                                                    // Row(
                                                    //   mainAxisSize: MainAxisSize.min,
                                                    //   children: [
                                                    //     StreamBuilder<bool?>(
                                                    //         initialData: null,
                                                    //         stream: _postService
                                                    //             .hasRepostedPlaylist(
                                                    //             widget
                                                    //                 .mangoPost.id),
                                                    //         builder: (BuildContext
                                                    //                 context,
                                                    //             AsyncSnapshot<bool?>
                                                    //                 snapshot) {
                                                    //           if (kDebugMode) {
                                                    //             print(snapshot.data);
                                                    //           }
                                                    //           if (snapshot.data == true) {
                                                    //             return InkWell(
                                                    //                 onTap: () {
                                                    //                   _postService
                                                    //                       .unrepostPlaylist(
                                                    //                       widget
                                                    //                           .mangoPost);
                                                    //                 },
                                                    //                 child: const Icon(
                                                    //                   Icons.recommend,
                                                    //                   color: Colors
                                                    //                       .greenAccent,
                                                    //                   size: 20,
                                                    //                 ));
                                                    //           }
                                                    //           return InkWell(
                                                    //               onTap: () async {
                                                    //                 _postService.repostPlaylist(
                                                    //                     widget
                                                    //                         .mangoPost,
                                                    //                     widget.mangoPost
                                                    //                         .postCreator ==
                                                    //                         FirebaseAuth
                                                    //                             .instance
                                                    //                             .currentUser!
                                                    //                             .uid);
                                                    //               },
                                                    //               child: const Icon(
                                                    //                 Icons.recommend,
                                                    //                 color: Colors.grey,
                                                    //                 size: 20,
                                                    //               ));
                                                    //         }),
                                                    //     const SizedBox(
                                                    //       width: 4,
                                                    //     ),
                                                    //     Provider.of<bool>(context)
                                                    //         ? InkWell(
                                                    //             onTap: () {
                                                    //               _postService
                                                    //                   .unlikePlaylist(
                                                    //                       widget
                                                    //                           .mangoPost);
                                                    //             },
                                                    //             child: const Icon(
                                                    //               Icons.favorite,
                                                    //               color: Colors
                                                    //                   .deepOrange,
                                                    //               size: 20,
                                                    //             ))
                                                    //         : InkWell(
                                                    //             onTap: () async {
                                                    //               _postService
                                                    //                   .likePlaylist(widget
                                                    //                       .mangoPost);
                                                    //             },
                                                    //             child: const Icon(
                                                    //               Icons
                                                    //                   .favorite_border,
                                                    //               color: Colors.grey,
                                                    //               size: 20,
                                                    //             )),
                                                    //     const SizedBox(
                                                    //       width: 2,
                                                    //     ),
                                                    //     LikeButton(
                                                    //       size: 20,
                                                    //       circleColor:
                                                    //           const CircleColor(
                                                    //               start: Colors
                                                    //                   .orangeAccent,
                                                    //               end: Colors.orange),
                                                    //       bubblesColor:
                                                    //           const BubblesColor(
                                                    //         dotPrimaryColor:
                                                    //             Colors.orangeAccent,
                                                    //         dotSecondaryColor:
                                                    //             Colors.orange,
                                                    //       ),
                                                    //       likeBuilder:
                                                    //           (bool isLiked) {
                                                    //         return Icon(
                                                    //           isLiked
                                                    //               ? Icons
                                                    //                   .leak_add_sharp
                                                    //               : Icons
                                                    //                   .leak_add_sharp,
                                                    //           color: isLiked
                                                    //               ? Colors.deepOrange
                                                    //               : Colors.grey,
                                                    //           size: 20,
                                                    //         );
                                                    //       },
                                                    //     ),
                                                    //   ],
                                                    // )
                                                  ],
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ]),
                                  placeholder: (context, url) =>
                                      const CircularProgressIndicator(),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: Container(
                                // height: _height/6.5,
                                width: _width,
                                padding: const EdgeInsets.all(25),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      "a collection by",
                                      style: TextStyle(
                                        color: Colors.grey,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w200,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceEvenly,
                                      children: [
                                        Expanded(
                                          child: InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                              userId: widget
                                                                  .mangoPost
                                                                  .postCreator)));
                                            },
                                            child: Row(
                                              children: [
                                                CachedNetworkImage(
                                                  height: 32,
                                                  imageUrl: receiverSnapshot
                                                          .data?.profileImage ??
                                                      '',
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Material(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            50),
                                                    // elevation: 1,
                                                    child: CircleAvatar(
                                                      backgroundImage:
                                                          imageProvider,
                                                      radius: 16,
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const Padding(
                                                    padding:
                                                        EdgeInsets.all(50.0),
                                                    child:
                                                        ShimmerWidget.circular(
                                                            width: 32,
                                                            height: 32),
                                                  ),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                                const SizedBox(
                                                  width: 5,
                                                ),
                                                Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      receiverSnapshot.data
                                                              ?.displayName ??
                                                          '',
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                    Text(
                                                      '@${receiverSnapshot.data?.username ?? ''}',
                                                      style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontSize: 12,
                                                        fontWeight:
                                                            FontWeight.w900,
                                                      ),
                                                    ),
                                                  ],
                                                )
                                              ],
                                            ),
                                          ),
                                        ),
                                        if (FirebaseAuth
                                                .instance.currentUser!.uid ==
                                            widget.mangoPost.postCreator)
                                          InkWell(
                                            onTap: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          ProfilePage(
                                                            userId: FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid,
                                                          )));
                                              // EditProfile(bannerImage: Provider.of<MangoUser>(context).bannerImageUrl, profileImage: Provider.of<MangoUser>(context).profileImage, username: Provider.of<MangoUser>(context).username, displayName: Provider.of<MangoUser>(context).displayName,)));
                                            },
                                            child: Container(
                                              // width: _width / 4,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    "View Profile",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    Icons.person,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else if (FirebaseAuth.instance
                                                    .currentUser!.uid !=
                                                widget.mangoPost.postCreator &&
                                            !Provider.of<bool>(context))
                                          InkWell(
                                            onTap: () {
                                              _userService.followUser(
                                                  widget.mangoPost.postCreator);
                                            },
                                            child: Container(
                                              // width: _width / 4,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    "Follow",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    Icons.person_add_rounded,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else if (FirebaseAuth.instance
                                                    .currentUser!.uid !=
                                                widget.mangoPost.postCreator &&
                                            Provider.of<bool>(context))
                                          InkWell(
                                            onTap: () {
                                              _userService.unfollowUser(
                                                  widget.mangoPost.postCreator);
                                            },
                                            child: Container(
                                              // width: _width / 4,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      vertical: 8,
                                                      horizontal: 15),
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black,
                                              ),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: const [
                                                  Text(
                                                    "Following",
                                                    style: TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.w900,
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: 5,
                                                  ),
                                                  Icon(
                                                    Icons.person_add_rounded,
                                                    color: Colors.white,
                                                    size: 16,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          )
                                        else
                                          Container()
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            SliverToBoxAdapter(
                              child: SizedBox(
                                height: _height / 2,
                                child: ListView(children: [
                                  Container(
                                    // height: _height/6.5,
                                    width: _width,
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        const Text(
                                          "Description",
                                          style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 24,
                                            fontWeight: FontWeight.w800,
                                          ),
                                        ),
                                        const SizedBox(
                                          height: 10,
                                        ),
                                        Text(
                                          widget.mangoPost.text,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                        widget.mangoPost.tags.isNotEmpty
                                            ?
                                          Padding(
                                            padding: const EdgeInsets.symmetric(vertical: 20.0),
                                            child: Wrap(
                                              alignment: WrapAlignment.start,
                                              children: widget.mangoPost.tags.map((tagModel) => tagChip(
                                                tagModel: tagModel,
                                                // onTap: () => _removeTag(tagModel),
                                                action: 'Explore',
                                              ))
                                                  .toSet()
                                                  .toList(),
                                            ),
                                          ) : const SizedBox(),
                                        const Padding(
                                          padding: EdgeInsets.all(10.0),
                                          child: Text(
                                            "Interactions",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14,
                                              fontWeight: FontWeight.w900,
                                            ),
                                          ),
                                        ),
                                        StreamProvider.value(
                                            value: _postService
                                                .getPlaylistComments(
                                                    widget.mangoPost.id),
                                            initialData: const <
                                                MangoPlaylistComment>[],
                                            child: PlaylistCommentList(
                                              mangoPlaylist: widget.mangoPost,
                                            ))
                                      ],
                                    ),
                                  ),
                                ]),
                              ),
                            ),
                          ],
                        ),
                        Positioned(
                            bottom: 10,
                            right: 15,
                            child: Center(
                              child: TextButton(
                                onPressed: () async {
                                  final songURL = widget.mangoPost.link;
                                  FirebaseFirestore.instance
                                      .collection("playlists")
                                      .doc(widget.mangoPost.id)
                                      .update(
                                          {"plays": FieldValue.increment(1)});

                                  FirebaseFirestore.instance
                                      .collection("users")
                                  .doc(FirebaseAuth.instance.currentUser!.uid)
                                  .collection('recent_events').doc().set({
                                    'recentId': widget.mangoPost.id,
                                    'type': 'playlist',
                                    'timeStamp': FieldValue.serverTimestamp(),
                                  });

                                  showModalBottomSheet(
                                      backgroundColor: Colors.transparent,
                                      isScrollControlled: true,
                                      context: context,
                                      builder: (context) => WebViewer(
                                            url: songURL,
                                          ));
                                },
                                style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(28.0),
                                  )),
                                  padding: MaterialStateProperty.all(
                                      const EdgeInsets.symmetric(
                                          vertical: 10.0, horizontal: 20.0)),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.black),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: const [
                                    Text(
                                      "View Details",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 20,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    SizedBox(
                                      width: 5,
                                    ),
                                    Icon(
                                      Icons.view_agenda_outlined,
                                      color: Colors.white,
                                      size: 16,
                                    ),
                                  ],
                                ),
                              ),
                            )),
                      ],
                    );
                  }),
            );
          }),
    );
  }

  Widget tagChip({
    tagModel,
    action,
  }) {
    return InkWell(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=> TagsPage(tag: tagModel))),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 5.0,
          ),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Text(
              tagModel,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 15.0,
              ),
            ),
          ),
        ));
  }
}
