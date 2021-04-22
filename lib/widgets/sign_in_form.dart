import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/screens/forgot_password.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:bikeapp/style/cool_button.dart';

class SignInForm extends StatefulWidget {

  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Form(
        key: formKey,
        child: Column(
          children: [
            emailTextField(),
            SizedBox(height: responsiveHeight(20.0)),
            passwordTextField(),
            SizedBox(height: responsiveHeight(50.0)),
            forgotPasswordText(context), 
            SizedBox(height: responsiveHeight(50.0)),
            signInButton(),
            SizedBox(height: responsiveHeight(35.0)),
          ],
        ),
      ),
    );
  }

  Widget emailTextField() {
    return TextFormField(
      controller: _emailController,
      keyboardType: TextInputType.emailAddress,
      decoration: customInputDecoration(hint: 'Enter your email', icon: Icon(Icons.mail)),
    );
  }

  Widget passwordTextField() {
    return TextFormField(
      controller: _passwordController,
      decoration: customInputDecoration(hint: 'Enter your password', icon: Icon(Icons.lock)),
    );
  }

  InputDecoration customInputDecoration({String hint, Icon icon}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: TextStyle(
        fontSize: responsiveWidth(11.0),
      ),
      floatingLabelBehavior: FloatingLabelBehavior.always,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(25),
        ),
      prefixIcon: Container(
        padding: EdgeInsets.only(left: 25, right: 20),
        child: IconTheme(
          data: IconThemeData(color: Colors.grey),
          child: icon,
        ),
      ),
    );
  }

  Widget forgotPasswordText(BuildContext context) {
    return GestureDetector(
      onTap: () => Navigator.of(context).pushNamed(ForgotPassword.routeName),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Forgot Password?",
            style: TextStyle(
              fontSize: responsiveWidth(12.0),
              color: Colors.blueAccent[700]),
          ),
        ]
      ),
    );
  }

  Widget signInButton() {
    return CoolButton(
      title: 'Sign in',
      textColor: Colors.white,
      filledColor: Colors.purple[300],
      splashColor: Theme.of(context).primaryColor,
      onPressed: () {
        context.read<AuthenticationService>().signIn(
            email: _emailController.text.trim(),
            password: _passwordController.text.trim());
      },
    );
  }
}