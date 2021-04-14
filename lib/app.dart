import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final routes = {
      // Put screen routes in here later
    };

    return MaterialApp(
      title: 'Super Mean Biker Gang',
      routes: routes,
    );
  }
}
