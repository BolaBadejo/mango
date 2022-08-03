import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/Profile/profile.dart';
import 'package:provider/provider.dart';

import '../../Services/shimmer_widget.dart';

class UserGrid extends StatefulWidget {
  const UserGrid({Key? key}) : super(key: key);

  @override
  State<UserGrid> createState() => _UserGridState();
}

class _UserGridState extends State<UserGrid> {
  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<MangoUser>>(context);
    return  Container(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: users.length,
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
                          userId: users[index].id,
                        )));
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    CachedNetworkImage(
                      height: 100,
                      imageUrl: users[index].profileImage,
                      imageBuilder: (context, imageProvider) => Material(
                        borderRadius: BorderRadius.circular(50),
                        elevation: 1,
                        child: CircleAvatar(
                          backgroundImage: imageProvider,
                          radius: 50,
                        ),
                      ),
                      placeholder: (context, url) => ShimmerWidget.circular(width: 100, height: 100),
                      errorWidget: (context, url, error) =>
                      const Icon(Icons.error),
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      users[index].displayName,
                      textAlign: TextAlign.center,
                      style: GoogleFonts.montserrat(
                        fontSize: 14,
                        color: Colors.black,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    ),
                    Text(
                      users[index].username,
                      style: GoogleFonts.montserrat(
                        fontSize: 12,
                        color: Colors.grey,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                      ),
                    )
                  ],
                ),
              ),
            );
          },
        ));
  }
}
