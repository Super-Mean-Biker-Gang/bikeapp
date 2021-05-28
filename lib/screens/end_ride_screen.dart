import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/widgets/end_ride_form.dart';
import 'package:flutter/material.dart';
import 'package:bikeapp/styles/color_gradients.dart';

class EndRideScreen extends StatelessWidget {
  static const routeName = "end_ride_screen";
  @override
  Widget build(BuildContext context) {
    ResponsiveSize().deviceSize(context);
    return Container(
      decoration: decoration(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("End Ride"),
          leading: GestureDetector(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back),
          ),
          centerTitle: true,
        ),
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
                    EndRideForm(),
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
