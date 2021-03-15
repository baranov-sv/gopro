import 'package:flutter/material.dart';
import 'dart:math';

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
    _connection = _connect(5);
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
                      child: Container(
                        child:
                            Center(child: Icon(Icons.featured_video_rounded)),
                        decoration: const BoxDecoration(color: Colors.green),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        child:
                            Center(child: Icon(Icons.enhance_photo_translate)),
                        decoration: const BoxDecoration(color: Colors.red),
                      ),
                    )
                  ],
                );
              } else {
                return Center(
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text("Error"),
                        ElevatedButton(
                            child: Text("Reconnect"),
                            onPressed: () {
                              setState(() {
                                _connection = _connect(3);
                              });
                            })
                      ]),
                );
              }
            }));
  }

  Future<String> _connect(int delay) {
    return Future<String>.delayed(Duration(seconds: delay), () {
      // if (false) {
      if (Random().nextBool()) {
        return "GoPro connection";
      } else {
        throw ("some arbitrary error");
      }
    });
  }
}
