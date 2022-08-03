import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/customModel/mang0_episodes.dart';

import '../../../Models/cloud/user_services.dart';
import '../../../Models/customModel/user.dart';
import '../Widgets/story_widget.dart';

class StoryViewPage extends StatefulWidget {
  final MangoUser user;
  final List<MangoUser> users;

  const StoryViewPage({
    Key? key, required this.users, required this.user,
  }) : super(key: key);

  @override
  _StoryViewPageState createState() => _StoryViewPageState();
}

class _StoryViewPageState extends State<StoryViewPage> {
  late PageController controller;

  @override
  void initState() {
    super.initState();

    final initialPage = widget.users.indexOf(widget.user);
    controller = PageController(initialPage: initialPage);
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => StreamBuilder<List<MangoEpisodes>>(
      initialData: const <MangoEpisodes>[],
      stream: UserService().getEpisodes(widget.user.id),
      builder:
          (BuildContext context, AsyncSnapshot<List<MangoEpisodes>> snapshot) {
        if (!snapshot.hasData) {
          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      return PageView(
        controller: controller,
        children: widget.users
            .map((user) => StoryWidget(
          user: user,
          controller: controller, episode: snapshot.data!, users: widget.users,
        ))
            .toList(),
      );
    }
  );
  }
