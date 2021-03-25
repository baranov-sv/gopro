import 'package:flutter/material.dart';
import 'package:gopro/models/media.dart';
import 'package:gopro/screens/media_screen.dart';

class MediaListScreen extends StatelessWidget {
  final List<Media> mediaList;
  MediaListScreen({Key? key, required this.mediaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Media')),
        body: SafeArea(
          child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: mediaList.length,
              itemBuilder: (context, index) {
                final _media = mediaList[index];
                return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => MediaScreen(media: _media)),
                      );
                    },
                    child: _MediaItem(
                        thumbnail: Image.network(_media.thumbnailUrl),
                        filename: _media.fileName,
                        size: _media.humanSize));
              }),
        ));
  }
}

class _MediaItem extends StatelessWidget {
  const _MediaItem({
    Key? key,
    required this.thumbnail,
    required this.filename,
    required this.size,
  }) : super(key: key);

  final Widget thumbnail;
  final String filename;
  final String size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: thumbnail,
          ),
          Expanded(
            flex: 3,
            child: Container(
                child: Center(
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: <Widget>[
                  Text(
                    filename,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.0,
                    ),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  Text(
                    size,
                    style: const TextStyle(fontSize: 12.0),
                  )
                ]))),
          )
        ],
      ),
    );
  }
}
