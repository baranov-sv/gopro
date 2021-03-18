import 'dart:async';
import 'package:flutter/material.dart';
import 'package:gopro/screens/media.dart';
import 'package:gopro/resources/gopro_provider.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

/// This is the private State class that goes with Home.
class _HomeState extends State<Home> {
  Future<String>? _connection;

  @override
  void initState() {
    _connection = _connect();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('GoPro App')),
        body: FutureBuilder<String>(
            future: _connection,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: Text("Connecting ..."));
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
                                    builder: (context) => Media()),
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
                                    builder: (context) => Media()),
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
                          Text(snapshot.error.toString()),
                          ElevatedButton(
                              child: Text("Reconnect"),
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
    await GoProProvider().fetchMediaList();

    return "GoPro connection";
  }
}
