import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/post.dart';
import 'package:mango/Screens/Posts/createpost.dart';
import 'package:mango/Screens/Widgets/listPost.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:mango/Models/cloud/post_services.dart';

class Feeds extends StatefulWidget {
  const Feeds({Key? key}) : super(key: key);

  @override
  _FeedsState createState() => _FeedsState();
}

class _FeedsState extends State<Feeds> with SingleTickerProviderStateMixin{
  AnimationController? _controller;

  bool _showAppbar = true; //this is to show app bar
  final ScrollController _scrollBottomBarController = ScrollController(); // set controller on scrolling
  bool isScrollingDown = false;
  bool _show = true;
  double bottomBarHeight = 75; // set bottom bar height
  double _bottomBarOffset = 0;
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  @override
  void initState() {
    super.initState();
    myScroll();
  }

  @override
  void dispose() {
    _scrollBottomBarController.removeListener(() {});
    super.dispose();
  }

  void showBottomBar() {
    setState(() {
      _show = true;
    });
  }

  void hideBottomBar() {
    setState(() {
      _show = false;
    });
  }

  void myScroll() async {
    _scrollBottomBarController.addListener(() {
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (!isScrollingDown) {
          isScrollingDown = true;
          _showAppbar = false;
          hideBottomBar();
        }
      }
      if (_scrollBottomBarController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (isScrollingDown) {
          isScrollingDown = false;
          _showAppbar = true;
          showBottomBar();
        }
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    double _height = MediaQuery.of(context).size.height;
    return MultiProvider(
      providers: [
        StreamProvider(
          initialData: const <MangoPost>[],
          create: (BuildContext context) {
            _postService
                .getPostsByEverybody(FirebaseAuth.instance.currentUser!.uid);
          },
        ),
      ],
      child: CustomScrollView(slivers: [
        SliverAppBar(
          expandedHeight: 0,
          automaticallyImplyLeading: false,
          backgroundColor: Colors.transparent,
          flexibleSpace: FlexibleSpaceBar(
            background: Column(
              children: [
                SafeArea(
                  child: Padding(
                    padding:
                        const EdgeInsets.only(left: 16, right: 16, top: 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          "Feeds",
                          style: TextStyle(
                              fontSize: 32, fontWeight: FontWeight.bold),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => CreatePost()));
                          },
                          child: Container(
                            padding: const EdgeInsets.only(
                                left: 8, right: 8, top: 2, bottom: 2),
                            height: 30,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(30),
                              color: Colors.pink[50],
                            ),
                            child: Row(
                              children: const <Widget>[
                                Icon(
                                  Icons.add,
                                  color: Colors.pink,
                                  size: 20,
                                ),
                                SizedBox(
                                  width: 2,
                                ),
                                Text(
                                  "Add New",
                                  style: TextStyle(
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        SliverToBoxAdapter(
          child: SizedBox(
            height: _height-100,
            child: StreamProvider.value(
                  value: _postService.getPostsByEverybody(FirebaseAuth.instance.currentUser!.uid),
                  initialData: const <MangoPost>[],
                  child: ListPost(scrollController: _scrollBottomBarController)),
            ),
          ),
      ]),
    );
  }
}
