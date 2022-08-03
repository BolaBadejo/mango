import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Screens/Posts/reply_post.dart';
import 'package:mango/Services/shimmer_widget.dart';

class PhotoViewer extends StatefulWidget {
  final post;
  final username;
  const PhotoViewer({Key? key, required this.post, required this.username}) : super(key: key);

  @override
  State<PhotoViewer> createState() => _PhotoViewerState();
}

class _PhotoViewerState extends State<PhotoViewer> {
  final PostService _postService = PostService();

  final double _sigmaX = 10; // from 0-10
  final double _sigmaY = 10; // from 0-10
  final double _opacity = 0.3; // from 0-1.0


  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Material(
      child: SizedBox(
        height: size.height,
        child: Stack(
          children: [
            CachedNetworkImage(
              width: double.infinity,
              height: double.infinity,
              imageUrl: widget.post.image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              placeholder: (context, url) => const ShimmerWidget.rectangularCircular(width: double.infinity, height: double.infinity),
              errorWidget: (context, url, error) => SizedBox(
                height: double.infinity,
                child: Center(
                    child: Icon(
                      Icons.error,
                      size: 80,
                      color: Colors.grey.withOpacity(0.3),
                    )),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                child: Container(
                  color: Colors.black.withOpacity(_opacity),
                ),
              ),
            ),
            SizedBox(
              width: double.infinity,
              height: double.infinity,
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: _sigmaX, sigmaY: _sigmaY),
                child: Container(
                  color: Colors.black.withOpacity(_opacity),
                ),
              ),
            ),
            CachedNetworkImage(
              width: double.infinity,
              imageUrl: widget.post.image,
              imageBuilder: (context, imageProvider) => Container(
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: imageProvider,
                    fit: BoxFit.contain,
                  ),
                ),
              ),
              placeholder: (context, url) => const ShimmerWidget.rectangularCircular(width: double.infinity, height: double.infinity),
              errorWidget: (context, url, error) => const Icon(Icons.error),
            ),
            Positioned(
                bottom: 20,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 20),
                  width: size.width,
              height: 20,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
            StreamBuilder<bool?>(
            initialData: null,
                    stream: _postService
                        .hasLikedPost(widget.post.id),
                    builder: (BuildContext context,
                        AsyncSnapshot<bool?> snapshot) {
                      if (snapshot.data == true) {
                        return InkWell(
                            onTap: () {
                             _postService
                                  .unlikePost(widget.post.id);
                            },
                            child: const Icon(
                              Icons.favorite,
                              color: Colors.deepOrange,
                              size: 20,
                            ));
                      }
                      return InkWell(
                          onTap: () async {
                            _postService
                                .likePost(widget.post.id, widget.post.postCreator);
                          },
                          child: const Icon(
                            Icons.favorite_border,
                            color: Colors.grey,
                            size: 20,
                          ));
                    }),
                  const SizedBox(
                    width: 10,
                  ),
                  // InkWell(
                  //     onTap: () async {
                  //       _postService.repostPost(
                  //           widget.post, widget.post.repost);
                  //     },
                  //     child: Icon(
                  //       Icons.repeat,
                  //       color: widget.post.repost
                  //           ? Colors.lightGreen
                  //           : Colors.grey,
                  //       size: 20,
                  //     )),
                  // const SizedBox(
                  //   width: 10,
                  // ),
                  InkWell(
                      onTap: () async {
                        final post = widget.post;
                        showModalBottomSheet(
                            backgroundColor: Colors.transparent,
                            isScrollControlled: true,
                            context: context,
                            builder: (context) => ReplyMessage(
                              post: post,
                            ));
                      },
                      child: Icon(
                        Icons.message_outlined,
                        color: widget.post.repost
                            ? Colors.lightGreen
                            : Colors.grey,
                        size: 20,
                      ))
                  ],
            ),

                  Text(
                    '@${widget.username}',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                    ),
                    maxLines: 6,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),))
          ],
        ),
      ),
    );
  }
}
