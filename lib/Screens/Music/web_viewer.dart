import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewer extends StatefulWidget {
  final String url;
  WebViewer({Key? key, required this.url}) : super(key: key);

  @override
  State<WebViewer> createState() => _WebViewerState();
}

class _WebViewerState extends State<WebViewer> {
  bool loading = false;
  final key = UniqueKey();
  int position = 1 ;

  doneLoading(String A) {
    setState(() {
      position = 0;
    });
  }

  startLoading(String A){
    setState(() {
      position = 1;
    });
  }

  @override
  Widget build(BuildContext context) {
    final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
      Factory(() => EagerGestureRecognizer())
    };
    void initState() {
      super.initState();
      if (Platform.isAndroid) WebView.platform = SurfaceAndroidWebView();
    }


    // UniqueKey _key = UniqueKey();

    Size size = MediaQuery.of(context).size;
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          height: 5,
          width: 120,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            color: Colors.grey,
          ),
        ),
        const SizedBox(height: 20),
        Container(
          clipBehavior: Clip.antiAlias,
          decoration: const BoxDecoration(
              color: Colors.black,
              borderRadius: BorderRadius.only(
                topLeft: Radius.circular(40),
                topRight: Radius.circular(40),
              )),
          constraints: BoxConstraints(maxHeight: size.height / 1.4),
          child: ClipRRect(
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(40),
              topRight: Radius.circular(40),
            ),
            child: IndexedStack(
              index: position,
              children: <Widget>[
                WebView(
                  // key: _key,
                  gestureNavigationEnabled: true,
                  gestureRecognizers: gestureRecognizers,
                  initialUrl: widget.url,
                  javascriptMode: JavascriptMode.unrestricted,
                  key: key ,
                  onPageFinished: doneLoading,
                  onPageStarted: startLoading,
                ),
                const SpinKitCircle(color: Colors.orange,),
              ],
            ),
          ),
        ),
        TextButton(
          onPressed: () async {
            final songURL = widget.url;

            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => WebViewer(url: songURL,)));


            // Check if Spotify is installed
            if (await canLaunch(songURL)) {
              // Launch the url which will open Spotify
              launch(songURL);
            }
          },
          style: ButtonStyle(
            padding: MaterialStateProperty.all(
                const EdgeInsets.symmetric(
                    vertical: 10.0, horizontal: 30.0)),
            backgroundColor:
            MaterialStateProperty.all<Color>(Colors.black),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "play in store",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 30,
                  fontWeight: FontWeight.w900,
                ),
              ),
              SizedBox(
                width: 5,
              ),
              Icon(
                Icons.exit_to_app,
                color: Colors.white,
                size: 30,
              ),
            ],
          ),
        ),
      ],
    );
  }

  handleLoad() {
    setState(){loading = false;}
  }
}
