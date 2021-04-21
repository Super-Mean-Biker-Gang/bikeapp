import 'package:flutter/material.dart';
import 'package:bikeapp/widgets/map_end_drawer.dart';
import 'package:bikeapp/widgets/map_drawer.dart';
import 'package:bikeapp/widgets/map_fab.dart';
import 'package:bikeapp/widgets/map_view.dart';

class MapScreen extends StatelessWidget {
  static const routeName = 'map_screen';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: MapView(),
        endDrawer: MapEndDrawer(),
        drawer: MapDrawer(),
        floatingActionButton: MapFab());
  }
}
