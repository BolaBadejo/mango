import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/mang0_episodes.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Screens/Episodes/Pages/story_page.dart';
import 'package:provider/provider.dart';

import '../../../Services/shimmer_widget.dart';

class EpisodeIntroPage extends StatefulWidget {
  final user;
  const EpisodeIntroPage({Key? key, required this.user}) : super(key: key);

  @override
  State<EpisodeIntroPage> createState() => _EpisodeIntroPageState();
}

class _EpisodeIntroPageState extends State<EpisodeIntroPage> {

  var myStories;

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
      email: '', fcmToken: '', verified: false);

  UserService _userService = UserService();

  @override
  Widget build(BuildContext context) {
    myStories = Provider.of<List<MangoEpisodes>>(context);
    var d = const Duration(seconds:3);
    // delayed 3 seconds to next page
    Future.delayed(d, () {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => StoryPage(story: myStories,)
        ),
      );
      // to next page and close this page
    });
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            StreamBuilder<MangoUser?>(
                initialData: _user,
                stream: _userService
                    .getUserInfo(widget.user),
                builder: (BuildContext context,
                    AsyncSnapshot<MangoUser?> snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      CachedNetworkImage(
                        height: 80,
                        imageUrl: snapshot.data!.profileImage,
                        imageBuilder: (context, imageProvider) =>
                            Material(
                              borderRadius: BorderRadius.circular(50),
                              elevation: 1,
                              child: CircleAvatar(
                                backgroundImage: imageProvider,
                                radius: 40,
                              ),
                            ),
                        placeholder: (context, url) => const ShimmerWidget.circular(width: 80, height: 80,),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                      ),
                      const SizedBox(height: 20,),
                      Text(
                        "Watch \n ${snapshot.data!.displayName}'s \n episode",
                        style: const TextStyle(
                        color: Colors.white,
                      ),
                      textAlign: TextAlign.center,)
                    ],
                  );
                })
          ],
        ),
      ),
    );
  }
}
