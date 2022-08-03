import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

class VideoWidget extends StatefulWidget {
  final File file;

  const VideoWidget(this.file);

  @override
  VideoWidgetState createState() => VideoWidgetState();
}

class VideoWidgetState extends State<VideoWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  Widget? videoStatusAnimation;

  @override
  void initState() {
    super.initState();

    videoStatusAnimation = Container();

    _controller = VideoPlayerController.file(widget.file)
      ..addListener(() {
        final bool isPlaying = _controller!.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        Timer(const Duration(milliseconds: 0), () {
          if (!mounted) return;

          setState(() {});
          _controller!.play();
        });
      });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: _controller!.value.aspectRatio,
    child: _controller!.value.isInitialized ? videoPlayer() : Container(),
  );

  Widget videoPlayer() => Stack(
    children: <Widget>[
      video(),
      Align(
        alignment: Alignment.bottomCenter,
        child: VideoProgressIndicator(
          _controller!,
          allowScrubbing: true,
          colors: const VideoProgressColors(
            playedColor: Color.fromRGBO(255, 165, 0, 0.7),
            bufferedColor: Color.fromRGBO(50, 50, 200, 0.2),
              backgroundColor: Color.fromRGBO(200, 200, 200, 0.5)
          ),
          // padding: EdgeInsets.all(16.0),
        ),
      ),
      Center(child: videoStatusAnimation),
    ],
  );

  Widget video() => GestureDetector(
    child: Container(child: VideoPlayer(_controller!)),
    onTap: () {
      if (!_controller!.value.isInitialized) {
        return;
      }
      if (_controller!.value.isPlaying) {
        videoStatusAnimation =
            FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
        _controller!.pause();
      } else {
        videoStatusAnimation =
            FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
        _controller!.play();
      }
    },
  );
}

class VideoPostWidget extends StatefulWidget {
  final String file;

  const VideoPostWidget(this.file);

  @override
  VideoPostWidgetState createState() => VideoPostWidgetState();
}

class VideoPostWidgetState extends State<VideoPostWidget> {
  VideoPlayerController? _controller;
  bool _isPlaying = false;

  Widget? videoStatusAnimation;

  @override
  void initState() {
    super.initState();

    videoStatusAnimation = Container();

    _controller = VideoPlayerController.network(widget.file)
      ..addListener(() {
        final bool isPlaying = _controller!.value.isPlaying;
        if (isPlaying != _isPlaying) {
          setState(() {
            _isPlaying = isPlaying;
          });
        }
      })
      ..initialize().then((_) {
        Timer(const Duration(milliseconds: 0), () {
          if (!mounted) return;

          setState(() {});
          _controller!.play();
        });
      });
  }

  @override
  void dispose() {
    _controller!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => AspectRatio(
    aspectRatio: _controller!.value.aspectRatio,
    child: _controller!.value.isInitialized ? videoPlayer() : Container(),
  );

  Widget videoPlayer() => Stack(
    children: <Widget>[
      video(),
      Align(
        alignment: Alignment.bottomCenter,
        child: VideoProgressIndicator(
          _controller!,
          allowScrubbing: true,
          colors: const VideoProgressColors(
            playedColor: Color.fromRGBO(255, 165, 0, 0.7),
            bufferedColor: Color.fromRGBO(50, 50, 200, 0.2),
              backgroundColor: Color.fromRGBO(200, 200, 200, 0.5)
          ),
          // padding: EdgeInsets.all(16.0),
        ),
      ),
      Center(child: videoStatusAnimation),
    ],
  );

  Widget video() => GestureDetector(
    child: Container(child: VideoPlayer(_controller!)),
    onTap: () {
      if (!_controller!.value.isInitialized) {
        return;
      }
      if (_controller!.value.isPlaying) {
        videoStatusAnimation =
            FadeAnimation(child: const Icon(Icons.pause, size: 100.0));
        _controller!.pause();
      } else {
        videoStatusAnimation =
            FadeAnimation(child: const Icon(Icons.play_arrow, size: 100.0));
        _controller!.play();
      }
    },
  );
}

class VideoWebWidget extends StatefulWidget {
  final String? file;

  const VideoWebWidget({required this.file});

  @override
  VideoWebWidgetState createState() => VideoWebWidgetState();
}

class VideoWebWidgetState extends State<VideoWebWidget> {
  late VideoPlayerController controller;

  @override
  void initState() {
    loadVideoPlayer();
    super.initState();
  }

  loadVideoPlayer(){
    controller = VideoPlayerController.network(widget.file!);
    controller.addListener(() {
      setState(() {});
    });
    controller.initialize().then((value){
      setState(() {});
    });

  }

  @override
  Widget build(BuildContext context) {
    return Column(
          children:[

            AspectRatio(
              aspectRatio: controller.value.aspectRatio,
              child: Stack(
                children: [
                  VideoPlayer(controller),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors:const VideoProgressColors(
                          backgroundColor: Color(0xFFBDBDBD),
                          playedColor: Color(0xFF81C784),
                          bufferedColor: Colors.grey,
                        )
                    ),
                  ),
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: VideoProgressIndicator(
                        controller,
                        allowScrubbing: true,
                        colors:const VideoProgressColors(
                          backgroundColor: Color(0xFFBDBDBD),
                          playedColor: Color(0xFF81C784),
                          bufferedColor: Colors.grey,
                        )
                    ),
                  ),
                  Positioned(
                    right: 2,
                    bottom: 5,
                    child: IconButton(
                        onPressed: (){
                          Navigator.push(context, MaterialPageRoute(builder: (context)=> Scaffold(extendBodyBehindAppBar: true, appBar: AppBar(
                            backgroundColor: Colors.transparent,
                            shadowColor: Colors.transparent,
                            leading: const CloseButton(),
                          ),body:Center(child: VideoWebWidget(file: widget.file)))));
                        },
                        icon:const Icon(Icons.fullscreen, color: Colors.white,)
                    ),),


                ],
              ),
            ),

            // Container( //duration of video
            //   child: Text("Total Duration: " + controller.value.duration.toString()),
            // ),

            // Container(
            //     child: VideoProgressIndicator(
            //         controller,
            //         allowScrubbing: true,
            //         colors:const VideoProgressColors(
            //           backgroundColor: Color(0xFFBDBDBD),
            //           playedColor: Color(0xFF81C784),
            //           bufferedColor: Colors.grey,
            //         )
            //     )
            // ),

            Row(
              mainAxisAlignment: MainAxisAlignment.start,

              children: [
                IconButton(
                    onPressed: (){
                      if(controller.value.isPlaying){
                        controller.pause();
                      }else{
                        controller.play();
                      }

                      setState(() {

                      });
                    },
                    icon:Icon(controller.value.isPlaying?Icons.pause:Icons.play_arrow)
                ),

                IconButton(
                    onPressed: (){
                      controller.seekTo(const Duration(seconds: 0));
                      controller.play();

                      setState(() {

                      });
                    },
                    icon:const Icon(Icons.restart_alt)
                )
              ],
            )
          ]
      );
  }
}

class FadeAnimation extends StatefulWidget {
  const FadeAnimation(
      {required this.child, this.duration = const Duration(milliseconds: 1000)});

  final Widget child;
  final Duration duration;

  @override
  _FadeAnimationState createState() => _FadeAnimationState();
}

class _FadeAnimationState extends State<FadeAnimation>
    with SingleTickerProviderStateMixin {
  AnimationController? animationController;

  @override
  void initState() {
    super.initState();
    animationController =
        AnimationController(duration: widget.duration, vsync: this);
    animationController!.addListener(() {
      if (mounted) {
        setState(() {});
      }
    });
    animationController!.forward(from: 0.0);
  }

  @override
  void deactivate() {
    animationController!.stop();
    super.deactivate();
  }

  @override
  void didUpdateWidget(FadeAnimation oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.child != widget.child) {
      animationController!.forward(from: 0.0);
    }
  }

  @override
  void dispose() {
    animationController!.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => animationController!.isAnimating
      ? Opacity(
    opacity: 1.0 - animationController!.value,
    child: widget.child,
  )
      : Container();
}