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
    return Center(
        child: FutureBuilder<String>(
            future: _connection,
            builder: (BuildContext context, AsyncSnapshot<String> snapshot) {
              if (snapshot.connectionState != ConnectionState.done) {
                return Center(child: Text("Connecting ..."));
              }

              if (snapshot.hasData) {
                return Column(children: [
                  Container(child: Text("Videos"), color: Colors.blue),
                  Container(child: Text("Photos"), color: Colors.red)
                ]);
              } else {
                return Column(
                  children: [
                    Center(child: Text("Error")),
                    ElevatedButton(
                        child: Text("Reconnect"),
                        onPressed: () {
                          setState(() {
                            _connection = _connect(3);
                          });
                        })
                  ],
                );
              }
            }));
  }

  Future<String> _connect(int delay) {
    return Future<String>.delayed(Duration(seconds: delay), () {
      if (Random().nextBool()) {
        return "GoPro connection";
      } else {
        throw ("some arbitrary error");
      }
    });
  }
}