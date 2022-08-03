import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:mango/Screens/Auth/authentication.dart';
import 'package:mango/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'onboarding_model.dart';

class OnBoard extends StatefulWidget {
  const OnBoard({Key? key}) : super(key: key);

  @override
  _OnBoardState createState() => _OnBoardState();
}

class _OnBoardState extends State<OnBoard> {
  int currentIndex = 0;
  late PageController _pageController;
  List<OnboardModel> screens = <OnboardModel>[
    OnboardModel(
      img: 'assets/images/img-1.png',
      text: "Music",
      desc:
      "Set your moments and moods with music playlists for you",
      bg: kCoral,
      button: kCoralMono, textColor: Colors.black,
    ),
    OnboardModel(
      img: 'assets/images/img-2.png',
      text: "Books",
      desc:
      "Fill your library with books and reading friends for you",
      bg: kKhaki,
      button: kKhakiMono, textColor: Colors.black,
    ),
    OnboardModel(
      img: 'assets/images/img-3.png',
      text: "Community",
      desc:
      "Join others in creating blissful moments and share them in your tribe",
      bg: kGold,
      button: kGoldMono, textColor: Colors.black87,
    ),
    OnboardModel(
      img: 'assets/images/img-3.png',
      text: "Connect",
      desc:
      "Meet people and create moments the way you like it",
      bg: kMidSeaGreen,
      button: kMidSeaGreenMono, textColor: Colors.white,
    ),
  ];

  @override
  void initState() {
    _pageController = PageController(initialPage: 0);
    super.initState();
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  _storeOnboardInfo() async {
    if (kDebugMode) {
      print("Shared pref called");
    }
    int isViewed = 0;
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setInt('onBoard', isViewed);
    if (kDebugMode) {
      print(prefs.getInt('onBoard'));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: screens[currentIndex].bg,
      appBar: AppBar(
        backgroundColor: screens[currentIndex].bg,
        elevation: 0.0,
        actions: [
          TextButton(
            onPressed: () {
              _storeOnboardInfo();
              Navigator.pushReplacement(
                  context, MaterialPageRoute(builder: (context) => const Authenticate()));
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: [
              Icon(
                Icons.skip_next,
                color: screens[currentIndex].textColor,
                size: 15,
              ),
              const SizedBox(
                width: 5.0,
              ),
              Text(
                "Skip",
                style: TextStyle(
                  color: screens[currentIndex].textColor,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(
                width: 10.0,
              ),
            ]),


          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 30.0),
        child: PageView.builder(
            itemCount: screens.length,
            controller: _pageController,
            physics: const NeverScrollableScrollPhysics(),
            onPageChanged: (int index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (_, index) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Image.asset(screens[index].img),
                  SizedBox(
                    height: 10.0,
                    child: ListView.builder(
                      itemCount: screens.length,
                      shrinkWrap: true,
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        return Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.symmetric(horizontal: 3.0),
                                width: currentIndex == index ? 25 : 8,
                                height: 8,
                                decoration: BoxDecoration(
                                  color: screens[currentIndex].button,
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            ]);
                      },
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: screens[index].text.length > 9 ? double.infinity : MediaQuery.of(context).size.width/1.5,
                        child: FittedBox(
                          fit: BoxFit.fitWidth,
                          child: Text(
                            screens[index].text,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              // fontSize: 78,
                              fontWeight: FontWeight.w900,
                              fontFamily: 'Montserrat',
                              color: screens[index].textColor,
                            ),
                          ),),
                      ),
                      const SizedBox(height: 10,),
                      Text(
                        screens[index].desc,
                        textAlign: TextAlign.center,
                        textWidthBasis: TextWidthBasis.longestLine,
                        overflow: TextOverflow.fade,
                        maxLines: 4,
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontStyle: FontStyle.italic,
                          fontFamily: 'Montserrat',
                          color: screens[index].textColor,
                        ),
                      ),
                    ],
                  ),
                  InkWell(
                    onTap: () async {
                      if (index == screens.length - 1) {
                        await _storeOnboardInfo();
                        Navigator.pushReplacement(context,
                            MaterialPageRoute(builder: (context) => const Authenticate()));
                      }

                      _pageController.nextPage(
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.bounceIn,
                      );
                    },
                    child: Container(
                      padding:
                      const EdgeInsets.symmetric(horizontal: 30.0, vertical: 10),
                      decoration: BoxDecoration(
                          color: screens[index].button,
                          borderRadius: BorderRadius.circular(15.0)),
                      child: Row(mainAxisSize: MainAxisSize.min, children: [
                        Text(
                          "Next",
                          style: TextStyle(
                              fontSize: 16.0,
                              color: screens[index].textColor),
                        ),
                        const SizedBox(
                          width: 15.0,
                        ),
                        Icon(
                          Icons.arrow_forward_sharp,
                          color: screens[index].textColor,
                        )
                      ]),
                    ),
                  )
                ],
              );
            }),
      ),
    );
  }
}