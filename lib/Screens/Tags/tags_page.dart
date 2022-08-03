import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:provider/provider.dart';

import '../../Models/customModel/library.dart';
import '../../Models/customModel/playlist.dart';
import '../../Models/widgets.dart';
import '../../constants.dart';

class TagsPage extends StatefulWidget {
  final String tag;
  const TagsPage({Key? key, required this.tag}) : super(key: key);

  @override
  State<TagsPage> createState() => _TagsPageState();
}

class _TagsPageState extends State<TagsPage> with SingleTickerProviderStateMixin {
  final PostService _postService = PostService();
  TabController? tabController;

  @override
  void initState() {
    // ignore: todo
    // TODO: implement initState
    super.initState();
    tabController = TabController(length: 2, vsync: this);
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Discover", style: kTitleTextStyle),
                    Text(widget.tag, style: headingextStyle),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              Container(
                height: size.height / 1.3,
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: Colors.black12,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 15.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      TabBar(
                        controller: tabController,
                        labelStyle: widgetTitleText2,
                        unselectedLabelStyle: textBody3,
                        indicator: BoxDecoration(
                            borderRadius: BorderRadius.circular(
                                50), // Creates border
                            color: Colors.grey),
                        tabs: const [
                          Tab(text: "Playlists"),
                          Tab(text: "Library")
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        height: size.height / 2,
                        // padding: const EdgeInsets.all(10),
                        child: TabBarView(
                          controller: tabController,
                          children: [
                            StreamProvider.value(
                                value: _postService
                                    .getPlaylistWithTags(widget.tag),
                                initialData: const <MangoPlaylist?>[],
                                child: const PlaylistGrid()),
                            StreamProvider.value(
                              value: _postService
                                  .getBookWithTags(widget.tag),
                              initialData: const <MangoLibrary?>[],
                              child: const LibraryGrid(),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ]),
      ),
    );
  }
}
