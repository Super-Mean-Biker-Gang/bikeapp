import 'package:flutter/material.dart';
import 'package:bikeapp/widgets/map_end_drawer.dart';
import 'package:bikeapp/widgets/map_drawer.dart';
import 'package:bikeapp/widgets/map_view.dart';
import 'package:geolocator/geolocator.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapScreen extends StatefulWidget {
  static const routeName = 'map_screen';
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _userPosition;

  void initState() {
    super.initState();
    determinePosition();
  }

  Future<void> goToPosition(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  void setUserPosition(Position position) {
    if (position.latitude != null && position.longitude != null) {
      _userPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
    }
  }

  determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if (!serviceEnabled) {
      print('Location services are disabled.');
    }

    // Check permissions
    permission = await Geolocator.checkPermission();

    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();

      if (permission == LocationPermission.denied) {
        print('Location permissions are denied');
      }
    } else if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
    }
    
    // If permission granted, set user location and move map to it
    if ((permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) &&
        serviceEnabled) {
      Position position = await Geolocator.getCurrentPosition();
      setUserPosition(position);
      goToPosition(_userPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MapView(controller: _controller),
      endDrawer: MapEndDrawer(),
      drawer: MapDrawer(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          determinePosition();
        },
        tooltip: 'Center map on Location',
        child: Icon(Icons.my_location),
      ),
    );
  }
}
