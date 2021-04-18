import 'package:bikeapp/screens/create_account.dart';
import 'package:flutter/material.dart';

class App extends StatefulWidget {
  @override
  _AppState createState() => _AppState();
}

class _AppState extends State<App> {
  @override
  Widget build(BuildContext context) {
    final routes = {
      CreateAccountScreen.routeName: (context) => CreateAccountScreen(),
    };

    return MaterialApp(
      title: 'Super Mean Biker Gang',
      routes: routes,
    );
  }
}
