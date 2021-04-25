import 'package:flutter/material.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/styles/color_gradients.dart';
import 'package:bikeapp/styles/cool_button.dart';
import 'package:bikeapp/styles/email_password_field.dart';

class ForgotPassword extends StatelessWidget {
  static const routeName = 'forgot_password';

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
                    emailTextField(),
                    SizedBox(height: responsiveHeight(65.0)),
                    submitRequestButton(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget submitRequestButton() {
    return CoolButton(
      title: 'Submit Request',
      textColor: Colors.white,
      filledColor: Colors.green,
      onPressed: () {},
    );
  }
}
