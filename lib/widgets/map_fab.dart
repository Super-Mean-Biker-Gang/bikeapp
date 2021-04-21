import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class MapFab extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () {
        print('Centers user on the map');
      },
      tooltip: 'Center map on Location',
      child: Icon(Icons.my_location),
    );
  }
}
