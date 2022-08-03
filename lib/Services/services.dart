import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

FirebaseAuth auth = FirebaseAuth.instance;
final googleLogIn = GoogleSignIn();

Future<bool?> googleSignIn() async {
  GoogleSignInAccount? googleSignInAccount = await googleLogIn .signIn();

  if (googleSignInAccount != null){
    GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

    AuthCredential credential = GoogleAuthProvider.credential(idToken: googleSignInAuthentication.idToken,
    accessToken: googleSignInAuthentication.accessToken);

    UserCredential result = await auth.signInWithCredential(credential);

    User? user = result.user;

    if (kDebugMode) {
      print(user!.uid);
    }

    return Future.value(true);
  }

}

Future<bool?> signUp(String email, String password) async {
  try{
    UserCredential result =await auth.createUserWithEmailAndPassword(email: email, password: password);
    User? user = result.user;
    return Future.value(true);
  }catch (e) {
    switch (e.toString()) {
      case 'email-already-in-use': if (kDebugMode) {
        print("email-already-in-use");
      }
      break;
      case 'invalid-email': if (kDebugMode) {
        print("invalid-email");
      }
      break;
      case 'operation-not-allowed': if (kDebugMode) {
        print("email-already-in-use");
      }
      break;
      case 'weak-password': if (kDebugMode) {
        print("weak-password");
      }
      break;
    }
  }

}

Future<bool?> signIn(String email, String password) async {
  try{
    UserCredential result =await auth.signInWithEmailAndPassword(email: email, password: password);
    // User? user = result.user;
    return Future.value(true);
  }catch (e) {
    switch (e.toString()) {
      case 'user-disabled': if (kDebugMode) {
        print("user-disabled");
      }
      break;
      case 'invalid-email': if (kDebugMode) {
        print("invalid-email");
      }
      break;
      case 'wrong-password': if (kDebugMode) {
        print("wrong-password");
      }
      break;
      case 'user-not-found': if (kDebugMode) {
        print("user-not-found");
      }
      break;
    }
  }

}

signOut() async {
  User? user = auth.currentUser;
  if (user!.providerData[1].providerId == 'google.com'){
    await googleLogIn.disconnect();
  }

  await auth.signOut();
}