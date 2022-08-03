import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'dart:io';
import 'package:mango/Models/customModel/mediaSource.dart';

import '../../Models/customModel/user.dart';
import '../../Services/shimmer_widget.dart';
import '../../constants.dart';
import '../Profile/profile.dart';

class CreateEpisodes extends StatefulWidget {
  const CreateEpisodes({Key? key}) : super(key: key);

  @override
  _CreateEpisodesState createState() => _CreateEpisodesState();
}

class _CreateEpisodesState extends State<CreateEpisodes> {
  final TextEditingController titleController = TextEditingController();
  final bool isEmpty = true;
  bool picked = false;
  final PostService _postService = PostService();
  final UserService _userService = UserService();

  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      displayName: '',
      username: '',
      dob: '',
      id: '',
      password: '',
      gender: '',
      profileImage: '',
      email: '', fcmToken: '', verified: false);

  File? returnedFile;


  @override
  Widget build(BuildContext context) {
    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream: _userService.getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder:
            (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            shadowColor: Colors.transparent,
            leading: const CloseButton(),
            actions: [
              GestureDetector(
                onTap: () async {
                  UserService().sendNotificationToTopic("@${snapshot.data!.username} has just shared a new episode", "New Episode!!", snapshot.data!.id);
                  // _postService.savePost(titleController.text.trim(), returnedFile);
                  Navigator.pop(context);
                },
                child: Container(
                  alignment: Alignment.center,
                  margin: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                  padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(25), color: Colors.black),
                  child: const Text(
                    'POST',
                    style: labelBody_,
                  ),
                ),
              )
            ],
          ),
          body: SingleChildScrollView(
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid,)));
                    },
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Row(
                            children:  [
                              CachedNetworkImage(
                                height: 28,
                                imageUrl:
                                snapshot.data?.profileImage ??
                                    '',
                                imageBuilder:
                                    (context, imageProvider) =>
                                    Material(
                                      borderRadius:
                                      BorderRadius.circular(50),
                                      // elevation: 1,
                                      child: CircleAvatar(
                                        backgroundImage: imageProvider,
                                        radius: 14,
                                      ),
                                    ),
                                placeholder: (context, url) =>
                                ShimmerWidget.circular(width: 28, height: 28),
                                errorWidget:
                                    (context, url, error) =>
                                const Icon(Icons.error),
                              ),
                              const SizedBox(
                                width: 5,
                              ),
                              Text(
                                snapshot.data!.displayName,
                                style: const TextStyle(
                                  color: Colors.black,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w900,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextField(
                    style: postTextBoxText,
                    maxLines: 3,
                    controller: titleController,
                    decoration: const InputDecoration(
                        border: InputBorder.none,
                        focusColor: Colors.orangeAccent,
                        hintText: 'How far na?',
                        hintStyle: postTextBoxHint),
                  ),
                  // SizedBox(
                  //   height: 10,
                  // ),
                  picked ? Image.file(returnedFile!): const Text('no media selected'),
                ],
              ),
            ),
          ),
          bottomNavigationBar: BottomAppBar(
            elevation: 0,
            child: Container(
              // margin: EdgeInsets.onl(vertical: 10),
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Row(
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
                  IconButton(
                    icon: const Icon(Icons.attachment),
                    iconSize: 24,
                    onPressed: () {  },
                  ),
                ],
              ),

            ),
          ),

        );
      }
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

  Future capture (MediaSource source) async{

  }
}
