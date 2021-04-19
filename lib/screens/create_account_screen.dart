import 'package:bikeapp/screens/map_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CreateAccountScreen extends StatelessWidget {
  static const routeName = "create_account_screen";

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextField(
          controller: emailController,
          decoration: InputDecoration(
            labelText: "Email",
          ),
        ),
        TextField(
          controller: passwordController,
          decoration: InputDecoration(
            labelText: "Password",
          ),
        ),
        ElevatedButton(
          onPressed: () {
            context.read<AuthenticationService>().createAccount(
                email: emailController.text.trim(),
                password: passwordController.text.trim());
            Navigator.of(context).pushNamed(MapScreen.routeName);
          },
          child: Text("Create Account"),
        )
      ],
    ));
  }
}
