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
import 'package:share/share.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../constants.dart';
import '../Music/comment_playlist.dart';

class ListPlaylist extends StatefulWidget {
  const ListPlaylist({Key? key}) : super(key: key);

  @override
  _ListPlaylistState createState() => _ListPlaylistState();
}

class _ListPlaylistState extends State<ListPlaylist> {
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
                Navigator.push(context, MaterialPageRoute(builder: (context) => PlaylistPage(mangoPost: post)));
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                    vertical: 10, horizontal: 20),
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
                                  height: 100,
                                  width: 100,
                                  imageUrl: post.image,
                                  imageBuilder: (context, imageProvider) => Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(20),
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


                                // Image.network(
                                //   post.image,
                                //   fit: BoxFit.cover,
                                //   height: 100,
                                //   width: 100,),


                                const SizedBox(
                                  width: 10,
                                ),
                                Column(
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
                                      Provider.of<MangoUser>(context).username,
                                      style: const TextStyle(
                                        color: Colors.grey,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 15,
                                    ),
                                    Row(
                                      children: [
                                        StreamBuilder<bool?>(
                                            initialData: null,
                                            stream: _postService
                                                .hasLikedPlaylist(
                                                post.id),
                                            builder: (BuildContext
                                            context,
                                                AsyncSnapshot<
                                                    bool?>
                                                snapshot) {
                                              if (snapshot
                                                  .data ==
                                                  true) {
                                                return InkWell(
                                                    onTap:
                                                        () {
                                                      _postService.unlikePlaylist(post);
                                                    },
                                                    child:
                                                    const Icon(
                                                      Icons
                                                          .favorite,
                                                      color: Colors
                                                          .deepOrange,
                                                      size:
                                                      20,
                                                    ));
                                              }
                                              return InkWell(
                                                  onTap:
                                                      () async {
                                                    _postService.likePlaylist(
                                                        post);
                                                    _userService.sendNotification(post, 'playlist',
                                                        "@${senderSnapshot.data!.username} just liked ${post.title}",
                                                        "New Interaction",
                                                        post.postCreator,
                                                        token);
                                                  },
                                                  child:
                                                  const Icon(
                                                    Icons
                                                        .favorite_border,
                                                    color: Colors
                                                        .grey,
                                                    size: 20,
                                                  ));
                                            }),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              Share.share(
                                                  'Listen to ${post.title} by @${receiverSnapshot.data!.username} on Mango. \n \n get the android app here \n http://tiny.cc/qhssuz',
                                                  subject:
                                                  "New Playlist On Mango");
                                              // _postService.repostPlaylist(
                                              //     widget.mangoPost, widget.mangoPost.repost);
                                              // _userService.sendNotification("@${senderSnapshot.data!.username} just reposted ${widget.mangoPost.title}", "Repost Alert", widget.mangoPost.postCreator, token);
                                            },
                                            child: const Icon(
                                              Icons.share,
                                              color:
                                              Colors.grey,
                                              size: 20,
                                            )),
                                        const SizedBox(
                                          width: 10,
                                        ),
                                        InkWell(
                                            onTap: () async {
                                              final mangoPost =
                                                  post;
                                              showModalBottomSheet(
                                                  backgroundColor:
                                                  Colors
                                                      .transparent,
                                                  isScrollControlled:
                                                  true,
                                                  context:
                                                  context,
                                                  builder: (context) => CommentPlaylist(
                                                      mangoPlaylist:
                                                      mangoPost,
                                                      userToken: receiverSnapshot
                                                          .data!
                                                          .fcmToken));
                                            },
                                            child: const Icon(
                                              Icons
                                                  .message_outlined,
                                              color: Colors
                                                  .grey,
                                              size: 20,
                                            ))
                                      ],
                                    )
                                  ],
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
