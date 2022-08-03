import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mango/Models/customModel/playlist.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:provider/provider.dart';

import '../../constants.dart';

class ListUsers extends StatefulWidget {
  const ListUsers({Key? key}) : super(key: key);

  @override
  _ListUsersState createState() => _ListUsersState();
}

class _ListUsersState extends State<ListUsers> {

  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<MangoUser>>(context);
    return ShaderMask(
      shaderCallback: (Rect rect) {
        return const LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            Colors.grey,
            Colors.transparent,
            Colors.transparent,
            Colors.transparent
          ],
          stops: [
            0.0,
            0.1,
            0.9,
            1.0
          ], // 10% purple, 80% transparent, 10% purple
        ).createShader(rect);
      },
      blendMode: BlendMode.dstOut,
      child: AnimationLimiter(
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          itemCount: posts.length,
          itemBuilder: (context, index) {
            print('e nor reach');
            final post = posts[index];
            return AnimationConfiguration.staggeredList(
              position: index,
              duration: const Duration(milliseconds: 500),
              child: SlideAnimation(
                verticalOffset: 50.0,
                child: FadeInAnimation(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        vertical: 10, horizontal: 20),
                    // margin: EdgeInsets.symmetric(vertical: 5,),
                    decoration: BoxDecoration(
                      // borderRadius: BorderRadius.circular(20),
                        border: Border.symmetric(
                            horizontal: BorderSide(
                                color: Colors.grey.shade100))),
                    child: Row(
                      mainAxisAlignment:
                      MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            CachedNetworkImage(
                              height: 100,
                              width: 100,
                              imageUrl: post.profileImage,
                              imageBuilder: (context, imageProvider) => CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 25,
                              ),
                              placeholder: (context, url) => const CircularProgressIndicator(),
                              errorWidget: (context, url, error) => const Icon(Icons.error),
                            ),
                            const CircleAvatar(
                              backgroundImage: AssetImage(
                                "asset/images/img1.jpg",
                              ),
                              radius: 25,
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Column(
                              crossAxisAlignment:
                              CrossAxisAlignment.start,
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  post.displayName,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  post.username,
                                  style: const TextStyle(
                                    color: Colors.grey,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                              children: [
                                TextButton(
                                    onPressed: () {},
                                    style: ButtonStyle(
                                      shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(
                                                28.0),
                                          )),
                                      padding:
                                      MaterialStateProperty.all(
                                          const EdgeInsets
                                              .symmetric(
                                              vertical: 5.0,
                                              horizontal: 20.0)),
                                      backgroundColor:
                                      MaterialStateProperty.all<
                                          Color>(kCoral),
                                    ),
                                    child: const Text(
                                      "follow",
                                      style: postTextBoxText4,
                                    ))
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
