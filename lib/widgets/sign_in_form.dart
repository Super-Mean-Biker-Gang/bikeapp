import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/screens/forgot_password.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:bikeapp/styles/cool_button.dart';
import 'package:bikeapp/styles/custom_input_decoration.dart';

class SignInForm extends StatefulWidget {
  @override
  _SignInFormState createState() => _SignInFormState();
}

class _SignInFormState extends State<SignInForm> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String email;
  String password;
  String eMessage;

  @override
  void initState() {
    eMessage = "";
    super.initState();
  }

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
            SizedBox(height: responsiveHeight(10.0)),
            displayErrorMessage(),
          ],
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

  Widget signInButton(BuildContext context) {
    return CoolButton(
        title: 'Sign in',
        textColor: Colors.white,
        filledColor: Colors.green,
        onPressed: () async {
          setState(() {
            eMessage = "";
          });
          if (formKey.currentState.validate()) {
            formKey.currentState.save();
            try {
              await context.read<AuthenticationService>().signIn(
                    email: emailController.text.trim(),
                    password: passwordController.text.trim(),
                  );
              Navigator.of(context).pushNamed(MapScreen.routeName);
            } catch (error) {
              setState(() {
                eMessage = error.message;
              });
            }
          }
        });
  }

  Widget displayErrorMessage() {
    if (eMessage != null) {
      return Text(eMessage,
          style: TextStyle(
            color: Colors.redAccent,
            fontSize: responsiveWidth(9.0),
            fontWeight: FontWeight.w500,
          ));
    } else {
      return Text('');
    }
  }
}
