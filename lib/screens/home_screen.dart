import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gopro/models/media.dart';
import 'package:gopro/screens/media_list_screen.dart';
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
        body: SafeArea(
          child: FutureBuilder<List<Media>>(
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
                  final _videos = snapshot.data!
                      .where((element) => element.isVideo)
                      .toList();
                  final _photos = snapshot.data!
                      .where((element) => element.isPhoto)
                      .toList();

                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: <Widget>[
                      Expanded(
                          child: _mediaTapWidget(
                              "assets/video-gallery.png", "Videos", _videos)),
                      const Divider(
                        height: 20,
                        thickness: 5,
                        indent: 20,
                        endIndent: 20,
                      ),
                      Expanded(
                          child: _mediaTapWidget(
                              "assets/photo-gallery.png", "Photos", _photos)),
                    ],
                  );
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
              }),
        ));
  }

  Future<List<Media>> _fetchMediaList() async {
    return GoProProvider().fetchMediaList();
  }

  Widget _mediaTapWidget(
      String mediaListAsset, String mediaListTitle, List<Media> mediaList) {
    return GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => MediaListScreen(
                    title: mediaListTitle, mediaList: mediaList)),
          );
        },
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Image.asset(mediaListAsset, width: 200, height: 200),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(mediaList.length.toString(),
                style: const TextStyle(fontSize: 18.0)),
          )
        ]));
  }
}
