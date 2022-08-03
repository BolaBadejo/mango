import 'package:cached_network_image/cached_network_image.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/mang0_episodes.dart';

import '../../../Models/customModel/user.dart';
import '../../../Services/shimmer_widget.dart';

class ProfileWidget extends StatelessWidget {
  final MangoUser user;
  final String date;

  const ProfileWidget({
    required this.user,
    required this.date,
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final MangoUser _user = MangoUser(
        bannerImageUrl: '',
        bio: '',
        hobbies: [],
        phone: '',
        profession: '',
        city: '',
        country: '',
        state: '',
        displayName: '',
        username: '',
        id: '',
        password: '',
        dob: '',
        gender: '',
        profileImage: '',
        email: '', fcmToken: '', verified: false);

    return Material(
        type: MaterialType.transparency,
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 16, vertical: 48),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              CachedNetworkImage(
                height: 28,
                imageUrl:
                user.profileImage,
                imageBuilder:
                    (context, imageProvider) =>
                    Material(
                      borderRadius:
                      BorderRadius.circular(50),
                      // elevation: 1,
                      child: CircleAvatar(
                        backgroundImage: imageProvider,
                        radius: 14,
                      ),
                    ),
                placeholder: (context, url) =>
                const ShimmerWidget.circular(width: 28, height: 28),
                errorWidget:
                    (context, url, error) =>
                const Icon(Icons.error),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      user.username,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.white,
                      ),
                    ),
                    Text(
                      date,
                      style: const TextStyle(color: Colors.white38),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      );
  }
}