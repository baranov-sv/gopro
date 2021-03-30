import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:gopro/models/media.dart';
import 'package:video_player/video_player.dart';
import 'package:photo_view/photo_view.dart';

class MediaScreen extends StatelessWidget {
  final Media media;

  MediaScreen({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    var deviceOrientation = MediaQuery.of(context).orientation;

    return Scaffold(
        appBar: deviceOrientation == Orientation.portrait
            ? AppBar(title: Text(media.fileName), actions: [
                IconButton(
                    icon: const Icon(Icons.rotate_90_degrees_ccw_sharp),
                    onPressed: () {
                      SystemChrome.setPreferredOrientations(
                          [DeviceOrientation.landscapeLeft]);
                    })
              ])
            : null,
        body: SafeArea(
            child: Center(
                child: media.isPhoto
                    ? _PhotoViewer(media: media)
                    : _VideoPlayer(media: media))));
  }
}

class _PhotoViewer extends StatelessWidget {
  final Media media;
  _PhotoViewer({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: PhotoView(
        imageProvider: NetworkImage(media.url),
        backgroundDecoration: BoxDecoration(color: Colors.white),
        loadingBuilder: (context, _) {
          return CircularProgressIndicator();
        },
        initialScale: PhotoViewComputedScale.contained,
      ),
    );
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

    _controller.setLooping(false);
    _controller.addListener(() {
      setState(() {
        // Seek to 0 position when video is ended
        if (_controller.value.duration == _controller.value.position) {
          _controller.seekTo(Duration()).then((value) => _controller.pause());
        }
      });
    });
    // Initialize the controller and store the Future for later use.
    _initializeVideoPlayerFuture = _controller.initialize();

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
    return FutureBuilder(
      future: _initializeVideoPlayerFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          // If the VideoPlayerController is still initializing, show a
          // loading spinner.
          return CircularProgressIndicator();
        }

        return Container(
          padding: const EdgeInsets.only(top: 10, bottom: 10),
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
      },
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
