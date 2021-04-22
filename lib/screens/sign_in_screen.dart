
import 'package:flutter/material.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/screens/create_account_screen.dart';
import 'package:bikeapp/widgets/sign_in_form.dart';

class SignInScreen extends StatelessWidget {
  static const routeName = 'sign_in_screen';

  @override
  Widget build(BuildContext context) {
    ResponsiveSize().deviceSize(context);
    ResponsiveSize().deviceOrientation(context);
    return Scaffold(
      backgroundColor: Colors.tealAccent[100],
      body: SafeArea(
        child: SizedBox(
          child: Container(
            padding: EdgeInsets.symmetric(vertical: responsiveHeight(25.0), horizontal: responsiveWidth(20.0)),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(height: responsiveHeight(50.0)),
                  Text(
                    "Welcome",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: responsiveWidth(33.0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(height: responsiveHeight(10.0)),
                  Text(
                    "Please log in with your email and password",
                    style: TextStyle(
                      color: Colors.grey[700],
                      fontSize: responsiveWidth(12.0),
                    ),
                  ),
                  SizedBox(height: responsiveHeight(70.0)),
                  SignInForm(),
                  SizedBox(height: responsiveHeight(70.0)),
                  withoutAccount(context),
                ],
              ),
            ),
          ),
        ), 
      ),
    );
  }

  Widget withoutAccount(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          "Don't have an account yet?",
          style: TextStyle(
            fontSize: responsiveWidth(13.0),
          ),
        ),
        SizedBox(height: responsiveHeight(5.0)),
        GestureDetector(
          onTap: () => Navigator.of(context).pushNamed(CreateAccountScreen.routeName),
          child: Text(
            "Create Account",
            style: TextStyle(
                fontSize: responsiveWidth(13.0),
                color: Colors.blueAccent[700],
            ),
          ),
        ),
      ],
    );
  }
}


