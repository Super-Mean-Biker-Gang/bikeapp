import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/screens/sign_in_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:bikeapp/styles/color_gradients.dart';
import 'package:bikeapp/styles/cool_button.dart';
import 'package:bikeapp/styles/custom_input_decoration.dart';

class ForgotPassword extends StatefulWidget {
  static const routeName = 'forgot_password';

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  final TextEditingController emailController = TextEditingController();
  final formKey = GlobalKey<FormState>();
  String email;
  String eMessage;

  @override
  void initState() {
    eMessage = "";
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    ResponsiveSize().deviceSize(context);
    return Container(
      decoration: decoration(),
      child: Scaffold(
        appBar: AppBar(),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SizedBox(
            child: Container(
              padding: EdgeInsets.symmetric(
                  vertical: responsiveHeight(45.0),
                  horizontal: responsiveWidth(15.0)),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Forgot Password?",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveWidth(24.0),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: responsiveHeight(30.0)),
                    Text(
                      "Please enter your email and we will send you a link to reset your password",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveWidth(11.0),
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: responsiveHeight(45.0)),
                    Container(
                      child: Form(
                        key: formKey,
                        child: Column(
                          children: [
                            emailTextField(),
                            SizedBox(height: responsiveHeight(10.0)),
                            displayErrorMessage(),
                            SizedBox(height: responsiveHeight(65.0)),
                            submitRequestButton(context),                           
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
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

  Widget submitRequestButton(BuildContext context) {
    return CoolButton(
      title: 'Submit Request',
      textColor: Colors.white,
      filledColor: Colors.green,
      onPressed: () async {
        setState(() {
          eMessage = "";
        });
        if (formKey.currentState.validate()) {
          formKey.currentState.save();
          try {
            await context.read<AuthenticationService>().passwordReset(
            email: emailController.text.trim(),
            );
            customPopUp(context);
          }catch (error) {
            setState(() {
              eMessage = error.message;
            });    
          }
        }
      },
    );
  }

  Widget displayErrorMessage() {
    if (eMessage != null) {
      return Text(
        eMessage,
        style: TextStyle(
          color: Colors.redAccent,
          fontSize: responsiveWidth(9.0),
          fontWeight: FontWeight.w500,
        )
      );
    } else {
      return Text('');
    }
  }

  void customPopUp(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Password Reset",
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            'A link for password reset has been sent to your email',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            TextButton(
              child: Text(
                'Back to Submit Request',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(ForgotPassword.routeName);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              )
            ),
            TextButton(
              child: Text(
                'Begin Sign in',
                style: TextStyle(color: Colors.white),
              ),
              onPressed: () {
                Navigator.of(context).pushNamed(SignInScreen.routeName);
              },
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Colors.green),
              )
            ),
          ],
        );
      },
    );
  }
}
