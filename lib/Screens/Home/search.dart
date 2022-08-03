import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/library.dart';
import 'package:mango/Models/customModel/playlist.dart';
import 'package:mango/Models/customModel/post.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/PDFReader/grid_books.dart';
import 'package:mango/Screens/Widgets/listPost.dart';
import 'package:mango/Screens/Widgets/list_friends.dart';
import 'package:mango/Screens/Widgets/list_playlist.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  TabController? tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 4, vsync: this);
  }

  final UserService _userService = UserService();
  final PostService _postService = PostService();
  String wordSearchController = '';
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        StreamProvider(
    initialData: const <MangoUser>[],
            create: (BuildContext context) {
              _userService.getUserByName(wordSearchController);
            },
            ),
        StreamProvider(
          initialData: const <MangoLibrary>[],
          create: (BuildContext context) {
            _postService.getBooksByName(wordSearchController);
          },
        ),
        StreamProvider(
          initialData: const <MangoPlaylist>[],
          create: (BuildContext context) {
            _postService.getPlaylistsByName(wordSearchController);
          },
        ),
        StreamProvider(
          initialData: const <MangoPost>[],
          create: (BuildContext context) {
            _postService.getPostsByName(wordSearchController);
          },
        ),
      ],
      child: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            leading: const CloseButton(),
            title: Container(
              padding: const EdgeInsets.only(left: 15, right: 15),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  border: const Border(
                    bottom: BorderSide(color: Colors.grey, width: 2),
                    top: BorderSide(color: Colors.grey, width: 2),
                    left: BorderSide(color: Colors.grey, width: 2),
                    right: BorderSide(color: Colors.grey, width: 2),
                  )),
              child: TextField(
                style: textBoxText,
                onChanged: (text) {
                  setState(() {
                    wordSearchController = text;
                  });
                },
                decoration: const InputDecoration(
                    border: InputBorder.none,
                    focusColor: Colors.orangeAccent,
                    hintText: 'search',
                    hintStyle: textBoxHint),
              ),
            ),
            // actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.search))],
          ),
          body: Column(
            children: [
              const SizedBox(
                height: 55,
                child: TabBar(
                    indicatorColor: Colors.black,
                    indicatorWeight: 3.0,
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.grey,
                    labelStyle: widgetTitleText2,
                    unselectedLabelStyle: textBody3,
                    isScrollable: true,
                    tabs: <Widget>[
                      Tab(text: "Users"),
                      Tab(text: "Posts"),
                      Tab(text: "Libraries"),
                      Tab(text: "Playlists")
                    ]),
              ),
              Expanded(
                flex: 10,
                child: TabBarView(children: [
                  StreamProvider.value(
                      value: _userService.getUserByName(wordSearchController),
                      initialData: const <MangoUser>[],
                      child: const ListUsers()),
                  StreamProvider.value(
                      value: _postService.getPostsByName(wordSearchController),
                      initialData: const <MangoPost>[],
                      child: const ListPost()),
                  StreamProvider.value(
                      value: _postService.getBooksByName(wordSearchController),
                      initialData: const <MangoLibrary>[],
                      child: const LibraryGrid()),
                  StreamProvider.value(
                      value:
                          _postService.getPlaylistsByName(wordSearchController),
                      initialData: const <MangoPlaylist>[],
                      child: const ListPlaylist()),
                ]),
              )
            ],
          ),
        ),
      ),
    );
  }
}
