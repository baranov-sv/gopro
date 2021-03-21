import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gopro/models/media.dart';
import 'package:gopro/screens/media_screen.dart';
import 'package:gopro/resources/gopro_provider.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

/// This is the private State class that goes with Home.
class _HomeScreenState extends State<HomeScreen> {
  Future<List<Media>>? _futureMediaList;

  @override
  void initState() {
    _futureMediaList = _fetchMediaList();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('GoPro App'), actions: [
          IconButton(
              icon: const Icon(Icons.flip_camera_android),
              onPressed: () {
                setState(() {
                  _futureMediaList = _fetchMediaList();
                });
              })
        ]),
        body: FutureBuilder<List<Media>>(
            future: _futureMediaList,
            builder:
                (BuildContext context, AsyncSnapshot<List<Media>> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: Text("Connecting ...",
                      style: const TextStyle(fontSize: 18.0)),
                );
              }

              if (snapshot.hasData) {
                return _MediaToogle(mediaList: snapshot.data!);
              } else {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            snapshot.error.toString(),
                            style: const TextStyle(fontSize: 18.0),
                          ),
                          ElevatedButton(
                              child: Text("Reconnect",
                                  style: const TextStyle(fontSize: 18.0)),
                              onPressed: () {
                                setState(() {
                                  _futureMediaList = _fetchMediaList();
                                });
                              })
                        ]),
                  ),
                );
              }
            }));
  }

  Future<List<Media>> _fetchMediaList() async {
    return GoProProvider().fetchMediaList();
  }
}

class _MediaToogle extends StatelessWidget {
  final List<Media> mediaList;
  _MediaToogle({Key? key, required this.mediaList}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final _videos = mediaList.where((element) => element.isVideo).toList();
    final _photos = mediaList.where((element) => element.isPhoto).toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: <Widget>[
        Expanded(
            child: _MediaTap(
                iconData: Icons.featured_video_rounded, mediaList: _videos)),
        const Divider(
          height: 20,
          thickness: 5,
          indent: 20,
          endIndent: 20,
        ),
        Expanded(
            child: _MediaTap(
                iconData: Icons.enhance_photo_translate, mediaList: _photos)),
      ],
    );
  }
}

class _MediaTap extends StatelessWidget {
  final List<Media> mediaList;
  final IconData iconData;
  _MediaTap({Key? key, required this.iconData, required this.mediaList})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MediaScreen(mediaList: mediaList)),
          );
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(iconData),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(mediaList.length.toString()),
          )
        ]));
  }
}
