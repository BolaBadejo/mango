import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'dart:io';
import 'package:mango/Models/customModel/mediaSource.dart';
import 'package:mango/Screens/Posts/Widgets/books.dart';
import 'package:mango/Screens/Profile/profile.dart';
import 'package:provider/provider.dart';

import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;

import '../../Models/cloud/user_services.dart';
import '../../Models/customModel/library.dart';
import '../../Models/customModel/playlist.dart';
import '../../Models/customModel/user.dart';
import '../../Services/shimmer_widget.dart';
import '../../constants.dart';
import 'Widgets/playlist.dart';
import 'Widgets/video_widget.dart';

class CreatePost extends StatefulWidget {
  const CreatePost({Key? key}) : super(key: key);

  @override
  _CreatePostState createState() => _CreatePostState();
}

class _CreatePostState extends State<CreatePost> {
  final TextEditingController titleController = TextEditingController();
  final bool isEmpty = true;
  bool picked = false;
  bool vidPicked = false;
  bool isLoading = false;
  String? selectedLink;
  String? selectedType;
  bool? selected = false;
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  int _count = 0;

  // Pass this method to the child page.
  void _updateLink(String link) {
    print(link);
    setState(() {
      selectedLink = link;
    });
  }

  final List<File> _image = [];

  void _updateType(String type) {
    setState(() {
      selectedType = type;
    });
  }

  void _updateDone(bool isSelected) {
    setState(() {
      selected = isSelected;
    });
  }

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
      reads: 0, tags: []);

  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      dob: '',
      username: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      id: '',
      password: '',
      gender: '',
      profileImage: '',
      email: '',
      fcmToken: '',
      verified: false);

  File? returnedFile;
  File? _video;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return StreamBuilder<MangoUser?>(
        initialData: _user,
        stream:
            _userService.getUserInfo(FirebaseAuth.instance.currentUser!.uid),
        builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
          String token = snapshot.data!.fcmToken;
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
                    isLoading
                        ? {}
                        : setState(() {
                            isLoading = true;
                          });
                    // if(returnedFile == null){
                    //   Fluttertoast.showToast(
                    //       msg: "Come on! Post an image",
                    //       toastLength: Toast.LENGTH_SHORT,
                    //       gravity: ToastGravity.TOP,
                    //       timeInSecForIosWeb: 1,
                    //       backgroundColor: Colors.orange,
                    //       textColor: Colors.white,
                    //       fontSize: 12.0
                    //   );
                    // }else if(titleController.text.isEmpty){
                    //   Fluttertoast.showToast(
                    //       msg: "Come on! Add a post caption.",
                    //       toastLength: Toast.LENGTH_SHORT,
                    //       gravity: ToastGravity.TOP,
                    //       timeInSecForIosWeb: 1,
                    //       backgroundColor: Colors.orange,
                    //       textColor: Colors.white,
                    //       fontSize: 12.0
                    //   );
                    // }else {
                    //
                    //   }
                    if(vidPicked == true){
                      _postService.saveVideoMediaPost(titleController.text.trim(),
                          _video, selectedLink, selectedType, selected);
                    }
                    else if(_image.length >= 2){
                      _postService.savePost(titleController.text.trim(),
                          _image, selectedLink, selectedType, selected);
                    } else {
                      _postService.saveSingleMediaPost(titleController.text.trim(),
                          _image[0], selectedLink, selectedType, selected);
                    }
                    UserService().sendNotificationToTopic(
                        "@${snapshot.data!.username} has just shared a new post",
                        "New Post!!",
                        snapshot.data!.id);
                    Navigator.pop(context);
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 10),
                    padding:
                        const EdgeInsets.symmetric(horizontal: 15, vertical: 2),
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(25),
                        color: Colors.black),
                    child: isLoading
                        ? const CircularProgressIndicator()
                        : const Text(
                            'POST',
                            style: labelBody_,
                          ),
                  ),
                )
              ],
            ),
            body: Stack(
              children: [
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20),
                  child: Column(
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ProfilePage(
                                      userId: FirebaseAuth.instance.currentUser!.uid)));
                        },
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Expanded(
                              child: Row(
                                children: [
                                  CachedNetworkImage(
                                    height: 28,
                                    imageUrl: snapshot.data?.profileImage ?? '',
                                    imageBuilder: (context, imageProvider) =>
                                        Material(
                                      borderRadius: BorderRadius.circular(50),
                                      // elevation: 1,
                                      child: CircleAvatar(
                                        backgroundImage: imageProvider,
                                        radius: 14,
                                      ),
                                    ),
                                    placeholder: (context, url) =>
                                        const ShimmerWidget.circular(
                                            width: 28, height: 28),
                                    errorWidget: (context, url, error) =>
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
                      selectedType == 'Book'
                          ? selected == true
                              ? StreamBuilder<MangoLibrary?>(
                                  initialData: _library,
                                  stream:
                                      _postService.getBookWithId(selectedLink!),
                                  builder: (BuildContext context,
                                      AsyncSnapshot<MangoLibrary?>
                                          playListSnapshot) {
                                    print(playListSnapshot.data!.image);
                                    if (!playListSnapshot.hasData) {
                                      return const Center(
                                        child: CircularProgressIndicator(),
                                      );
                                    }
                                    return Container(
                                      width: size.width,
                                      height: 80,
                                      margin: const EdgeInsets.only(
                                          left: 0,
                                          right: 0,
                                          bottom: 10,
                                          top: 10),
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.black),
                                      child: Row(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 10.0,
                                                bottom: 10.0,
                                                left: 10,
                                                right: 15),
                                            child: CachedNetworkImage(
                                              height: 60,
                                              width: 45,
                                              imageUrl:
                                                  playListSnapshot.data!.image,
                                              imageBuilder:
                                                  (context, imageProvider) =>
                                                      Container(
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(5),
                                                  image: DecorationImage(
                                                    image: imageProvider,
                                                    fit: BoxFit.cover,
                                                  ),
                                                ),
                                              ),
                                              placeholder: (context, url) =>
                                                  const ShimmerWidget
                                                          .rectangularCircular(
                                                      width: 80, height: 80),
                                              errorWidget:
                                                  (context, url, error) =>
                                                      const Icon(Icons.error),
                                            ),
                                          ),
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
                                                    playListSnapshot
                                                        .data!.title,
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
                                                  Text(
                                                    playListSnapshot
                                                            .data?.text ??
                                                        '',
                                                      style: const TextStyle(
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
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 15.0),
                                            child: CloseButton(
                                              color: Colors.white,
                                              onPressed: () {
                                                setState(() {
                                                  selectedType = null;
                                                  selectedLink = null;
                                                  selected = false;
                                                });
                                              },
                                            ),
                                          )
                                        ],
                                      ),
                                    );
                                  })
                              : Container()
                          : selectedType == 'Playlist'
                              ? selected == true
                                  ? StreamBuilder<MangoPlaylist?>(
                                      initialData: _playlist,
                                      stream: _postService
                                          .getPlaylistWithId(selectedLink!),
                                      builder: (BuildContext context,
                                          AsyncSnapshot<MangoPlaylist?>
                                              playListSnapshot) {
                                        print(playListSnapshot.data!.image);
                                        if (!playListSnapshot.hasData) {
                                          return const Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        }
                                        return Container(
                                          width: size.width,
                                          height: 80,
                                          margin: const EdgeInsets.only(
                                              left: 0,
                                              right: 0,
                                              bottom: 10,
                                              top: 10),
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              color: Colors.black),
                                          child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Padding(
                                                padding: const EdgeInsets.only(
                                                    top: 10.0,
                                                    bottom: 10.0,
                                                    left: 10,
                                                    right: 15),
                                                child: CachedNetworkImage(
                                                  height: 60,
                                                  width: 60,
                                                  imageUrl: playListSnapshot
                                                      .data!.image,
                                                  imageBuilder: (context,
                                                          imageProvider) =>
                                                      Container(
                                                    decoration: BoxDecoration(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              5),
                                                      image: DecorationImage(
                                                        image: imageProvider,
                                                        fit: BoxFit.cover,
                                                      ),
                                                    ),
                                                  ),
                                                  placeholder: (context, url) =>
                                                      const ShimmerWidget
                                                              .rectangularCircular(
                                                          width: 80,
                                                          height: 80),
                                                  errorWidget: (context, url,
                                                          error) =>
                                                      const Icon(Icons.error),
                                                ),
                                              ),
                                              Expanded(
                                                child: Padding(
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 20),
                                                  child: Column(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Text(
                                                        playListSnapshot
                                                            .data!.title,
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
                                                      Text(
                                                        playListSnapshot
                                                                .data?.text ??
                                                            '',
                                                        style: const TextStyle(
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
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 15.0),
                                                child: CloseButton(
                                                  color: Colors.white,
                                                  onPressed: () {
                                                    setState(() {
                                                      selectedType = null;
                                                      selectedLink = null;
                                                      selected = false;
                                                    });
                                                  },
                                                ),
                                              )
                                            ],
                                          ),
                                        );
                                      })
                                  : Container()
                              : Container(),
                      vidPicked ? Container(
                          height: 400,
                          width: double.infinity,
                          padding: const EdgeInsets.all(4),
                          child: Stack(
                            fit: StackFit.expand,
                            clipBehavior: Clip.hardEdge,
                            alignment: Alignment.center,
                            children: <Widget>[
                              Positioned(
                                  left: 0,
                                  right: 0,
                                  child:VideoWidget(_video!))])) : picked
                          ? Container(
                              height: 80,
                              width: double.infinity,
                              padding: const EdgeInsets.all(4),
                              child: ListView.builder(
                                  scrollDirection: Axis.horizontal,
                                  itemCount: _image.length + 1,
                                  itemBuilder: (context, index) {
                                    return index == 0
                                        ? Center(
                                            child: Container(
                                              margin: const EdgeInsets.only(right: 5),
                                              decoration: const BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  color: Colors.black),
                                              child: IconButton(
                                                  icon: const Icon(Icons.add),
                                                  color: Colors.white,
                                                  onPressed: () => chooseImage()),
                                            ),
                                          )
                                        : Stack(
                                            children: [
                                              Container(
                                                height: 80,
                                                width: 70,
                                                margin: const EdgeInsets.all(5),
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10),
                                                    image: DecorationImage(
                                                        image: FileImage(
                                                            _image[index - 1]),
                                                        fit: BoxFit.cover)),
                                              ),
                                              Positioned(
                                                right: 0,
                                                child: InkWell(
                                                  onTap: () {
                                                    setState(() {
                                                      _image.remove(
                                                          _image[index - 1]);
                                                    });
                                                  },
                                                  child: const CircleAvatar(
                                                    backgroundColor:
                                                        Colors.black54,
                                                    radius: 12.0,
                                                    child: Icon(
                                                      Icons.clear,
                                                      size: 10.0,
                                                      color: Colors.white,
                                                    ),
                                                  ),
                                                ),
                                              )
                                            ],
                                          );
                                  }),
                            )
                          : const Text('no media selected'),
                    ],
                  ),
                ),
                Positioned(
                  bottom: 0,
                  child: Container(
                    // margin: EdgeInsets.onl(vertical: 10),
                    padding: const EdgeInsets.symmetric(horizontal: 20),
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
                          onPressed: () => chooseImage(),
                          // onPressed: () => pickFromGallery(context),
                        ),
                        IconButton(
                          icon: const Icon(Icons.video_camera_back_outlined),
                          iconSize: 24,
                          onPressed: () => chooseVideo(),
                        ),
                        IconButton(
                          icon: const Icon(Icons.attachment),
                          iconSize: 24,
                          onPressed: () {
                            showModalBottomSheet(
                                backgroundColor: Colors.transparent,
                                isScrollControlled: true,
                                context: context,
                                builder: (context) => addLink());
                          },
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          );
        });
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
      _image.add(file);
      // returnedFile = file;
      picked = true;
    });
  }

  Future capture(MediaSource source) async {}

  addLink() {
    Size size = MediaQuery.of(context).size;
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
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
                        TabBar(
                          // controller: ,
                          labelStyle: widgetTitleText2,
                          unselectedLabelStyle: textBody3,
                          indicator: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(50), // Creates border
                              color: Colors.grey),
                          tabs: const [
                            Tab(text: "Playlists"),
                            Tab(text: "Library")
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          height: size.height / 2,
                          // padding: const EdgeInsets.all(10),
                          child: TabBarView(children: [
                            StreamProvider.value(
                                value: _postService.getPlaylistsByUser(
                                    FirebaseAuth.instance.currentUser!.uid),
                                initialData: const <MangoPlaylist>[],
                                child: ListPlaylistPost(
                                  updateLink: _updateLink,
                                  updateType: _updateType,
                                  updateDone: _updateDone,
                                )),
                            StreamProvider.value(
                                value: _postService.getLibraryByUser(
                                    FirebaseAuth.instance.currentUser!.uid),
                                initialData: const <MangoLibrary>[],
                                child: LibraryGridPost(
                                  updateLink: _updateLink,
                                  updateType: _updateType,
                                  updateDone: _updateDone,
                                )),
                          ]),
                        ),
                      ],
                    ),
                  )),
            ),
          ],
        ),
      ),
    );
  }

  chooseImage() async {
    final getMedia = ImagePicker().pickImage;
    final media = await getMedia(source: ImageSource.gallery);
    final file = File(media!.path);
    setState(() {
      _image.add(file);
      print('this is selected images $_image');
      // returnedFile = file;
      picked = true;
    });

    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // setState(() {
    //   _image.add(File(pickedFile!.path));
    // });
    // if (pickedFile!.path == null) retrieveLostData();
  }

  chooseVideo() async {
    final getMedia = ImagePicker().pickVideo;
    final media = await getMedia(source: ImageSource.gallery);
    final file = File(media!.path);
    setState(() {
      // if (_video != null) _video = null;
      _video = file;
      vidPicked = true;
    });

    // final pickedFile = await picker.pickImage(source: ImageSource.gallery);
    // setState(() {
    //   _image.add(File(pickedFile!.path));
    // });
    // if (pickedFile!.path == null) retrieveLostData();
  }
}
