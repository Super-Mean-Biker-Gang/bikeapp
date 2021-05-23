import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/widgets/create_account_form.dart';
import 'package:flutter/material.dart';
import 'package:bikeapp/styles/color_gradients.dart';

class CreateAccountScreen extends StatelessWidget {
  static const routeName = "create_account_screen";
  @override
  Widget build(BuildContext context) {
    ResponsiveSize().deviceSize(context);
    return Container(
      decoration: decoration(),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SizedBox(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: responsiveHeight(25.0),
                horizontal: responsiveWidth(15.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      "Create an Account",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveWidth(24.0),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: responsiveHeight(10.0)),
                    CreateAccountForm(),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
