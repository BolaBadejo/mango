import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Screens/Music/playlist_page.dart';
import 'package:provider/provider.dart';

import '../../../Models/customModel/playlist.dart';
import '../../../Models/customModel/user.dart';
import '../../../Services/shimmer_widget.dart';
import '../../../constants.dart';

class ViewPlaylists extends StatefulWidget {
  const ViewPlaylists({Key? key}) : super(key: key);

  @override
  State<ViewPlaylists> createState() => _ViewPlaylistsState();
}

class _ViewPlaylistsState extends State<ViewPlaylists> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        id: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        dob: '',
        password: '',
        gender: '',
        profileImage: '',
        email: '',
        fcmToken: '',
        verified: false);
    final playlists = Provider.of<List<MangoPlaylist>>(context);
    return Scaffold(
      appBar: AppBar(
        shadowColor: Colors.transparent,
        backgroundColor: Colors.transparent,
        leading: const CloseButton(),
      ),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
             Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25,),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:  [
                  const Text("Discover", style: headingextStyle),
                  Text('${playlists.length} playlists', style: kTitleTextStyle),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Center(
              child: Container(
                height: _height/1.3,
                // alignment: Alignment.center,
                decoration: BoxDecoration(
                  // color: Colors.black12,
                  borderRadius: BorderRadius.circular(30),

                ),
                child: Container(
                    padding: const EdgeInsets.all(12.0),
                    child: GridView.builder(
                      itemCount: playlists.length,
                      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        crossAxisSpacing: 4.0,
                        mainAxisSpacing: 10.0,
                        childAspectRatio: 0.8,
                      ),
                      itemBuilder: (BuildContext context, int index){
                        return StreamBuilder<MangoUser?>(
                            initialData: _user,
                            stream: UserService().getUserInfo(
                                playlists[index].postCreator),
                            builder: (BuildContext context,
                                AsyncSnapshot<MangoUser?>
                                snapshot2) {
                              if (!snapshot2.hasData) {
                                return const Center(
                                  child:
                                  CircularProgressIndicator(),
                                );
                              }
                            return GestureDetector(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => PlaylistPage(
                                          mangoPost: playlists[index],
                                        )));
                              },
                              child: Container(
                                margin: const EdgeInsets.symmetric(horizontal: 10),
                                child: Column(
                                  children: [
                                    CachedNetworkImage(
                                      height: 100,
                                      imageUrl: playlists[index].image,
                                      imageBuilder: (context, imageProvider) => Material(
                                        borderRadius: BorderRadius.circular(50),
                                        elevation: 1,
                                        child: Container(
                                            height: 100,
                                            width: 100,
                                            decoration: BoxDecoration(
                                                borderRadius: BorderRadius.circular(20),
                                                boxShadow: [
                                                  BoxShadow(
                                                    color: Colors.grey.withOpacity(0.2),
                                                    spreadRadius: 2,
                                                    blurRadius: 1,
                                                    offset: const Offset(
                                                        0, 1), // changes position of shadow
                                                  ),
                                                ],
                                                image: DecorationImage(
                                                    image: imageProvider, fit: BoxFit.cover))),
                                      ),
                                      placeholder: (context, url) => const ShimmerWidget.rectangularCircular(width: 100, height: 100,),
                                      errorWidget: (context, url, error) =>
                                      const Icon(Icons.error),
                                    ),
                                    const SizedBox(
                                      height: 10,
                                    ),
                                    Text(
                                      playlists[index].title.length > 25 ? playlists[index].title.substring(0, 25)+'...' : playlists[index].title,
                                      textAlign: TextAlign.center,
                                      style: GoogleFonts.montserrat(
                                        fontSize: 12,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    ),
                                    Text(
                                      '@${snapshot2.data!.username}',
                                      style: GoogleFonts.montserrat(
                                        fontSize: 11,
                                        color: Colors.grey,
                                        fontWeight: FontWeight.w500,
                                        fontStyle: FontStyle.normal,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            );
                          }
                        );
                      },
                    ))
                    )
            )
          ],
        ),
      ),

    );
  }
}
