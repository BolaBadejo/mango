import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/library.dart';
import 'package:mango/Models/customModel/playlist.dart';
import 'package:mango/Models/customModel/recent_events.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Models/widgets.dart';
import 'package:mango/Screens/AccountSetup/interests.dart';
import 'package:mango/Screens/Home/pages/view_all_playlists.dart';
import 'package:mango/Screens/Music/create_playlist.dart';
import 'package:mango/Screens/Music/database.dart';
import 'package:mango/Screens/PDFReader/bookDetail.dart';
import 'package:mango/Screens/Posts/add_book.dart';
import 'package:mango/Screens/Posts/createpost.dart';
import 'package:mango/Services/shimmer_widget.dart';
import 'package:provider/provider.dart';

import '../Music/playlist_page.dart';
import '../Tags/tags_page.dart';

class HomePages extends StatefulWidget {
  const HomePages({Key? key}) : super(key: key);

  @override
  _HomePagesState createState() => _HomePagesState();
}

class _HomePagesState extends State<HomePages> {
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  refresh() {
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    return CustomScrollView(slivers: [
      SliverAppBar(
        automaticallyImplyLeading: false,
        backgroundColor: Colors.white,
        shadowColor: Colors.transparent,
        floating: true,
        toolbarHeight: 60,
        title: Text(
          'How far na?',
          style: GoogleFonts.montserrat(
            fontSize: 28,
            fontWeight: FontWeight.w600,
            fontStyle: FontStyle.normal,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.edit),
            tooltip: 'write',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => CreatePost()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.music_note),
            tooltip: 'Add new music',
            onPressed: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => const CreatePlaylist()));
            },
          ),
          IconButton(
            icon: const Icon(Icons.library_add),
            tooltip: 'Add new book',
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const AddBook()));
            },
          ),
        ],
      ),
      SliverList(
        delegate: SliverChildListDelegate([
          Container(
            color: Colors.white,
            width: _width,
            child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 30),
                  SizedBox(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const RecentEventsWidget(),
                          const SizedBox(height: 20),
                          Padding(
                            padding:
                                const EdgeInsets.fromLTRB(16.0, 0, 16.0, 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  'Discover',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                GestureDetector(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                StreamProvider.value(
                                                    value: _postService
                                                        .getPlaylistsByEverybody(
                                                            FirebaseAuth
                                                                .instance
                                                                .currentUser!
                                                                .uid),
                                                    initialData: const <
                                                        MangoPlaylist>[],
                                                    child:
                                                        const ViewPlaylists())));
                                  },
                                  child:
                                      const Icon(Icons.arrow_forward_outlined),
                                  // child: Text(
                                  //   '>>',
                                  //   style: GoogleFonts.montserrat(
                                  //     fontSize: 20,
                                  //     fontWeight: FontWeight.w800,
                                  //     fontStyle: FontStyle.normal,
                                  //   ),
                                  // ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            height: (_height / 4.5) + 60,
                            child: StreamProvider.value(
                                value: _postService.getPlaylistsByEverybody(
                                    FirebaseAuth.instance.currentUser!.uid),
                                initialData: const <MangoPlaylist>[],
                                child: TrackWidget(
                                  notifyParent: refresh,
                                )),
                          )
                        ]),
                  ),
                  const SizedBox(height: 30),
                  SizedBox(
                    child: StreamProvider.value(
                      value: _userService
                          .getAllUsers(FirebaseAuth.instance.currentUser!.uid),
                      initialData: const <MangoUser>[],
                      child: CirclePlaylistWidget(
                        title: "meet new buds",
                        subtitle: "3456 playlists",
                        notifyParent: refresh,
                      ),
                    ),
                  ),
                  const SizedBox(height: 30),
                  const MostListenedPlayListWidget(),
                  const SizedBox(height: 30),
                  const PlayListWidget(),
                  const SizedBox(height: 30),
                  const ByStateBooks(),
                  const SizedBox(height: 30),
                  const MostReadBooksWidget(),
                  const SizedBox(height: 30),
                  const PlaylistWithSimilarTags(),
                  const ByProfessionBooks(),
                  const SizedBox(height: 30),
                  const ByCityMusic(),
                  const SizedBox(height: 30),
                  const BookWidget(),
                  const SizedBox(height: 30),
                  const ByCountryBooks(),
                  const SizedBox(height: 30),
                  const TagsWidget(),
                  const SizedBox(height: 30),
                  const ByCityBooks(),
                  const SizedBox(height: 30),
                  const BooksWithSimilarTags(),
                  const SizedBox(height: 30),
                  const ByCountryMusic(),
                  const SizedBox(height: 30),
                  const ByProfessionMusic(),
                  const SizedBox(height: 30),
                  // const ByHobbyMusic(),
                  // const SizedBox(height: 30),
                  const BookWidget(),
                  const SizedBox(height: 30),
                  const PlayListWidget(),
                  const SizedBox(height: 30),
                  const ByStateMusic(),
                  const SizedBox(height: 30),
                ]),
          )
        ]),
      )
    ]);
  }
}

Future<String> category() async {
  UserService _userService = UserService();
  var categories = await _userService
      .userInterestList(FirebaseAuth.instance.currentUser!.uid);
  categories.shuffle();
  String selectedCategory = categories[0];

  return selectedCategory;
}

Future<String> interest(String selectedCategory) async {
  UserService _userService = UserService();
  var interest = await _userService.getInterest(selectedCategory);
  interest.shuffle();

  String nominatedInterest = interest[0];
  return nominatedInterest;
}

Future<List<String>> interestList(String selectedCategory) async {
  UserService _userService = UserService();
  var interest = await _userService.getInterest(selectedCategory);
  interest.shuffle();
  return interest;
}

class PlayListWidget extends StatelessWidget {
  const PlayListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
    final UserService _userService = UserService();

    return FutureBuilder<String>(
        future: category(),
        builder: (context, snapshot) {
          var category = snapshot.data;
          if (!snapshot.hasData) {
            return Container();
          } // This container can be a loading screen, since its waiting for data.
          if (snapshot.data!.isNotEmpty) {
            return FutureBuilder<String>(
                future: interest(category!),
                builder: (context, snapshot2) {
                  var interest = snapshot2.data;
                  if (!snapshot2.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 0, bottom: 5),
                            child: ShimmerWidget.rectangular(
                                width: 120, height: 14)),
                        const Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 20),
                            child: ShimmerWidget.rectangular(
                                width: 80, height: 12)),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: const [
                                    ShimmerWidget.rectangularCircular(
                                        width: 100, height: 100),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ShimmerWidget.rectangular(
                                        width: 70, height: 12),
                                    ShimmerWidget.rectangular(
                                        width: 50, height: 12)
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } // This container can be a loading screen, since its waiting for data.

                  if (snapshot2.data!.isNotEmpty) {
                    return SizedBox(
                      child: FutureProvider.value(
                        value: _postService.discoverPlaylistsByInterest(
                            category, interest),
                        initialData: const <MangoPlaylist>[],
                        child: SquarePlaylistWidget(
                          title: interest,
                          subtitle: "from $category",
                        ),
                      ),
                    );
                  } else {
                    print("List Null");
                    return Text("nada");
                  }
                });
          } else {
            print("List Null");
            return Text("nada");
          }
        });
  }
}

class PlaylistWithSimilarTags extends StatelessWidget {
  const PlaylistWithSimilarTags({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
    final UserService _userService = UserService();

    return FutureBuilder<String>(
        future: category(),
        builder: (context, snapshot) {
          var category = snapshot.data;
          if (!snapshot.hasData) {
            return Container();
          } // This container can be a loading screen, since its waiting for data.
          if (snapshot.data!.isNotEmpty) {
            return FutureBuilder<String>(
                future: interest(category!),
                builder: (context, snapshot2) {
                  var interest = snapshot2.data;
                  if (!snapshot2.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 0, bottom: 5),
                            child: ShimmerWidget.rectangular(
                                width: 120, height: 14)),
                        const Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 20),
                            child: ShimmerWidget.rectangular(
                                width: 80, height: 12)),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: const [
                                    ShimmerWidget.rectangularCircular(
                                        width: 100, height: 100),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ShimmerWidget.rectangular(
                                        width: 70, height: 12),
                                    ShimmerWidget.rectangular(
                                        width: 50, height: 12)
                                    // Text(
                                    //   users[index].id,
                                    //   style: GoogleFonts.montserrat(
                                    //     fontSize: 14,
                                    //     color: Colors.grey,
                                    //     fontWeight: FontWeight.w500,
                                    //     fontStyle: FontStyle.normal,
                                    //   ),
                                    // )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } // This container can be a loading screen, since its waiting for data.

                  if (snapshot2.data!.isNotEmpty) {
                    return SizedBox(
                        child: StreamProvider.value(
                            value: _postService.getPlaylistWithTags(interest!),
                            initialData: const <MangoPlaylist>[],
                            child: SquarePlaylistWidget(
                              subtitle: "More music relating to",
                              title: interest,
                            )));
                  } else {
                    print("List Null");
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                          top: 10),
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10),
                          color: Colors.black),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                    'Be the first to tag ${category.isNotEmpty ? category : 'a topic'} to your music in this space',
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
                                  const Text(
                                    'No music here',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const AddBook()));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 2, bottom: 2),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: const <Widget>[
                                    Text(
                                      "Let's go",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
                    );
                  }
                });
          } else {
            print("List Null");
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                  top: 10),
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10),
                  color: Colors.black),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        children: const [
                          Text(
                            'Select interests to tailor your Mango experience',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'You have no interest selected',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Interests(uid: FirebaseAuth.instance.currentUser!.uid)));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: const <Widget>[
                            Text(
                              "Let's go",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
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
            );
          }
        });
  }
}

class BooksWithSimilarTags extends StatelessWidget {
  const BooksWithSimilarTags({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
    final UserService _userService = UserService();

    return FutureBuilder<String>(
        future: category(),
        builder: (context, snapshot) {
          var category = snapshot.data;
          if (!snapshot.hasData) {
            return Container();
          } // This container can be a loading screen, since its waiting for data.
          if (snapshot.data!.isNotEmpty) {
            return FutureBuilder<String>(
                future: interest(category!),
                builder: (context, snapshot2) {
                  var interest = snapshot2.data;
                  if (!snapshot2.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 0, bottom: 5),
                            child: ShimmerWidget.rectangular(
                                width: 120, height: 14)),
                        const Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 20),
                            child: ShimmerWidget.rectangular(
                                width: 80, height: 12)),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: const [
                                    ShimmerWidget.rectangularCircular(
                                        width: 100, height: 100),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ShimmerWidget.rectangular(
                                        width: 70, height: 12),
                                    ShimmerWidget.rectangular(
                                        width: 50, height: 12)
                                    // Text(
                                    //   users[index].id,
                                    //   style: GoogleFonts.montserrat(
                                    //     fontSize: 14,
                                    //     color: Colors.grey,
                                    //     fontWeight: FontWeight.w500,
                                    //     fontStyle: FontStyle.normal,
                                    //   ),
                                    // )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } // This container can be a loading screen, since its waiting for data.

                  if (snapshot2.data!.isNotEmpty) {
                    return SizedBox(
                        child: StreamProvider.value(
                            value: _postService.getBooksWithTags(interest!),
                            initialData: const <MangoLibrary>[],
                            child:  BookListWidget(
                              subtitle: "More books relating to",
                              title: interest,
                            )));
                  } else {
                    print("List Null");
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                          top: 10),
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10),
                          color: Colors.black),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                    'Be the first to tag ${category.isNotEmpty ? category : 'a topic'} to your book in this space',
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
                                  const Text(
                                    'No book here',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const AddBook()));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 2, bottom: 2),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: const <Widget>[
                                    Text(
                                      "Let's go",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
                    );
                  }
                });
          } else {
            print("List Null");
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                  top: 10),
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10),
                  color: Colors.black),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        children: const [
                          Text(
                            'Select interests to tailor your Mango experience',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'You have no interest selected',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Interests(uid: FirebaseAuth.instance.currentUser!.uid)));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: const <Widget>[
                            Text(
                              "Let's go",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
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
            );
          }
        });
  }
}

class ByProfessionMusic extends StatelessWidget {
  const ByProfessionMusic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
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
        email: '',
        fcmToken: '',
        verified: false);

    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream:
            UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder<List<MangoPlaylist>>(
              initialData: const [],
              future: _postService
                  .getPlaylistByProfession(snapshot.data!.profession),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MangoPlaylist>> playListSnapshot) {
                if (!playListSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!playListSnapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20, top: 0, bottom: 5),
                          child: ShimmerWidget.rectangular(
                              width: 120, height: 14)),
                      const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child:
                              ShimmerWidget.rectangular(width: 80, height: 12)),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: const [
                                  ShimmerWidget.rectangularCircular(
                                      width: 100, height: 100),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ShimmerWidget.rectangular(
                                      width: 70, height: 12),
                                  ShimmerWidget.rectangular(
                                      width: 50, height: 12)
                                  // Text(
                                  //   users[index].id,
                                  //   style: GoogleFonts.montserrat(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontStyle: FontStyle.normal,
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (playListSnapshot.data!.isNotEmpty) {
                  bool isLoading = playListSnapshot.data!.isEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "What other",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.profession,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                Text('are listening to',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.arrow_forward_outlined),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      isLoading
                          ? SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: const [
                                        ShimmerWidget.rectangularCircular(
                                            width: 100, height: 100),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 70, height: 12),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 50, height: 12)
                                        // Text(
                                        //   users[index].id,
                                        //   style: GoogleFonts.montserrat(
                                        //     fontSize: 14,
                                        //     color: Colors.grey,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontStyle: FontStyle.normal,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: playListSnapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlaylistPage(
                                                    mangoPost: playListSnapshot
                                                        .data![index],
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 100,
                                            imageUrl: playListSnapshot
                                                .data![index].image,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.cover))),

                                            //     Material(
                                            //   borderRadius: BorderRadius.circular(50),
                                            //   elevation: 1,
                                            //   child: CircleAvatar(
                                            //     backgroundImage: imageProvider,
                                            //     radius: 50,
                                            //   ),
                                            // ),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget
                                                        .rectangularCircular(
                                                    width: 100, height: 100),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            playListSnapshot.data![index].title
                                                        .length >
                                                    15
                                                ? playListSnapshot
                                                        .data![index].title
                                                        .substring(0, 15) +
                                                    '...'
                                                : playListSnapshot
                                                    .data![index].title,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream: _userService.getUserInfo(
                                                  playListSnapshot.data![index]
                                                      .postCreator),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Text(
                                                      snapshot.data!.username,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12));
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  );
                } else {
                  print("List Null");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10),
                    padding: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.black),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                  'Be the first ${snapshot.data!.profession.isNotEmpty ? snapshot.data!.profession : 'pro'} to put music in this space',
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
                                const Text(
                                  'No music here',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const CreatePlaylist()));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    "Let's go",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
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
                  );
                }
              });
        });
  }
}

class ByCountryMusic extends StatelessWidget {
  const ByCountryMusic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
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
        email: '',
        fcmToken: '',
        verified: false);

    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream:
            UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder<List<MangoPlaylist>>(
              initialData: const [],
              future: _postService
                  .getPlaylistByCountry(snapshot.data!.country),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MangoPlaylist>> playListSnapshot) {
                if (!playListSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!playListSnapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20, top: 0, bottom: 5),
                          child: ShimmerWidget.rectangular(
                              width: 120, height: 14)),
                      const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child:
                              ShimmerWidget.rectangular(width: 80, height: 12)),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: const [
                                  ShimmerWidget.rectangularCircular(
                                      width: 100, height: 100),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ShimmerWidget.rectangular(
                                      width: 70, height: 12),
                                  ShimmerWidget.rectangular(
                                      width: 50, height: 12)
                                  // Text(
                                  //   users[index].id,
                                  //   style: GoogleFonts.montserrat(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontStyle: FontStyle.normal,
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (playListSnapshot.data!.isNotEmpty) {
                  bool isLoading = playListSnapshot.data!.isEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 0,),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Greetings from",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.country,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.arrow_forward_outlined),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      isLoading
                          ? SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: const [
                                        ShimmerWidget.rectangularCircular(
                                            width: 100, height: 100),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 70, height: 12),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 50, height: 12)
                                        // Text(
                                        //   users[index].id,
                                        //   style: GoogleFonts.montserrat(
                                        //     fontSize: 14,
                                        //     color: Colors.grey,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontStyle: FontStyle.normal,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: playListSnapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlaylistPage(
                                                    mangoPost: playListSnapshot
                                                        .data![index],
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 100,
                                            imageUrl: playListSnapshot
                                                .data![index].image,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.cover))),

                                            //     Material(
                                            //   borderRadius: BorderRadius.circular(50),
                                            //   elevation: 1,
                                            //   child: CircleAvatar(
                                            //     backgroundImage: imageProvider,
                                            //     radius: 50,
                                            //   ),
                                            // ),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget
                                                        .rectangularCircular(
                                                    width: 100, height: 100),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            playListSnapshot.data![index].title
                                                        .length >
                                                    15
                                                ? playListSnapshot
                                                        .data![index].title
                                                        .substring(0, 15) +
                                                    '...'
                                                : playListSnapshot
                                                    .data![index].title,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream: _userService.getUserInfo(
                                                  playListSnapshot.data![index]
                                                      .postCreator),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Text(
                                                      snapshot.data!.username,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12));
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  );
                } else {
                  print("List Null");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10),
                    padding: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.black),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                  'Be the first from ${snapshot.data!.country.isNotEmpty ? snapshot.data!.country : 'your country'} to put music in this space',
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
                                const Text(
                                  'No music here',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const CreatePlaylist()));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    "Let's go",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
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
                  );
                }
              });
        });
  }
}

class ByStateMusic extends StatelessWidget {
  const ByStateMusic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
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
        email: '',
        fcmToken: '',
        verified: false);

    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream:
            UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder<List<MangoPlaylist>>(
              initialData: const [],
              future: _postService
                  .getPlaylistByState(snapshot.data!.state),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MangoPlaylist>> playListSnapshot) {
                if (!playListSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!playListSnapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20, top: 0, bottom: 5),
                          child: ShimmerWidget.rectangular(
                              width: 120, height: 14)),
                      const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child:
                              ShimmerWidget.rectangular(width: 80, height: 12)),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: const [
                                  ShimmerWidget.rectangularCircular(
                                      width: 100, height: 100),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ShimmerWidget.rectangular(
                                      width: 70, height: 12),
                                  ShimmerWidget.rectangular(
                                      width: 50, height: 12)
                                  // Text(
                                  //   users[index].id,
                                  //   style: GoogleFonts.montserrat(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontStyle: FontStyle.normal,
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (playListSnapshot.data!.isNotEmpty) {
                  bool isLoading = playListSnapshot.data!.isEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 0,),
                            child: Text(
                              '${snapshot.data!.state} Vibes',
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.arrow_forward_outlined),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      isLoading
                          ? SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: const [
                                        ShimmerWidget.rectangularCircular(
                                            width: 100, height: 100),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 70, height: 12),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 50, height: 12)
                                        // Text(
                                        //   users[index].id,
                                        //   style: GoogleFonts.montserrat(
                                        //     fontSize: 14,
                                        //     color: Colors.grey,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontStyle: FontStyle.normal,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: playListSnapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlaylistPage(
                                                    mangoPost: playListSnapshot
                                                        .data![index],
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 100,
                                            imageUrl: playListSnapshot
                                                .data![index].image,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.cover))),

                                            //     Material(
                                            //   borderRadius: BorderRadius.circular(50),
                                            //   elevation: 1,
                                            //   child: CircleAvatar(
                                            //     backgroundImage: imageProvider,
                                            //     radius: 50,
                                            //   ),
                                            // ),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget
                                                        .rectangularCircular(
                                                    width: 100, height: 100),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            playListSnapshot.data![index].title
                                                        .length >
                                                    15
                                                ? playListSnapshot
                                                        .data![index].title
                                                        .substring(0, 15) +
                                                    '...'
                                                : playListSnapshot
                                                    .data![index].title,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream: _userService.getUserInfo(
                                                  playListSnapshot.data![index]
                                                      .postCreator),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Text(
                                                      snapshot.data!.username,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12));
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  );
                } else {
                  print("List Null");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10),
                    padding: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.black),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                  'Be the first from ${snapshot.data!.state.isNotEmpty ? snapshot.data!.state : 'your city'} to put music in this space',
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
                                const Text(
                                  'No music here',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const CreatePlaylist()));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    "Let's go",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
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
                  );
                }
              });
        });
  }
}

class ByCityMusic extends StatelessWidget {
  const ByCityMusic({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
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
        email: '',
        fcmToken: '',
        verified: false);

    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream:
            UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder<List<MangoPlaylist>>(
              initialData: const [],
              future: _postService
                  .getPlaylistByCountry(snapshot.data!.country),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MangoPlaylist>> playListSnapshot) {
                if (!playListSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!playListSnapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20, top: 0, bottom: 5),
                          child: ShimmerWidget.rectangular(
                              width: 120, height: 14)),
                      const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child:
                              ShimmerWidget.rectangular(width: 80, height: 12)),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: const [
                                  ShimmerWidget.rectangularCircular(
                                      width: 100, height: 100),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ShimmerWidget.rectangular(
                                      width: 70, height: 12),
                                  ShimmerWidget.rectangular(
                                      width: 50, height: 12)
                                  // Text(
                                  //   users[index].id,
                                  //   style: GoogleFonts.montserrat(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontStyle: FontStyle.normal,
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (playListSnapshot.data!.isNotEmpty) {
                  bool isLoading = playListSnapshot.data!.isEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Straight out of",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.city,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.arrow_forward_outlined),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      isLoading
                          ? SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: const [
                                        ShimmerWidget.rectangularCircular(
                                            width: 100, height: 100),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 70, height: 12),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 50, height: 12)
                                        // Text(
                                        //   users[index].id,
                                        //   style: GoogleFonts.montserrat(
                                        //     fontSize: 14,
                                        //     color: Colors.grey,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontStyle: FontStyle.normal,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: playListSnapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  PlaylistPage(
                                                    mangoPost: playListSnapshot
                                                        .data![index],
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 100,
                                            imageUrl: playListSnapshot
                                                .data![index].image,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.cover))),

                                            //     Material(
                                            //   borderRadius: BorderRadius.circular(50),
                                            //   elevation: 1,
                                            //   child: CircleAvatar(
                                            //     backgroundImage: imageProvider,
                                            //     radius: 50,
                                            //   ),
                                            // ),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget
                                                        .rectangularCircular(
                                                    width: 100, height: 100),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            playListSnapshot.data![index].title
                                                        .length >
                                                    15
                                                ? playListSnapshot
                                                        .data![index].title
                                                        .substring(0, 15) +
                                                    '...'
                                                : playListSnapshot
                                                    .data![index].title,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream: _userService.getUserInfo(
                                                  playListSnapshot.data![index]
                                                      .postCreator),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Text(
                                                      snapshot.data!.username,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12));
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  );
                } else {
                  print("List Null");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10),
                    padding: const EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.black),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                                  'Be the first from ${snapshot.data!.city.isNotEmpty ? snapshot.data!.city : 'your city'} to put music in this space',
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
                                const Text(
                                  'No music here',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const CreatePlaylist()));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    "Let's go",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
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
                  );
                }
              });
        });
  }
}

class ByProfessionBooks extends StatelessWidget {
  const ByProfessionBooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
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
        email: '',
        fcmToken: '',
        verified: false);

    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream:
            UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder<List<MangoLibrary>>(
              initialData: const [],
              future: _postService
                  .getBooksByProfession(snapshot.data!.profession),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MangoLibrary>> playListSnapshot) {
                if (!playListSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!playListSnapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20, top: 0, bottom: 5),
                          child: ShimmerWidget.rectangular(
                              width: 120, height: 14)),
                      const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child:
                              ShimmerWidget.rectangular(width: 80, height: 12)),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: const [
                                  ShimmerWidget.rectangularCircular(
                                      width: 100, height: 100),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ShimmerWidget.rectangular(
                                      width: 70, height: 12),
                                  ShimmerWidget.rectangular(
                                      width: 50, height: 12)
                                  // Text(
                                  //   users[index].id,
                                  //   style: GoogleFonts.montserrat(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontStyle: FontStyle.normal,
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (playListSnapshot.data!.isNotEmpty) {
                  bool isLoading = playListSnapshot.data!.isEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "What other",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.profession,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 18,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                Text('are listening to',
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.arrow_forward_outlined),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      isLoading
                          ? SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: const [
                                        ShimmerWidget.rectangularCircular(
                                            width: 100, height: 100),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 70, height: 12),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 50, height: 12)
                                        // Text(
                                        //   users[index].id,
                                        //   style: GoogleFonts.montserrat(
                                        //     fontSize: 14,
                                        //     color: Colors.grey,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontStyle: FontStyle.normal,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: playListSnapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookDetail(
                                                    mangoLibrary: playListSnapshot
                                                        .data![index],
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 100,
                                            imageUrl: playListSnapshot
                                                .data![index].image,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.cover))),

                                            //     Material(
                                            //   borderRadius: BorderRadius.circular(50),
                                            //   elevation: 1,
                                            //   child: CircleAvatar(
                                            //     backgroundImage: imageProvider,
                                            //     radius: 50,
                                            //   ),
                                            // ),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget
                                                        .rectangularCircular(
                                                    width: 100, height: 100),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            playListSnapshot.data![index].title
                                                        .length >
                                                    15
                                                ? playListSnapshot
                                                        .data![index].title
                                                        .substring(0, 15) +
                                                    '...'
                                                : playListSnapshot
                                                    .data![index].title,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream: _userService.getUserInfo(
                                                  playListSnapshot.data![index]
                                                      .postCreator),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Text(
                                                      snapshot.data!.username,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12));
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  );
                } else {
                  print("List Null");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10),
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.black),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              children: const [
                                Text(
                                  'Be the first to put a book in this space',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'No book here',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const AddBook()));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    "Let's go",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
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
                  );
                }
              });
        });
  }
}

class ByCountryBooks extends StatelessWidget {
  const ByCountryBooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
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
        email: '',
        fcmToken: '',
        verified: false);

    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream:
            UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder<List<MangoLibrary>>(
              initialData: const [],
              future: _postService
                  .getBooksByCountry(snapshot.data!.country),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MangoLibrary>> playListSnapshot) {
                if (!playListSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!playListSnapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20, top: 0, bottom: 5),
                          child: ShimmerWidget.rectangular(
                              width: 120, height: 14)),
                      const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child:
                              ShimmerWidget.rectangular(width: 80, height: 12)),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: const [
                                  ShimmerWidget.rectangularCircular(
                                      width: 100, height: 100),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ShimmerWidget.rectangular(
                                      width: 70, height: 12),
                                  ShimmerWidget.rectangular(
                                      width: 50, height: 12)
                                  // Text(
                                  //   users[index].id,
                                  //   style: GoogleFonts.montserrat(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontStyle: FontStyle.normal,
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (playListSnapshot.data!.isNotEmpty) {
                  bool isLoading = playListSnapshot.data!.isEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 0,),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Greetings from",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.country,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.arrow_forward_outlined),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      isLoading
                          ? SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: const [
                                        ShimmerWidget.rectangularCircular(
                                            width: 100, height: 100),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 70, height: 12),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 50, height: 12)
                                        // Text(
                                        //   users[index].id,
                                        //   style: GoogleFonts.montserrat(
                                        //     fontSize: 14,
                                        //     color: Colors.grey,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontStyle: FontStyle.normal,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: playListSnapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookDetail(
                                                    mangoLibrary: playListSnapshot
                                                        .data![index],
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 100,
                                            imageUrl: playListSnapshot
                                                .data![index].image,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.cover))),

                                            //     Material(
                                            //   borderRadius: BorderRadius.circular(50),
                                            //   elevation: 1,
                                            //   child: CircleAvatar(
                                            //     backgroundImage: imageProvider,
                                            //     radius: 50,
                                            //   ),
                                            // ),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget
                                                        .rectangularCircular(
                                                    width: 100, height: 100),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            playListSnapshot.data![index].title
                                                        .length >
                                                    15
                                                ? playListSnapshot
                                                        .data![index].title
                                                        .substring(0, 15) +
                                                    '...'
                                                : playListSnapshot
                                                    .data![index].title,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream: _userService.getUserInfo(
                                                  playListSnapshot.data![index]
                                                      .postCreator),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Text(
                                                      snapshot.data!.username,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12));
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  );
                } else {
                  print("List Null");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10),
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.black),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              children: const [
                                Text(
                                  'Be the first to put a book in this space',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'No book here',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const AddBook()));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    "Let's go",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
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
                  );
                }
              });
        });
  }
}

class ByStateBooks extends StatelessWidget {
  const ByStateBooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
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
        email: '',
        fcmToken: '',
        verified: false);

    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream:
            UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder<List<MangoLibrary>>(
              initialData: const [],
              future: _postService
                  .getBooksByState(snapshot.data!.state),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MangoLibrary>> playListSnapshot) {
                if (!playListSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!playListSnapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20, top: 0, bottom: 5),
                          child: ShimmerWidget.rectangular(
                              width: 120, height: 14)),
                      const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child:
                              ShimmerWidget.rectangular(width: 80, height: 12)),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: const [
                                  ShimmerWidget.rectangularCircular(
                                      width: 100, height: 100),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ShimmerWidget.rectangular(
                                      width: 70, height: 12),
                                  ShimmerWidget.rectangular(
                                      width: 50, height: 12)
                                  // Text(
                                  //   users[index].id,
                                  //   style: GoogleFonts.montserrat(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontStyle: FontStyle.normal,
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (playListSnapshot.data!.isNotEmpty) {
                  bool isLoading = playListSnapshot.data!.isEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 0,),
                            child: Text(
                              '${snapshot.data!.state} Vibes',
                              style: GoogleFonts.montserrat(
                                fontSize: 24,
                                fontWeight: FontWeight.w600,
                                fontStyle: FontStyle.normal,
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.arrow_forward_outlined),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      isLoading
                          ? SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: const [
                                        ShimmerWidget.rectangularCircular(
                                            width: 100, height: 100),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 70, height: 12),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 50, height: 12)
                                        // Text(
                                        //   users[index].id,
                                        //   style: GoogleFonts.montserrat(
                                        //     fontSize: 14,
                                        //     color: Colors.grey,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontStyle: FontStyle.normal,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: playListSnapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookDetail(
                                                    mangoLibrary: playListSnapshot
                                                        .data![index],
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 100,
                                            imageUrl: playListSnapshot
                                                .data![index].image,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.cover))),

                                            //     Material(
                                            //   borderRadius: BorderRadius.circular(50),
                                            //   elevation: 1,
                                            //   child: CircleAvatar(
                                            //     backgroundImage: imageProvider,
                                            //     radius: 50,
                                            //   ),
                                            // ),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget
                                                        .rectangularCircular(
                                                    width: 100, height: 100),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            playListSnapshot.data![index].title
                                                        .length >
                                                    15
                                                ? playListSnapshot
                                                        .data![index].title
                                                        .substring(0, 15) +
                                                    '...'
                                                : playListSnapshot
                                                    .data![index].title,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream: _userService.getUserInfo(
                                                  playListSnapshot.data![index]
                                                      .postCreator),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Text(
                                                      snapshot.data!.username,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12));
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  );
                } else {
                  print("List Null");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10),
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.black),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              children: const [
                                Text(
                                  'Be the first to put a book in this space',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                      'No book here',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const AddBook()));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    "Let's go",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
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
                  );
                }
              });
        });
  }
}

class ByCityBooks extends StatelessWidget {
  const ByCityBooks({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
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
        email: '',
        fcmToken: '',
        verified: false);

    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream:
            UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          return FutureBuilder<List<MangoLibrary>>(
              initialData: const [],
              future: _postService
                  .getBooksByCountry(snapshot.data!.country),
              builder: (BuildContext context,
                  AsyncSnapshot<List<MangoLibrary>> playListSnapshot) {
                if (!playListSnapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
                if (!playListSnapshot.hasData) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                          padding: EdgeInsets.only(left: 20, top: 0, bottom: 5),
                          child: ShimmerWidget.rectangular(
                              width: 120, height: 14)),
                      const Padding(
                          padding: EdgeInsets.only(left: 20, bottom: 20),
                          child:
                              ShimmerWidget.rectangular(width: 80, height: 12)),
                      SizedBox(
                        height: 140,
                        child: ListView.builder(
                          itemCount: 4,
                          scrollDirection: Axis.horizontal,
                          shrinkWrap: true,
                          itemBuilder: (BuildContext context, int index) {
                            return Container(
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 10),
                              child: Column(
                                children: const [
                                  ShimmerWidget.rectangularCircular(
                                      width: 100, height: 100),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  ShimmerWidget.rectangular(
                                      width: 70, height: 12),
                                  ShimmerWidget.rectangular(
                                      width: 50, height: 12)
                                  // Text(
                                  //   users[index].id,
                                  //   style: GoogleFonts.montserrat(
                                  //     fontSize: 14,
                                  //     color: Colors.grey,
                                  //     fontWeight: FontWeight.w500,
                                  //     fontStyle: FontStyle.normal,
                                  //   ),
                                  // )
                                ],
                              ),
                            );
                          },
                        ),
                      )
                    ],
                  );
                } else if (playListSnapshot.data!.isNotEmpty) {
                  bool isLoading = playListSnapshot.data!.isEmpty;

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Straight out of",
                                  style: GoogleFonts.montserrat(
                                    fontSize: 14,
                                    color: Colors.grey,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                                Text(
                                  snapshot.data!.city,
                                  style: GoogleFonts.montserrat(
                                    fontSize: 24,
                                    fontWeight: FontWeight.w600,
                                    fontStyle: FontStyle.normal,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              // Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
                            },
                            child: const Padding(
                              padding: EdgeInsets.only(right: 20),
                              child: Icon(Icons.arrow_forward_outlined),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30,),
                      isLoading
                          ? SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: 4,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return Container(
                                    margin: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Column(
                                      children: const [
                                        ShimmerWidget.rectangularCircular(
                                            width: 100, height: 100),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 70, height: 12),
                                        SizedBox(
                                          height: 5,
                                        ),
                                        ShimmerWidget.rectangularCircular(
                                            width: 50, height: 12)
                                        // Text(
                                        //   users[index].id,
                                        //   style: GoogleFonts.montserrat(
                                        //     fontSize: 14,
                                        //     color: Colors.grey,
                                        //     fontWeight: FontWeight.w500,
                                        //     fontStyle: FontStyle.normal,
                                        //   ),
                                        // )
                                      ],
                                    ),
                                  );
                                },
                              ),
                            )
                          : SizedBox(
                              height: 140,
                              child: ListView.builder(
                                itemCount: playListSnapshot.data!.length,
                                scrollDirection: Axis.horizontal,
                                shrinkWrap: true,
                                itemBuilder: (BuildContext context, int index) {
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  BookDetail(
                                                    mangoLibrary: playListSnapshot
                                                        .data![index],
                                                  )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(
                                          horizontal: 10),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 100,
                                            imageUrl: playListSnapshot
                                                .data![index].image,
                                            imageBuilder: (context,
                                                    imageProvider) =>
                                                Container(
                                                    height: 100,
                                                    width: 100,
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(10),
                                                        boxShadow: [
                                                          BoxShadow(
                                                            color: Colors.grey
                                                                .withOpacity(
                                                                    0.2),
                                                            spreadRadius: 2,
                                                            blurRadius: 1,
                                                            offset: const Offset(
                                                                0,
                                                                1), // changes position of shadow
                                                          ),
                                                        ],
                                                        image: DecorationImage(
                                                            image:
                                                                imageProvider,
                                                            fit:
                                                                BoxFit.cover))),

                                            //     Material(
                                            //   borderRadius: BorderRadius.circular(50),
                                            //   elevation: 1,
                                            //   child: CircleAvatar(
                                            //     backgroundImage: imageProvider,
                                            //     radius: 50,
                                            //   ),
                                            // ),
                                            placeholder: (context, url) =>
                                                const ShimmerWidget
                                                        .rectangularCircular(
                                                    width: 100, height: 100),
                                            errorWidget:
                                                (context, url, error) =>
                                                    const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            playListSnapshot.data![index].title
                                                        .length >
                                                    15
                                                ? playListSnapshot
                                                        .data![index].title
                                                        .substring(0, 15) +
                                                    '...'
                                                : playListSnapshot
                                                    .data![index].title,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 14,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                          ),
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream: _userService.getUserInfo(
                                                  playListSnapshot.data![index]
                                                      .postCreator),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?>
                                                      snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child:
                                                        CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Text(
                                                      snapshot.data!.username,
                                                      style: const TextStyle(
                                                          color: Colors.grey,
                                                          fontWeight:
                                                              FontWeight.bold,
                                                          fontSize: 12));
                                                }
                                              }),
                                        ],
                                      ),
                                    ),
                                  );
                                },
                              ),
                            )
                    ],
                  );
                } else {
                  print("List Null");
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    height: 80,
                    margin: const EdgeInsets.only(
                        left: 20,
                        right: 20,
                        bottom: 10,
                        top: 10),
                    padding: EdgeInsets.only(left: 15),
                    decoration: BoxDecoration(
                        borderRadius:
                        BorderRadius.circular(10),
                        color: Colors.black),
                    child: Row(
                      crossAxisAlignment:
                      CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
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
                              children: const [
                                Text(
                                  'Be the first to put a book in this space',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 12,
                                    fontWeight:
                                    FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  'No book here',
                                  style: TextStyle(
                                    color: Colors.grey,
                                    fontSize: 10,
                                    fontWeight:
                                    FontWeight.w700,
                                  ),
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 15.0),
                          child: InkWell(
                            onTap: () {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) => const AddBook()));
                            },
                            child: Container(
                              padding: const EdgeInsets.only(
                                  left: 8, right: 8, top: 2, bottom: 2),
                              height: 30,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(30),
                                color: Colors.white,
                              ),
                              child: Row(
                                children: const <Widget>[
                                  Text(
                                    "Let's go",
                                    style: TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.bold),
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
                  );
                }
              });
        });
  }
}

class TagsWidget extends StatelessWidget {
  const TagsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
    final UserService _userService = UserService();

    return FutureBuilder<String>(
        future: category(),
        builder: (context, snapshot) {
          var category = snapshot.data;
          if (!snapshot.hasData) {
            return Container();
          } // This container can be a loading screen, since its waiting for data.
          if (snapshot.data!.isNotEmpty) {
            return FutureBuilder<List<String>>(
                future: interestList(category!),
                builder: (context, snapshot2) {
                  var interest = snapshot2.data;
                  if (!snapshot2.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 0, bottom: 5),
                            child: ShimmerWidget.rectangular(
                                width: 120, height: 14)),
                        const Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 20),
                            child: ShimmerWidget.rectangular(
                                width: 80, height: 12)),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: const [
                                    ShimmerWidget.rectangularCircular(
                                        width: 100, height: 100),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ShimmerWidget.rectangular(
                                        width: 70, height: 12),
                                    ShimmerWidget.rectangular(
                                        width: 50, height: 12)
                                    // Text(
                                    //   users[index].id,
                                    //   style: GoogleFonts.montserrat(
                                    //     fontSize: 14,
                                    //     color: Colors.grey,
                                    //     fontWeight: FontWeight.w500,
                                    //     fontStyle: FontStyle.normal,
                                    //   ),
                                    // )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } // This container can be a loading screen, since its waiting for data.

                  if (snapshot2.data!.isNotEmpty) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(
                              left: 20, top: 20, bottom: 5),
                          child: Text(
                            'Tags you follow',
                            style: GoogleFonts.montserrat(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              fontStyle: FontStyle.normal,
                            ),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.only(left: 20, top: 20),
                          height: 70,
                          child: FutureProvider.value(
                            value: _postService.discoverPlaylistsByInterest(
                                category, interest),
                            initialData: const <MangoPlaylist>[],
                            child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount: interest?.length,
                                itemBuilder: (context, index) {
                                  return tagChip(
                                    tagModel: interest![index],
                                    action: 'Explore',
                                    context: context,
                                  );
                                }),
                            // Wrap(
                            // alignment: WrapAlignment.start,
                            // children: widget.mangoLibrary.tags.map((tagModel) => tagChip(
                            // tagModel: tagModel,
                            // action: 'Explore',
                            // )),
                            // TagListWidget(
                            //   title: "Tags you follow",
                            //   subtitle: "from $category",
                            // ),
                          ),
                        ),
                      ],
                    );
                  } else {
                    print("List Null");
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                          top: 10),
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10),
                          color: Colors.black),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                children: const [
                                  Text(
                                    'Select interests to tailor your Mango experience',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'You have no interest selected',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => Interests(uid: FirebaseAuth.instance.currentUser!.uid)));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 2, bottom: 2),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: const <Widget>[
                                    Text(
                                      "Let's go",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
                    );
                  }
                });
          } else {
            print("List Null");
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                  top: 10),
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10),
                  color: Colors.black),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        children: const [
                          Text(
                            'Select interests to tailor your Mango experience',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'You have no interest selected',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Interests(uid: FirebaseAuth.instance.currentUser!.uid)));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: const <Widget>[
                            Text(
                              "Let's go",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
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
            );
          }
        });
  }

  Widget tagChip({
    tagModel,
    action,
    context,
  }) {
    return InkWell(
        onTap: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => TagsPage(tag: tagModel))),
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 5.0,
            horizontal: 5.0,
          ),
          child: Container(
            alignment: Alignment.center,
            padding: const EdgeInsets.symmetric(
              horizontal: 10.0,
              vertical: 10.0,
            ),
            decoration: BoxDecoration(
              color: Colors.green,
              borderRadius: BorderRadius.circular(100.0),
            ),
            child: Center(
              child: Text(
                tagModel,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
        ));
  }
}

class RecentEventsWidget extends StatelessWidget {
  const RecentEventsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();

    return FutureBuilder<String>(
        future: category(),
        builder: (context, snapshot) {
          var category = snapshot.data;
          if (!snapshot.hasData) {
            return Container();
          } // This container can be a loading screen, since its waiting for data.
          if (snapshot.data!.isNotEmpty) {
            return FutureBuilder<String>(
                future: interest(category!),
                builder: (context, snapshot2) {
                  var interest = snapshot2.data;
                  if (!snapshot2.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 0, bottom: 20),
                            child: ShimmerWidget.rectangularCircular(
                                width: 120, height: 14)),
                        Container(
                          height: 100,
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: const [
                                    ShimmerWidget.rectangularCircular(
                                        width: 100, height: 80),
                                    // Text(
                                    //   users[index].id,
                                    //   style: GoogleFonts.montserrat(
                                    //     fontSize: 14,
                                    //     color: Colors.grey,
                                    //     fontWeight: FontWeight.w500,
                                    //     fontStyle: FontStyle.normal,
                                    //   ),
                                    // )
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } // This container can be a loading screen, since its waiting for data.

                  if (snapshot2.data!.isNotEmpty) {
                    return SizedBox(
                      child: StreamProvider.value(
                        value: _postService.getRecentEvents(),
                        initialData: const <RecentEvent>[],
                        child: const FilterWidgets(),
                      ),
                    );
                  } else {
                    print("List Null");print("List Null");
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                          top: 10),
                      padding: EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10),
                          color: Colors.black),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                children: const [
                                  Text(
                                    'You\'ve had no recent activity',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight:
                                      FontWeight.bold,
                                    ),
                                  ),
                                  SizedBox(
                                    height: 5,
                                  ),
                                  Text(
                                    'Do more with Mango, find and discover new \nbooks and music within your space',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),

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
                    );
                  }
                });
          } else {
            return  Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                  top: 10),
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10),
                  color: Colors.black),
              child: const Center(
                child: Text(
                  'Something went wrong',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),
              ),
            );
          }
        });
  }
}

class FilterWidgets extends StatelessWidget {
  const FilterWidgets({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        id: '',
        password: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        dob: '',
        gender: '',
        profileImage: '',
        email: '',
        fcmToken: '',
        verified: false);

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

    final MangoPlaylist _playlist = MangoPlaylist(
        reply: false,
        replyCount: 0,
        originalID: '',
        repost: false,
        repostCount: 0,
        likeCount: 0,
        tags: [],
        title: '',
        text: '',
        link: '',
        postCreator: '',
        image: '',
        timeStamp: Timestamp.fromMillisecondsSinceEpoch(3),
        id: '',
        plays: 0);

    final event = Provider.of<List<RecentEvent>>(context);
    bool isLoading = event.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0, bottom: 5),
                  child: Text(
                    'Get back in',
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        isLoading
            ? Container(
                height: 100,
                padding: const EdgeInsets.only(left: 20, top: 20),
                child: ListView.builder(
                  itemCount: 4,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: const [
                          ShimmerWidget.rectangularCircular(
                              width: 100, height: 80),
                          // Text(
                          //   users[index].id,
                          //   style: GoogleFonts.montserrat(
                          //     fontSize: 14,
                          //     color: Colors.grey,
                          //     fontWeight: FontWeight.w500,
                          //     fontStyle: FontStyle.normal,
                          //   ),
                          // )
                        ],
                      ),
                    );
                  },
                ),
              )
            : Container(
                height: 90,
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: ListView.builder(
                  itemCount: event.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    if (event[index].type == 'playlist') {
                      return StreamBuilder<MangoPlaylist?>(
                          initialData: _playlist,
                          stream: PostService()
                              .getPlaylistWithId(event[index].recentId),
                          builder: (BuildContext context,
                              AsyncSnapshot<MangoPlaylist?> playListSnapshot) {
                            print(playListSnapshot.data!.image);
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
                                        builder: (context) => PlaylistPage(
                                              mangoPost: playListSnapshot.data!,
                                            )));
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding:
                                    const EdgeInsets.only(left: 10, right: 15),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      height: 50,
                                      imageUrl: playListSnapshot.data!.image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 2,
                                                      blurRadius: 1,
                                                      offset: const Offset(0,
                                                          1), // changes position of shadow
                                                    ),
                                                  ],
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover))),

                                      //     Material(
                                      //   borderRadius: BorderRadius.circular(50),
                                      //   elevation: 1,
                                      //   child: CircleAvatar(
                                      //     backgroundImage: imageProvider,
                                      //     radius: 50,
                                      //   ),
                                      // ),
                                      placeholder: (context, url) =>
                                          const ShimmerWidget
                                                  .rectangularCircular(
                                              width: 50, height: 50),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          playListSnapshot.data!.title.length >
                                                  25
                                              ? playListSnapshot.data!.title
                                                      .substring(0, 25) +
                                                  '...'
                                              : playListSnapshot.data!.title,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        StreamBuilder<MangoUser?>(
                                            initialData: _user,
                                            stream: UserService().getUserInfo(
                                                playListSnapshot
                                                        .data!.postCreator),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<MangoUser?>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else {
                                                return Text(
                                                    snapshot.data!.username,
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12));
                                              }
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else if (event[index].type == 'book') {
                      return StreamBuilder<MangoLibrary?>(
                          initialData: _library,
                          stream: PostService()
                              .getBookWithId(event[index].recentId),
                          builder: (BuildContext context,
                              AsyncSnapshot<MangoLibrary?> librarySnapshot) {
                            if (!librarySnapshot.hasData) {
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
                                                  librarySnapshot.data!,
                                            )));
                              },
                              child: Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                padding:
                                    const EdgeInsets.only(left: 10, right: 15),
                                decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(10)),
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    CachedNetworkImage(
                                      height: 50,
                                      imageUrl: librarySnapshot.data!.image,
                                      imageBuilder: (context, imageProvider) =>
                                          Container(
                                              height: 50,
                                              width: 40,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(10),
                                                  boxShadow: [
                                                    BoxShadow(
                                                      color: Colors.grey
                                                          .withOpacity(0.2),
                                                      spreadRadius: 2,
                                                      blurRadius: 1,
                                                      offset: const Offset(0,
                                                          1), // changes position of shadow
                                                    ),
                                                  ],
                                                  image: DecorationImage(
                                                      image: imageProvider,
                                                      fit: BoxFit.cover))),

                                      //     Material(
                                      //   borderRadius: BorderRadius.circular(50),
                                      //   elevation: 1,
                                      //   child: CircleAvatar(
                                      //     backgroundImage: imageProvider,
                                      //     radius: 50,
                                      //   ),
                                      // ),
                                      placeholder: (context, url) =>
                                          const ShimmerWidget
                                                  .rectangularCircular(
                                              width: 40, height: 50),
                                      errorWidget: (context, url, error) =>
                                          const Icon(Icons.error),
                                    ),
                                    const SizedBox(
                                      width: 10,
                                    ),
                                    Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          librarySnapshot.data!.title.length >
                                                  25
                                              ? librarySnapshot.data!.title
                                                      .substring(0, 25) +
                                                  '...'
                                              : librarySnapshot.data!.title,
                                          style: GoogleFonts.montserrat(
                                            fontSize: 14,
                                            color: Colors.white,
                                            fontWeight: FontWeight.w500,
                                            fontStyle: FontStyle.normal,
                                          ),
                                        ),
                                        StreamBuilder<MangoUser?>(
                                            initialData: _user,
                                            stream: UserService().getUserInfo(
                                                librarySnapshot
                                                        .data!.postCreator),
                                            builder: (BuildContext context,
                                                AsyncSnapshot<MangoUser?>
                                                    snapshot) {
                                              if (!snapshot.hasData) {
                                                return const Center(
                                                  child:
                                                      CircularProgressIndicator(),
                                                );
                                              } else {
                                                return Text(
                                                    snapshot.data!.username,
                                                    style: const TextStyle(
                                                        color: Colors.grey,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 12));
                                              }
                                            }),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            );
                          });
                    } else {
                      return Container();
                    }
                  },
                ),
              )
      ],
    );
  }
}

class MostListenedPlayListWidget extends StatelessWidget {
  const MostListenedPlayListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
    final UserService _userService = UserService();

    return SizedBox(
      child: StreamProvider.value(
        value: _postService.mostPlayedMusic(),
        initialData: const <MangoPlaylist>[],
        child: const SquarePlaylistWidget(
          title: "What's Trending",
          subtitle: "what's everybody vibing to",
        ),
      ),
    );
  }
}

class MostReadBooksWidget extends StatelessWidget {
  const MostReadBooksWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();

    return SizedBox(
      child: StreamProvider.value(
        initialData: const <MangoLibrary>[],
        value: _postService.mostReadBooks(),
        child: const BookListWidget(
          title: 'Top Reads',
          subtitle: "the most read books",
        ),
      ),
    );
  }
}

class BookWidget extends StatelessWidget {
  const BookWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final PostService _postService = PostService();
    final UserService _userService = UserService();

    return FutureBuilder<String>(
        future: category(),
        builder: (context, snapshot) {
          var category = snapshot.data;
          if (!snapshot.hasData) {
            return Container();
          } // This container can be a loading screen, since its waiting for data.
          if (snapshot.data!.isNotEmpty) {
            return FutureBuilder<String>(
                future: interest(category!),
                builder: (context, snapshot2) {
                  var interest = snapshot2.data;
                  if (!snapshot2.hasData) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Padding(
                            padding:
                                EdgeInsets.only(left: 20, top: 0, bottom: 5),
                            child: ShimmerWidget.rectangular(
                                width: 120, height: 14)),
                        const Padding(
                            padding: EdgeInsets.only(left: 20, bottom: 20),
                            child: ShimmerWidget.rectangular(
                                width: 80, height: 12)),
                        SizedBox(
                          height: 140,
                          child: ListView.builder(
                            itemCount: 4,
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true,
                            itemBuilder: (BuildContext context, int index) {
                              return Container(
                                margin:
                                    const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: const [
                                    ShimmerWidget.rectangularCircular(
                                        width: 100, height: 100),
                                    SizedBox(
                                      height: 5,
                                    ),
                                    ShimmerWidget.rectangular(
                                        width: 70, height: 12),
                                    ShimmerWidget.rectangular(
                                        width: 50, height: 12)
                                  ],
                                ),
                              );
                            },
                          ),
                        )
                      ],
                    );
                  } // This container can be a loading screen, since its waiting for data.

                  if (snapshot2.data!.isNotEmpty) {
                    return SizedBox(
                      child: FutureProvider.value(
                        initialData: const <MangoLibrary>[],
                        value: _postService.discoverLibraryByInterest(
                            category, interest),
                        child: BookChartWidget(
                          title: interest,
                          subtitle: "from $category",
                        ),
                      ),
                    );
                  } else {
                    print("List Null");
                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 80,
                      margin: const EdgeInsets.only(
                          left: 20,
                          right: 20,
                          bottom: 10,
                          top: 10),
                      padding: const EdgeInsets.only(left: 15),
                      decoration: BoxDecoration(
                          borderRadius:
                          BorderRadius.circular(10),
                          color: Colors.black),
                      child: Row(
                        crossAxisAlignment:
                        CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
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
                                    'Be the first to upload a book on $category',
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
                                  const Text(
                                    'No book here',
                                    style: TextStyle(
                                      color: Colors.grey,
                                      fontSize: 10,
                                      fontWeight:
                                      FontWeight.w700,
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15.0),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(context,
                                    MaterialPageRoute(builder: (context) => const AddBook()));
                              },
                              child: Container(
                                padding: const EdgeInsets.only(
                                    left: 8, right: 8, top: 2, bottom: 2),
                                height: 30,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Row(
                                  children: const <Widget>[
                                    Text(
                                      "Let's go",
                                      style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold),
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
                    );
                  }
                });
          } else {
            print("List Null");
            return Container(
              width: MediaQuery.of(context).size.width,
              height: 80,
              margin: const EdgeInsets.only(
                  left: 20,
                  right: 20,
                  bottom: 10,
                  top: 10),
              padding: EdgeInsets.only(left: 15),
              decoration: BoxDecoration(
                  borderRadius:
                  BorderRadius.circular(10),
                  color: Colors.black),
              child: Row(
                crossAxisAlignment:
                CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
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
                        children: const [
                          Text(
                            'Select interests to tailor your Mango experience',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 12,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),
                          SizedBox(
                            height: 5,
                          ),
                          Text(
                            'You have no interest selected',
                            style: TextStyle(
                              color: Colors.grey,
                              fontSize: 10,
                              fontWeight:
                              FontWeight.w700,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 15.0),
                    child: InkWell(
                      onTap: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Interests(uid: FirebaseAuth.instance.currentUser!.uid)));
                      },
                      child: Container(
                        padding: const EdgeInsets.only(
                            left: 8, right: 8, top: 2, bottom: 2),
                        height: 30,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(30),
                          color: Colors.white,
                        ),
                        child: Row(
                          children: const <Widget>[
                            Text(
                              "Let's go",
                              style: TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.bold),
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
            );
          }
        });
  }
}
