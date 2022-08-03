import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/cloud/user_services.dart';
import 'package:mango/Models/customModel/chat.dart';
import 'package:mango/Models/customModel/library.dart';
import 'package:mango/Models/customModel/playlist.dart';
import 'package:mango/Models/customModel/post.dart';
import 'package:quiver/iterables.dart';

import '../../Screens/Music/reply_playlist.dart';
import '../../Screens/Notifications/mango_notifications.dart';
import '../../utils.dart';
import '../customModel/recent_events.dart';
import '../customModel/reply_books.dart';

class PostService {
  final UtilsService _utilsService = UtilsService();

  List<MangoPost> _postListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoPost(
          text: (doc.data() as dynamic)['text'] ?? '',
          postCreator: (doc.data() as dynamic)['postCreator'] ?? '',
          image: (doc.data() as dynamic)['image'] ?? '',
          video: (doc.data() as dynamic)['video'] ?? '',
          timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
          originalID: (doc.data() as dynamic)['originalID'] ?? '',
          link: (doc.data() as dynamic)['link'] ?? '',
          replyTo: (doc.data() as dynamic)['replyTo'] ?? '',
          linkType: (doc.data() as dynamic)['linkType'] ?? '',
          id: doc.id,
          repostCount: (doc.data() as dynamic)['repostCount'] ?? 0,
          multiImage: (doc.data() as dynamic)['multiImage'],
          likeCount: (doc.data() as dynamic)['likeCount'] ?? 0,
          repost: (doc.data() as dynamic)['repost'] ?? false,
          multiMedia: (doc.data() as dynamic)['multiMedia'] ?? false,
          isLinked: (doc.data() as dynamic)['isLinked'] ?? false,
          repliedPostID: (doc.data() as dynamic)['repliedPostID'],
          reply: (doc.data() as dynamic)['reply'] ?? false,
          replyCount: (doc.data() as dynamic)['replyCount'] ?? 0,
      );
    }).toList();
  }

  List<Message> _messageListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return Message(
          text: (doc.data() as dynamic)['message'] ?? '',
          replyMessage: (doc.data() as dynamic)['replyMessage'],
          timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
          receiver: (doc.data() as dynamic)['id'] ?? '',
          sender: (doc.data() as dynamic)['sender'] ?? '');
    }).toList();
  }

  List<MangoPlaylist> _playListFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoPlaylist(
        text: (doc.data() as dynamic)['text'] ?? '',
        title: (doc.data() as dynamic)['title'] ?? '',
        postCreator: (doc.data() as dynamic)['postCreator'] ?? '',
        image: (doc.data() as dynamic)['image'] ?? '',
        timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
        plays: (doc.data() as dynamic)['plays'] ?? 0,
        id: doc.id,
        link: (doc.data() as dynamic)['link'] ?? '',
        repost: (doc.data() as dynamic)['repost'] ?? false,
        repostCount: (doc.data() as dynamic)['repostCount'] ?? 0,
        likeCount: (doc.data() as dynamic)['likeCount'] ?? 0,
        tags: (doc.data() as dynamic)['tags'] ?? [],
        originalID: (doc.data() as dynamic)['originalID'],
        replyCount: (doc.data() as dynamic)['replyCount'] ?? 0,
        repliedPlaylistID:(doc.data() as dynamic)['repliedPlaylistID'],
        reply: (doc.data() as dynamic)['reply'] ?? false,
      );
    }).toList();
  }

  MangoPlaylist? _playlistFromFirebaseSnapshot(DocumentSnapshot snapshot) {
    return snapshot != null
        ? MangoPlaylist(
      text: (snapshot.data() as dynamic)['text'] ?? '',
      title: (snapshot.data() as dynamic)['title'] ?? '',
      postCreator: (snapshot.data() as dynamic)['postCreator'] ?? '',
      image: (snapshot.data() as dynamic)['image'] ?? '',
      timeStamp: (snapshot.data() as dynamic)['timeStamp'] ?? 0,
      plays: (snapshot.data() as dynamic)['plays'] ?? 0,
      id: snapshot.id,
      link: (snapshot.data() as dynamic)['link'] ?? '',
      repost: (snapshot.data() as dynamic)['repost'] ?? false,
      repostCount: (snapshot.data() as dynamic)['repostCount'] ?? 0,
      likeCount: (snapshot.data() as dynamic)['likeCount'] ?? 0,
      tags: (snapshot.data() as dynamic)['tags'] ?? [],
      originalID: (snapshot.data() as dynamic)['originalID'],
      replyCount: (snapshot.data() as dynamic)['replyCount'] ?? 0,
      repliedPlaylistID:(snapshot.data() as dynamic)['repliedPlaylistID'],
      reply: (snapshot.data() as dynamic)['reply'] ?? false,
    )
        : null;
  }

  MangoLibrary? _libraryFromFirebaseSnapshot(DocumentSnapshot snapshot) {
    return snapshot != null
        ? MangoLibrary(
        text: (snapshot.data() as dynamic)['text'] ?? '',
        title: (snapshot.data() as dynamic)['title'] ?? '',
        postCreator: (snapshot.data() as dynamic)['postCreator'] ?? '',
        image: (snapshot.data() as dynamic)['image'] ?? '',
        timeStamp: (snapshot.data() as dynamic)['timeStamp'] ?? 0,
        reads: (snapshot.data() as dynamic)['reads'] ?? 0,
        id: snapshot.id,
        link: (snapshot.data() as dynamic)['link'] ?? '',
        author: (snapshot.data() as dynamic)['author'] ?? '',
        originalID: (snapshot.data() as dynamic)['originalID'] ?? '',
        tags: (snapshot.data() as dynamic)['tags'] ?? [],
        likeCount: (snapshot.data() as dynamic)['likeCount'] ?? 0 ,
        repostCount: (snapshot.data() as dynamic)['repostCount'] ?? 0,
        reply: (snapshot.data() as dynamic)['reply'] ?? false,
        repost: (snapshot.data() as dynamic)['repost'] ?? false,
        replyCount: (snapshot.data() as dynamic)['repostCount'] ?? 0
    )
        : null;
  }

  List<MangoLibrary> _libraryFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoLibrary(
          text: (doc.data() as dynamic)['text'] ?? '',
          title: (doc.data() as dynamic)['title'] ?? '',
          postCreator: (doc.data() as dynamic)['postCreator'] ?? '',
          image: (doc.data() as dynamic)['image'] ?? '',
          timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
          tags: (doc.data() as dynamic)['tags'] ?? [],
          reads: (doc.data() as dynamic)['reads'] ?? 0,
          id: doc.id,
          link: (doc.data() as dynamic)['link'] ?? '',
          author: (doc.data() as dynamic)['author'] ?? '',
          originalID: (doc.data() as dynamic)['originalID'] ?? '',
          likeCount: (doc.data() as dynamic)['likeCount'] ?? 0 ,
          repostCount: (doc.data() as dynamic)['repostCount'] ?? 0,
          reply: (doc.data() as dynamic)['reply'] ?? false,
          repost: (doc.data() as dynamic)['repost'] ?? false,
          replyCount: (doc.data() as dynamic)['repostCount'] ?? 0);
    }).toList();
  }

  List<MangoBookComment> _bookCommentsFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoBookComment(
          text: (doc.data() as dynamic)['text'] ?? '',
          postCreator: (doc.data() as dynamic)['postCreator'] ?? '',
          timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
          id: doc.id,
          repliedCommentID: (doc.data() as dynamic)['repliedCommentID'] ?? '',
          likeCount: (doc.data() as dynamic)['likeCount'] ?? 0 ,
          repostCount: (doc.data() as dynamic)['repostCount'] ?? 0,
          reply: (doc.data() as dynamic)['reply'] ?? false,
          repost: (doc.data() as dynamic)['repost'] ?? false,
          replyCount: (doc.data() as dynamic)['repostCount'] ?? 0);
    }).toList();
  }

  List<MangoNotifications> _notificationsFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoNotifications(
          message: (doc.data() as dynamic)['message'] ?? '',
          sender: (doc.data() as dynamic)['sender'] ?? '',
          timeStamp: (doc.data() as dynamic)['time'] ?? 0,
          id: doc.id,
          receiver: (doc.data() as dynamic)['receiver'] ?? '',
          page: (doc.data() as dynamic)['page'] ?? '',
          pageId: (doc.data() as dynamic)['pageId'] ?? '',
          title: (doc.data() as dynamic)['title'] ?? '');
    }).toList();
  }



  List<MangoPlaylistComment> _playlistCommentsFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return MangoPlaylistComment(
          text: (doc.data() as dynamic)['text'] ?? '',
          postCreator: (doc.data() as dynamic)['postCreator'] ?? '',
          timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
          id: doc.id,
          repliedCommentID: (doc.data() as dynamic)['repliedCommentID'] ?? '',
          likeCount: (doc.data() as dynamic)['likeCount'] ?? 0 ,
          repostCount: (doc.data() as dynamic)['repostCount'] ?? 0,
          reply: (doc.data() as dynamic)['reply'] ?? false,
          repost: (doc.data() as dynamic)['repost'] ?? false,
          replyCount: (doc.data() as dynamic)['repostCount'] ?? 0);
    }).toList();
  }

  List<RecentEvent> _recentEventsFromSnapshots(QuerySnapshot snapshot) {
    return snapshot.docs.map((doc) {
      return RecentEvent(
        recentId: (doc.data() as dynamic)['recentId'] ?? '',
        timeStamp: (doc.data() as dynamic)['timeStamp'] ?? 0,
        type: (doc.data() as dynamic)['type'] ?? '',);
    }).toList();
  }

  Future savePost(text, file, link, type, isLinked) async {
    var saveFile;
    List upload = [];
    if (file != null) {
      for(var image in file) {
        saveFile = await _utilsService.uploadFile(image,
          "posts/image/${FirebaseAuth.instance.currentUser!.uid}/${Timestamp
              .now()}/image");
        upload.add(saveFile);
      }
    }
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'multiImage': upload,
      'image': null,
      'multiMedia': true,
      'link': link,
      'linkType': type,
      'isLinked': isLinked,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
    });
  }

  Future saveSingleMediaPost(text, file, link, type, isLinked) async {
    var saveFile = await _utilsService.uploadFile(file,
        "posts/image/${FirebaseAuth.instance.currentUser!.uid}/${Timestamp
            .now()}/image");
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'image': saveFile,
      'link': link,
      'multiMedia': false,
      'linkType': type,
      'isLinked': isLinked,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
    });
  }

  Future saveVideoMediaPost(text, file, link, type, isLinked) async {
    var saveFile = await _utilsService.uploadFile(file,
        "posts/video/${FirebaseAuth.instance.currentUser!.uid}/${Timestamp
            .now()}/video");
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'video': saveFile,
      'link': link,
      'multiMedia': false,
      'linkType': type,
      'isLinked': isLinked,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
    });
  }

  Future saveEpisode(byteFile) async {
    print(byteFile);
    var saveFile = await _utilsService.uploadImage(byteFile,
        "episodes/image/${FirebaseAuth.instance.currentUser!.uid}/${Timestamp.now()}/image");
    await FirebaseFirestore.instance.collection("episodes").add({
      'image': saveFile,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
    });
  }

  Future savePlaylist(link, image, tags, title, text) async {
    var imageFile = await _utilsService.uploadFile(image,
        "playlists/image/${FirebaseAuth.instance.currentUser!.uid}/${Timestamp.now()}/image");
    await FirebaseFirestore.instance.collection("playlists").add({
      'link': link,
      'image': imageFile,
      'tags': tags,
      'title': title,
      'text': text,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
    });
  }

  Future saveLibrary(link, image, tags, title, text, author) async {
    var imageFile = await _utilsService.uploadFile(image,
        "library/image/${FirebaseAuth.instance.currentUser!.uid}/${FieldValue.serverTimestamp()}/bookcover");
    var imageBook = await _utilsService.uploadFile(link,
        "library/book/${FirebaseAuth.instance.currentUser!.uid}/${FieldValue.serverTimestamp()}/book");
    await FirebaseFirestore.instance.collection("library").add({
      'link': imageBook,
      'image': imageFile,
      'tags': tags,
      'title': title,
      'text': text,
      'author': author,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
    });
  }

  Stream<List<MangoPost>> getPostsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .where("postCreator", isEqualTo: uid)
    .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(_postListFromSnapshots);
  }

  Stream<List<MangoPost>> getPostsByEverybody(uid) {
    return FirebaseFirestore.instance
        .collection("posts")
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(_postListFromSnapshots);
  }

  Stream<List<MangoPlaylist>> getPlaylistsByUser(uid) {
    return FirebaseFirestore.instance
        .collection("playlists")
        .where("postCreator", isEqualTo: uid)
        .snapshots()
        .map(_playListFromSnapshots);
  }

  Stream<List<MangoPlaylist>> mostPlayedMusic() {
    return FirebaseFirestore.instance
        .collection("playlists")
        .orderBy("plays", descending: true)
        .limit(20)
        .snapshots()
        .map(_playListFromSnapshots);
  }

  Stream<List<MangoPlaylist>> getPlaylistsByEverybody(uid) {
    return FirebaseFirestore.instance
        .collection("playlists")
        .orderBy("timeStamp", descending: true)
        .snapshots()
        .map(_playListFromSnapshots);
  }

  Stream<List<MangoLibrary>> getLibraryByUser(uid) {
    return FirebaseFirestore.instance
        .collection("library")
        .where("postCreator", isEqualTo: uid)
        .snapshots()
        .map(_libraryFromSnapshots);
  }

  Stream<List<MangoLibrary>> mostReadBooks() {
    return FirebaseFirestore.instance
        .collection("library")
        .orderBy("reads", descending: true)
        .limit(20)
        .snapshots()
        .map(_libraryFromSnapshots);
  }

  Stream<List<MangoLibrary>> getPlaylistsByID(uid) {
    return FirebaseFirestore.instance
        .collection("playlists")
        .where("id", isEqualTo: uid)
        .snapshots()
        .map(_libraryFromSnapshots);
  }

  Stream<List<MangoLibrary>> getLibraryByEverybody(uid) {
    return FirebaseFirestore.instance
        .collection("library")
        .snapshots()
        .map(_libraryFromSnapshots);
  }

  Stream<List<MangoLibrary?>> getBooksByName(word) {
    if (kDebugMode) {
      print("this is searching for $word");
    }
    return FirebaseFirestore.instance
        .collection("library")
        .orderBy("title")
        .startAt([word])
        .endAt([word + '\uf8ff'])
        .limit(10)
        .snapshots()
        .map(_libraryFromSnapshots);
  }

  Stream<List<MangoPlaylist?>> getPlaylistsByName(word) {
    if (kDebugMode) {
      print("this is searching for $word");
    }
    return FirebaseFirestore.instance
        .collection("playlists")
        .orderBy("title")
        .startAt([word])
        .endAt([word + '\uf8ff'])
        .limit(10)
        .snapshots()
        .map(_playListFromSnapshots);
  }

  Stream<List<MangoPost?>> getPostsByName(word) {
    if (kDebugMode) {
      print("this is searching for $word");
    }
    return FirebaseFirestore.instance
        .collection("posts")
        .orderBy("text")
        .startAt([word])
        .endAt([word + '\uf8ff'])
        .limit(10)
        .snapshots()
        .map(_postListFromSnapshots);
  }

  Stream<bool> hasLikedPost(postID) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("liked")
        .doc(postID)
        .snapshots()
        .map((snapshots) => snapshots.exists);
  }

  Stream<bool> hasRepostedPost(MangoPost post) {
    Stream<bool> value;
    if (post.repost){
      value = FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("reposts")
          .doc(post.originalID)
          .snapshots()
          .map((snapshots) => snapshots.exists);
    } else {
      value = FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("reposts")
        .doc(post.id)
        .snapshots()
        .map((snapshots) => snapshots.exists);
    }
    return value;
  }

  Stream<bool> hasCommentedOnPost(postID) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("replies")
        .doc(postID)
        .snapshots()
        .map((snapshots) => snapshots.exists);
  }

  Future<void> likePost(postID, creator) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('liked')
        .doc(postID)
        .set({});

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});

    FirebaseMessaging.instance.subscribeToTopic(creator);
  }

  Future<void> unlikePost(postID) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('liked')
        .doc(postID)
        .delete();

    await FirebaseFirestore.instance
        .collection('posts')
        .doc(postID)
        .collection('likes')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }

  Stream<bool> hasLikedBook(postID) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("likedBook")
        .doc(postID)
        .snapshots()
        .map((snapshots) => snapshots.exists);
  }

  Future<void> likeBook(postID, creator) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('likedBook')
        .doc(postID)
        .set({});

    await FirebaseFirestore.instance
        .collection('library')
        .doc(postID)
        .collection('liked')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});
    FirebaseMessaging.instance.subscribeToTopic(creator);
  }

  Future<void> unlikeBook(postID) async {
    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('likedBook')
        .doc(postID)
        .delete();

    await FirebaseFirestore.instance
        .collection('library')
        .doc(postID)
        .collection('liked')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();
  }

  Stream<bool> hasLikedPlaylist(postID) {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection("likedPlaylist")
        .doc(postID)
        .snapshots()
        .map((snapshots) => snapshots.exists);
  }

  Future<void> likePlaylist(MangoPlaylist playlist) async {
    playlist.likeCount += 1;
    await FirebaseFirestore.instance
        .collection('playlists')
        .doc(playlist.id)
        .collection('likedPlaylist')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('likedPlaylist')
        .doc(playlist.id)
        .set({});
    FirebaseMessaging.instance.subscribeToTopic(playlist.postCreator);
  }

  Future<void> unlikePlaylist(MangoPlaylist playlist) async {
    playlist.likeCount -= 1;
    await FirebaseFirestore.instance
        .collection('playlists')
        .doc(playlist.id)
        .collection('likedPlaylist')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('likedPlaylist')
        .doc(playlist.id)
        .delete();
  }

  Future repostPlaylist(MangoPlaylist playlist, bool current) async {
    if (current) {
      playlist.repostCount -= 1;
      await FirebaseFirestore.instance
          .collection('playlists')
          .doc(playlist.id)
          .collection('repost')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection('playlists')
          .where('originalID', isEqualTo: playlist.id)
          .where('postCreator',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          return;
        }
        FirebaseFirestore.instance
            .collection('playlists')
            .doc(value.docs[0].id)
            .delete();
      });
      return;
    }

    FirebaseMessaging.instance.subscribeToTopic(playlist.postCreator);
    playlist.repostCount += 1;
    await FirebaseFirestore.instance
        .collection('playlists')
        .doc(playlist.id)
        .collection('repost')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});

    await FirebaseFirestore.instance.collection("playlists").add({
      'link': playlist.link,
      'image': playlist.image,
      'title': playlist.title,
      'text': playlist.text,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': DateTime.now(),
      'retweet': true,
      'originalID': playlist.id,
    });
  }

  Future unrepostPlaylist(MangoPlaylist playlist) async {
    playlist.repostCount -= 1;
    await FirebaseFirestore.instance
        .collection('playlists')
        .doc(playlist.id)
        .collection('repost')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('playlists')
        .where('originalID', isEqualTo: playlist.id)
        .where('postCreator', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        return;
      }
      FirebaseFirestore.instance
          .collection('playlists')
          .doc(value.docs[0].id)
          .delete();
    });
  }

  Stream<bool> hasRepostedPlaylist(postID) {
    return FirebaseFirestore.instance
        .collection("playlists")
        .doc(postID)
        .collection("repost")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshots) => snapshots.exists);
  }



  Future repostBook(MangoLibrary book, bool current) async {
    if (current) {
      book.repostCount -= 1;
      await FirebaseFirestore.instance
          .collection('library')
          .doc(book.id)
          .collection('repost')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection('library')
          .where('originalID', isEqualTo: book.id)
          .where('postCreator',
              isEqualTo: FirebaseAuth.instance.currentUser!.uid)
          .get()
          .then((value) {
        if (value.docs.isEmpty) {
          return;
        }
        FirebaseFirestore.instance
            .collection('library')
            .doc(value.docs[0].id)
            .delete();
      });
      return;
    }

    book.repostCount += 1;
    FirebaseMessaging.instance.subscribeToTopic(book.postCreator);
    await FirebaseFirestore.instance
        .collection('library')
        .doc(book.id)
        .collection('repost')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .set({});

    await FirebaseFirestore.instance.collection("library").add({
      'link': book.link,
      'image': book.image,
      'title': book.title,
      'text': book.text,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': DateTime.now(),
      'retweet': true,
      'originalID': book.id,
    });
  }

  Future unrepostBook(MangoPlaylist playlist) async {
    playlist.repostCount -= 1;
    await FirebaseFirestore.instance
        .collection('library')
        .doc(playlist.id)
        .collection('repost')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .delete();

    await FirebaseFirestore.instance
        .collection('library')
        .where('originalID', isEqualTo: playlist.id)
        .where('postCreator', isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .get()
        .then((value) {
      if (value.docs.isEmpty) {
        return;
      }
      FirebaseFirestore.instance
          .collection('library')
          .doc(value.docs[0].id)
          .delete();
    });
  }

  Stream<bool> hasRepostedBook(postID) {
    return FirebaseFirestore.instance
        .collection("library")
        .doc(postID)
        .collection("repost")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map((snapshots) => snapshots.exists);
  }

  Future<List<MangoPost>> getFeeds() async {
    List<String> usersFollowing = await UserService()
        .whoFollowsUser(FirebaseAuth.instance.currentUser!.uid);

    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);

    List<MangoPost> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_postListFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate!.compareTo(adate!);
    });

    return feedList;
  }

  Future<List<MangoPlaylist>> getPlaylistByProfession(String profession) async {
    List<String> usersWithProfession = await UserService()
        .getUsersWithProfession(profession);

    var splitUsersFollowing = partition<dynamic>(usersWithProfession, 10);

    List<MangoPlaylist> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("playlists")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_playListFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future<List<MangoPlaylist>> getPlaylistByState(String profession) async {
    List<String> usersWithState = await UserService()
        .getUsersWithState(profession);

    var splitUsersFollowing = partition<dynamic>(usersWithState, 10);

    List<MangoPlaylist> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("playlists")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_playListFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future<List<MangoPlaylist>> getPlaylistByCity(String city) async {
    List<String> usersWithCity = await UserService()
        .getUsersWithCity(city);

    var splitUsersFollowing = partition<dynamic>(usersWithCity, 10);

    List<MangoPlaylist> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("playlists")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_playListFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future<List<MangoPlaylist>> getPlaylistByCountry(String country) async {
    List<String> usersWithCountry = await UserService()
        .getUsersWithCountry(country);

    var splitUsersFollowing = partition<dynamic>(usersWithCountry, 10);

    List<MangoPlaylist> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("playlists")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_playListFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }


  Future<List<MangoLibrary>> getBooksByProfession(String profession) async {
    List<String> usersWithProfession = await UserService()
        .getUsersWithProfession(profession);

    var splitUsersFollowing = partition<dynamic>(usersWithProfession, 10);

    List<MangoLibrary> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("library")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_libraryFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future<List<MangoLibrary>> getBooksByState(String profession) async {
    List<String> usersWithState = await UserService()
        .getUsersWithState(profession);

    var splitUsersFollowing = partition<dynamic>(usersWithState, 10);

    List<MangoLibrary> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("library")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_libraryFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future<List<MangoLibrary>> getBooksByCity(String city) async {
    List<String> usersWithCity = await UserService()
        .getUsersWithCity(city);

    var splitUsersFollowing = partition<dynamic>(usersWithCity, 10);

    List<MangoLibrary> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("library")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_libraryFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future<List<MangoLibrary>> getBooksByCountry(String country) async {
    List<String> usersWithCountry = await UserService()
        .getUsersWithCountry(country);

    var splitUsersFollowing = partition<dynamic>(usersWithCountry, 10);

    List<MangoLibrary> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("library")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_libraryFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Stream<List<MangoPost>> getReplies(uid) {
    return FirebaseFirestore.instance
        .collection('posts')
        .where("repliedPostID", isEqualTo: uid)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(_postListFromSnapshots);
  }

  Stream<List<MangoBookComment>> getBookComments(uid) {
    return FirebaseFirestore.instance
        .collection('bookComments')
        .where("repliedCommentID", isEqualTo: uid)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(_bookCommentsFromSnapshots);
  }

  Stream<List<MangoNotifications>> getNotifications() {
    return FirebaseFirestore.instance
        .collection('notifications')
        .where("receiver", isEqualTo: FirebaseAuth.instance.currentUser!.uid)
        .snapshots()
        .map(_notificationsFromSnapshots);
  }

  Stream<List<MangoPlaylistComment>> getPlaylistComments(uid) {
    return FirebaseFirestore.instance
        .collection('playlistComments')
        .where("repliedCommentID", isEqualTo: uid)
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(_playlistCommentsFromSnapshots);
  }

  Stream<List<RecentEvent>> getRecentEvents() {
    return FirebaseFirestore.instance
        .collection("users")
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('recent_events')
        .orderBy('timeStamp', descending: true)
        .snapshots()
        .map(_recentEventsFromSnapshots);
  }

  // Future<List<MangoPost>> getReplies(uid) async {
  //   print(uid);
  //   List<String> usersFollowing = await whoRepliedPost(uid);
  //
  //   var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);
  //
  //   List<MangoPost> feedList = [];
  //
  //   for (int i = 0; i < splitUsersFollowing.length; i++) {
  //     QuerySnapshot querySnapshot = await FirebaseFirestore.instance
  //         .collection("posts")
  //         .where("repliedPostID", isEqualTo: uid)
  //         .orderBy('timeStamp', descending: true)
  //         .get();
  //
  //     feedList.addAll(_postListFromSnapshots(querySnapshot));
  //   }
  //
  //   feedList.sort((a, b) {
  //     var adate = a.timeStamp;
  //     var bdate = b.timeStamp;
  //
  //     return bdate.compareTo(adate);
  //   });
  //
  //   return feedList;
  // }

  Future<List<MangoPlaylist>> discoverPlaylistsByInterest(
      category, interest) async {
    List usersInterested =
        await UserService().checkUserInterest(category, interest);

    var splitUsersFollowing = partition<dynamic>(usersInterested, 10);

    List<MangoPlaylist> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      print(splitUsersFollowing.elementAt(i));
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("playlists")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_playListFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future<List<MangoPlaylist>> discoverPostsByInterest(
      category, interest) async {
    List usersInterested =
        await UserService().whoIsInterestedFollowsUser(category, interest);

    var splitUsersFollowing = partition<dynamic>(usersInterested, 10);

    List<MangoPlaylist> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("posts")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_playListFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future<List<MangoLibrary>> discoverLibraryByInterest(
      category, interest) async {
    List usersInterested =
        await UserService().whoIsInterestedFollowsUser(category, interest);

    var splitUsersFollowing = partition<dynamic>(usersInterested, 10);

    List<MangoLibrary> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("library")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_libraryFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future<List<MangoPlaylist>> getPlaylistsByInterest(
      String category, String interest) async {
    List<String> usersFollowing =
        await UserService().usersWithInterest(category, interest);

    var splitUsersFollowing = partition<dynamic>(usersFollowing, 10);

    List<MangoPlaylist> feedList = [];

    for (int i = 0; i < splitUsersFollowing.length; i++) {
      QuerySnapshot querySnapshot = await FirebaseFirestore.instance
          .collection("playlists")
          .where("postCreator", whereIn: splitUsersFollowing.elementAt(i))
          .orderBy('timeStamp', descending: true)
          .get();

      feedList.addAll(_playListFromSnapshots(querySnapshot));
    }

    feedList.sort((a, b) {
      var adate = a.timeStamp;
      var bdate = b.timeStamp;

      return bdate.compareTo(adate);
    });

    return feedList;
  }

  Future unrepostPost(MangoPost post, bool current) async {
      post.repostCount -= 1;
      await FirebaseFirestore.instance
          .collection('posts')
          .doc(post.id)
          .collection('reposts')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection('posts')
          .where('originalID', isEqualTo: post.id)
      .where('postCreator', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
      .where('originalID', isEqualTo: post.originalID)
          .get()
      .then((value) {
        if(value.docs.isEmpty){
          return;
        } else {
          FirebaseFirestore.instance
            .collection('posts')
            .doc(value.docs[0].id)
            .delete();
        }
      });


      FirebaseMessaging.instance.subscribeToTopic(post.postCreator);

  }


  Future replyPost(String? text, File? file, MangoPost post) async {
    post.replyCount += 1;
    await FirebaseFirestore.instance
        .collection('posts')
        .doc(post.id)
        .collection('replies')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({});

    await FirebaseFirestore.instance
        .collection('users')
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .collection('replies')
        .doc(post.id)
        .set({});

    var saveFile;
    if(file != null) {
       saveFile = await _utilsService.uploadFile(file,
          "posts/image/${FirebaseAuth.instance.currentUser!.uid}/${Timestamp
              .now()}/image");
    }
    await FirebaseFirestore.instance.collection("posts").add({
      'text': text,
      'image': saveFile,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
      'repliedPostID': post.id,
      'reply': true,
      'replyTo': post.id
    });
  }



  MangoPost _postFromSnapshots(DocumentSnapshot snapshot) {
    return
      MangoPost(
          text: (snapshot.data() as dynamic)['text'] ?? '',
          postCreator: (snapshot.data() as dynamic)['postCreator'] ?? '',
          image: (snapshot.data() as dynamic)['image'] ?? '',
          video: (snapshot.data() as dynamic)['video'] ?? '',
          timeStamp: (snapshot.data() as dynamic)['timeStamp'] ?? 0,
          originalID: (snapshot.data() as dynamic)['originalID'] ?? '',
        multiImage: (snapshot.data() as dynamic)['multiImage'],
          link: (snapshot.data() as dynamic)['link'] ?? '',
        replyTo: (snapshot.data() as dynamic)['replyTo'] ?? '',
          linkType: (snapshot.data() as dynamic)['linkType'] ?? '',
          id: snapshot.id,
          repostCount: (snapshot.data() as dynamic)['repostCount'] ?? 0,
          likeCount: (snapshot.data() as dynamic)['likeCount'] ?? 0,
          repost: (snapshot.data() as dynamic)['repost'] ?? false,
        isLinked: (snapshot.data() as dynamic)['isLinked'] ?? false,
        multiMedia: (snapshot.data() as dynamic)['multiMedia'] ?? false,
          reply: (snapshot.data() as dynamic)['reply'] ?? false,
          replyCount: (snapshot.data() as dynamic)['replyCount'] ?? 0,
          repliedPostID:(snapshot.data() as dynamic)['repliedPostID'],
      );
  }

  Future<MangoPost?> getPostById(String? originalID) async{
    DocumentSnapshot postSnap = await FirebaseFirestore.instance.collection('posts').doc(originalID).get();
    return _postFromSnapshots(postSnap);
  }

  Future<MangoPost?> getBookCommentById(String? originalID) async{
    DocumentSnapshot postSnap = await FirebaseFirestore.instance.collection('bookComments').doc(originalID).get();
    return _postFromSnapshots(postSnap);
  }

  Future sharePlaylist(MangoPlaylist playlist, bool current) async {
    print ("this is current $current");
    if (current) {
      playlist.repostCount -= 1;
      await FirebaseFirestore.instance
          .collection('playlists')
          .doc(playlist.id)
          .collection('reposts')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .delete();

      await FirebaseFirestore.instance
          .collection('playlists')
          .where('originalID', isEqualTo: playlist.id)
      .where('postCreator', isEqualTo: FirebaseAuth.instance.currentUser?.uid)
          .get()
      .then((value) {
        if(value.docs.isEmpty){
          return;
        } else {
          FirebaseFirestore.instance
            .collection('playlists')
            .doc(value.docs[0].id)
            .delete();
        }
      });

    } else {
      playlist.repostCount += 1;
      await FirebaseFirestore.instance
          .collection('playlists')
          .doc(playlist.id)
          .collection('reposts')
          .doc(FirebaseAuth.instance.currentUser?.uid)
          .set({});

      await FirebaseFirestore.instance.collection('playlists').add({
        'postCreator': FirebaseAuth.instance.currentUser?.uid,
        'timeStamp': FieldValue.serverTimestamp(),
        'repost': true,
        'originalID': playlist.id
      });
    }
  }

  Future replyPlaylist(String? text, File? file, MangoPlaylist playlist) async {
    playlist.replyCount += 1;
    await FirebaseFirestore.instance
        .collection('playlists')
        .doc(playlist.id)
        .collection('comments')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({});

    await FirebaseFirestore.instance.collection("playlistComments").add({
      'text': text,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
      'repliedCommentID': playlist.id,
    });
  }


  Future commentBook(String? text, File? file, MangoLibrary mangoLibrary) async {
    mangoLibrary.replyCount += 1;
    await FirebaseFirestore.instance
        .collection('library')
        .doc(mangoLibrary.id)
        .collection('comments')
        .doc(FirebaseAuth.instance.currentUser?.uid)
        .set({});

    await FirebaseFirestore.instance.collection("bookComments").add({
      'text': text,
      'postCreator': FirebaseAuth.instance.currentUser!.uid,
      'timeStamp': FieldValue.serverTimestamp(),
      'repliedCommentID': mangoLibrary.id,
    });
  }

  MangoPlaylist _playlistFromSnapshots(DocumentSnapshot snapshot) {
    return
      MangoPlaylist(
        text: (snapshot.data() as dynamic)['text'] ?? '',
        postCreator: (snapshot.data() as dynamic)['postCreator'] ?? '',
        image: (snapshot.data() as dynamic)['image'] ?? '',
        timeStamp: (snapshot.data() as dynamic)['timeStamp'] ?? 0,
        originalID: (snapshot.data() as dynamic)['originalID'],
        id: snapshot.id,
        repostCount: (snapshot.data() as dynamic)['repostCount'] ?? 0,
        plays: (snapshot.data() as dynamic)['plays'] ?? 0,
        likeCount: (snapshot.data() as dynamic)['likeCount'] ?? 0,
        tags: (snapshot.data() as dynamic)['tags'] ?? [],
        repost: (snapshot.data() as dynamic)['repost'] ?? false,
        reply: (snapshot.data() as dynamic)['reply'] ?? false,
        replyCount: (snapshot.data() as dynamic)['replyCount'] ?? 0,
        repliedPlaylistID:(snapshot.data() as dynamic)['repliedPostID'],
        title: (snapshot.data() as dynamic)['title'] ?? '',
        link: (snapshot.data() as dynamic)['link'] ?? '',
      );
  }


  Future<MangoPlaylist?> getPlaylistById(String? originalID) async{
    DocumentSnapshot postSnap = await FirebaseFirestore.instance.collection('playlists').doc(originalID).get();
    return _playlistFromSnapshots(postSnap);
  }

  Stream<MangoPlaylist?> getPlaylistWithId(String postId){
    return FirebaseFirestore.instance
        .collection('playlists')
        .doc(postId)
        .snapshots()
        .map(_playlistFromFirebaseSnapshot);
  }

  Stream<MangoLibrary?> getBookWithId(String postId){
    return FirebaseFirestore.instance
        .collection('library')
        .doc(postId)
        .snapshots()
        .map(_libraryFromFirebaseSnapshot);
  }

  Stream<MangoPost?> getPostWithId(String postId){
    return FirebaseFirestore.instance
        .collection('posts')
        .doc(postId)
        .snapshots()
        .map(_postFromSnapshots);
  }

  Stream <List<MangoPlaylist>> getPlaylistWithTags(String tag){
    return FirebaseFirestore.instance
        .collection('playlists')
        .where('tags', arrayContains: tag)
        .snapshots()
        .map(_playListFromSnapshots);
  }

  Stream <List<MangoLibrary>> getBooksWithTags(String tag){
    return FirebaseFirestore.instance
        .collection('library')
        .where('tags', arrayContains: tag)
        .snapshots()
        .map(_libraryFromSnapshots);
  }

  Stream<List<MangoLibrary?>> getBookWithTags(String tag){
    return FirebaseFirestore.instance
        .collection('library')
        .where('tags', arrayContains: tag)
        .snapshots()
        .map(_libraryFromSnapshots);
  }

  Stream<List<MangoPost?>> getPostWithTags(String tag){
    return FirebaseFirestore.instance
        .collection('posts')
        .where('tags', arrayContains: tag)
        .snapshots()
        .map(_postListFromSnapshots);
  }
}