// // import 'package:camera_deep_ar/camera_deep_ar.dart';
// // import 'package:camera_deep_ar/camera_deep_ar.dart';
// import 'package:flutter/material.dart';
// import 'package:mango/constants.dart';
// import 'package:rwa_deep_ar/rwa_deep_ar.dart';
//
//
// void main() {
//   runApp(ARCamera());
// }
//
// class ARCamera extends StatefulWidget {
//   @override
//   _ARCameraState createState() => _ARCameraState();
// }
//
// class _ARCameraState extends State<ARCamera> {
//   late CameraDeepArController cameraDeepArController;
//   int effectCount = 0;
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: Scaffold(
//           body: Stack(
//             children: [
//               CameraDeepAr(
//                   onCameraReady: (isReady) {
//                     setState(() {});
//                   },
//                   onImageCaptured: (path) {
//                     setState(() {});
//                   },
//                   onVideoRecorded: (path) {
//                     setState(() {});
//                   },
//                   androidLicenceKey: apiKey,
//                   iosLicenceKey: apiKey,
//                   cameraDeepArCallback: (c) async {
//                     cameraDeepArController = c;
//                     setState(() {});
//                   }),
//               Align(
//                   alignment: Alignment.bottomRight,
//                   child: Container(
//                       padding: EdgeInsets.all(20),
//                       child: FloatingActionButton(
//                           backgroundColor: Colors.amber,
//                           child: Icon(Icons.navigate_next),
//                           onPressed: () => {
//                             cameraDeepArController.changeMask(effectCount),
//                             if (effectCount == 7) {effectCount = 0},
//                             effectCount++
//                           })))
//             ],
//           )),
//     );
//   }
// }
