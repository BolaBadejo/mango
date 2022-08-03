import 'dart:io';
import 'dart:typed_data';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Screens/Episodes/utils.dart';
import 'package:mango/Screens/Profile/profile.dart';
import 'package:mango/Services/filters.dart';

import 'dart:ui' as ui;

import 'package:path_provider/path_provider.dart';

class EpisodesWidget extends StatefulWidget {
  final Function(GlobalKey key) builder;

  const EpisodesWidget({Key? key, required this.builder}) : super(key: key);

  @override
  State<EpisodesWidget> createState() => _EpisodesWidgetState();
}

class _EpisodesWidgetState extends State<EpisodesWidget> {
  final globalKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return RepaintBoundary(
      key: globalKey,
      child: widget.builder(globalKey),
    );
  }
}


class EpisodeWidgets {
  previewEpisodeMeta(BuildContext context, File episodeMeta) {
    Size size = MediaQuery.of(context).size;
    final GlobalKey _globalKey = GlobalKey();
    final List<List<double>> filters = [ORIGINAL_MATRIX, SEPIA_MATRIX, GREYSCALE_MATRIX , VINTAGE_MATRIX, SWEET_MATRIX];
    final PostService _postService = PostService();
    GlobalKey? key1;
    Uint8List? bytes1;

    return showModalBottomSheet(
      isScrollControlled: true,
      context: context,
      builder: (context) => Scaffold(
        extendBodyBehindAppBar: true,
        body: Stack(
          children: [
            Center(
              child: EpisodesWidget(
                builder: (key) {
                  key1 = key;

                  return Container(
                    color: Colors.black,
                    constraints: BoxConstraints(
                      maxHeight: size.height,
                      maxWidth: size.width,
                    ),
                    child: PageView.builder(
                        itemCount: filters.length,
                        itemBuilder: (context, index){
                          return ColorFiltered(
                              colorFilter: ColorFilter.matrix(filters[index]),
                              child: Image.file(episodeMeta, width: size.width, ));
                        }),
                  );
                },
              ),
            ),
            Positioned(
              bottom: 10,
              child: Container(
                // margin: EdgeInsets.onl(vertical: 10),
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.download_outlined, color: Colors.white,),
                      iconSize: 30,
                      onPressed: () => null,
                    ),
                    IconButton(
                      icon: const Icon(Icons.add_a_photo, color: Colors.white,),
                      iconSize: 30,
                      onPressed: () => null,
                    ),
                  ],
                ),

              ),
            ),

            Positioned(
              right: 10,
              top: 25,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30),
                  color: Colors.black.withOpacity(0.3),
                ),
                // margin: EdgeInsets.onl(vertical: 10),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    IconButton(
                      icon: const Icon(Icons.text_fields_outlined, color: Colors.white,),
                      iconSize: 30,
                      onPressed: () => null,
                    ),
                    SizedBox(height: 15),
                    IconButton(
                      icon: const Icon(Icons.brush, color: Colors.white,),
                      iconSize: 30,
                      onPressed: () => null,
                    ),
                    SizedBox(height: 15),
                    IconButton(
                      icon: const Icon(Icons.attachment, color: Colors.white,),
                      iconSize: 30,
                      onPressed: () => null,
                    ),
                    SizedBox(height: 15),
                    IconButton(
                      icon: const Icon(Icons.multitrack_audio, color: Colors.white,),
                      iconSize: 30,
                      onPressed: () => null,
                    ),
                  ],
                ),

              ),
            )
          ],
        ),
        floatingActionButton: FloatingActionButton(
            onPressed: () async {
              print("we are here");
              final Uint8List bytes1 = await Utils.capture(key1!);
              _postService.saveEpisode(bytes1).whenComplete(() => Navigator.of(context).pop(MaterialPageRoute(
                  builder: (context) => ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid,
                  ))));
            },
            // onPressed: convertWidgetToImage,
            backgroundColor: Colors.orange,
            child: const Icon(Icons.send)

        ),
      ),
    );
  }
}

//

// Container(
// height: size.height,
// width: size.width,
// decoration: const BoxDecoration(
// color: Colors.black,
// ),
// child: Stack(
// children: [
// Container(
// height: size.height,
// width: size.width,
// child: Image.file(episodeMeta)),
// Positioned(
// top: 700,
// child: Container(
// width: size.width,
// child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
// children: [
// TextButton(
// autofocus: true,
// onPressed: (){},
// style: ButtonStyle(
// shape: MaterialStateProperty.all<
//     RoundedRectangleBorder>(
// RoundedRectangleBorder(
// borderRadius:
// BorderRadius.circular(
// 28.0),
// )),
// padding:
// MaterialStateProperty.all(
// const EdgeInsets
//     .symmetric(
// vertical: 10.0,
// horizontal: 20.0)),
// backgroundColor:
// MaterialStateProperty.all<
//     Color>(Colors.red),
// ),
// child: Row(mainAxisSize: MainAxisSize.min, children: const [
// Icon(
// Icons.cancel,
// color: Colors.white,
// size: 30,
// ),
// SizedBox(
// width: 5.0,
// ),
// Text(
// "Cancel",
// style: TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.w600,
// fontSize: 16),
// ),
// SizedBox(
// width: 10.0,
// ),
// ]),
// ),TextButton(
// autofocus: true,
// onPressed: (){},
// style: ButtonStyle(
// shape: MaterialStateProperty.all<
// RoundedRectangleBorder>(
// RoundedRectangleBorder(
// borderRadius:
// BorderRadius.circular(
// 28.0),
// )),
// padding:
// MaterialStateProperty.all(
// const EdgeInsets
//     .symmetric(
// vertical: 10.0,
// horizontal: 20.0)),
// backgroundColor:
// MaterialStateProperty.all<
// Color>(Colors.red),
// ),
// child: Row(mainAxisSize: MainAxisSize.min, children: const [
// Icon(
// Icons.upload_file,
// color: Colors.white,
// size: 30,
// ),
// SizedBox(
// width: 5.0,
// ),
// Text(
// "Upload",
// style: TextStyle(
// color: Colors.white,
// fontWeight: FontWeight.w600,
// fontSize: 16),
// ),
// SizedBox(
// width: 10.0,
// ),
// ]),
// ),
// ],
// ),
// ))
// ],
// ),
// ));
