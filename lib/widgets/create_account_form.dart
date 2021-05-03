import 'package:bikeapp/screens/create_account_screen.dart';
import 'package:flutter/material.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:provider/provider.dart';

class CreateAccountForm extends StatelessWidget {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  // Email Validation and password matching from https://heartbeat.fritz.ai/firebase-user-authentication-in-flutter-1635fb175675
  String emailValidator(String value) {
    Pattern pattern =
        r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
    RegExp regex = new RegExp(pattern);
    if (!regex.hasMatch(value)) {
      return 'Email format is invalid';
    } else {
      return null;
    }
  }

  String passwordValidator(String value) {
    if (value.length < 8) {
      return 'Password must be longer than 8 characters';
    } else {
      return null;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
            child: Form(
                key: _registerFormKey,
                child: Column(children: <Widget>[
                  TextFormField(
                    controller: emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                    keyboardType: TextInputType.emailAddress,
                    validator: emailValidator,
                  ),
                  TextFormField(
                    controller: passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                    validator: passwordValidator,
                  ),
                  TextFormField(
                    controller: confirmPasswordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Confirm Password",
                    ),
                    validator: passwordValidator,
                  ),
                  submitButton(context),
                  Text("Already have an account?"),
                  TextButton(
                    child: Text("Login here!"),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  )
                ]))));
  }

  Widget submitButton(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ElevatedButton(
          onPressed: () {
            if (_registerFormKey.currentState.validate()) {
              if (passwordController.text == confirmPasswordController.text) {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text("Waiver"),
                          // Eventually read this from a text doc
                          content: Text(
                              "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"),
                          actions: <Widget>[
                            TextButton(
                                child: Text("I accept"),
                                onPressed: () {
                                  registerAndSignIn(context);
                                }),
                            TextButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.popUntil(
                                      context,
                                      ModalRoute.withName(
                                          CreateAccountScreen.routeName));
                                }),
                          ]);
                    });
              } else {
                showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                          title: Text("Error"),
                          content: Text("The passwords do not match"),
                          actions: <Widget>[
                            TextButton(
                                child: Text("Close"),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                })
                          ]);
                    });
              }
            }
          },
          child: Text("Create Account"),
        ));
  }

  void registerAndSignIn(BuildContext context) {
    context
        .read<AuthenticationService>()
        .createAccount(
            email: emailController.text.trim(),
            password: passwordController.text.trim())
        .catchError((e) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
                title: Text("Error"),
                content: Text("Account with email already exists"),
                actions: <Widget>[
                  TextButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.popUntil(context,
                            ModalRoute.withName(CreateAccountScreen.routeName));
                      })
                ]);
          });
    });
    context.read<AuthenticationService>().signIn(
        email: emailController.text.trim(),
        password: passwordController.text.trim());
    Navigator.of(context).pushNamed(MapScreen.routeName);
  }
}
