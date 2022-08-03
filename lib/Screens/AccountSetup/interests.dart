import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:mango/Models/customModel/interest_elements.dart';

import '../../constants.dart';
import 'add_friends.dart';

class Interests extends StatefulWidget {
  final String? uid;
  const Interests({Key? key, required this.uid}) : super(key: key);

  @override
  _InterestsState createState() => _InterestsState();
}

class _InterestsState extends State<Interests> {
  var booksPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('books');

  var musicPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('music');

  var sportPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('sport');

  var celebritiesPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('celebrities');

  var comedyPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('comedy');

  var economyPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('economy');

  var moviesPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('movies');

  var entertainmentPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('entertainment');

  var artAndDesignPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('art_and_design');

  var sciencePreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('science');

  var techAndInnovationsPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('tech_and_innovations');

  var businessPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('business');

  var lifestylePreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('lifestyle');

  var travelPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('travel');

  var ecoPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('eco');

  var fashionPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('fashion');

  var newsPreferenceCollection = FirebaseFirestore.instance
      .collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('interests')
      .doc('news');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        shadowColor: Colors.transparent,
        automaticallyImplyLeading: false,
        actions: [
          TextButton(
            onPressed: () {
              if (SelectedInterests.books.isEmpty){} else {
                booksPreferenceCollection.set({
                'selectedGenres': SelectedInterests.books,
              });
              }
              if (SelectedInterests.music.isEmpty){} else {
                musicPreferenceCollection.set({
                'selectedGenres': SelectedInterests.music,
              });
              }
              if (SelectedInterests.comedy.isEmpty){} else {
                comedyPreferenceCollection.set({
                'selectedGenres': SelectedInterests.comedy,
              });
              }
              if (SelectedInterests.celebrities.isEmpty){} else {
                celebritiesPreferenceCollection.set({
                'selectedGenres': SelectedInterests.celebrities,
              });
              }
              if (SelectedInterests.movies.isEmpty){} else {
                moviesPreferenceCollection.set({
                'selectedGenres': SelectedInterests.movies,
              });
              }
              if (SelectedInterests.sport.isEmpty){} else {
                sportPreferenceCollection.set({
                'selectedGenres': SelectedInterests.sport,
              });
              }
              if (SelectedInterests.artanddesign.isEmpty){} else {
                artAndDesignPreferenceCollection.set({
                'selectedGenres': SelectedInterests.artanddesign,
              });
              }
              if (SelectedInterests.business.isEmpty){} else {
                businessPreferenceCollection.set({
                'selectedGenres': SelectedInterests.business,
              });
              }
              if (SelectedInterests.science.isEmpty){} else {
                sciencePreferenceCollection.set({
                'selectedGenres': SelectedInterests.science,
              });
              }
              if (SelectedInterests.lifestyle.isEmpty){} else {
                lifestylePreferenceCollection.set({
                'selectedGenres': SelectedInterests.lifestyle,
              });
              }
              if (SelectedInterests.travel.isEmpty){} else {
                travelPreferenceCollection.set({
                'selectedGenres': SelectedInterests.travel,
              });
              }
              if (SelectedInterests.economy.isEmpty){} else {
                economyPreferenceCollection.set({
                'selectedGenres': SelectedInterests.economy,
              });
              }
              if (SelectedInterests.eco.isEmpty){} else {
                ecoPreferenceCollection.set({
                'selectedGenres': SelectedInterests.eco,
              });
              }
              if (SelectedInterests.innovationsandtech.isEmpty){} else{
                techAndInnovationsPreferenceCollection.set({
                'selectedGenres': SelectedInterests.innovationsandtech,
              });
              }
              if (SelectedInterests.news.isEmpty){} else {
                newsPreferenceCollection.set({
                'selectedGenres': SelectedInterests.news,
              });
              }
              if (SelectedInterests.fashion.isEmpty){} else {
                fashionPreferenceCollection.set({
                'selectedGenres': SelectedInterests.fashion,
              });
              }

              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => MakeFriends(
                            uid: widget.uid,
                          )));
            },
            child: Row(mainAxisSize: MainAxisSize.min, children: const [
              Icon(
                Icons.skip_next,
                color: Colors.black,
                size: 22,
              ),
              SizedBox(
                width: 5.0,
              ),
              Text(
                "Next",
                style: TextStyle(
                    color: Colors.black,
                    fontWeight: FontWeight.w600,
                    fontSize: 18),
              ),
              SizedBox(
                width: 10.0,
              ),
            ]),
          )
        ],
      ),
      extendBodyBehindAppBar: true,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 130,
              ),
              const Text(
                "what are you interested in",
                style: headingextStyle,
              ),
              const SizedBox(
                height: 10,
              ),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 30),
                child: Text(
                  "tailor your Mango Space to your taste",
                  style: postTextBoxHint,
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(
                height: 40,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Books"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.books.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                          chipName: InterestList.books[index],
                          category: 'books');
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Music"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.music.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 2,
                    crossAxisSpacing: 1,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.music[index],
                        category: 'music',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Sport"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.sport.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.sport[index],
                        category: 'sport',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Celebrities"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.celebrities.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.celebrities[index],
                        category: 'celebrities',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Comedy"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.comedy.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.comedy[index],
                        category: 'comedy',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Movies"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.movies.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.movies[index],
                        category: 'movies',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Entertainment"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.entertainment.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.entertainment[index],
                        category: 'movies',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Innovation & Technology"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.innovationsAndTech.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.innovationsAndTech[index],
                        category: 'innovationsandtech',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Art & Designs"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.artAndDesign.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.artAndDesign[index],
                        category: 'artanddesign',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Science"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.science.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.science[index],
                        category: 'science',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Business"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.business.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.business[index],
                        category: 'business',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Lifestyle"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.lifestyle.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.lifestyle[index],
                        category: 'lifestyle',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Travel"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.travel.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.travel[index],
                        category: 'travel',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("News"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.news.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.news[index],
                        category: 'news',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Eco"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.eco.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.eco[index],
                        category: 'eco',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer("Fashion"),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.fashion.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.fashion[index],
                        category: 'fashion',
                      );
                    },
                  ),
                ),
              ),
              const Divider(
                color: Colors.blueGrey,
                height: 10.0,
              ),
              const SizedBox(
                height: 20,
              ),
              Align(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: _titleContainer('Life & History'),
                ),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: SizedBox(
                  height: 150,
                  child: MasonryGridView.count(
                    scrollDirection: Axis.horizontal,
                    itemCount: InterestList.lifeAndHistory.length,
                    crossAxisCount: 3,
                    mainAxisSpacing: 4,
                    crossAxisSpacing: 4,
                    itemBuilder: (context, index) {
                      return FilterChipWidget(
                        chipName: InterestList.lifeAndHistory[index],
                        category: 'lifeAndHistory',
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

Widget _titleContainer(String myTitle) {
  return Text(
    myTitle,
    style: const TextStyle(
        color: Colors.black, fontSize: 18.0, fontWeight: FontWeight.bold),
  );
}

class FilterChipWidget extends StatefulWidget {
  final String chipName;
  final String category;

  const FilterChipWidget(
      {Key? key, required this.chipName, required this.category})
      : super(key: key);

  @override
  _FilterChipWidgetState createState() => _FilterChipWidgetState();
}

class _FilterChipWidgetState extends State<FilterChipWidget> {
  var _isSelected = false;
  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.chipName),
      labelStyle: const TextStyle(
          color: Colors.black, fontSize: 16.0, fontWeight: FontWeight.w600),
      selected: _isSelected,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(30.0),
      ),
      backgroundColor: const Color(0xffededed),
      onSelected: (bool isSelected) {
        setState(() {
          switch (widget.category) {
            case "books":
              {
                SelectedInterests.books.add(widget.chipName);
              }
              break;

            case "music":
              {
                SelectedInterests.music.add(widget.chipName);
              }
              break;

            case "sport":
              {
                SelectedInterests.sport.add(widget.chipName);
              }
              break;

            case "celebrities":
              {
                SelectedInterests.celebrities.add(widget.chipName);
              }
              break;

            case "comedy":
              {
                SelectedInterests.comedy.add(widget.chipName);
              }
              break;

            case "movies":
              {
                SelectedInterests.movies.add(widget.chipName);
              }
              break;

            case "innovationsandtech":
              {
                SelectedInterests.innovationsandtech.add(widget.chipName);
              }
              break;

            case "artanddesign":
              {
                SelectedInterests.artanddesign.add(widget.chipName);
              }
              break;

            case "science":
              {
                SelectedInterests.science.add(widget.chipName);
              }
              break;

            case "lifestyle":
              {
                SelectedInterests.lifestyle.add(widget.chipName);
              }
              break;

            case "business":
              {
                SelectedInterests.business.add(widget.chipName);
              }
              break;

            case "travel":
              {
                SelectedInterests.travel.add(widget.chipName);
              }
              break;

            case "news":
              {
                SelectedInterests.news.add(widget.chipName);
              }
              break;

            case "eco":
              {
                SelectedInterests.eco.add(widget.chipName);
              }
              break;

            case "lifeAndHistory":
              {
                SelectedInterests.lifeAndHistory.add(widget.chipName);
              }
              break;

            case "fashion":
              {
                SelectedInterests.fashion.add(widget.chipName);
              }
              break;
          }
          _isSelected = isSelected;
        });
      },
      selectedColor: Colors.deepOrangeAccent.withOpacity(0.6),
    );
  }
}
