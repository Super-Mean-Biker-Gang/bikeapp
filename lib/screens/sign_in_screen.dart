import 'package:bikeapp/screens/create_account_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = 'sign_in_screen';

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
            context.read<AuthenticationService>().signIn(
                email: emailController.text.trim(),
                password: passwordController.text.trim());
          },
          child: Text("Sign in"),
        ),
        ElevatedButton(
          onPressed: () {
            Navigator.of(context).pushNamed(CreateAccountScreen.routeName);
          },
          child: Text("Create New Account"),
        )
      ],
    ));
  }
}
