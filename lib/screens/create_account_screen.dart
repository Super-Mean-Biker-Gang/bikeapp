import 'package:bikeapp/widgets/create_account_form.dart';
import 'package:flutter/material.dart';

class CreateAccountScreen extends StatelessWidget {
  static const routeName = "create_account_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Register")),
      body: CreateAccountForm(),
    );
  }
}
