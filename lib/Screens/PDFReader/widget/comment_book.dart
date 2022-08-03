import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/Models/customModel/reply_books.dart';

import '../../../Models/cloud/post_services.dart';
import '../../../Models/customModel/library.dart';
import '../../../constants.dart';


class CommentBook extends StatefulWidget {
  final MangoLibrary mangoLibrary;
  const CommentBook({Key? key, required this.mangoLibrary}) : super(key: key);

  @override
  State<CommentBook> createState() => _CommentBookState();
}

class _CommentBookState extends State<CommentBook> {
  final TextEditingController titleController = TextEditingController();
  final bool isEmpty = true;
  bool picked = false;
  final PostService _postService = PostService();

  File? returnedFile;
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
            constraints: BoxConstraints(maxHeight: size.height / 2.6),
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
                      const Text(
                        "write comment",
                        style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 20,),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.black,
                              width: 2,
                            )
                        ),
                        child: TextField(
                          style: postTextBoxText,
                          maxLines: 3,
                          controller: titleController,
                          decoration: const InputDecoration(
                              border: InputBorder.none,
                              focusColor: Colors.orangeAccent,
                              hintText: 'How far na?',
                              hintStyle: postTextBoxHint),
                        ),
                      ),

                      picked ? Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          SizedBox(
                              height: 60,
                              width: 60,
                              child: Image.file(returnedFile!, fit: BoxFit.cover,)),
                        ],
                      ): const Text('no media selected'),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              IconButton(
                                icon: const Icon(Icons.photo_camera),
                                iconSize: 24,
                                onPressed: () => pickFromCamera(context),
                              ),
                              IconButton(
                                icon: const Icon(Icons.photo),
                                iconSize: 24,
                                onPressed: () => pickFromGallery(context),
                              ),
                            ],
                          ),
                          TextButton(
                            onPressed: () async {
                              _postService.commentBook(titleController.text.trim(), returnedFile, widget.mangoLibrary);
                              Navigator.pop(context);
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
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: const [
                                Text(
                                  "reply",
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
                                  Icons.message_outlined,
                                  color: Colors.white,
                                  size: 16,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
            ),
          ),
        ],
      ),
    );
  }

  Future pickFromGallery(BuildContext context) async{
    final getMedia = ImagePicker().pickImage;
    final media = await getMedia(source: ImageSource.gallery);
    final file = File(media!.path);
    setState(() {
      returnedFile = file;
      picked = true;
    });
  }

  Future pickFromCamera(BuildContext context) async{
    final getMedia = ImagePicker().pickImage;
    final media = await getMedia(source: ImageSource.camera);
    final file = File(media!.path);
    setState(() {
      returnedFile = file;
      picked = true;
    });
  }
}