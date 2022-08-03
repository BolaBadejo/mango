// @dart=2.9

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mango/Services/local_notifications_service.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'Models/customModel/user.dart';
import 'Screens/Onboarding/onboarding.dart';
import 'Services/auth.dart';
import 'Services/wrapper.dart';

int isviewed;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  LocalNotificationService.initialize();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
  ));
  SharedPreferences prefs = await SharedPreferences.getInstance();
  isviewed = prefs.getInt('onBoard');


  runApp(MangoYou());
}

final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
FlutterLocalNotificationsPlugin();

class MangoYou extends StatefulWidget {

   MangoYou({Key key}) : super(key: key);

  @override
  State<MangoYou> createState() => _MangoYouState();
}

class _MangoYouState extends State<MangoYou> {
  @override
  void initState() {
    super.initState();
    FirebaseMessaging.onMessage.listen((event) {
      LocalNotificationService.display(event);
    });
  }

  final Future<FirebaseApp> _mangoApp = Firebase.initializeApp();

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Mango',
      theme: ThemeData(
          primarySwatch: Colors.orange,
          textTheme: GoogleFonts.poppinsTextTheme(
            Theme.of(context).textTheme,
          ),
      ),
      home: FutureBuilder(
        future: _mangoApp,
          builder: (context, snapshot){
          if (snapshot.hasError){
            if (kDebugMode) {
              print("There has been an error: ${snapshot.error.toString()}");
            }
            return const Text("Something has gone wrong...");
          } else if (snapshot.hasData){
            return const Mango();
          } else {
            return const Center(
              child: CircularProgressIndicator(
                color: Colors.black,
              ),
            );
          }
          }
      ),
      //
    );
  }
}


class Mango extends StatefulWidget {
  const Mango({Key key}) : super(key: key);

  // Create the initialization Future outside of `build`:
  @override
  _MangoState createState() => _MangoState();
}

class _MangoState extends State<Mango> {
  /// The future is part of the state of our widget. We should not call `initializeApp`
  /// directly inside [build].
  final Future<FirebaseApp> _initialization = Firebase.initializeApp();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _initialization,
      builder: (context, snapshot) {
        // Check for errors
        if (snapshot.hasError) {
          // return SomethingWentWrong();
        }
        else if (snapshot.connectionState == ConnectionState.waiting) {
          return const Material(
            child: Center(
              child: Text("setting up your space..."),
            ),
          );
        }
        else if (snapshot.connectionState == ConnectionState.done) {
          return StreamProvider<MangoUser>.value(
              value: AuthService().user,
              initialData: null,
              child: MaterialApp(
                debugShowCheckedModeBanner: false,
                theme: ThemeData(
                    primarySwatch: Colors.orange,
                    textTheme: GoogleFonts.montserratTextTheme(
                      Theme.of(context).textTheme,
                    )),
                home: isviewed != 0 ? const OnBoard() : const Wrapper(),)
          );
        }

        // Otherwise, show something whilst waiting for initialization to complete

        return const Material(
          child: Center(
            child: Text("setting up your space..."),
          ),
        );

        // return MaterialApp(
        //   debugShowCheckedModeBanner: false,
        //   theme: ThemeData(
        //       primarySwatch: Colors.orange,
        //       textTheme: GoogleFonts.montserratTextTheme(
        //         Theme.of(context).textTheme,
        //       )),
        //   home: const Mango(),
        // );
      },
    );
  }
}

// class SplashScreen extends StatefulWidget {
//   const SplashScreen({Key key}) : super(key: key);
//
//   @override
//   _SplashScreenState createState() => _SplashScreenState();
// }
//
// class _SplashScreenState extends State<SplashScreen> {
//   @override
//   void initState() {
//     var d = const Duration(seconds: 6);
//     Future.delayed(d, () {
//       Navigator.pushAndRemoveUntil(
//         context,
//         MaterialPageRoute(
//           builder: (BuildContext context) {
//             return MaterialApp(
//               debugShowCheckedModeBanner: false,
//               theme: ThemeData(
//                   primarySwatch: Colors.orange,
//                   textTheme: GoogleFonts.montserratTextTheme(
//                     Theme.of(context).textTheme,
//                   )),
//               home: const Mango(),
//             );
//           },
//         ),
//             (route) => false,
//       );
//     });
//
//     super.initState();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Container(
//         color: Colors.white,
//         child: Center(
//           child: Image.asset(
//             "asset/images/_mango.png",
//             width: 120,
//             fit: BoxFit.cover,
//           ),
//         ),
//     );
//   }
// }