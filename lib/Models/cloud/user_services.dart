import 'dart:collection';
import 'dart:convert';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/customModel/chat.dart';
import 'package:mango/Models/customModel/mang0_episodes.dart';
import 'package:mango/Models/customModel/user.dart';
import 'package:http/http.dart' as http;
import 'package:quiver/iterables.dart';

import '../../utils.dart';

class UserService {
  final UtilsService _utilsService = UtilsService();

  MangoUser? _userFromFirebaseSnapshot(DocumentSnapshot snapshot) {
    return snapshot != null
        ? MangoUser(
            gender: (snapshot.data() as dynamic)['gender'] ?? '',
            password: (snapshot.data() as dynamic)['password'] ?? '',
            email: (snapshot.data() as dynamic)['email'] ?? '',
            profession: (snapshot.data() as dynamic)['profession'] ?? '',
            phone: (snapshot.data() as dynamic)['phone'] ?? '',
            country: (snapshot.data() as dynamic)['country'] ?? '',
            state: (snapshot.data() as dynamic)['state'] ?? '',
            city: (snapshot.data() as dynamic)['city'] ?? '',
            hobbies: (snapshot.data() as dynamic)['hobbies'] ?? [],
            bannerImageUrl:
                (snapshot.data() as dynamic)['bannerImageUrl'] ?? '',
            profileImage: (snapshot.data() as dynamic)['profileImage'],
            bio: (snapshot.data() as dynamic)['bio'] ?? '',
            displayName: (snapshot.data() as dynamic)['displayName'] ?? '',
            username: (snapshot.data() as dynamic)['username'] ?? '',
            fcmToken: (snapshot.data() as dynamic)['fcmToken'] ?? '',
            dob: (snapshot.data() as dynamic)['dob'] ?? '',
            verified: (snapshot.data() as dynamic)['verified'] ?? false,
            id: snapshot.id,
          )
        : null;
  }

  List<Message> _lastMessageFirebaseSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Message(
          text: (doc.data() as dynamic)['message'] ?? '',
          timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
          receiver: (doc.data() as dynamic)['id'] ?? '',
          sender: (doc.data() as dynamic)['sender'] ?? '');
    }).toList();
  }

  List<Message> _messageListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Message(
          text: (doc.data() as dynamic)['message'] ?? '',
          timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
          replyMessage: (doc.data() as dynamic)['replyMessage'] ?? '',
          receiver: (doc.data() as dynamic)['id'] ?? '',
          sender: (doc.data() as dynamic)['sender'] ?? '');
    }).toList();
  }

  Stream<MangoUser?> getUserInfo(String? uid) {
    String id = ' ';
    if (uid!.isNotEmpty) {
      id = uid;
    }
    return FirebaseFirestore.instance
        .collection("users")
        .doc(id)
        .snapshots()
        .map(_userFromFirebaseSnapshot);
  }

  Future<List<MangoUser>> getUserbyUsername(String username) async {
    String cleanUsername = username.substring(1);
    var query = await FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: cleanUsername)
        .get();

    return _usersFromSnapshots(query);
  }

  Stream<int> noFollowers(uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("followers")
        .snapshots()
        .length
        .asStream();
  }

  Stream<int> noFollowing(uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection("following")
        .snapshots()
        .length
        .asStream();
  }

  Stream<bool> isFollowing(uid, otherUid) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .doc(otherUid)
        .snapshots()
        .map((snapshots) => snapshots.exists);
  }

  Future<void> bookGenres(String genre) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('books')
        .doc(genre)
        .set({});
  }

  Future<void> uploadMessage(uid, message, replyMessage) async {
    if (message == '') {
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('chats')
          .doc(uid)
          .collection('messages')
          .add({
        'id': uid,
        'sender': FirebaseAuth.instance.currentUser!.uid,
        'message': message,
        'replyMessage': replyMessage,
        'timeStamp': FieldValue.serverTimestamp()
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('chats')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('messages')
          .add({
        'id': uid,
        'sender': FirebaseAuth.instance.currentUser!.uid,
        'message': message,
        'replyMessage': replyMessage,
        'timeStamp': FieldValue.serverTimestamp()
      });
    }
  }

  Future<void> registerConversation(uid, message) async {
    if (message == '') {
    } else {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection('conversations')
          .doc(uid)
          .set({});

      await FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('conversations')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .set({});
    }
  }

  Stream<List<Message>> getMessages(uid) {
    return FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('chats')
        .doc(uid)
        .collection('messages')
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(_messageListFromSnapshots);
  }

  Future<void> followUser(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('following')
        .doc(uid)
        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});

    FirebaseMessaging.instance
        .subscribeToTopic(FirebaseAuth.instance.currentUser!.uid);
  }

  Future<List<String>> whoFollowsUser(uid) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("followers")
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    users.add(uid);
    return users;
  }

  Future<List<String>> whoUserFollows(uid) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    users.add(uid);
    return users;
  }

  Future<List<String>> whoFollowsUser2(uid) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("followers")
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    return users;
  }

  Future<List<String>> whoUserFollows2(uid) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("following")
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    return users;
  }

  Future<void> unfollowUser(uid) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('following')
        .doc(uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('followers')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }

  Future<List<MangoUser>> getFollowers(String uid) async {
    List<String> usersFollowing = await UserService().whoFollowsUser2(uid);

    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);

    List<MangoUser> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("id", whereIn: splitUsersFollowing.elementAt(i))
          .get();

      feedList.addAll(_usersFromSnapshots(querySnapshot));
    }

    return feedList;
  }

  Future<List<MangoUser>> getFollowing(String uid) async {
    List<String> usersFollowing = await UserService().whoUserFollows2(uid);

    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);

    List<MangoUser> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("users")
          .where("id", whereIn: splitUsersFollowing.elementAt(i))
          .get();

      feedList.addAll(_usersFromSnapshots(querySnapshot));
    }

    return feedList;
  }

  Stream<List<MangoUser?>> getUserByName(word) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isGreaterThanOrEqualTo: [word])
        .limit(10)
        .snapshots()
        .map(_userListFromSnapshot);
  }

  Stream<List<MangoUser?>> getUserByUserName(name) {
    return FirebaseFirestore.instance
        .collection("users")
        .where('username', isEqualTo: name)
        .limit(1)
        .snapshots()
        .map(_userListFromSnapshot);
  }

  List<MangoUser> _usersFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoUser(
        gender: (doc.data() as dynamic)['gender'] ?? '',
        password: (doc.data() as dynamic)['password'] ?? '',
        profession: (doc.data() as dynamic)['profession'] ?? '',
        phone: (doc.data() as dynamic)['phone'] ?? '',
        country: (doc.data() as dynamic)['country'] ?? '',
        state: (doc.data() as dynamic)['state'] ?? '',
        city: (doc.data() as dynamic)['city'] ?? '',
        hobbies: (doc.data() as dynamic)['hobbies'] ?? [],
        email: (doc.data() as dynamic)['email'] ?? '',
        bannerImageUrl: (doc.data() as dynamic)['bannerImageUrl'] ?? '',
        profileImage: (doc.data() as dynamic)['profileImage'],
        bio: (doc.data() as dynamic)['bio'] ?? '',
        displayName: (doc.data() as dynamic)['displayName'] ?? '',
        username: (doc.data() as dynamic)['username'] ?? '',
        verified: (doc.data() as dynamic)['verified'] ?? false,
        dob: (doc.data() as dynamic)['dob'] ?? '',
        id: doc.id,
        fcmToken: (doc.data() as dynamic)['fcmToken'] ?? '',
      );
    }).toList();
  }

  Future saveUser(a, b, c, d, e, f, g) async {
    await FirebaseFirestore.instance.collection("users").add({
      'id': a,
      'username': b,
      'password': c,
      'email': d,
      'gender': e,
      'timeCreated': f,
      'profileImage': g
    });
  }

  Future<void> updateBannerImage(File? _bannerImage) async {
    String bannerImageUrl = '';
    bannerImageUrl = await _utilsService.uploadFile(_bannerImage!,
        "user/profile/${FirebaseAuth.instance.currentUser!.uid}/bannerImageUrl");

    Map<String, Object> data = HashMap();
    if (bannerImageUrl != '') data['bannerImageUrl'] = bannerImageUrl;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }

  Future<void> updateProfileImage(File? _profileImage) async {
    String profileImage = '';
    profileImage = await _utilsService.uploadFile(_profileImage!,
        "user/profile/${FirebaseAuth.instance.currentUser!.uid}/profileImage");

    Map<String, Object> data = HashMap();
    if (profileImage != '') data['profileImage'] = profileImage;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }

  Future<void> updateDisplayName(String? displayName) async {
    Map<String, Object> data = HashMap();
    if (displayName != '') data['displayName'] = displayName!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }

  Future<void> updateUsername(String? username) async {
    Map<String, Object> data = HashMap();
    if (username != '') data['username'] = username!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }

  Future<void> updateDOB(String? dob) async {
    Map<String, Object> data = HashMap();
    if (dob != '') data['dob'] = dob!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }

  Future<void> updateCountry(String? country) async {
    Map<String, Object> data = HashMap();
    if (country != '') data['country'] = country!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    // print('Nationality updated');
  }

  Future<void> updateState(String? state) async {
    Map<String, Object> data = HashMap();
    if (state != '') data['state'] = state!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    // print('state updated');
  }

  Future<void> updatePhone(String? state) async {
    Map<String, Object> data = HashMap();
    if (state != '') data['phone'] = state!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    // print('phone updated');
  }

  Future<void> updateCity(String? city) async {
    Map<String, Object> data = HashMap();
    if (city != '') data['city'] = city!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    // print('city updated');
  }

  Future<void> updateProfession(String? jd) async {
    Map<String, Object> data = HashMap();
    if (jd != '') data['profession'] = jd!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    // print('profession updated');
  }

  Future<void> updateHobbies(List<String> jd) async {
    // print(jd);
    Map<String, Object> data = HashMap();
    if (jd.isNotEmpty) data['hobbies'] = jd;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    // print('hobbies updated');
  }

  Future<void> updateBio(String? bio) async {
    Map<String, Object> data = HashMap();
    if (bio != '') data['bio'] = bio!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
    // print('bio updated');
  }

  Future<void> updateProfile(
      String? displayName,
      String? username,
      String? bio,
      String? gender) async {

    Map<String, Object> data = HashMap();
    if (username != '') data['username'] = username!;
    if (displayName != '') data['displayName'] = displayName!;
    if (bio != '') data['bio'] = bio!;
    if (gender != '') data['gender'] = gender!;

    await FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update(data);
  }

  Stream<List<MangoUser>> getAllUsers(uid) {
    return FirebaseFirestore.instance
        .collection("users")
        .snapshots()
        .map(_usersFromSnapshots);
  }

  Future<List> getAllUserName() async {
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection('users').get();
    final allData =
        querySnapshot.docs.map((doc) => doc.get('username')).toList();
    return allData;
  }

  Future<List<String>> usersWithInterest(
      String category, String interest) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users/$category/")
        .where("selectedGenres", arrayContains: interest)
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    return users;
  }

  List<MangoUser?> _userListFromSnapshot(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoUser(
        id: doc.id,
        bio: (doc.data() as dynamic)['bio'] ?? '',
        profession: (doc.data() as dynamic)['profession'] ?? '',
        phone: (doc.data() as dynamic)['phone'] ?? '',
        country: (doc.data() as dynamic)['country'] ?? '',
        state: (doc.data() as dynamic)['state'] ?? '',
        city: (doc.data() as dynamic)['city'] ?? '',
        hobbies: (doc.data() as dynamic)['hobbies'] ?? [],
        username: (doc.data() as dynamic)['username'] ?? '',
        gender: (doc.data() as dynamic)['gender'] ?? '',
        verified: (doc.data() as dynamic)['verified'] ?? false,
        password: (doc.data() as dynamic)['password'] ?? '',
        bannerImageUrl: (doc.data() as dynamic)['bannerImageUrl'] ?? '',
        dob: (doc.data() as dynamic)['dob'] ?? '',
        email: (doc.data() as dynamic)['email'] ?? '',
        displayName: (doc.data() as dynamic)['displayName'] ?? '',
        profileImage: (doc.data() as dynamic)['profileImage'] ?? '',
        fcmToken: (doc.data() as dynamic)['fcmToken'] ?? '',
      );
    }).toList();
  }

  Future<List<String>> allUserId(uid) async {
    QuerySnapshot query =
        await FirebaseFirestore.instance.collection("users").get();

    final users = query.docs.map((doc) => doc.id).toList();
    return users;
  }

  Future<List<String>> getData() async {
    // Get docs from collection reference
    QuerySnapshot querySnapshot =
        await FirebaseFirestore.instance.collection("users").get();
    // Get data from docs and convert map to List
    final allData = querySnapshot.docs.map((doc) => doc.id).toList();
    return allData;
  }

  Future<List<String>> userInterestList(uid) async {
    final result = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("interests")
        .get();

    final users = result.docs.map((doc) => doc.id).toList();
    // final users = result.docs.map((doc) => doc.data().toString()).toList();
    // print(users);
    return users;
  }

  Future<List<String>> getInterest(interest) async {
    List<String> interestList = [];
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('interests')
        .doc(interest)
        .get()
        .then((value) {
      // first add the data to the Offset object
      for (var value in List.from(value.data()!['selectedGenres'])) {
        interestList.add(value);
      }
    });
    // // print(interestList);

    return interestList;
  }

  Future<List> checkUserInterest(category, interest) async {
    List<String> interestList = [];

    var uid = await getData();
    var val = [];
    for (int i = 0; i < uid.length; i++) {
      QuerySnapshot? querySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(uid[i])
          .collection('interests')
          .doc(category)
          .get()
          .then((value) {
        // first add the data to the Offset object
        for (var value in List.from(value.data()!['selectedGenres'])) {
          interestList.add(value);
        }
        return null;
      });
      if (interestList.contains(interest)) {
        val.add(uid[i]);
      } else {}
    }
    return val;
  }

  Future<String> doesUserHaveInterest(category, interest, uid) async {
    final DocumentReference result = FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("interests")
        .doc(category);

    DocumentSnapshot value = await result.get();
    List<dynamic>? documents = value['selectedGenres'];
    if (documents!.isNotEmpty) {
      return uid;
    } else {
      return "uninterested";
    }
  }
  // Future<String> doesUserHaveInterest(category, interest, uid) async {
  //   final QuerySnapshot result = await FirebaseFirestore.instance
  //       .collection("users")
  //       .doc(uid)
  //       .collection(category)
  //       .where("selectedGenres", arrayContains: interest)
  //       .get();
  //
  //
  //   final List<DocumentSnapshot> documents = result.docs;
  //
  //   if (documents.isNotEmpty) {
  //
  //     return uid;
  //   } else {
  //     return "uninterested";
  //   }
  // }

  Future<List> whoIsInterestedFollowsUser(category, interest) async {
    var uid = await getData();
    var val = [];
    for (int i = 0; i < uid.length; i++) {
      var feedback = await doesUserHaveInterest(category, interest, uid[i]);
      if (feedback == "uninterested") {
      } else {
        val.add(feedback);
      }
    }

    return val;
  }

  Future<List<String>> getConversators(uid) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection("users")
        .doc(uid)
        .collection("conversations")
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    return users;
  }

  Future<List<Message>> getConversationInfo(uid) async {
    {
      List<String> usersFollowing = await UserService().getConversators(uid);

      var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);

      List<Message> feedList = [];

      for (int i = 0; i < usersFollowing.length; i++) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('users')
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .collection('chats')
            .doc(usersFollowing[i])
            .collection('messages')
            .orderBy('timeStamp', descending: true)
            .limit(1)
            .get();

        feedList.addAll(_lastMessageFirebaseSnapshot(querySnapshot));
      }

      feedList.sort((a, b) {
        var adate = a.timeStamp;
        var bdate = b.timeStamp;

        return bdate.compareTo(adate);
      });

      return feedList;
    }
  }

  List<MangoEpisodes> _episodesFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoEpisodes(
        postCreator: (doc.data() as dynamic)['postCreator'] ?? '',
        image: (doc.data() as dynamic)['image'] ?? '',
        timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
        id: doc.id,
      );
    }).toList();
  }

  List<MangoEpisodes> _episodeListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoEpisodes(
        postCreator: (doc.data() as dynamic)['postCreator'] ?? '',
        image: (doc.data() as dynamic)['image'] ?? '',
        timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
        id: doc.id,
      );
    }).toList();
  }

  Future<List<MangoEpisodes>> getEpisodeInfo(uid) async {
    {
      List<String> usersFollowing = await UserService().whoUserFollows(uid);
      usersFollowing.add(FirebaseAuth.instance.currentUser!.uid);
      var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);

      List<MangoEpisodes> feedList = [];

      for (int i = 0; i < usersFollowing.length; i++) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('episodes')
            .where("postCreator", isEqualTo: usersFollowing[i])
            .orderBy('timeStamp', descending: true)
            .limit(1)
            .get();
        feedList.addAll(_episodesFromSnapshots(querySnapshot));
      }

      feedList.sort((a, b) {
        var adate = a.timeStamp;
        var bdate = b.timeStamp;

        return bdate.compareTo(adate);
      });
      return feedList;
    }
  }

  Future<List<MangoUser>> findUsersWithEpisodes(uid) async {
    {
      List<String> usersFollowing = await UserService().whoUserFollows(uid);
      usersFollowing.add(FirebaseAuth.instance.currentUser!.uid);
      var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);

      List<MangoEpisodes> feedList = [];
      List<MangoUser> userList = [];
      List uidList = [];

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
          email: '',
          fcmToken: '',
          verified: false,
          hobbies: [],
          phone: '',
          profession: '',
          city: '',
          country: '',
          state: '');

      for (int i = 0; i < splitUsersFollowing.length; i++) {
        QuerySnapshot querySnapshot = await FirebaseFirestore.instance
            .collection('episodes')
            .where("postCreator", isEqualTo: splitUsersFollowing.elementAt(i))
            .orderBy('timeStamp', descending: true)
            .limit(1)
            .get()
            .then((value) {
          if (value.docs.isNotEmpty) {
            // print('this user has a story ${splitUsersFollowing.elementAt(i)}');
            uidList.add(splitUsersFollowing.elementAt(i));
          } else {}
          return value;
        });
        feedList.addAll(_episodesFromSnapshots(querySnapshot));
      }

      for (int j = 0; j < feedList.length; j++) {
        StreamBuilder<MangoUser?>(
            initialData: _user,
            stream: UserService().getUserInfo(uidList[j]),
            builder:
                (BuildContext context, AsyncSnapshot<MangoUser?> snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
              MangoUser? user = snapshot.data!;
              userList.add(user);
              return Container();
            });
      }
      return userList;
    }
  }



  // Stream <List<MangoUser>> getUsersWithProfession(String profession){
  //   return FirebaseFirestore.instance
  //       .collection('users')
  //       .where('tags', isEqualTo: profession)
  //       .snapshots()
  //       .map(_usersFromSnapshots);
  // }

  Future<List<String>> getUsersWithProfession(String profession) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('profession', isEqualTo: profession)
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    return users;
  }

  Future<List<String>> getUsersWithState(String state) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('state', isEqualTo: state)
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    return users;
  }

  Future<List<String>> getUsersWithCity(String city) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('city', isEqualTo: city)
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    return users;
  }

  Future<List<String>> getUsersWithCountry(String country) async {
    QuerySnapshot query = await FirebaseFirestore.instance
        .collection('users')
        .where('country', isEqualTo: country)
        .get();

    final users = query.docs.map((doc) => doc.id).toList();
    return users;
  }

  Stream <List<MangoUser>> getUsersWithHobbies(String hobby){
    return FirebaseFirestore.instance
        .collection('users')
        .where('hobbies', arrayContains: hobby)
        .snapshots()
        .map(_usersFromSnapshots);
  }

  Stream<List<MangoEpisodes>> getEpisodes(uid) {
    return FirebaseFirestore.instance
        .collection('episodes')
        .where('postCreator', isEqualTo: uid)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(_episodeListFromSnapshots);
  }

  Future sendNotification(var id, String page, String message, String title, String receiverID, String receiverToken) async {
    var db = FirebaseFirestore.instance;
    await db.collection('notifications').add({
      'pageId': id,
      'message': message,
      'title': title,
      'sender': FirebaseAuth.instance.currentUser!.uid,
      'page': page,
      'receiver': receiverID,
      'time': FieldValue.serverTimestamp(),
    });

    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'body': message,
      'title': title,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAAz8AR0X8:APA91bEh-1OM8JyYmnc2LbxdNyLkCEYzhzKXf5Tc-JtYms2cm6dJX6m4B_oCzefsIYHiw2IZsxr-ozmxYkIRCCH4E6leZTPsNDBI9aobj3waUk1RvZ4bwyiYNwV7VrtyXDF2EDsOGF0v'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': message
                },
                'priority': 'high',
                'data': data,
                'to': '$receiverToken'
              }));

      if (response.statusCode == 200) {
        // print("notification sent");
      } else {
        // print("Error");
      }
    } catch (e) {
      // print(e);
    }
    return;
  }

  Future sendNotificationToTopic(
      String message, String title, String receiverID) async {
    final data = {
      'click_action': 'FLUTTER_NOTIFICATION_CLICK',
      'id': '1',
      'status': 'done',
      'body': message,
      'title': title,
    };

    try {
      http.Response response =
          await http.post(Uri.parse('https://fcm.googleapis.com/fcm/send'),
              headers: <String, String>{
                'Content-Type': 'application/json',
                'Authorization':
                    'key=AAAA7NEUBtQ:APA91bFXJb8RWaNPOwdeu3Ih3Jlb3hvQWjp1eRSxMs2xpMuOcJMdzYQYqZHP82-hYCDErFrrQdfrZ9cGiTlkNKvrgJqmaRrNoVqjPKNx34E76tyqwg2GLrt8cR9qSJveJEn0zxyW6qgY'
              },
              body: jsonEncode(<String, dynamic>{
                'notification': <String, dynamic>{
                  'title': title,
                  'body': message
                },
                'priority': 'high',
                'data': data,
                'to': '/topics/${FirebaseAuth.instance.currentUser!.uid}'
              }));

      if (response.statusCode == 200) {
        // print("Notification sent");
      } else {
        // print("Error");
      }
    } catch (e) {
      // print(e);
    }
    return;
  }
}
