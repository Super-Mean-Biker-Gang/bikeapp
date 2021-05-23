import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:bikeapp/screens/create_account_screen.dart';
import 'package:bikeapp/screens/privacy_policy_screen.dart';
import 'package:bikeapp/screens/terms_of_service_screen.dart';
import 'package:bikeapp/screens/sign_in_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:provider/provider.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/styles/cool_button.dart';
import 'package:bikeapp/styles/custom_input_decoration.dart';
import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';


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
  String email;
  String password;
  String confirmPassword;

  @override
  void initState() {
    super.initState();
    loadText();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: SingleChildScrollView(
        child: Form(
          key: _registerFormKey,
          child: Column(children: <Widget>[
            emailTextField(),
            SizedBox(height: responsiveHeight(10.0)),
            passwordTextField(),
            SizedBox(height: responsiveHeight(10.0)),
            confirmPasswordTextField(),
            SizedBox(height: responsiveHeight(20.0)),
            submitButton(context),
            SizedBox(height: responsiveHeight(40.0)),
            Text("Already have an account?",
                textAlign: TextAlign.left,
                style: TextStyle(color: Colors.white)),
            TextButton(
              child: Text("Login here!", style: TextStyle(color: Colors.pink)),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ]),
        ),
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration(
          hint: 'Enter your email', icon: Icon(Icons.mail)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your email';
        } else if (!EmailValidator.validate(value) && value.isNotEmpty) {
          return 'Please enter a valid email address';
        }
        return null;
      },
      onSaved: (value) => email = value.trim(),
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      controller: passwordController,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration(
          hint: 'Enter your password', icon: Icon(Icons.lock)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 8 && value.isNotEmpty) {
          return 'Password must be at least 8 characters';
        }
        return null;
      },
      onSaved: (value) => password = value.trim(),
    );
  }

  Widget confirmPasswordTextField() {
    return TextFormField(
      controller: confirmPasswordController,
      obscureText: true,
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration(
          hint: 'Enter your password', icon: Icon(Icons.lock)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter your password';
        } else if (value.length < 8 && value.isNotEmpty) {
          return 'Password must be at least 8 characters';
        } else if (value != passwordController.text.toString()) {
          return 'Passwors must match';
        }
        return null;
      },
      onSaved: (value) => confirmPassword = value.trim(),
    );
  }

  Widget submitButton(BuildContext context) {
    return CoolButton(
      title: 'Register',
      textColor: Colors.white,
      filledColor: Colors.pink,
      onPressed: () {
        if (_registerFormKey.currentState.validate()) {
          if (passwordController.text == confirmPasswordController.text) {
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Waiver", textAlign: TextAlign.center),
                  content: Text.rich(
                    TextSpan(
                      text: _waverMessage,
                      children: [
                        TextSpan(text: '\n                    \n'),
                        TextSpan(text: 'By continuing, you agree to our '),
                        TextSpan(
                            text: 'Terms of Service',
                            style: TextStyle(
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, TermsOfServiceScreen.routeName);
                              }),
                        TextSpan(text: ' and '),
                        TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(
                                decoration: TextDecoration.underline),
                            recognizer: TapGestureRecognizer()
                              ..onTap = () {
                                Navigator.pushNamed(
                                    context, PrivacyPolicyScreen.routeName);
                              }),
                      ],
                    ),
                  ),
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
                          registerAndSignIn(context);
                        }),
                    TextButton(
                      child: Text("Close"),
                      onPressed: () {
                        Navigator.popUntil(context,
                            ModalRoute.withName(CreateAccountScreen.routeName));
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
                },
              ),
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
