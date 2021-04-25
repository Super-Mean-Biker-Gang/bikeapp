import 'package:flutter/material.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/screens/forgot_password.dart';
import 'package:bikeapp/styles/email_password_field.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            emailTextField(),
            SizedBox(height: responsiveHeight(10.0)),
            passwordTextField(),
            SizedBox(height: responsiveHeight(20.0)),
            forgotPasswordText(context),
            SizedBox(height: responsiveHeight(20.0)),
            signInButton(context),
          ],
        ),
      ),
    );
  }

  Widget forgotPasswordText(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ForgotPassword.routeName),
      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(
          "Forgot Password?",
          style: TextStyle(
              fontSize: responsiveWidth(11.0),
              fontWeight: FontWeight.w500,
              color: Colors.cyanAccent),
        ),
      ]),
    );
  }
}
