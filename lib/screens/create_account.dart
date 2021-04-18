import 'package:flutter/material.dart';

class CreateAccountScreen extends StatelessWidget {
  // static const routeName = 'create_account_screen';
  static const routeName = '/';

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Super Mean Biker Gang"),
        centerTitle: true,
      ),
      body: Text("Create account screen"),
    );
  }
}
