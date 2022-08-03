import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_animations/flutter_staggered_animations.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Screens/AccountSetup/book_genre.dart';

import '../../constants.dart';

class MusicGenreSelection extends StatefulWidget {
  final String? uid;
  const MusicGenreSelection({Key? key, required this.uid}) : super(key: key);

  @override
  _MusicGenreSelectionState createState() => _MusicGenreSelectionState(uid!);
}

class _MusicGenreSelectionState extends State<MusicGenreSelection> {
  var genres = [
    'Hiphop',
    'Dance',
    'Soul',
    'Jazz',
    'R&B',
    'EDM',
    'Grime',
    'Apala',
    'Sakara',
    'Country',
    'House',
    'Electro',
    'Rock',
    'Pop',
    'Afrobeats',
    'Afrohouse',
    'Afrosoul',
    'Afro-pop',
    'Trap',
    'Blues',
    'Raggae',
    'Techno',
    'Instrumentals',
    'Indie',
    'Fuji',
    'Juju',
    'Highlife',
    'Gospel',
    'Lullaby'
  ];
  final List  _selectedGenre = List.filled(1, "...", growable: true);
  var genrePreferenceCollection = FirebaseFirestore.instance.collection('users')
      .doc(FirebaseAuth.instance.currentUser!.uid)
      .collection('music');
  final UserService _userService = UserService();

  _MusicGenreSelectionState(this.uid);
  final String uid;

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
              genrePreferenceCollection.add({
                'selectedGenres': _selectedGenre,
              });
              Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BookGenreSelection(uid: uid,)));
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
      body: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          children: [
            const SizedBox(
              height: 130,
            ),
            const Text(
              "discover music",
              style: postTextBoxText2,
            ),
            const SizedBox(height: 20,),
            Wrap(
              direction: Axis.horizontal,
              children: selectedChips(),
            ),
            const SizedBox(
              height: 20,
            ),
            Expanded(
              child: ShaderMask(
                shaderCallback: (Rect rect) {
                  return const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.grey,
                      Colors.transparent,
                      Colors.transparent,
                      Colors.transparent
                    ],
                    stops: [
                      0.0,
                      0.1,
                      0.9,
                      1.0
                    ], // 10% purple, 80% transparent, 10% purple
                  ).createShader(rect);
                },
                blendMode: BlendMode.dstOut,
                child:
                AnimationLimiter(
                  child: GridView.builder(
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 4 / 1,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemCount: genres.length,
                    itemBuilder: (context, index) {
                      return AnimationConfiguration.staggeredGrid(
                        position: index,
                        duration: const Duration(milliseconds: 375),
                        columnCount: 2,
                        child: ScaleAnimation(
                          child: FadeInAnimation(
                            child: InkWell(
                              onTap: () => setState(() {
                                _selectedGenre.add(genres[index]);
                                genres.removeAt(index);
                                if (genres.isEmpty){
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => BookGenreSelection(uid: uid,)));
                                }
                              }),
                              child: Container(
                                alignment: Alignment.center,
                                child: Text(
                                  genres[index],
                                  style: postTextBoxText3,
                                ),
                                decoration: BoxDecoration(
                                    color: Colors.deepOrange,
                                    borderRadius: BorderRadius.circular(30)),
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }List<Widget> selectedChips () {
    List<Widget> chips = [];
    bool sttate = false;
    for (int i=0; i< _selectedGenre.length; i++) {
      Widget item = Padding(
        padding: const EdgeInsets.only(left:10, right: 5),
        child: InputChip(
          avatar: CircleAvatar(
            child: Text(
                '${_selectedGenre[i]}'),
            backgroundColor: Colors.white,
          ),
          label: Text('${_selectedGenre[i]}'),
          labelStyle: const TextStyle(color: Colors.white),
          backgroundColor: Colors.grey,
          selected: sttate,
          onDeleted: () {
            setState(() {
              _selectedGenre.removeAt(i);
            });
          },
          onSelected: (bool value)
          {
            setState(() {
              !sttate;
            });
          },
        ),
      );
      chips.add(item);
    }
    return chips;
  }
}