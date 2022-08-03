import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Screens/Music/playlist_page.dart';
import 'package:mango/Screens/Profile/profile.dart';
import 'package:provider/provider.dart';

import '../../../Models/customModel/playlist.dart';
import '../../../Models/customModel/user.dart';
import '../../../Services/shimmer_widget.dart';
import '../../../constants.dart';

class ViewUser extends StatefulWidget {
  final List<MangoUser> users;
  const ViewUser({Key? key, required this.users}) : super(key: key);

  @override
  State<ViewUser> createState() => _ViewUserState();
}

class _ViewUserState extends State<ViewUser> {
  @override
  Widget build(BuildContext context) {
    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
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
        id: '',
        password: '',
        gender: '',
        profileImage: '',
        email: '',
        fcmToken: '',
        verified: false);
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
                  const Text("Meet new buds", style: headingextStyle),
                  Text('${widget.users.length} users', style: kTitleTextStyle),
                ],
              ),
            ),
            const SizedBox(height: 20),

            Center(
                child: Container(
                    height: _height/1.3,
                    // alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                        padding: const EdgeInsets.all(12.0),
                        child: GridView.builder(
                          itemCount: widget.users.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.8,
                          ),
                          itemBuilder: (BuildContext context, int index){
                                  return GestureDetector(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ProfilePage(
                                                userId: widget.users[index].id,
                                              )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: [
                                          CachedNetworkImage(
                                            height: 100,
                                            imageUrl: widget.users[index].profileImage,
                                            imageBuilder: (context, imageProvider) => Material(
                                              borderRadius: BorderRadius.circular(50),
                                              elevation: 1,
                                              child: CircleAvatar(
                                                backgroundImage: imageProvider,
                                                radius: 50,
                                              ),
                                            ),
                                            placeholder: (context, url) => const ShimmerWidget.circular(width: 100, height: 100),
                                            errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                            MainAxisAlignment.center,
                                            crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                            children: [
                                              Text(
                                                widget.users[index].displayName.length > 25 ? widget.users[index].displayName.substring(0, 25)+'...' : widget.users[index].displayName,
                                                textAlign: TextAlign.center,
                                                style: GoogleFonts.montserrat(
                                                  fontSize: 12,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontStyle: FontStyle.normal,
                                                ),
                                              ),
                                              widget.users[index].verified ? const Padding(
                                                padding: EdgeInsets.only(
                                                    left:
                                                    2.0),
                                                child:
                                                Icon(
                                                  Icons
                                                      .verified,
                                                  size:
                                                  12,
                                                ),
                                              ) : Container(),
                                            ],
                                          ),
                                          Text(
                                            '@${widget.users[index].username}',
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
                            ))
                )
            )
          ],
        ),
      ),

    );
  }
}
