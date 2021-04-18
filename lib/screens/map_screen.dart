import 'package:bikeapp/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bikeapp/screens/sign_in_screen.dart';

class MapScreen extends StatelessWidget {
  static const routeName = 'map_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
      child: Column(
        children: [
          Text("Map Screen"),
          ElevatedButton(
            onPressed: () {
              context.read<AuthenticationService>().signOut();
              Navigator.of(context).pushNamed(SignInScreen.routeName);
            },
            child: Text("Sign out"),
          )
        ],
      ),
    ));
  }
}
