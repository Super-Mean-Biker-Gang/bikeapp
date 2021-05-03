import 'package:bikeapp/widgets/add_bike_form.dart';
import 'package:flutter/material.dart';

class AddBikeScreen extends StatelessWidget {
  static const routeName = "add_bike_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Add A Bike")),
      body: AddBikeForm(),
    );
  }
}
