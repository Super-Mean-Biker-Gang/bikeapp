import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'dart:async';
import 'package:bikeapp/widgets/map_search_bar.dart';

class MapView extends StatefulWidget {
  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  
  Completer<GoogleMapController> _controller = Completer();

  // Initial Position in Downtown Denver, CO
  static final CameraPosition _initialPosition = CameraPosition(
    target: LatLng(39.7527, -105.0017),
    zoom: 14.4746,
  );
  
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
              initialCameraPosition: _initialPosition,
              onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
              },
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
