import 'package:flutter/material.dart';
import 'package:advance_pdf_viewer/advance_pdf_viewer.dart';

class PdfReader extends StatefulWidget {
  final file;
  final title;
  const PdfReader({Key? key, this.file, this.title}) : super(key: key);
  @override
  _PdfReaderState createState() => _PdfReaderState();
}

class _PdfReaderState extends State<PdfReader> {
  bool _isLoading = true;
  PDFDocument document = PDFDocument();

  @override
  void initState() {
    super.initState();
    loadDocument();
  }

  @override
//   void initState() {
//     super.initState();
//     _initPdf();
//   }
//
//   _initPdf() async {
//     setState(() {
//       _loading = true;
//     });
//     final doc = await PDFDocument.fromAsset(widget.file);
//     setState(() {
//       _doc = doc;
//       _loading = false;
//     });
//   }

  loadDocument() async {
    setState(() {
      _isLoading = true;
    });
    final _document = await PDFDocument.fromURL(
      // widget.file,
      "https://unec.edu.az/application/uploads/2014/12/pdf-sample.pdf",
      // cacheManager: CacheManager(
      //     Config(
      //       "customCacheKey",
      //       stalePeriod: const Duration(days: 2),
      //       maxNrOfCacheObjects: 10,
      //     ),
      //   ),
    );

    setState(() {
      document = _document;
      _isLoading = false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: _isLoading
            ? Center(child: CircularProgressIndicator())
            : PDFViewer(
          document: document,
          zoomSteps: 1,
          //uncomment below line to preload all pages
          lazyLoad: false,
          // uncomment below line to scroll vertically
          scrollDirection: Axis.vertical,

          //uncomment below code to replace bottom navigation with your own
          /* navigationBuilder:
                          (context, page, totalPages, jumpToPage, animateToPage) {
                        return ButtonBar(
                          alignment: MainAxisAlignment.spaceEvenly,
                          children: <Widget>[
                            IconButton(
                              icon: Icon(Icons.first_page),
                              onPressed: () {
                                jumpToPage()(page: 0);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_back),
                              onPressed: () {
                                animateToPage(page: page - 2);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.arrow_forward),
                              onPressed: () {
                                animateToPage(page: page);
                              },
                            ),
                            IconButton(
                              icon: Icon(Icons.last_page),
                              onPressed: () {
                                jumpToPage(page: totalPages - 1);
                              },
                            ),
                          ],
                        );
                      }, */
        ),
      ),
    );
  }
}

// import 'package:audioplayers/audioplayers.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_plugin_pdf_viewer/flutter_plugin_pdf_viewer.dart';
// import 'package:just_testing/models/studySchedule.dart';
// import 'package:just_testing/modules/Notes/NotePage.dart';
// import 'API.dart';
// import 'dart:convert';
//
// class PDFReader extends StatefulWidget {
//   final String file;
//   final Task task;
//   PDFReader({Key key, this.task, this.file}) : super(key: key);
//
//   @override
//   _PDFReaderState createState() => _PDFReaderState(file);
// }
//
// class _PDFReaderState extends State<PDFReader> {
//   String pathPDF;
//   AudioPlayer audioPlayer = AudioPlayer(mode: PlayerMode.LOW_LATENCY);
//
//   var url;
//   _PDFReaderState(this.pathPDF);
//   PDFDocument _doc;
//   bool _loading;
//
//   @override
//   void initState() {
//     super.initState();
//     _initPdf();
//   }
//
//   _initPdf() async {
//     setState(() {
//       _loading = true;
//     });
//     final doc = await PDFDocument.fromAsset(widget.file);
//     setState(() {
//       _doc = doc;
//       _loading = false;
//     });
//   }
//
//   final GlobalKey<ScaffoldState> _key = GlobalKey();
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       key: _key,
//       appBar: AppBar(
//         backgroundColor: Colors.white,
//         elevation: 0,
//         leading: IconButton(
//           onPressed: () {
//             Navigator.pop(context);
//           },
//           icon: Icon(
//             Icons.arrow_back,
//             color: Colors.black,
//           ),
//         ),
//         actions: [
//           TextButton(
//             onPressed: () => _key.currentState.openDrawer(),
//             child: Row(
//               children: [Icon(Icons.edit), Text("Take notes")],
//             ),
//           ),
//           SizedBox(width: 10,),
//           TextButton(
//             onPressed: () async {
//               // url = 'http://127.0.0.1:5000/api?query=oop.pdf';
//               // url = 'http://10.0.2.2:5000/api?Query=' + widget.file.toString();
//               url = 'http://10.0.2.2:5000/api?Query=' + "oop.pdf";
//               await getData(url);
//                 int result = await audioPlayer.play(url);
//                 if (result == 1) {
//                   // success
//                 }
//
//             },
//             child: Row(
//               children: [
//                 Icon(Icons.multitrack_audio_sharp),
//                 Text("Read to me")
//               ],
//             ),
//           ),
//         ],
//       ),
//       drawer: new NotesPage(),
//       body: _loading
//           ? Center(
//               child: CircularProgressIndicator(),
//             )
//           : PDFViewer(
//               document: _doc,
//               indicatorBackground: Colors.red,
//               // showIndicator: false,
//               // showPicker: false,
//             ),
//     );
//   }
// }
