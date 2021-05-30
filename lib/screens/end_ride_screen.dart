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
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                EndRideForm(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
