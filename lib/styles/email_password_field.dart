import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:bikeapp/styles/cool_button.dart';

final TextEditingController _emailController = TextEditingController();
final TextEditingController _passwordController = TextEditingController();

Widget emailTextField() {
  return TextFormField(
    controller: _emailController,
    keyboardType: TextInputType.emailAddress,
    style: TextStyle(color: Colors.white),
    decoration:
        customInputDecoration(hint: 'Enter your email', icon: Icon(Icons.mail)),
  );
}

Widget passwordTextField() {
  return TextFormField(
    controller: _passwordController,
    style: TextStyle(color: Colors.white),
    decoration: customInputDecoration(
        hint: 'Enter your password', icon: Icon(Icons.lock)),
  );
}

InputDecoration customInputDecoration({String hint, Icon icon}) {
  return InputDecoration(
    hintText: hint,
    hintStyle: TextStyle(
      color: Colors.white,
      fontSize: responsiveWidth(10.0),
    ),
    floatingLabelBehavior: FloatingLabelBehavior.always,
    border: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
    ),
    enabledBorder: OutlineInputBorder(
      borderRadius: BorderRadius.circular(25),
      borderSide: BorderSide(
        color: Colors.cyanAccent,
        width: responsiveWidth(2.0),
      ),
    ),
    prefixIcon: Container(
      padding: EdgeInsets.only(left: 25, right: 20),
      child: IconTheme(
        data: IconThemeData(color: Colors.white),
        child: icon,
      ),
    ),
  );
}

Widget signInButton(BuildContext context) {
  return CoolButton(
    title: 'Sign in',
    textColor: Colors.white,
    filledColor: Colors.green,
    onPressed: () {
      context.read<AuthenticationService>().signIn(
          email: _emailController.text.trim(),
          password: _passwordController.text.trim());
    },
  );
}
