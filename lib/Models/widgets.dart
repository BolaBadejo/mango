import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mango/Models/customModel/library.dart';
import 'package:mango/Models/customModel/mang0_episodes.dart';
import 'package:mango/Screens/Episodes/Pages/episode_intro_page.dart';
import 'package:mango/Screens/Home/pages/view_all_playlists.dart';
import 'package:mango/Screens/Messaging/pages/chat_page.dart';
import 'package:mango/Screens/Music/database.dart';
import 'package:mango/Screens/Music/playlist_page.dart';
import 'package:mango/Screens/Profile/profile.dart';
import 'package:mango/Services/shimmer_widget.dart';
import 'package:provider/provider.dart';
import '../Screens/Episodes/Pages/story_view_page.dart';
import '../Screens/Home/pages/view_all_users.dart';
import '../Screens/Home/pages/view_playlists_category.dart';
import '../Screens/Home/pages/viwe_booklist_category.dart';
import '../Screens/PDFReader/bookDetail.dart';
import '../constants.dart';
import 'cloud/user_services.dart';
import 'customModel/playlist.dart';
import 'customModel/user.dart';


class TrackWidget extends StatelessWidget {
  final Function() notifyParent;
  TrackWidget({Key? key, required this.notifyParent}) : super(key: key);
  final MangoUser _user = MangoUser(
      bannerImageUrl: '',
      bio: '',
      displayName: '',
      username: '',
      id: '',
      password: '',
      dob: '',
      gender: '',
      profileImage: '',
      email: '', fcmToken: '', verified: false,
      hobbies: [],
      phone: '',
      profession: '',
      city: '',
      country: '',
      state: '');
  final UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final posts = Provider.of<List<MangoPlaylist>>(context);
    return ListView.builder(
      itemCount: posts.length,
      shrinkWrap: true,
      scrollDirection: Axis.horizontal,
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => PlaylistPage(
                          mangoPost: posts[index],
                        )));
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CachedNetworkImage(
                width: _height/4.5,
                height: _height/4.5,
                imageUrl: posts[index].image,
                imageBuilder: (context, imageProvider) => Container(
                  margin: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(_height/60),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 1,
                        offset: const Offset(0, 1), // changes position of shadow
                      ),
                    ],
                    image: DecorationImage(
                      image: imageProvider,
                      fit: BoxFit.cover,
                    ),
                  ),

                ),
                placeholder: (context, url) =>  ShimmerWidget.rectangularCircularMargin(width: _height / 4.5, height: _height / 4.5, margin: const EdgeInsets.all(10),),
                errorWidget: (context, url, error) => const Icon(Icons.error),
              ),
              SizedBox(
                width: _height / 4.5,
                child: Padding(
                  padding: const EdgeInsets.only(left: 10.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        posts[index].title,
                        style: const TextStyle(
                          color: Colors.black,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      StreamBuilder<MangoUser?>(
                          initialData: _user,
                          stream:
                          _userService.getUserInfo(posts[index].postCreator),
                          builder: (BuildContext context,
                              AsyncSnapshot<MangoUser?> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Text("@${snapshot.data!.username}",
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12));
                            }
                          }),
                    ],
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class CirclePlaylistWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  final Function() notifyParent;

  const CirclePlaylistWidget(
      {Key? key,
      required this.title,
      required this.subtitle,
      required this.notifyParent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {

    double _width = MediaQuery.of(context).size.width;
    double _height = MediaQuery.of(context).size.height;
    final users = Provider.of<List<MangoUser>>(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 20, top: 0, bottom: 20, right: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title,
                style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  fontStyle: FontStyle.normal,
                ),
              ),
              GestureDetector(
                onTap: (){
                  Navigator.push(context, MaterialPageRoute(builder: (context) => ViewUser(users: users,)));
                },
                child: const Icon(Icons.arrow_forward_outlined),
                // child: Text(
                //   '>>',
                //   style: GoogleFonts.montserrat(
                //     fontSize: 20,
                //     fontWeight: FontWeight.w800,
                //     fontStyle: FontStyle.normal,
                //   ),
                // ),
              ),
            ],
          ),
        ),

        SizedBox(
          height: _height / 6.5,
          child: ListView.builder(
            itemCount: users.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
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
                        height: _height / 9.5,
                        imageUrl: users[index].profileImage,
                        imageBuilder: (context, imageProvider) => Material(
                          borderRadius: BorderRadius.circular(50),
                          elevation: 1,
                          child: CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: _height/19,
                          ),
                        ),
                        placeholder: (context, url) => ShimmerWidget.circular(width: 100, height: 100),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      SizedBox(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              users[index].displayName,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                              maxLines: 2,
                            ), users[index].verified ? const Padding(
                              padding: EdgeInsets.only(
                                  left:
                                  2.0),
                              child:
                              Icon(
                                Icons
                                    .verified,
                                size:
                                14,
                              ),
                            ) : Container(),
                          ],
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
          ),
        )
      ],
    );
  }
}

class ChatCircle extends StatelessWidget {
  const ChatCircle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final users = Provider.of<List<MangoUser>>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 20, bottom: 0),
      child: SizedBox(
        height: 60,
        child: ListView.builder(
          itemCount: users.length,
          scrollDirection: Axis.horizontal,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            if (index == 0) {
              return Container(
                margin: const EdgeInsets.only(right: 12),
                child: const CircleAvatar(
                  radius: 24,
                  child: Icon(Icons.search),
                ),
              );
            } else {
              return GestureDetector(
                onTap: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatPage(user: users[index]),
                  ));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        height: 60,
                        imageUrl: users[index].profileImage,
                        imageBuilder: (context, imageProvider) => Material(
                          borderRadius: BorderRadius.circular(50),
                          elevation: 1,
                          child: CircleAvatar(
                            backgroundImage: imageProvider,
                            radius: 30,
                          ),
                        ),
                        placeholder: (context, url) => ShimmerWidget.circular(width: 60, height: 60),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                    ],
                  ),
                ),
              );
            }
          },
        ),
      ),
    );
  }
}

class ConvoCard extends StatefulWidget {
  final message;
  final uid;
  const ConvoCard({Key? key, required this.message, required this.uid})
      : super(key: key);

  @override
  State<ConvoCard> createState() => _ConvoCardState();
}

class _ConvoCardState extends State<ConvoCard> {
  @override
  Widget build(BuildContext context) {
    Size _size = MediaQuery.of(context).size;
    final UserService _userService = UserService();
    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        id: '',
        password: '',
        dob: '',
        gender: '',
        profileImage: '',
        email: '', fcmToken: '', verified: false,
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '');
    return MultiProvider(
      providers: [
        StreamProvider<MangoUser?>(
            create: (context) => _userService.getUserInfo(widget.uid),
            initialData: _user),
      ],
      child: GestureDetector(
        onTap: () {
          print(
              "This is username: ${Provider.of<MangoUser>(context).username}");
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                user: Provider.of<MangoUser>(context),
              ),
            ),
          );
        },
        child: Container(
          width: _size.width,
          height: 70,
          padding: const EdgeInsets.only(left: 16, right: 16, top: 10, bottom: 10),
          child: Row(
            children: <Widget>[
              Expanded(
                child: Row(
                  children: <Widget>[
                    CachedNetworkImage(
                      height: 40,
                      imageUrl: Provider.of<MangoUser>(context).profileImage,
                      imageBuilder: (context, imageProvider) => Material(
                        borderRadius: BorderRadius.circular(50),
                        elevation: 1,
                        child: CircleAvatar(
                          backgroundImage: imageProvider,
                          radius: 20,
                        ),
                      ),
                      placeholder: (context, url) => const ShimmerWidget.circular(width: 40, height: 40),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                    ),
                    const SizedBox(
                      width: 16,
                    ),
                    Expanded(
                      child: Container(
                        color: Colors.transparent,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              Provider.of<MangoUser>(context).username,
                              style: const TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.w700),
                            ),
                            const SizedBox(
                              height: 6,
                            ),
                            Text(
                              widget.message.text,
                              style: TextStyle(
                                  fontSize: 13,
                                  color: Colors.grey.shade600,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const Text(
                "10:00am",
                style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class StoryCircle extends StatelessWidget {
  const StoryCircle({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    UserService _userService = UserService();
    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        dob: '',
        id: '',
        password: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        gender: '',
        profileImage: '',
        email: '', fcmToken: '', verified: false);
    final users = Provider.of<List<MangoUser>>(context);
    return Padding(
      padding: const EdgeInsets.only(left: 16.0, top: 20, bottom: 0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.zero,
        children: <Widget>[
          GestureDetector(
            onTap: () {
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(
              //     builder: (context) => StreamProvider.value(
              //         value: _userService.getEpisodes(
              //             FirebaseAuth.instance.currentUser!.uid),
              //         initialData: const <MangoEpisodes>[],
              //         child: EpisodeIntroPage(
              //           user: FirebaseAuth.instance.currentUser!.uid,
              //         )),
              //   ),
              // );
            },
            child: StreamBuilder<MangoUser?>(
                initialData: _user,
                stream: _userService
                    .getUserInfo(FirebaseAuth.instance.currentUser!.uid),
                builder: (BuildContext context,
                    AsyncSnapshot<MangoUser?> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: ShimmerWidget.circular(width: 80, height: 80),
                    );
                  }
                  return CachedNetworkImage(
                    height: 80,
                    imageUrl: snapshot.data!.profileImage,
                    imageBuilder: (context, imageProvider) => Material(
                      borderRadius: BorderRadius.circular(50),
                      elevation: 1,
                      child: CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 40,
                        child: const Icon(Icons.add, size: 35,),
                      ),
                    ),
                    placeholder: (context, url) => const ShimmerWidget.circular(width: 80, height: 80),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  );
                }),
          ),
          const SizedBox(
            height: 10,
          ),
          SizedBox(
            height: 100,
            child: ListView.builder(
              itemCount: users.length,
              scrollDirection: Axis.horizontal,
              physics: const BouncingScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (BuildContext context, int index) {
                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => StoryViewPage( users: users, user: users[index],)
                      ),
                    );
                  },
                  child: Container(
                    margin: const EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      children: [
                        CachedNetworkImage(
                                height: 80,
                                imageUrl: users[index].profileImage,
                                imageBuilder: (context, imageProvider) =>
                                    Material(
                                  borderRadius: BorderRadius.circular(50),
                                  elevation: 1,
                                  child: CircleAvatar(
                                    backgroundImage: imageProvider,
                                    radius: 40,
                                  ),
                                ),
                                placeholder: (context, url) => const ShimmerWidget.circular(width: 80, height: 80),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error),
                              ),
                        const SizedBox(height: 5,),
                        Text(users[index].username, style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 15,
                        ),),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class SquarePlaylistWidget extends StatelessWidget {
  final String? title;
  final String subtitle;

  const SquarePlaylistWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        dob: '',
        id: '',
        password: '',
        gender: '',
        profileImage: '',
        email: '', fcmToken: '', verified: false);
    final UserService _userService = UserService();

    final users = Provider.of<List<MangoPlaylist>>(context);
    bool isLoading = users.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0, bottom: 5),
                  child: Text(
                    title!,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                subtitle.isNotEmpty ? Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey),
                  ),
                ): const SizedBox(),
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.arrow_forward_outlined),
              ),
            ),
          ],
        ),
        subtitle.isNotEmpty ? SizedBox() : SizedBox(height: 20,),

        isLoading? SizedBox(
          height: 140,
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: const [
                    ShimmerWidget.rectangularCircular(width: 100, height: 100),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerWidget.rectangularCircular(width: 70, height: 12),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerWidget.rectangularCircular(width: 50, height: 12)
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
              );
            },
          ),
        ) : SizedBox(
          height: 140,
          child: ListView.builder(
            itemCount: users.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlaylistPage(
                                mangoPost: users[index],
                              )));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        height: 100,
                        imageUrl: users[index].image,
                        imageBuilder: (context, imageProvider) => Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                        placeholder: (context, url) => const ShimmerWidget.rectangularCircular(width: 100, height: 100),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        users[index].title.length > 15 ? users[index].title.substring(0, 15)+'...' : users[index].title,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      StreamBuilder<MangoUser?>(
                          initialData: _user,
                          stream:
                          _userService.getUserInfo(users[index].postCreator),
                          builder: (BuildContext context,
                              AsyncSnapshot<MangoUser?> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Text(snapshot.data!.username,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12));
                            }
                          }),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class TagListWidget extends StatelessWidget {
  final String? title;
  final String subtitle;

  const TagListWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

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
        email: '', fcmToken: '', verified: false);
    final UserService _userService = UserService();

    final users = Provider.of<List<MangoPlaylist>>(context);
    bool isLoading = users.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0, bottom: 5),
                  child: Text(
                    title!,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewPlaylistsCategory(category: title!, interest: subtitle, users: users,)));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.arrow_forward_outlined),
              ),
            ),
          ],
        ),

        isLoading? SizedBox(
          height: 140,
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: const [
                    ShimmerWidget.rectangularCircular(width: 100, height: 100),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerWidget.rectangularCircular(width: 70, height: 12),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerWidget.rectangularCircular(width: 50, height: 12)
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
              );
            },
          ),
        ) : SizedBox(
          height: 140,
          child: ListView.builder(
            itemCount: users.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PlaylistPage(
                                mangoPost: users[index],
                              )));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        height: 100,
                        imageUrl: users[index].image,
                        imageBuilder: (context, imageProvider) => Container(
                            height: 100,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                        placeholder: (context, url) => const ShimmerWidget.rectangularCircular(width: 100, height: 100),
                        errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        users[index].title.length > 15 ? users[index].title.substring(0, 15)+'...' : users[index].title,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      StreamBuilder<MangoUser?>(
                          initialData: _user,
                          stream:
                          _userService.getUserInfo(users[index].postCreator),
                          builder: (BuildContext context,
                              AsyncSnapshot<MangoUser?> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Text(snapshot.data!.username,
                                  style: const TextStyle(
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12));
                            }
                          }),
                    ],
                  ),
                ),
              );
            },
          ),
        )
      ],
    );
  }
}

class BookListWidget extends StatelessWidget {
  final String title;
  final String subtitle;

  const BookListWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        dob: '',
        id: '',
        password: '',
        gender: '',
        profileImage: '',
        email: '', fcmToken: '', verified: false);
    final UserService _userService = UserService();

    final users = Provider.of<List<MangoLibrary>>(context);
    bool isLoading = users.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0, bottom: 5),
                  child: Text(
                    title,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewBooklistCategory(category: title, interest: subtitle, users: users,)));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.arrow_forward_outlined),
              ),
            ),
          ],
        ),
        isLoading? SizedBox(
          height: 180,
          child: ListView.builder(
            itemCount: 4,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: const [
                    ShimmerWidget.rectangularCircular(width: 100, height: 140),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerWidget.rectangularCircular(width: 70, height: 12),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerWidget.rectangularCircular(width: 50, height: 12)
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
              );
            },
          ),
        ) : SizedBox(
          height: 180,
          child: ListView.builder(
            itemCount: users.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookDetail(mangoLibrary: users[index],
                              )));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        height: 140,
                        imageUrl: users[index].image,
                        imageBuilder: (context, imageProvider) => Container(
                            height: 140,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                        height: 5,
                      ),
                      Text(
                        users[index].title.length > 15 ? users[index].title.substring(0, 15)+'...' : users[index].title,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      StreamBuilder<MangoUser?>(
                          initialData: _user,
                          stream:
                          _userService.getUserInfo(users[index].postCreator),
                          builder: (BuildContext context,
                              AsyncSnapshot<MangoUser?> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Text(snapshot.data!.username.length > 15 ? snapshot.data!.username.substring(0, 15)+'...' :snapshot.data!.username,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12));
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
            },
          ),
        )
      ],
    );
  }
}


class BookChartWidget extends StatelessWidget {
  final String? title;
  final String subtitle;

  const BookChartWidget({
    Key? key,
    required this.title,
    required this.subtitle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {

    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        dob: '',
        id: '',
        password: '',
        gender: '',
        profileImage: '',
        email: '', fcmToken: '', verified: false);
    final UserService _userService = UserService();

    final users = Provider.of<List<MangoLibrary>>(context);
    bool isLoading = users.isEmpty;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 0, bottom: 5),
                  child: Text(
                    title!,
                    style: GoogleFonts.montserrat(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      fontStyle: FontStyle.normal,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 20, bottom: 20),
                  child: Text(
                    subtitle,
                    style: GoogleFonts.montserrat(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        fontStyle: FontStyle.normal,
                        color: Colors.grey),
                  ),
                ),
              ],
            ),
            GestureDetector(
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context) => ViewBooklistCategory(category: title!, interest: subtitle, users: users,)));
              },
              child: const Padding(
                padding: EdgeInsets.only(right: 20),
                child: Icon(Icons.arrow_forward_outlined),
              ),
            ),
          ],
        ),
        isLoading? SizedBox(
          height: 180,
          child: GridView.builder(
            itemCount: 5,
            gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                maxCrossAxisExtent: 200,
                childAspectRatio: 2 / 3,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10
            ),
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: const [
                    ShimmerWidget.rectangularCircular(width: 100, height: 140),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerWidget.rectangularCircular(width: 70, height: 12),
                    SizedBox(
                      height: 5,
                    ),
                    ShimmerWidget.rectangularCircular(width: 50, height: 12)
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
              );
            },
          ),
        ) : SizedBox(
          height: 180,
          child: ListView.builder(
            itemCount: users.length,
            scrollDirection: Axis.horizontal,
            shrinkWrap: true,
            itemBuilder: (BuildContext context, int index) {
              return GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => BookDetail(mangoLibrary: users[index],
                              )));
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 10),
                  child: Column(
                    children: [
                      CachedNetworkImage(
                        height: 140,
                        imageUrl: users[index].image,
                        imageBuilder: (context, imageProvider) => Container(
                            height: 140,
                            width: 100,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10),
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
                        height: 5,
                      ),
                      Text(
                        users[index].title.length > 15 ? users[index].title.substring(0, 15)+'...' : users[index].title,
                        style: GoogleFonts.montserrat(
                          fontSize: 14,
                          color: Colors.black,
                          fontWeight: FontWeight.w500,
                          fontStyle: FontStyle.normal,
                        ),
                      ),
                      StreamBuilder<MangoUser?>(
                          initialData: _user,
                          stream:
                          _userService.getUserInfo(users[index].postCreator),
                          builder: (BuildContext context,
                              AsyncSnapshot<MangoUser?> snapshot) {
                            if (!snapshot.hasData) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            } else {
                              return Text(snapshot.data!.username.length > 15 ? snapshot.data!.username.substring(0, 15)+'...' :snapshot.data!.username,
                                  style: const TextStyle(
                                    overflow: TextOverflow.ellipsis,
                                      color: Colors.grey,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12));
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
            },
          ),
        )
      ],
    );
  }
}


class PlatlistsList extends StatelessWidget {
  final List<Playlist> playlist;
  const PlatlistsList({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: playlist.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Container(
            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
            // margin: EdgeInsets.symmetric(vertical: 5,),
            decoration: BoxDecoration(
                // borderRadius: BorderRadius.circular(20),
                border: Border.symmetric(
                    horizontal: BorderSide(color: Colors.grey.shade100))),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      height: 100,
                      width: 100,
                      padding: const EdgeInsets.all(5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        image: DecorationImage(
                          image: AssetImage(all[index].artwork),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(
                      width: 10,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          all[index].title,
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
                          all[index].artist,
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
                          children: const [
                            Icon(
                              Icons.play_arrow,
                              color: Colors.black,
                              size: 14,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "300",
                              style: playlistCardStat,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.leak_add,
                              color: Colors.black,
                              size: 14,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "110",
                              style: playlistCardStat,
                            ),
                            SizedBox(
                              width: 10,
                            ),
                            Icon(
                              Icons.add_circle_outline,
                              color: Colors.black,
                              size: 14,
                            ),
                            SizedBox(
                              width: 3,
                            ),
                            Text(
                              "10",
                              style: playlistCardStat,
                            ),
                          ],
                        )
                      ],
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
            ),
          );
        });
  }
}


class PlaylistGrid extends StatelessWidget {
  const PlaylistGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final playlists = Provider.of<List<MangoPlaylist?>>(context);
    return Container(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: playlists.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 3,
            crossAxisSpacing: 4.0,
            mainAxisSpacing: 10.0,
            childAspectRatio: 0.7,
          ),
          itemBuilder: (BuildContext context, int index){
            final MangoUser _user = MangoUser(
                bannerImageUrl: '',
                bio: '',
                displayName: '',
                username: '',
                hobbies: [],
                phone: '',
                profession: '',
                city: '',
                country: '',
                state: '',
                dob: '',
                id: '',
                password: '',
                gender: '',
                profileImage: '',
                email: '', fcmToken: '', verified: false);
            return StreamBuilder<MangoUser?>(
                initialData: _user,
                stream: UserService().getUserInfo(
                    playlists[index]!.postCreator),
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
                                mangoPost: playlists[index]!,
                              )));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            height: 100,
                            imageUrl: playlists[index]!.image,
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
                            placeholder: (context, url) => const ShimmerWidget.circular(width: 100, height: 100),
                            errorWidget: (context, url, error) =>
                            const Icon(Icons.error),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          Text(
                            playlists[index]!.title.length > 25 ? playlists[index]!.title.substring(0, 25)+'...' : playlists[index]!.title,
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
        ));
  }
}


class LibraryGrid extends StatelessWidget {
  const LibraryGrid({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        displayName: '',
        username: '',
        dob: '',
        id: '',
        password: '',
        gender: '',
        profileImage: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        email: '', fcmToken: '', verified: false);
    final books = Provider.of<List<MangoLibrary?>>(context);
    return Container(
        padding: const EdgeInsets.all(12.0),
        child: GridView.builder(
          itemCount: books.length,
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
                    books[index]!.postCreator),
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
                              builder: (context) => BookDetail(mangoLibrary: books[index]!,
                              )));
                    },
                    child: Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          CachedNetworkImage(
                            height: 140,
                            imageUrl: books[index]!.image,
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
                              books[index]!.title.length > 15 ? books[index]!.title.substring(0, 15)+'...' : books[index]!.title,
                              style: GoogleFonts.montserrat(
                                fontSize: 14,
                                color: Colors.black,
                                fontWeight: FontWeight.w500,
                                fontStyle: FontStyle.normal,
                              ),
                              textAlign: TextAlign.center
                          ),
                          StreamBuilder<MangoUser?>(
                              initialData: _user,
                              stream:
                              UserService().getUserInfo(books[index]!.postCreator),
                              builder: (BuildContext context,
                                  AsyncSnapshot<MangoUser?> snapshot) {
                                if (!snapshot.hasData) {
                                  return const Center(
                                    child: CircularProgressIndicator(),
                                  );
                                } else {
                                  return Text(snapshot.data!.username.length > 15 ? snapshot.data!.username.substring(0, 15)+'...' :snapshot.data!.username,
                                      style: const TextStyle(
                                          overflow: TextOverflow.ellipsis,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.bold,
                                          fontSize: 12));
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
        ));
  }
}

class Story extends StatelessWidget {
  final List<Playlist> playlist;
  const Story({Key? key, required this.playlist}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
        itemCount: playlist.length,
        scrollDirection: Axis.horizontal,
        shrinkWrap: true,
        itemBuilder: (BuildContext context, int index) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 100,
                child: ListView.builder(
                  itemCount: playlist.length,
                  scrollDirection: Axis.horizontal,
                  shrinkWrap: true,
                  itemBuilder: (BuildContext context, int index) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 10),
                      child: Column(
                        children: [
                          CircleAvatar(
                            backgroundImage:
                                AssetImage(playlist[index].artwork),
                            radius: 40,
                          ),
                          const SizedBox(
                            height: 5,
                          ),
                          Text(
                            playlist[index].username,
                            style: GoogleFonts.montserrat(
                              fontSize: 12,
                              color: Colors.grey,
                              fontWeight: FontWeight.w500,
                              fontStyle: FontStyle.normal,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              )
            ],
          );
        });
  }
}
