import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:bikeapp/widgets/map_search_bar.dart';
import 'package:geolocator/geolocator.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();

  static CameraPosition _userPosition;

  @override
  void initState() {
    super.initState();
    _determinePosition();
  }

  // Initial Position in Downtown Denver, CO
  static final CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(39.7527, -105.0017),
    zoom: 14.4746,
  );

  // Send the camera to a new camera position
  Future<void> _goToPosition(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  // Set the initial value of the user's location after retrieving it
  void setUserPosition(Position position) {
    if (position.latitude != null && position.longitude != null) {
      _userPosition = CameraPosition(
        target: LatLng(position.latitude, position.longitude),
        zoom: 14.4746,
      );
    }
  }

  // Request permission and determine the current position of the device
  void _determinePosition() async {
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
    }

    if (permission == LocationPermission.deniedForever) {
      print(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // If permission granted, set user location and move map to it
    if ((permission == LocationPermission.always ||
            permission == LocationPermission.whileInUse) &&
        serviceEnabled) {
      Position position = await Geolocator.getCurrentPosition();
      setUserPosition(position);
      _goToPosition(_userPosition);
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return SingleChildScrollView(
      child: SizedBox(
        height: queryData.size.height * 1,
        width: queryData.size.width * 1,
        child: Stack(
          children: [
            GoogleMap(
              mapType: MapType.hybrid,
              initialCameraPosition: _defaultPosition,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              },
              myLocationEnabled: true,
              compassEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
            Padding(
                padding: EdgeInsets.only(top: queryData.size.height * .10),
                child: MapSearchBar()),
          ],
        ),
      ),
    );
  }
}
