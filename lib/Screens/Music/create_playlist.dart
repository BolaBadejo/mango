import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tags/flutter_tags.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mango/Models/cloud/post_services.dart';

import '../../Models/cloud/user_services.dart';
import '../../Models/customModel/mango_tags.dart';
import '../../Models/customModel/user.dart';
import '../../Services/shimmer_widget.dart';
import '../../constants.dart';
import '../Posts/Widgets/tags.dart';
import '../Profile/profile.dart';

class CreatePlaylist extends StatefulWidget {
  const CreatePlaylist({Key? key}) : super(key: key);

  @override
  _CreatePlaylistState createState() => _CreatePlaylistState();
}

class _CreatePlaylistState extends State<CreatePlaylist> {
  final TextEditingController titleController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController linkController = TextEditingController();
  final bool isEmpty = true;
  bool picked = false;
  bool isLoading = false;
  final PostService _postService = PostService();
  final UserService _userService = UserService();
  List<MangoTags> _tags = [];
  final List<String> _tagString = [];

  TextEditingController _searchTextEditingController =
  new TextEditingController();
  String get _searchText => _searchTextEditingController.text.trim();

  File? _playlistImage;
  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      username: '',
      dob: '',
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

  List<String> _items=[];

  // List _items;
  double _fontSize = 14;

  // @override
  // void initState(){
  //   super.initState();
  //   // if you store data on a local database (sqflite), then you could do something like this
  //   Model().getItems().then((items){
  //     _items = items;
  //   });
  // }

  refreshState(VoidCallback fn) {
    if (mounted) setState(fn);
  }

  @override
  void initState() {
    super.initState();
    _searchTextEditingController.addListener(() => refreshState(() {}));
  }

  @override
  void dispose() {
    super.dispose();
    _searchTextEditingController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
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
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              shadowColor: Colors.transparent,
              leading: const CloseButton(
                color: Colors.black,
              ),
              actions: [
                TextButton(
                  onPressed: () async {
                    isLoading
                        ? {}
                        : setState(() {
                            isLoading = true;
                          });

                    await _postService.savePlaylist(
                        linkController.text.trim(),
                        _playlistImage!,
                        _tagString,
                        titleController.text.trim(),
                        bioController.text.trim());
                    UserService().sendNotificationToTopic(
                        "@${snapshot.data!.username} has just shared new music",
                        "New Music!!",
                        snapshot.data!.id);
                    Navigator.pop(context);
                  },
                  child: isLoading
                      ? const CircularProgressIndicator()
                      : const Text("save"),
                )
              ],
            ),
            body: SingleChildScrollView(
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 25,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("Create Playlist", style: headingextStyle),
                    const SizedBox(height: 20),
                    InkWell(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                     ProfilePage(userId: FirebaseAuth.instance.currentUser!.uid,)));
                      },
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
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
                                  const ShimmerWidget.circular(width: 28, height: 28),
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
                    const Icon(
                      Icons.group_add,
                      color: Colors.grey,
                      size: 20,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    picked
                        ? Image.file(
                            _playlistImage!,
                            height: 160,
                            width: 160,
                            fit: BoxFit.cover,
                          )
                        : Container(
                            height: 160,
                            width: 160,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10),
                              color: Colors.grey,
                            ),
                            child: Icon(
                              Icons.add,
                              size: 50,
                              color: Colors.grey.shade700,
                            ),
                          ),
                    const SizedBox(
                      height: 10,
                    ),
                    InkWell(
                        onTap: () {
                          pickFromGallery(context);
                        },
                        child: const Text(
                          "   add image",
                          style: TextStyle(
                              fontWeight: FontWeight.w600, color: Colors.green),
                        )),
                    const SizedBox(
                      height: 20,
                    ),
                    Container(
                      width: _width,
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
                        controller: titleController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusColor: Colors.orangeAccent,
                            hintText: 'playlist title',
                            hintStyle: textBoxHint),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: _width,
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
                        controller: linkController,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusColor: Colors.orangeAccent,
                            hintText: 'add playlist link',
                            hintStyle: textBoxHint),
                      ),
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: _width,
                      padding: const EdgeInsets.only(left: 15, right: 15),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15),
                          border: const Border(
                            bottom: BorderSide(color: Colors.grey, width: 2),
                            top: BorderSide(color: Colors.grey, width: 2),
                            left: BorderSide(color: Colors.grey, width: 2),
                            right: BorderSide(color: Colors.grey, width: 2),
                          )),
                      child: TextField(
                        style: textBoxText,
                        controller: bioController,
                        minLines: 12,
                        maxLines: 16,
                        decoration: const InputDecoration(
                            border: InputBorder.none,
                            focusColor: Colors.orangeAccent,
                            hintText: 'describe your playlist',
                            hintStyle: textBoxHint),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _tagIcon(),
                // Tags(
                //   key:_tagStateKey,
                //   horizontalScroll: true,
                //   itemCount: _items.length, // required
                //   itemBuilder: (int index){
                //     final item = _items[index];
                //
                //     return ItemTags(
                //       active: false,
                //       alignment: MainAxisAlignment.start,
                //       padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                //       textColor: Colors.black,
                //       textActiveColor: Colors.white,
                //       color: Colors.white,
                //       splashColor: Colors.transparent,
                //       activeColor: Colors.black,
                //         border: Border.all(
                //           width: 2
                //         ),
                //       // Each ItemTags must contain a Key. Keys allow Flutter to
                //       // uniquely identify widgets.
                //       key: Key(index.toString()),
                //       index: index, // required
                //       title: item,
                //       // active: item.active,
                //       // customData: item.customData,
                //       textStyle: TextStyle( fontSize: _fontSize, ),
                //       combine: ItemTagsCombine.withTextBefore,
                //       // image: ItemTagsImage(
                //       //     image: AssetImage("img.jpg") // OR NetworkImage("https://...image.png")
                //       // ), // OR null,
                //       // icon: ItemTagsIcon(
                //       //   icon: Icons.add,
                //       // ), // OR null,
                //       // removeButton: ItemTagsRemoveButton(
                //       //   onRemoved: (){
                //       //     // Remove the item from the data source.
                //       //     setState(() {
                //       //       // required
                //       //       _items.removeAt(index);
                //       //     });
                //       //     //required
                //       //     return true;
                //       //   },
                //       // ), // OR null,
                //       onPressed: (item) => print(item),
                //       onLongPressed: (item) => print(item),
                //     );
                //
                //   },
                // ),
                    const SizedBox(
                      height: 30,
                    ),
                  ],
                ),
              ),
            ),
          );
        });

    // void _getTags()
    // {
    //   _tags.forEach((tag) => print(tag));
    // }
  }

  final List<MangoTags> _tagsToSelect = loadedTags;
  final List<MangoTags> _limitedToSelect = limitedTags;

  List<MangoTags> _filterSearchResultList() {
    if (_searchText.isEmpty) return _limitedToSelect;

    List<MangoTags> _tempList = [];
    for (int index = 0; index < _tagsToSelect.length; index++) {
      MangoTags tagModel = _tagsToSelect[index];
      if (tagModel.title
          .toLowerCase()
          .trim()
          .contains(_searchText.toLowerCase())) {
        _tempList.add(tagModel);
      }
    }

    return _tempList;
  }

  List<MangoTags> _filterShortResultList() {
    if (_searchText.isEmpty) return _tagsToSelect;

    List<MangoTags> _tempList = [];
    for (int index = 0; index < 15; index++) {
      MangoTags tagModel = _tagsToSelect[index];
      if (tagModel.title
          .toLowerCase()
          .trim()
          .contains(_searchText.toLowerCase())) {
        _tempList.add(tagModel);
      }
    }

    return _tempList;
  }

  Widget _buildSearchFieldWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _searchTextEditingController,
              decoration: const InputDecoration.collapsed(
                hintText: 'Search Tag',
                hintStyle: TextStyle(
                  color: Colors.grey,
                ),
              ),
              style: const TextStyle(
                fontSize: 16.0,
              ),
              textInputAction: TextInputAction.search,
            ),
          ),
          _searchText.isNotEmpty
              ? InkWell(
            child: Icon(
              Icons.clear,
              color: Colors.grey.shade700,
            ),
            onTap: () => _searchTextEditingController.clear(),
          )
              : Icon(
            Icons.search,
            color: Colors.grey.shade700,
          ),
          Container(),
        ],
      ),
    );
  }

  Widget _tagIcon() {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _tagsWidget(),
      ],
    );
  }

  Widget _tagsWidget() {
    return Flexible(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
           Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(20)
              ),
              child: const Text(
                'add tags',
                style: TextStyle(
                    fontWeight: FontWeight.w600, color: Colors.white),
              ),
            ),
          ),
          const SizedBox(height: 10,),
          _tags.isNotEmpty
              ? Column(children: [
            Wrap(
              alignment: WrapAlignment.start,
              children: _tags.map((tagModel) => tagChip(
                tagModel: tagModel,
                onTap: () => _removeTag(tagModel),
                action: 'Remove',
              ))
                  .toSet()
                  .toList(),
            ),
            const SizedBox(height: 10,),
          ])
              : Container(),
          _buildSearchFieldWidget(),
          _displayTagWidget(),
        ],
      ),
    );
  }

  _displayTagWidget() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _filterSearchResultList().isNotEmpty
          ? _buildSuggestionWidget()
          : Text('No Labels added'),
    );
  }

  Widget _buildSuggestionWidget() {
    return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
      if (_filterSearchResultList().length != _tags.length) Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
            padding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            decoration: BoxDecoration(
                color: Colors.grey.shade400,
                borderRadius: BorderRadius.circular(20)
            ),
            child: const Text('Suggestions',
            style: TextStyle(
                fontWeight: FontWeight.w600, color: Colors.white,),)),
      ),
      Wrap(
        alignment: WrapAlignment.start,
        children: _filterSearchResultList()
            .where((tagModel) => !_tags.contains(tagModel))
            .map((tagModel) => tagChip(
          tagModel: tagModel,
          onTap: () => _addTags(tagModel),
          action: 'Add',
        ))
            .toList(),
      ),
    ]);
  }

  _addTags(tagModel) async {
    if (!_tags.contains(tagModel)) {
      setState(() {
        _tags.add(tagModel);
        _tagString.add(tagModel.title);
      });
    }
  }

_removeTag(tagModel) async {
  if (_tags.contains(tagModel)) {
    setState(() {
      _tags.remove(tagModel);
      _tagString.remove(tagModel);
    });
  }
}

Widget tagChip({
  tagModel,
  onTap,
  action,
}) {
  return InkWell(
      onTap: onTap,
      child: Stack(
        children: [
          Container(
            padding: EdgeInsets.symmetric(
              vertical: 5.0,
              horizontal: 5.0,
            ),
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 10.0,
                vertical: 10.0,
              ),
              decoration: BoxDecoration(
                color: Colors.green,
                borderRadius: BorderRadius.circular(100.0),
              ),
              child: Text(
                '${tagModel.title}',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 15.0,
                ),
              ),
            ),
          ),
          Positioned(
            right: 0,
            child: CircleAvatar(
              backgroundColor: Colors.green.shade800,
              radius: 8.0,
              child: Icon(
                Icons.clear,
                size: 10.0,
                color: Colors.white,
              ),
            ),
          )
        ],
      ));
}

  final GlobalKey<TagsState> _tagStateKey = GlobalKey<TagsState>();
// Allows you to get a list of all the ItemTags
  _getAllItem(){
    List<Item>? lst = _tagStateKey.currentState?.getAllItem;
    if(lst!=null)
      lst.where((a) => a.active==true).forEach( ( a) => print(a.title));
  }

  Future pickFromGallery(BuildContext context) async {
    final getMedia = ImagePicker().pickImage;
    final media = await getMedia(source: ImageSource.gallery);
    final file = File(media!.path);
    setState(() {
      _playlistImage = file;
      picked = true;
    });
  }
}
