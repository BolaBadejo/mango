import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Services/shimmer_widget.dart';

import '../../../Models/customModel/library.dart';
import '../../../Models/customModel/user.dart';
import '../../../constants.dart';
import '../../PDFReader/bookDetail.dart';

class ViewBooklistCategory extends StatefulWidget {
  final String category;
  final String interest;
  final List<MangoLibrary> users;
  const ViewBooklistCategory({Key? key, required this.category, required this.interest, required this.users}) : super(key: key);

  @override
  State<ViewBooklistCategory> createState() => _ViewBooklistCategoryState();
}

class _ViewBooklistCategoryState extends State<ViewBooklistCategory> {
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
                  Text(widget.interest, style: kTitleTextStyle),
                  Text(widget.category, style: headingextStyle),
                  Text('${widget.users.length} books', style: kTitleTextStyle),
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
                          itemCount: widget.users.length,
                          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 3,
                            crossAxisSpacing: 4.0,
                            mainAxisSpacing: 10.0,
                            childAspectRatio: 0.6,
                          ),
                          itemBuilder: (BuildContext context, int index){
                            return StreamBuilder<MangoUser?>(
                                initialData: _user,
                                stream: UserService().getUserInfo(
                                    widget.users[index].postCreator),
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
                                              builder: (context) => BookDetail(mangoLibrary: widget.users[index],
                                              )));
                                    },
                                    child: Container(
                                      margin: const EdgeInsets.symmetric(horizontal: 10),
                                      child: Column(
                                        children: [
                                          CachedNetworkImage(
                                            height: 140,
                                            imageUrl: widget.users[index].image,
                                            imageBuilder: (context, imageProvider) => Container(
                                                height: 140,
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

                                            //     Material(
                                            //   borderRadius: BorderRadius.circular(50),
                                            //   elevation: 1,
                                            //   child: CircleAvatar(
                                            //     backgroundImage: imageProvider,
                                            //     radius: 50,
                                            //   ),
                                            // ),
                                            placeholder: (context, url) => const ShimmerWidget.rectangularCircular(width: 100, height: 140),
                                            errorWidget: (context, url, error) =>
                                            const Icon(Icons.error),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Text(
                                            widget.users[index].title.length > 25 ? widget.users[index].title.substring(0, 25)+'...' : widget.users[index].title,
                                            style: GoogleFonts.montserrat(
                                              fontSize: 12,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w500,
                                              fontStyle: FontStyle.normal,
                                            ),
                                              textAlign: TextAlign.center
                                          ),
                                          StreamBuilder<MangoUser?>(
                                              initialData: _user,
                                              stream:
                                              UserService().getUserInfo(widget.users[index].postCreator),
                                              builder: (BuildContext context,
                                                  AsyncSnapshot<MangoUser?> snapshot) {
                                                if (!snapshot.hasData) {
                                                  return const Center(
                                                    child: CircularProgressIndicator(),
                                                  );
                                                } else {
                                                  return Text(snapshot.data!.username.length > 10 ? snapshot.data!.username.substring(0, 10)+'...' :snapshot.data!.username,
                                                      style: const TextStyle(
                                                          overflow: TextOverflow.ellipsis,
                                                          color: Colors.grey,
                                                          fontWeight: FontWeight.bold,
                                                          fontSize: 11));
                                                }
                                              }),
                                          // Text(
                                          //   users[index].id,
                                          //   style: GoogleFonts.montserrat(
                                          //     fontSize: 14,
                                          //     color: Colors.grey,
                                          //     fontWeight: FontWeight.w500,
                                          //     fontStyle: FontStyle.normal,
                                          //   ),
                                          // )
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
