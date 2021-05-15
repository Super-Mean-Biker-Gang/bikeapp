import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bikeapp/screens/create_account_screen.dart';
import 'package:bikeapp/screens/sign_in_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:provider/provider.dart';

const WAVER_PATH = 'assets/text_files/registerWaver.txt';

String _waverMessage;

class CreateAccountForm extends StatefulWidget {
  @override
  _CreateAccountFormState createState() => _CreateAccountFormState();
}

class _CreateAccountFormState extends State<CreateAccountForm> {
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  final TextEditingController confirmPasswordController =
      TextEditingController();

  @override
  void initState() {
    super.initState();
    loadText();
  }

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
            ),
          ]),
        ),
      ),
    );
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
                    content: Text(_waverMessage),
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
                        },
                      ),
                    ],
                  );
                },
              );
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
                        },
                      ),
                    ],
                  );
                },
              );
            }
          }
        },
        child: Text("Create Account"),
      ),
    );
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
                  }),
            ],
          );
        },
      );
    });
    Navigator.of(context).pushNamed(SignInScreen.routeName);
  }

  Future loadText() async {
    _waverMessage = await rootBundle.loadString(WAVER_PATH);
    print(_waverMessage);
  }
}
