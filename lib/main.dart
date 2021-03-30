import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gopro/screens/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp])
      .then((_) {
    runApp(App());
  });
}

class App extends StatelessWidget {
  final _observer = _NavigatorObserverWithOrientation();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'GoPro App',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: HomeScreen(),
      navigatorObservers: [_observer],
    );
  }
}

class _NavigatorObserverWithOrientation extends NavigatorObserver {
  // Set portrait orientation when push/pop routes
  @override
  void didPop(Route route, Route? previousRoute) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }

  @override
  void didPush(Route route, Route? previousRoute) {
    SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  }
}
