import 'package:flutter/material.dart';
import 'package:bikeapp/widgets/map_end_drawer.dart';
import 'package:bikeapp/widgets/map_drawer.dart';
import 'package:bikeapp/widgets/map_view.dart';
import 'package:location/location.dart';
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

  void setUserPosition(LocationData location) {
    if (location.latitude != null && location.longitude != null) {
      _userPosition = CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 14.4746,
      );
    }
  }

  determinePosition() async {
    Location location = Location();

    bool _serviceEnabled;
    PermissionStatus _permissionGranted;
    LocationData _locationData;

    // Check if service is enabled
    _serviceEnabled = await location.serviceEnabled();

    if (!_serviceEnabled) {
      _serviceEnabled = await location.requestService();
      if (!_serviceEnabled) {
        return;
      }
    }

    // Check and request permissions if needed
    _permissionGranted = await location.hasPermission();

    if (_permissionGranted == PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != PermissionStatus.granted) {
        return;
      }
    }

    // Get location and pass it to set user location
    _locationData = await location.getLocation();
    setUserPosition(_locationData);
    goToPosition(_userPosition);
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
          backgroundColor: Colors.blue),
    );
  }
}
