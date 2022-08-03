import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mango/Models/customModel/user.dart';

import '../Screens/Home/home.dart';

class AuthService {
  FirebaseAuth auth = FirebaseAuth.instance;

  Stream<User?> get onAuthStateChanged => auth.authStateChanges();

  // GET UID
  Future<String> getCurrentUID() async {
    return auth.currentUser!.uid;
  }

  MangoUser? _userFromFirebaseUser(User? user) {
    return user != null
        ? MangoUser(
            id: user.uid,
            username: '',
            profileImage: '',
            bio: '',
            bannerImageUrl: '',
            hobbies: [],
            phone: '',
            profession: '',
            city: '',
            country: '',
            state: '',
            dob: '',
            displayName: '',
            email: '',
            gender: '',
            password: '',
            fcmToken: '',
            verified: false)
        : null;
  }

  Stream<MangoUser?> get user {
    return auth.authStateChanges().map(_userFromFirebaseUser);
  }

  Future signUp(email, password, context) async {
    String? fcm = await FirebaseMessaging.instance.getToken();
    try {
      UserCredential user = (await auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      ));

      await FirebaseFirestore.instance
          .collection("users")
          .doc(user.user!.uid)
          .set({
        'id': FirebaseAuth.instance.currentUser!.uid,
        'username': FirebaseAuth.instance.currentUser!.uid,
        'profileImage':
            'https://firebasestorage.googleapis.com/v0/b/mango-cloud-34e08.appspot.com/o/mango_meta%2FAsset%201mango.png?alt=media&token=627d9782-b066-4b48-a509-e71e358bc148',
        'bio': 'Welcome to my space',
        'bannerImageUrl':
            'https://firebasestorage.googleapis.com/v0/b/mango-cloud-34e08.appspot.com/o/mango_meta%2Fpexels-alan-cabello-1165502.jpg?alt=media&token=f7e28fa4-5459-41bd-baff-834d8b6056cd',
        'displayName': 'email',
        'email': email,
        'timeCreated': '${DateTime.now()}',
        'gender': '',
        'password': password,
        'fcmToken': fcm
      });
      _userFromFirebaseUser(user.user);
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
        SnackBar snack = const SnackBar(
          content: Text('The password provided is too weak.'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
      } else if (e.code == 'email-already-in-use') {
        SnackBar snack = const SnackBar(
          content: Text('The account already exists for that email.'),
          duration: Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
      SnackBar snack = SnackBar(
        content: Text(e.message!),
        duration: const Duration(seconds: 2),
      );
      ScaffoldMessenger.of(context).showSnackBar(snack);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future signIn(email, password, context) async {
    try {
      User user = (await auth.signInWithEmailAndPassword(
          email: email, password: password)) as User;
      _userFromFirebaseUser(user);
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => const HomePage()),
      // );
    } on FirebaseAuthException catch (e) {
        SnackBar snack = SnackBar(
          content: Text(e.message!),
          duration: const Duration(seconds: 2),
        );
        ScaffoldMessenger.of(context).showSnackBar(snack);
    } catch (e) {
      if (kDebugMode) {
        print(e);
      }
    }
  }

  Future signOut() async {
    try {
      return await auth.signOut();
    } catch (e) {
      if (kDebugMode) {
        print(e.toString());
      }
    }
  }
}
