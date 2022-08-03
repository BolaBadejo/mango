import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/library.dart';
import 'package:mango/Models/customModel/reply_books.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/PDFReader/library_comment_list.dart';
import 'package:mango/Screens/PDFReader/page/pdf_viewer_page.dart';
import 'package:mango/Screens/PDFReader/widget/comment_book.dart';
import 'package:mango/Screens/Profile/profile.dart';
import 'package:provider/provider.dart';
import 'package:share/share.dart';

import '../../Services/shimmer_widget.dart';
import '../Tags/tags_page.dart';
import '../Widgets/reply_post_list.dart';
import 'API/pdf_api.dart';

class BookDetail extends StatefulWidget {
  final MangoLibrary mangoLibrary;
  const BookDetail({Key? key, required this.mangoLibrary}) : super(key: key);

  @override
  _BookDetailState createState() => _BookDetailState();
}

class _BookDetailState extends State<BookDetail> {
  final PostService _postService = PostService();

  Widget buttonChild = Row(
    mainAxisAlignment: MainAxisAlignment.center,
    children: const [
      Text(
        "read here",
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
        Icons.exit_to_app,
        color: Colors.white,
        size: 16,
      ),
    ],
  );

  int isPressed = 0;


  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    double _width = MediaQuery.of(context).size.width;
    print(widget.mangoLibrary.id);
    final UserService _userService = UserService();
    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        dob: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        username: '',
        id: '',
        password: '',
        gender: '',
        profileImage: '',
        email: '', fcmToken: '', verified: false);

    bool isLiked;

    return MultiProvider(
      providers: [
        StreamProvider<bool>(
            create: (context) => _userService.isFollowing(
                FirebaseAuth.instance.currentUser!.uid, widget.mangoLibrary.postCreator),
            initialData: false),
      ],
      child: StreamBuilder<MangoUser?>(
          initialData: _user,
          stream: UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
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
                stream: UserService().getUserInfo(widget.mangoLibrary.postCreator),
                builder:
                    (BuildContext context, AsyncSnapshot<MangoUser?> receiverSnapshot) {
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
                                  widget.mangoLibrary.title,
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
                              background: Hero(
                                tag: widget.mangoLibrary.image,
                                child: CachedNetworkImage(
                                  width: 300,
                                  imageUrl: widget.mangoLibrary.image,
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
                                            borderRadius: BorderRadius.circular(10),
                                            color: Colors.black),
                                        child: Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Expanded(
                                              flex: 2,
                                              child: CachedNetworkImage(
                                                width: 300,
                                                height: 450,
                                                imageUrl: widget.mangoLibrary.image,
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Container(
                                                  margin: const EdgeInsets.symmetric(
                                                      vertical: 20, horizontal: 20),
                                                  decoration: BoxDecoration(
                                                    image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover),
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const ShimmerWidget.rectangularCircular(width: 300, height: 450),
                                                errorWidget: (context, url, error) =>
                                                    const Icon(Icons.error),
                                              ),
                                            ),
                                            Expanded(
                                              flex: 3,
                                              child: Padding(
                                                padding: const EdgeInsets.symmetric(
                                                    vertical: 20),
                                                child: Column(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      widget.mangoLibrary.title,
                                                      style: const TextStyle(
                                                        color: Colors.white,
                                                        fontSize: 18,
                                                        fontWeight: FontWeight.bold,
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
                                                        fontWeight: FontWeight.w700,
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
                                                                .hasLikedBook(widget.mangoLibrary.id),
                                                            builder: (BuildContext context,
                                                                AsyncSnapshot<bool?> snapshot) {
                                                              if (snapshot.data == true) {
                                                                return InkWell(
                                                                    onTap: () {
                                                                      _postService
                                                                          .unlikeBook(widget.mangoLibrary.id);
                                                                    },
                                                                    child: const Icon(
                                                                      Icons.favorite,
                                                                      color: Colors.deepOrange,
                                                                      size: 20,
                                                                    ));
                                                              }
                                                              return InkWell(
                                                                  onTap: () async {
                                                                    _postService
                                                                        .likeBook(widget.mangoLibrary.id, widget.mangoLibrary.postCreator);
                                                                    _userService.sendNotification(widget.mangoLibrary, 'book',"@${senderSnapshot.data!.username} just liked ${widget.mangoLibrary.title}", "New Interaction", widget.mangoLibrary.postCreator, token);
                                                                  },
                                                                  child: const Icon(
                                                                    Icons.favorite_border,
                                                                    color: Colors.grey,
                                                                    size: 20,
                                                                  ));
                                                            }),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                            onTap: () async {
                                                              Share.share('Read ${widget.mangoLibrary.title} by @${receiverSnapshot.data!.username} on Mango. \n \n get the android app here \n http://tiny.cc/qhssuz', subject: "New Playlist On Mango");
                                                              // _postService.repostBook(
                                                              //     widget.mangoLibrary, widget.mangoLibrary.repost);
                                                              // _userService.sendNotification("@${senderSnapshot.data!.username} just reposted ${widget.mangoLibrary.title}", "New Interaction", widget.mangoLibrary.postCreator, token);
                                                            },
                                                            child: const Icon(
                                                              Icons.share,
                                                              color: Colors.grey,
                                                              size: 20,
                                                            )),
                                                        const SizedBox(
                                                          width: 10,
                                                        ),
                                                        InkWell(
                                                            onTap: () async {
                                                              final mangoLibrary = widget.mangoLibrary;
                                                              showModalBottomSheet(
                                                                  backgroundColor: Colors.transparent,
                                                                  isScrollControlled: true,
                                                                  context: context,
                                                                  builder: (context) => CommentBook(mangoLibrary: mangoLibrary,

                                                                  ));
                                                            },
                                                            child: Icon(
                                                              Icons.message_outlined,
                                                              color: widget.mangoLibrary.repost
                                                                  ? Colors.lightGreen
                                                                  : Colors.grey,
                                                              size: 20,
                                                            ))
                                                      ],
                                                    )
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
                                      const ShimmerWidget.rectangularCircular(width: 300, height: 450),
                                  errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                ),
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
                                                                .mangoLibrary
                                                                .postCreator)));
                                          },
                                          child: Row(
                                            children: [
                                              CachedNetworkImage(
                                                height: 32,
                                                imageUrl:
                                                receiverSnapshot.data?.profileImage ??
                                                        '',
                                                imageBuilder:
                                                    (context, imageProvider) =>
                                                        Material(
                                                  borderRadius:
                                                      BorderRadius.circular(50),
                                                  // elevation: 1,
                                                  child: CircleAvatar(
                                                    backgroundImage: imageProvider,
                                                    radius: 16,
                                                  ),
                                                ),
                                                placeholder: (context, url) =>
                                                    const ShimmerWidget.circular(width: 32, height: 32),
                                                errorWidget:
                                                    (context, url, error) =>
                                                        const Icon(Icons.error),
                                              ),
                                              const SizedBox(
                                                width: 5,
                                              ),
                                              Column(
                                                crossAxisAlignment: CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    receiverSnapshot.data?.displayName ?? '',
                                                    style: const TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 16,
                                                      fontWeight: FontWeight.w900,
                                                    ),
                                                  ),
                                                  Text(
                                                    '@${receiverSnapshot.data?.username ?? ''}',
                                                    style: const TextStyle(
                                                      color: Colors.grey,
                                                      fontSize: 12,
                                                      fontWeight: FontWeight.w900,
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
                                          widget.mangoLibrary.postCreator)
                                        InkWell(
                                          onTap: () {
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ProfilePage(
                                                          userId:
                                                          FirebaseAuth.instance.currentUser!.uid,
                                                        )));
                                            // EditProfile(bannerImage: Provider.of<MangoUser>(context).bannerImageUrl, profileImage: Provider.of<MangoUser>(context).profileImage, username: Provider.of<MangoUser>(context).username, displayName: Provider.of<MangoUser>(context).displayName,)));
                                          },
                                          child: Container(
                                            // width: _width / 4,
                                            padding: const EdgeInsets.symmetric(
                                                vertical: 8, horizontal: 15),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(
                                                  20),
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
                                                    fontWeight: FontWeight.w900,
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
                                        ) else if (FirebaseAuth.instance
                                          .currentUser!.uid !=
                                          widget.mangoLibrary.postCreator &&
                                          !Provider.of<bool>(context))
                                        InkWell(
                                          onTap: () {
                                            _userService
                                                .followUser(widget.mangoLibrary.postCreator);
                                          },
                                          child: Container(
                                            // width: _width / 4,
                                            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(20),
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
                                                    fontWeight: FontWeight.w900,
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
                                        ) else if (FirebaseAuth.instance
                                            .currentUser!.uid !=
                                            widget.mangoLibrary.postCreator &&
                                            Provider.of<bool>(context))
                                          InkWell(
                                            onTap: () {
                                              _userService
                                                  .unfollowUser(widget.mangoLibrary.postCreator);
                                            },
                                            child: Container(
                                              // width: _width / 4,
                                              padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 15),
                                              decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
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
                                                      fontWeight: FontWeight.w900,
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
                                        else Container()
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          SliverToBoxAdapter(
                            child: SizedBox(
                              height: _height/2,
                              child: ListView(
                                children: <Widget> [
                                  Container(
                                    // height: _height/6.5,
                                    width: _width,
                                    padding: const EdgeInsets.all(25),
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.start,
                                      crossAxisAlignment: CrossAxisAlignment.start,
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
                                          widget.mangoLibrary.text,
                                          style: const TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w700,
                                          ),
                                          maxLines: 10,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ],
                                    ),
                                  ),
                                  widget.mangoLibrary.tags.isNotEmpty
                                      ?
                                  Wrap(
                                    alignment: WrapAlignment.start,
                                    children: widget.mangoLibrary.tags.map((tagModel) => tagChip(
                                      tagModel: tagModel,
                                      action: 'Explore',
                                    ))
                                        .toSet()
                                        .toList(),
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
                                      value: _postService.getBookComments(widget.mangoLibrary.id),
                                      initialData: const <MangoBookComment>[],
                                      child: LibraryCommentList(mangoLibrary: widget.mangoLibrary,))
                                ],
                              ),
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

                                if (isPressed == 0) {
                                  FirebaseFirestore.instance.collection("library").doc(widget.mangoLibrary.id).update({"reads": FieldValue.increment(1)});
                                  FirebaseFirestore.instance
                                      .collection("users")
                                      .doc(FirebaseAuth.instance.currentUser!.uid)
                                      .collection('recent_events').doc().set({
                                    'recentId': widget.mangoLibrary.id,
                                    'type': 'book',
                                    'timeStamp': FieldValue.serverTimestamp(),
                                  });
                                  final url = widget.mangoLibrary.link;
                                  setState(() {
                                    isPressed++;
                                    buttonChild = const CircularProgressIndicator();
                                  });

                                  final file = await PDFApi.loadNetwork(url);
                                  openPDF(context, file, widget.mangoLibrary.title, widget.mangoLibrary.id);
                                  setState(() {
                                    buttonChild = Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: const [
                                        Text(
                                          "read here",
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
                                          Icons.exit_to_app,
                                          color: Colors.white,
                                          size: 16,
                                        ),
                                      ],
                                    );
                                  });
                                } else {}
                              },
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(28.0),
                                )),
                                padding: MaterialStateProperty.all(
                                    const EdgeInsets.symmetric(
                                        vertical: 10.0, horizontal: 20.0)),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(Colors.black),
                              ),
                              child: buttonChild,
                            ),
                          )),
                    ],
                  );
                }),
          );
        }
      ),
    );
  }

  void openPDF(BuildContext context, File file, String title, String id) {
    Navigator.of(context).push(
        MaterialPageRoute(builder: (context) => PDFViewerPage(file: file, title: title,)),
      );
  }

  Widget tagChip({
    tagModel,
    action,
  }) {
    return InkWell(
        onTap: ()=>Navigator.push(context, MaterialPageRoute(builder: (context)=>TagsPage(tag: tagModel))),
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


