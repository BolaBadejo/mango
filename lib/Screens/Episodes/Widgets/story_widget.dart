import 'package:flutter/material.dart';
import 'package:mango/Models/customModel/mang0_episodes.dart';
import 'package:mango/Screens/Episodes/Widgets/profile.dart';
import 'package:story_view/controller/story_controller.dart';
import 'package:story_view/utils.dart';
import 'package:story_view/widgets/story_view.dart';

import '../../../Models/customModel/user.dart';

class StoryWidget extends StatefulWidget {
  final MangoUser user;
  final List<MangoUser> users;
  final List<MangoEpisodes> episode;
  final PageController controller;

  const StoryWidget({
    required this.user,
    required this.controller, required this.episode, required this.users,
  });

  @override
  _StoryWidgetState createState() => _StoryWidgetState();
}

class _StoryWidgetState extends State<StoryWidget> {
  final storyItems = <StoryItem>[];
  StoryController? controller;
  String date = '';

  void addStoryItems() {
    for (final story in widget.episode) {
      storyItems.add(StoryItem.pageImage(
        url: story.image,
        controller: controller!,
        caption: story.postCreator,
        duration: const Duration(
          milliseconds: 5000,
        ),
      ));
      // switch (story.mediaType) {
      //   case MediaType.image:
      //     storyItems.add(StoryItem.pageImage(
      //       url: story.url,
      //       controller: controller,
      //       caption: story.caption,
      //       duration: Duration(
      //         milliseconds: (story.duration * 1000).toInt(),
      //       ),
      //     ));
      //     break;
      //   case MediaType.text:
      //     storyItems.add(
      //       StoryItem.text(
      //         title: story.caption,
      //         backgroundColor: story.color,
      //         duration: Duration(
      //           milliseconds: (story.duration * 1000).toInt(),
      //         ),
      //       ),
      //     );
      //     break;
      // }
    }
  }

  @override
  void initState() {
    super.initState();

    controller = StoryController();
    addStoryItems();
    date = widget.episode[0].timeStamp as String;
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void handleCompleted() {
    widget.controller.nextPage(
      duration: Duration(milliseconds: 300),
      curve: Curves.easeIn,
    );

    final currentIndex = widget.users.indexOf(widget.user);
    final isLastPage = widget.users.length - 1 == currentIndex;

    if (isLastPage) {
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) => Stack(
    children: <Widget>[
      Material(
        type: MaterialType.transparency,
        child: StoryView(
          storyItems: storyItems,
          controller: controller!,
          onComplete: handleCompleted,
          onVerticalSwipeComplete: (direction) {
            if (direction == Direction.down) {
              Navigator.pop(context);
            }
          },
          onStoryShow: (storyItem) {
            final index = storyItems.indexOf(storyItem);

            if (index > 0) {
              setState(() {
                date = widget.episode[index].timeStamp.toString();
              });
            }
          },
        ),
      ),
      ProfileWidget(
        user: widget.user,
        date: date,
      ),
    ],
  );
}