import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/library.dart';
import 'package:mango/Models/customModel/playlist.dart';
import 'package:mango/Models/customModel/post.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/Episodes/episodes_widget.dart';
import 'package:mango/Screens/Messaging/pages/chat_page.dart';
import 'package:mango/Screens/Music/create_playlist.dart';
import 'package:mango/Screens/PDFReader/grid_books.dart';
import 'package:mango/Screens/Profile/fowwers_page.dart';
import 'package:mango/Screens/Widgets/list_playlist.dart';
import 'package:mango/Screens/Widgets/userPostlist.dart';
import 'package:mango/Services/shimmer_widget.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';
import 'account_settings.dart';

class ProfilePage extends StatefulWidget {
  final String userId;
  const ProfilePage({Key? key, required this.userId}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  ScrollController _scrollController = ScrollController();
  var profileImage = '';

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
      dob: '',
      id: '',
      password: '',
      gender: '',
      profileImage: '',
      email: '',
      fcmToken: '',
      verified: false);

  @override
  void initState() {
    super.initState();
    _scrollController = ScrollController();
    _scrollController.addListener(() => setState(() {}));
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;

    if (kDebugMode) {
      print(widget.userId);
    }

    return MultiProvider(
      providers: [
        StreamProvider<bool>(
            create: (context) => _userService.isFollowing(
                FirebaseAuth.instance.currentUser!.uid, widget.userId),
            initialData: false),
        StreamProvider<int>(
            create: (context) => _userService
                .noFollowers(FirebaseAuth.instance.currentUser!.uid),
            initialData: 0),
        StreamProvider<int>(
            create: (context) => _userService
                .noFollowing(FirebaseAuth.instance.currentUser!.uid),
            initialData: 0),
        StreamProvider<MangoUser?>(
            create: (context) => _userService.getUserInfo(widget.userId),
            initialData: _user),
        // StreamProvider.value(
        //     value: _postService.getPlaylistsByUser(
        //         widget.userId),
        //     initialData: <MangoPost>[]),
        StreamProvider(
          initialData: const <MangoPost>[],
          create: (BuildContext context) {
            _postService.getPostsByUser(widget.userId);
          },
        ),
      ],
      child: Stack(
        alignment: AlignmentDirectional.center,
        children: [
          FutureBuilder<List<String>>(
              initialData: const <String>[],
              future: UserService().whoUserFollows2(widget.userId),
              builder: (BuildContext context,
                  AsyncSnapshot<List<String>> followingSnapshot) {
                int foll = followingSnapshot.data!.length;
                if (!followingSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return StreamBuilder<MangoUser?>(
                    initialData: _user,
                    stream: _userService.getUserInfo(
                        widget.userId),
                    builder: (BuildContext context,
                        AsyncSnapshot<MangoUser?>
                        snapshot2) {
                      if (!snapshot2.hasData) {
                        return const Center(
                          child:
                          CircularProgressIndicator(),
                        );
                      }
                    return Scaffold(
                      body: DefaultTabController(
                        length: 4,
                        child: FutureBuilder<List<String>>(
                            initialData: const <String>[],
                            future: UserService().whoFollowsUser2(widget.userId),
                            builder: (BuildContext context,
                                AsyncSnapshot<List<String>> followerSnapshot) {
                              int follower = followerSnapshot.data!.length;
                              if (!followingSnapshot.hasData) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              return NestedScrollView(
                                controller: _scrollController,
                                headerSliverBuilder: (context, _) {
                                  String username =
                                      Provider.of<MangoUser>(context).username;
                                  return [
                                    SliverAppBar(
                                      floating: false,
                                      pinned: true,
                                      backgroundColor: Colors.transparent,
                                      leading: const CloseButton(
                                        color: Colors.white,
                                      ),
                                      shadowColor: Colors.transparent,
                                      expandedHeight: _height / 4.8,
                                      stretch: true,
                                      flexibleSpace: FlexibleSpaceBar(
                                        background: CachedNetworkImage(
                                          imageUrl: Provider.of<MangoUser>(context)
                                              .bannerImageUrl,
                                          imageBuilder: (context, imageProvider) =>
                                              Container(
                                            decoration: BoxDecoration(
                                              image: DecorationImage(
                                                image: imageProvider,
                                                fit: BoxFit.cover,
                                              ),
                                            ),
                                          ),
                                          placeholder: (context, url) =>
                                              const ShimmerWidget.rectangular(
                                                  width: double.infinity,
                                                  height: double.infinity),
                                          errorWidget: (context, url, error) =>
                                              const Icon(Icons.error),
                                        ),
                                      ),
                                    ),
                                    SliverList(
                                      delegate: SliverChildListDelegate(
                                        [
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream: _userService.getUserInfo(
                                                  FirebaseAuth
                                                      .instance.currentUser!.uid),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?>
                                                      snapshot) {
                                                String token =
                                                    snapshot.data!.fcmToken;
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                }
                                                return Stack(
                                                  alignment:
                                                      AlignmentDirectional.center,
                                                  clipBehavior: Clip.none,
                                                  children: [
                                                    Column(
                                                      children: [
                                                        const SizedBox(
                                                          height: 60,
                                                        ),
                                                        Container(
                                                          padding: const EdgeInsets
                                                                  .symmetric(
                                                              horizontal: 15,
                                                              vertical: 10),
                                                          alignment:
                                                              Alignment.center,
                                                          child: Column(
                                                            children: [
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  Text(
                                                                    Provider.of<MangoUser>(
                                                                            context)
                                                                        .displayName,
                                                                    style:
                                                                        textHeader2,
                                                                  ),
                                                                  Provider.of<MangoUser>(
                                                                                  context)
                                                                              .verified ==
                                                                          true
                                                                      ? const Padding(
                                                                          padding: EdgeInsets.only(
                                                                              left:
                                                                                  2.0),
                                                                          child:
                                                                              Icon(
                                                                            Icons
                                                                                .verified,
                                                                            size:
                                                                                20,
                                                                          ),
                                                                        )
                                                                      : Container()
                                                                ],
                                                              ),
                                                              Text(
                                                                "@${Provider.of<MangoUser>(context).username}",
                                                                style: textBody3,
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              Padding(
                                                                padding:
                                                                    const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            35.0),
                                                                child: Text(
                                                                  Provider.of<MangoUser>(
                                                                          context)
                                                                      .bio,
                                                                  textWidthBasis:
                                                                      TextWidthBasis
                                                                          .longestLine,
                                                                  overflow:
                                                                      TextOverflow
                                                                          .fade,
                                                                  maxLines: 4,
                                                                  textAlign:
                                                                      TextAlign
                                                                          .center,
                                                                  style:
                                                                      playlistCardStat,
                                                                ),
                                                              ),
                                                              const SizedBox(
                                                                height: 30,
                                                              ),
                                                              Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                crossAxisAlignment:
                                                                    CrossAxisAlignment
                                                                        .center,
                                                                children: [
                                                                  const Icon(
                                                                    Icons
                                                                        .person_outline_outlined,
                                                                    color: Colors
                                                                        .orange,
                                                                    size: 15,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: (){
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => FollowersPage(uid: widget.userId)));
                                                                    },
                                                                    child: Text(
                                                                      follower.toString(),
                                                                      style: postSTat,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .supervised_user_circle_outlined,
                                                                    color: Colors
                                                                        .orange,
                                                                    size: 15,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  GestureDetector(
                                                                    onTap: () {
                                                                      Navigator.push(
                                                                          context,
                                                                          MaterialPageRoute(
                                                                              builder: (context) => FollowingPage(uid: widget.userId)));
                                                                    },
                                                                    child: Text(
                                                                      foll
                                                                          .toString(),
                                                                      style:
                                                                          postSTat,
                                                                    ),
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 20,
                                                                  ),
                                                                  const Icon(
                                                                    Icons
                                                                        .library_music_outlined,
                                                                    color: Colors
                                                                        .orange,
                                                                    size: 15,
                                                                  ),
                                                                  const SizedBox(
                                                                    width: 10,
                                                                  ),
                                                                  const Text(
                                                                    "0",
                                                                    style: postSTat,
                                                                  ),
                                                                ],
                                                              ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              if (FirebaseAuth
                                                                      .instance
                                                                      .currentUser!
                                                                      .uid ==
                                                                  widget.userId)
                                                                InkWell(
                                                                  onTap: () {
                                                                    Navigator.push(
                                                                        context,
                                                                        MaterialPageRoute(
                                                                            builder: (context) =>
                                                                                AccountSettings(
                                                                                  userId: widget.userId,
                                                                                )));
                                                                    // EditProfile(bannerImage: Provider.of<MangoUser>(context).bannerImageUrl, profileImage: Provider.of<MangoUser>(context).profileImage, username: Provider.of<MangoUser>(context).username, displayName: Provider.of<MangoUser>(context).displayName,)));
                                                                  },
                                                                  child: Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            15,
                                                                        vertical:
                                                                            8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                                    25),
                                                                            border:
                                                                                const Border(
                                                                              bottom: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                              top: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                              left: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                              right: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                            ),
                                                                            color: Colors
                                                                                .transparent),
                                                                    child:
                                                                        const Text(
                                                                      'Account Setup',
                                                                      style:
                                                                          labelBody,
                                                                    ),
                                                                  ),
                                                                )
                                                              else if (FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid !=
                                                                      widget
                                                                          .userId &&
                                                                  !Provider.of<
                                                                          bool>(
                                                                      context))
                                                                InkWell(
                                                                  onTap: () {
                                                                    _userService
                                                                        .followUser(
                                                                            widget
                                                                                .userId);
                                                                    _userService.sendNotification('', 'user',
                                                                        "@${snapshot.data!.username} just followed you",
                                                                        "New Follower",
                                                                        widget
                                                                            .userId,
                                                                        snapshot2.data!.fcmToken);
                                                                  },
                                                                  child: Container(
                                                                    padding: const EdgeInsets
                                                                            .symmetric(
                                                                        horizontal:
                                                                            15,
                                                                        vertical:
                                                                            8),
                                                                    decoration:
                                                                        BoxDecoration(
                                                                            borderRadius:
                                                                                BorderRadius.circular(
                                                                                    25),
                                                                            border:
                                                                                const Border(
                                                                              bottom: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                              top: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                              left: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                              right: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                            ),
                                                                            color: Colors
                                                                                .transparent),
                                                                    child:
                                                                        const Text(
                                                                      'follow',
                                                                      style:
                                                                          labelBody,
                                                                    ),
                                                                  ),
                                                                )
                                                              else if (FirebaseAuth
                                                                          .instance
                                                                          .currentUser!
                                                                          .uid !=
                                                                      widget
                                                                          .userId &&
                                                                  Provider.of<bool>(
                                                                      context))
                                                                InkWell(
                                                                  onTap: () {
                                                                    _userService
                                                                        .unfollowUser(
                                                                            widget
                                                                                .userId);
                                                                  },
                                                                  child: Row(
                                                                    mainAxisAlignment:
                                                                        MainAxisAlignment
                                                                            .center,
                                                                    children: [
                                                                      Container(
                                                                        padding: const EdgeInsets
                                                                                .symmetric(
                                                                            horizontal:
                                                                                15,
                                                                            vertical:
                                                                                8),
                                                                        decoration: BoxDecoration(
                                                                            borderRadius: BorderRadius.circular(25),
                                                                            border: const Border(
                                                                              bottom: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                              top: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                              left: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                              right: BorderSide(
                                                                                  color: Colors.orange,
                                                                                  width: 2),
                                                                            ),
                                                                            color: Colors.orange),
                                                                        child: Row(
                                                                          mainAxisAlignment:
                                                                              MainAxisAlignment
                                                                                  .center,
                                                                          children: const [
                                                                            Text(
                                                                              'following',
                                                                              style:
                                                                                  labelBody_,
                                                                            ),
                                                                            SizedBox(
                                                                              width:
                                                                                  5,
                                                                            ),
                                                                            Icon(
                                                                                Icons
                                                                                    .mobile_friendly_outlined,
                                                                                size:
                                                                                    20,
                                                                                color:
                                                                                    Colors.white),
                                                                          ],
                                                                        ),
                                                                      ),
                                                                      const SizedBox(
                                                                        width: 10,
                                                                      ),
                                                                      StreamBuilder<
                                                                              MangoUser?>(
                                                                          initialData:
                                                                              _user,
                                                                          stream: _userService.getUserInfo(
                                                                              Provider.of<MangoUser>(context)
                                                                                  .id),
                                                                          builder: (BuildContext
                                                                                  context,
                                                                              AsyncSnapshot<MangoUser?>
                                                                                  snapshot) {
                                                                            if (!snapshot
                                                                                .hasData) {
                                                                              return const Center(
                                                                                child:
                                                                                    CircularProgressIndicator(),
                                                                              );
                                                                            }
                                                                            return InkWell(
                                                                              onTap:
                                                                                  () {
                                                                                Navigator.push(context,
                                                                                    MaterialPageRoute(builder: (context) => ChatPage(user: snapshot.data!)));
                                                                              },
                                                                              child:
                                                                                  Container(
                                                                                padding:
                                                                                    const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                                                                                decoration: BoxDecoration(
                                                                                    borderRadius: BorderRadius.circular(25),
                                                                                    border: const Border(
                                                                                      bottom: BorderSide(color: Colors.orange, width: 2),
                                                                                      top: BorderSide(color: Colors.orange, width: 2),
                                                                                      left: BorderSide(color: Colors.orange, width: 2),
                                                                                      right: BorderSide(color: Colors.orange, width: 2),
                                                                                    ),
                                                                                    color: Colors.transparent),
                                                                                child:
                                                                                    Row(
                                                                                  mainAxisAlignment: MainAxisAlignment.center,
                                                                                  children: const [
                                                                                    Text(
                                                                                      'message',
                                                                                      style: labelBody,
                                                                                    ),
                                                                                    SizedBox(
                                                                                      width: 5,
                                                                                    ),
                                                                                    Icon(Icons.mail, size: 20, color: Colors.black),
                                                                                  ],
                                                                                ),
                                                                              ),
                                                                            );
                                                                          })
                                                                    ],
                                                                  ),
                                                                ),
                                                              const SizedBox(
                                                                height: 20,
                                                              ),
                                                              const TabBar(
                                                                // controller: ,
                                                                labelStyle:
                                                                    widgetTitleText2,
                                                                unselectedLabelStyle:
                                                                    textBody3,
                                                                tabs: [
                                                                  Tab(
                                                                      text:
                                                                      "Posts"),
                                                                  Tab(
                                                                      text:
                                                                          "Playlists"),
                                                                  Tab(
                                                                      text:
                                                                          "Library"),
                                                                  Tab(
                                                                      text:
                                                                          "Episodes")
                                                                ],
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                );
                                              }),
                                        ],
                                      ),
                                    ),
                                  ];
                                },
                                body: TabBarView(children: [
                                  StreamProvider.value(
                                    value: _postService
                                        .getPostsByUser(widget.userId),
                                    initialData: const <MangoPost>[],
                                    child: const UserPostList()),
                                  StreamProvider.value(
                                      value: _postService
                                          .getPlaylistsByUser(widget.userId),
                                      initialData: const <MangoPlaylist>[],
                                      child: const ListPlaylist()),
                                  StreamProvider.value(
                                      value: _postService
                                          .getLibraryByUser(widget.userId),
                                      initialData: const <MangoLibrary>[],
                                      child: LibraryGrid()),
                                  const Center(
                                    child: Text("Episodes coming soon"),
                                  ),
                                ]),
                              );
                            }),
                      ),
                      floatingActionButton: FloatingActionButton(
                        onPressed: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const CreatePlaylist()));
                        },
                        backgroundColor: Colors.orange,
                        child: const Icon(
                          Icons.add,
                          size: 40,
                        ),
                      ),
                    );
                  }
                );
              }),
          StreamProvider.value(
              value: _postService.getPlaylistsByUser(widget.userId),
              initialData: const <MangoPlaylist>[],
              child: ProfilePicture(
                controller: _scrollController,
                uid: widget.userId,
              )),
        ],
      ),
    );
  }
}

class ProfilePicture extends StatefulWidget {
  final controller;
  final uid;
  const ProfilePicture({Key? key, required this.controller, required this.uid})
      : super(key: key);

  @override
  _ProfilePictureState createState() => _ProfilePictureState();
}

class _ProfilePictureState extends State<ProfilePicture> {
  EpisodeWidgets episodeWidgets = EpisodeWidgets();
  File? returnedFile;
  var _value;
  bool picked = false;
  bool pickedBanner = false;

  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double defaultTopMargin = (_height / 4) - 60.0;
    //pixels from top where scaling should start
    const double scaleStart = 96.0;
    //pixels from top where scaling should end
    const double scaleEnd = scaleStart / 2;

    final image = Provider.of<MangoUser>(context).profileImage;

    double top = defaultTopMargin;
    double scale = 1.0;
    if (widget.controller.hasClients) {
      double offset = widget.controller.offset;
      top -= offset;
      if (offset < defaultTopMargin - scaleStart) {
        //offset small => don't scale down
        scale = 1.0;
      } else if (offset < defaultTopMargin - scaleEnd) {
        //offset between scaleStart and scaleEnd => scale down
        scale = (defaultTopMargin - scaleEnd - offset) / scaleEnd;
      } else {
        //offset passed scaleEnd => hide fab
        scale = 0.0;
      }
    }
    return Positioned(
      top: top,
      child: Transform(
        transform: Matrix4.identity()..scale(scale),
        alignment: Alignment.center,
        child: CachedNetworkImage(
          height: 100,
          width: 100,
          imageUrl: image,
          imageBuilder: (context, imageProvider) => Stack(
            children: [
              CircleAvatar(
                backgroundImage: imageProvider,
                radius: 50,
              ),
              // widget.uid == FirebaseAuth.instance.currentUser!.uid
              //     ? GestureDetector(
              //         onTap: () {},
              //         child: Positioned(
              //           bottom: 0,
              //           right: 0,
              //           child: GestureDetector(
              //             onTap: () => pickFromCamera(context).whenComplete(
              //                 () => episodeWidgets.previewEpisodeMeta(
              //                     context, returnedFile!)),
              //             // ()=> ARCamera(),
              //
              //             child: const CircleAvatar(
              //                 radius: 15,
              //                 backgroundColor: Colors.black,
              //                 child: Icon(
              //                   Icons.add_circle_outline_sharp,
              //                   color: Colors.orange,
              //                 )),
              //           ),
              //         ),
              //       )
              //     : const SizedBox(),
            ],
          ),
          placeholder: (context, url) => const ShimmerWidget.circular(width: 100, height: 100,),
          errorWidget: (context, url, error) => const CircleAvatar(
              backgroundColor: Colors.white,
              radius: 50.0,
              child: Icon(Icons.image)),
          placeholderFadeInDuration: const Duration(seconds: 3),
        ),
      ),
    );
  }

  Future pickFromGallery(BuildContext context) async {
    final getMedia = ImagePicker().pickImage;
    final media = await getMedia(source: ImageSource.gallery);
    final file = File(media!.path);
    setState(() {
      returnedFile = file;
      picked = true;
    });
  }

  Future pickFromCamera(BuildContext context) async {
    final getMedia = ImagePicker().pickImage;
    final media = await getMedia(source: ImageSource.camera);
    final file = File(media!.path);
    setState(() {
      returnedFile = file;
      picked = true;
    });
  }
}

//
// PopupMenuButton(
// child: const CircleAvatar(
// radius: 15,
// backgroundColor: Colors.black,
// child: Icon(Icons.add_circle_outline_sharp, color: Colors.orange,)),
// onSelected: (newValue) {
// if (newValue == 0) {
// pickFromCamera(context).whenComplete(() => episodeWidgets.previewEpisodeMeta(
// context, returnedFile!));
// }
// if (newValue == 1) {
// pickFromGallery(context).whenComplete(() => episodeWidgets.previewEpisodeMeta(
// context, returnedFile!));
// }// add this property
// setState(() {
// _value = newValue; // it gives the value which is selected
// });
// },
// itemBuilder: (context) => [
// const PopupMenuItem(
// child: Text("From Camera"),
// value: 0,
// ),
// const PopupMenuItem(
// child: Text("From gallery"),
// value: 1,
// ),
// ],
// ),
