import 'package:flutter/material.dart';

class LocationServicesDeniedPopup extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text("Location Services - Denied"),
      content: Text('Please allow location services to use this feature'),
      actions: <Widget>[
        TextButton(
          child: Text("Go back"),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ],
    );
  }
}
