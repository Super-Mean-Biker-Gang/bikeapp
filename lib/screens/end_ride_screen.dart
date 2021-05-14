import 'package:bikeapp/widgets/end_ride_form.dart';
import 'package:flutter/material.dart';

class EndRideScreen extends StatelessWidget {
  static const routeName = "end_ride_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add A Bike")),
      body: EndRideForm(),
    );
  }
}
