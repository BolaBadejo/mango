import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/post_services.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/mang0_episodes.dart';
import 'package:mango/Models/customModel/post.dart';
import 'package:mango/Models/customModel/reply_books.dart';
import 'package:mango/Models/customModel/timeago.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:mango/Models/widgets.dart';
import 'package:mango/Screens/Auth/signin.dart';
import 'package:mango/Screens/Auth/signup.dart';
import 'package:mango/Screens/Music/playlist_page.dart';
import 'package:mango/Screens/Music/web_viewer.dart';
import 'package:mango/Screens/Notifications/mango_notifications.dart';
import 'package:mango/Screens/PDFReader/bookDetail.dart';
import 'package:mango/Screens/PDFReader/widget/comment_book.dart';
import 'package:mango/Screens/Posts/reply_post.dart';
import 'package:mango/Screens/Posts/view_post.dart';
import 'package:mango/Services/photo_viewer.dart';
import 'package:provider/provider.dart';

import '../../Models/customModel/library.dart';
import '../../Services/shimmer_widget.dart';
import '../Profile/profile.dart';

class NotificationsList extends StatefulWidget {
  final scrollController;
  const NotificationsList({Key? key, this.scrollController}) : super(key: key);

  @override
  _NotificationsListState createState() => _NotificationsListState();
}

class _NotificationsListState extends State<NotificationsList> {
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
      id: '',
      password: '',
      gender: '',
      profileImage: '',
      email: '', fcmToken: '', verified: false);
  @override
  Widget build(BuildContext context) {
    final notification = Provider.of<List<MangoNotifications>>(context);
    print(notification.length);
    return ListView.builder(
      controller: widget.scrollController,
      padding: MediaQuery
          .of(context)
          .padding
          .copyWith(
        top: 0,
        left: 0,
        right: 0,
        bottom: 50,
      ),
      scrollDirection: Axis.vertical,
      shrinkWrap: true,
      itemCount: notification.length,
      itemBuilder: (context, index) {
        final notify = notification[index];
        double actualTime = notify.timeStamp
            .toDate()
            .difference(DateTime.now())
            .inMinutes
            .toDouble();
        actualTime *= 1;
        String timeString = '';
        double apprTime = 0;
        if ((actualTime / 60) >= 0 && 24 > (actualTime / 60)) {
          apprTime = actualTime / 60;
          timeString = "$apprTime";
        } else if ((actualTime / 1440) >= 1 && 1000 > (actualTime / 1440)) {
          apprTime = actualTime / 1440;
          timeString = "$apprTime";
        }
        return Container(
          margin: const EdgeInsets.only(bottom: 15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(30),
            color: Colors.white70

          ),
          child: StreamBuilder<MangoUser?>(
              initialData: _user,
              stream: _userService.getUserInfo(notify.sender),
              builder:
                  (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
                if (!snapshot.hasData) {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              return ListTile(
                onTap: (){
                  if(notify.page == ''){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              userId: notify.sender,
                            )));
                  }
                  else if (notify.page == 'post'){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ViewPost(
                              post: notify.pageId, user: snapshot.data!,
                            )));
                  }
                  else if (notify.page == 'user'){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => ProfilePage(
                              userId: notify.sender,
                            )));
                  }
                  else if (notify.page == 'playlist'){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => PlaylistPage(
                              mangoPost: notify.pageId,
                            )));
                  }
                  else if (notify.page == 'book'){
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => BookDetail(
                              mangoLibrary: notify.pageId,
                            )));
                  }
                },
                leading: CachedNetworkImage(
                  height: 44,
                  imageUrl:
                  snapshot.data?.profileImage ??
                      '',
                  imageBuilder:
                      (context, imageProvider) =>
                      Material(
                        borderRadius:
                        BorderRadius.circular(50),
                        // elevation: 1,
                        child: CircleAvatar(
                          backgroundImage: imageProvider,
                          radius: 22,
                        ),
                      ),
                  placeholder: (context, url) =>
                  const ShimmerWidget.circular(width: 44, height: 44,),
                  errorWidget:
                      (context, url, error) =>
                  const Icon(Icons.error),
                ),
                title: Text(notify.title,
                    style: const TextStyle(
                  color: Colors.black,
                  fontSize: 14,
                  fontWeight: FontWeight.w900,
                )),
                subtitle: Text(notify.message,
                style: const TextStyle(
                  color: Colors.grey,
                  fontSize: 12,
                  fontWeight: FontWeight.w900,
                )),
                trailing: Text(timeString),
              );
            }
          ),
        );
      },
    );
  }
}