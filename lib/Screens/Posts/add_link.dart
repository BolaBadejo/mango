import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/customModel/post.dart';
import 'package:provider/provider.dart';

import '../../Models/cloud/user_services.dart';
import '../../Models/customModel/library.dart';
import '../../Models/customModel/playlist.dart';
import '../../Models/customModel/user.dart';
import '../../constants.dart';
import '../Music/comment_playlist.dart';
import '../Music/playlist_page.dart';
import '../PDFReader/grid_books.dart';
import '../Widgets/list_playlist.dart';

class AddLink extends StatefulWidget {
  const AddLink({Key? key}) : super(key: key);

  @override
  State<AddLink> createState() => _AddLinkState();
}

class _AddLinkState extends State<AddLink> {
  final TextEditingController titleController = TextEditingController();
  final bool isEmpty = true;
  bool picked = false;
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      username: '',
      dob: '',
      id: '',
      password: '',
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

  File? returnedFile;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery
        .of(context)
        .size;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery
          .of(context)
          .viewInsets
          .bottom),
      child: DefaultTabController(
        length: 2,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container(
              height: 5,
              width: 120,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  )),
              constraints: BoxConstraints(maxHeight: size.height / 1.6),
              child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(40),
                    topRight: Radius.circular(40),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Row(
                        //   mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        //   children: [
                        //     Container(
                        //       width: (size.width / 2) - 30,
                        //       padding: const EdgeInsets.symmetric(vertical: 12),
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(25),
                        //           border: const Border(
                        //             bottom: BorderSide(color: Colors.black, width: 2),
                        //             top: BorderSide(color: Colors.black, width: 2),
                        //             left: BorderSide(color: Colors.black, width: 2),
                        //             right: BorderSide(color: Colors.black, width: 2),
                        //           ),
                        //           color: Colors.transparent
                        //       ),
                        //       child: const Text('Music', style: labelBody,),
                        //     ),
                        //     Container(
                        //       width: (size.width / 2) - 30,
                        //       padding: const EdgeInsets.symmetric(vertical: 12),
                        //       alignment: Alignment.center,
                        //       decoration: BoxDecoration(
                        //           borderRadius: BorderRadius.circular(25),
                        //           // border: Border(
                        //           //   bottom: BorderSide(color: Colors.black, width: 2),
                        //           //   top: BorderSide(color: Colors.black, width: 2),
                        //           //   left: BorderSide(color: Colors.black, width: 2),
                        //           //   right: BorderSide(color: Colors.black, width: 2),
                        //           // ),
                        //           color: Colors.transparent
                        //       ),
                        //       child: const Text('Books', style: labelBody,),
                        //     ),
                        //   ],
                        // ),
                        const TabBar(
                          // controller: ,
                          labelStyle:
                          widgetTitleText2,
                          unselectedLabelStyle:
                          textBody3,
                          tabs: [
                            Tab(
                                text:
                                "Playlists"),
                            Tab(
                                text:
                                "Library")
                          ],
                        ),
                        const SizedBox(height: 20,),
                        Container(
                          height: size.height / 2,
                          padding: const EdgeInsets.all(10),
                          child: TabBarView(children: [
                            StreamProvider.value(
                                value: _postService
                                    .getPlaylistsByUser(
                                    FirebaseAuth.instance.currentUser!.uid),
                                initialData: const <MangoPlaylist>[],
                                child: const ListPlaylist()),
                            StreamProvider.value(
                                value: _postService
                                    .getLibraryByUser(
                                    FirebaseAuth.instance.currentUser!.uid),
                                initialData: const <MangoLibrary>[],
                                child: LibraryGrid()),
                          ]),
                        ),
                      ],
                    ),
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

}
