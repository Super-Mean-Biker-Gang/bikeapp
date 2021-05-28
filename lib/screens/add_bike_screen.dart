import 'package:bikeapp/widgets/add_bike_form.dart';
import 'package:flutter/material.dart';
import 'package:bikeapp/styles/color_gradients.dart';
import 'package:bikeapp/models/responsive_size.dart';

class AddBikeScreen extends StatelessWidget {
  static const routeName = "add_bike_screen";
  @override
  Widget build(BuildContext context) {
    ResponsiveSize().deviceSize(context);
    return Container(
      decoration: decoration(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Add Bike"),
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
                    AddBikeForm(),
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
