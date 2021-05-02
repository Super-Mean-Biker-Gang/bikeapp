import 'package:flutter/material.dart';

class AccidentWaverScreen extends StatelessWidget {
  static const routeName = "accident_waver_screen";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Accident Waiver")),
      body: Container(
        child: Text("Hello from the waiver form"),
      ),
    );
  }
}
