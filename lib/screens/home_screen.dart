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
  Future<String>? _connection;
  List<Media> _mediaList = [];

  @override
  void initState() {
    _connection = _connect();
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
                  _connection = _connect();
                });
              })
        ]),
        body: FutureBuilder<String>(
            future: _connection,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(
                  child: Text("Connecting ...",
                      style: const TextStyle(fontSize: 18.0)),
                );
              }

              if (snapshot.hasData) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MediaScreen(
                                        mediaList: _mediaList
                                            .where((element) => element.isVideo)
                                            .toList())),
                              );
                            },
                            child: Container(
                                // decoration:
                                //     const BoxDecoration(color: Colors.green),
                                child:
                                    const Icon(Icons.featured_video_rounded)))),
                    const Divider(
                      height: 20,
                      thickness: 5,
                      indent: 20,
                      endIndent: 20,
                    ),
                    Expanded(
                        child: InkWell(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => MediaScreen(
                                        mediaList: _mediaList
                                            .where((element) => element.isPhoto)
                                            .toList())),
                              );
                            },
                            child: Container(
                                // decoration:
                                //     const BoxDecoration(color: Colors.green),
                                child:
                                    const Icon(Icons.enhance_photo_translate))))
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
                                  _connection = _connect();
                                });
                              })
                        ]),
                  ),
                );
              }
            }));
  }

  Future<String> _connect() async {
    _mediaList = await GoProProvider().fetchMediaList();

    return "GoPro connection";
  }
}
