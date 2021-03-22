import 'package:flutter/material.dart';
import 'package:gopro/models/media.dart';

class MediaScreen extends StatelessWidget {
  final Media media;

  MediaScreen({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(media.fileName)),
        body: _Media(media: media));
  }
}

class _Media extends StatelessWidget {
  final Media media;

  _Media({Key? key, required this.media}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (media.isPhoto) {
      return Center(
        child: InteractiveViewer(
            child: SizedBox.expand(
                child: FadeInImage.assetNetwork(
              placeholder: 'assets/circular_progress_indicator.gif',
              image: media.url,
            )),
            minScale: 0.1,
            maxScale: 5.0),
      );
    } else {
      return Center(child: Text("Not supported yet"));
    }
  }
}
