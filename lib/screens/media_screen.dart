import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gopro/models/media.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';

class MediaScreen extends StatelessWidget {
  final Media media;

  MediaScreen({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (media.isPhoto) {
      return Scaffold(
          appBar: AppBar(title: Text(media.fileName)),
          body: SafeArea(
              child: Center(
            child: PhotoView(
                imageProvider: NetworkImage(media.url),
                backgroundDecoration: BoxDecoration(color: Colors.white),
                loadingBuilder: (context, _) {
                  return CircularProgressIndicator();
                },
                minScale: 0.1),
          )));
    } else {
      return _VideoPlayer(media: media);
    }
  }
}

class _VideoPlayer extends StatefulWidget {
  final Media media;
  _VideoPlayer({Key? key, required this.media}) : super(key: key);

  @override
  _VideoPlayerState createState() => _VideoPlayerState(media: media);
}

class _VideoPlayerState extends State<_VideoPlayer> {
  final Media media;
  _VideoPlayerState({required this.media}) : super();

  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    // Create and store the VideoPlayerController. The VideoPlayerController
    // offers several different constructors to play videos from assets, files,
    // or the internet.
    _controller = VideoPlayerController.network(media.url);

    _controller.addListener(() {
      setState(() {});
    });
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

    // Use the controller to loop the video.
    _controller.setLooping(true);

    super.initState();
  }

  @override
  void dispose() {
    // Ensure disposing of the VideoPlayerController to free up resources.
    _controller.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(media.fileName),
      ),
      // Use a FutureBuilder to display a loading spinner while waiting for the
      // VideoPlayerController to finish initializing.
      body: SafeArea(
        child: FutureBuilder(
          future: _initializeVideoPlayerFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: Stack(
                    alignment: Alignment.bottomCenter,
                    children: <Widget>[
                      VideoPlayer(_controller),
                      _ControlsOverlay(controller: _controller),
                      VideoProgressIndicator(_controller, allowScrubbing: true),
                    ],
                  ),
                ),
              );
            } else {
              // If the VideoPlayerController is still initializing, show a
              // loading spinner.
              return Center(child: CircularProgressIndicator());
            }
          },
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class _ControlsOverlay extends StatelessWidget {
  const _ControlsOverlay({Key? key, required this.controller})
      : super(key: key);

  final VideoPlayerController controller;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        AnimatedSwitcher(
          duration: Duration(milliseconds: 50),
          reverseDuration: Duration(milliseconds: 200),
          child: controller.value.isPlaying
              ? SizedBox.shrink()
              : Container(
                  color: Colors.black26,
                  child: Center(
                    child: Icon(
                      Icons.play_arrow,
                      color: Colors.white,
                      size: 100.0,
                    ),
                  ),
                ),
        ),
        GestureDetector(
          onTap: () {
            controller.value.isPlaying ? controller.pause() : controller.play();
          },
        ),
      ],
    );
  }
}
