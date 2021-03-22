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
        body: ListView.builder(
            padding: const EdgeInsets.all(8),
            itemCount: mediaList.length,
            itemBuilder: (context, index) {
              final _media = mediaList[index];
              return InkWell(
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
            }));
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
            child: _MediaDescription(filename: filename, size: size),
          )
        ],
      ),
    );
  }
}

class _MediaDescription extends StatelessWidget {
  const _MediaDescription({
    Key? key,
    required this.filename,
    required this.size,
  }) : super(key: key);

  final String filename;
  final String size;

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Center(
            child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
          _title(),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          _size()
        ])));
  }

  Widget _title() {
    return Text(
      filename,
      style: const TextStyle(
        fontWeight: FontWeight.w500,
        fontSize: 16.0,
      ),
    );
  }

  Widget _size() {
    return Text(
      size,
      style: const TextStyle(fontSize: 12.0),
    );
  }
}
