import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/customModel/library.dart';
import 'package:provider/provider.dart';

import 'bookDetail.dart';

class LibraryGrid extends StatefulWidget {
  const LibraryGrid({Key? key}) : super(key: key);

  @override
  _LibraryGridState createState() => _LibraryGridState();
}

class _LibraryGridState extends State<LibraryGrid> {
  @override
  Widget build(BuildContext context) {
    final posts = Provider.of<List<MangoLibrary>>(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GridView.builder(
          padding: MediaQuery.of(context).padding.copyWith(
            top: 0,
            left: 0,
            right: 0,
            bottom: 50,
          ),
          itemCount: posts.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 20.0,
            crossAxisSpacing: 20.0,
            childAspectRatio: 0.75,
          ),
          itemBuilder: (context, index) {
            final post = posts[index];
            return GestureDetector(
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => BookDetail(mangoLibrary: post)));
            },
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Container(
                    // height: 180,
                    // width: 160,
                    decoration: BoxDecoration(
                      // color: Colors.greenAccent,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Hero(
                      tag: post.image,
                      child: CachedNetworkImage(
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
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 20.0 / 4),
                  child: Text(
                    // products is out demo list
                    post.title,
                    style: const TextStyle(color: Color(0xFFACACAC)),
                  ),
                ),
                Text(
                  post.author,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                )
              ],
            ),
          );}),
    );
  }
}
