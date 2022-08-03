import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:like_button/like_button.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/playlist.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/Music/playlist_page.dart';
import 'package:provider/provider.dart';

import '../createpost.dart';

class ListPlaylistPost extends StatefulWidget {
  ValueChanged<String> updateLink;
  ValueChanged<String> updateType;
  ValueChanged<bool> updateDone;
  ListPlaylistPost({Key? key, required this.updateLink, required this.updateType, required this.updateDone}) : super(key: key);

  @override
  _ListPlaylistPostState createState() => _ListPlaylistPostState();
}

class _ListPlaylistPostState extends State<ListPlaylistPost> {
  final UserService _userService = UserService();
  final PostService _postService = PostService();
  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '',
      username: '',
      dob: '',
      id: '', password: '', gender: '', profileImage: '', email: '', fcmToken: '', verified: false);


  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<MangoPlaylist>>(context);
    return ListView.builder(
      padding: MediaQuery.of(context).padding.copyWith(
        top: 0,
        left: 0,
        right: 0,
        bottom: 50,
      ),
      scrollDirection: Axis.vertical,
      itemCount: posts.length,
      itemBuilder: (context, index) {
        final post = posts[index];
        return StreamBuilder<MangoUser?>(
            initialData: _user,
            stream: _userService.getUserInfo(post.postCreator),
            builder: (BuildContext context, AsyncSnapshot<MangoUser?> snapshot){
              if(!snapshot.hasData){
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              return GestureDetector(
                onTap: () {
                  widget.updateLink(post.id);
                  widget.updateType('Playlist');
                  widget.updateDone(true);
                  Navigator.pop(context);
                },
                child: Container(
                  padding: const EdgeInsets.symmetric(
                      vertical: 10, horizontal: 0),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.circular(20),
                      border: Border.symmetric(
                          horizontal: BorderSide(
                              color: Colors.grey.shade100))),
                  child: StreamBuilder<MangoUser?>(
                      initialData: _user,
                      stream:
                      UserService().getUserInfo(FirebaseAuth.instance.currentUser!.uid),
                      builder:
                          (BuildContext context, AsyncSnapshot<MangoUser?> senderSnapshot) {
                        if (!senderSnapshot.hasData) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        return Row(
                          mainAxisAlignment:
                          MainAxisAlignment.spaceBetween,
                          children: [
                            StreamBuilder<MangoUser?>(
                                initialData: _user,
                                stream:
                                UserService().getUserInfo(post.postCreator),
                                builder: (BuildContext context,
                                    AsyncSnapshot<MangoUser?> receiverSnapshot) {
                                  String token = receiverSnapshot.data!.fcmToken;
                                  if (!receiverSnapshot.hasData) {
                                    return const Center(
                                      child: CircularProgressIndicator(),
                                    );
                                  }
                                  return Row(
                                    children: [
                                      CachedNetworkImage(
                                        height: 50,
                                        width: 50,
                                        imageUrl: post.image,
                                        imageBuilder: (context, imageProvider) => Container(
                                          decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(10),
                                            image: DecorationImage(
                                              image: imageProvider,
                                              fit: BoxFit.cover,
                                              // colorFilter:
                                              // const ColorFilter.mode(Colors.red, BlendMode.colorBurn),
                                            ),
                                          ),
                                        ),
                                        placeholder: (context, url) => const CircularProgressIndicator(),
                                        errorWidget: (context, url, error) => const Icon(Icons.error),
                                      ),
                                      const SizedBox(
                                        width: 10,
                                      ),
                                      SizedBox(
                                        child: Column(
                                          crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              post.title,
                                              style: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 16,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            const SizedBox(
                                              height: 5,
                                            ),
                                            Text(
                                              post.text.length > 15 ? post.text.substring(0, 50)+'...' : post.text,
                                              maxLines: 2,
                                              overflow: TextOverflow.ellipsis,
                                              style: const TextStyle(
                                                color: Colors.grey,
                                                fontSize: 12,
                                                fontWeight: FontWeight.w700,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  );
                                }
                            ),
                            Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Column(
                                  crossAxisAlignment:
                                  CrossAxisAlignment.center,
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: const [
                                    Icon(
                                      Icons.more_vert_sharp,
                                      size: 25,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        );
                      }
                  ),
                ),
              );
            });
      },
    );
  }
}
