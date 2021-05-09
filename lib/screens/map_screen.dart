import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/widgets/map_end_drawer.dart';
import 'package:bikeapp/widgets/map_drawer.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';
// import 'package:flutter_google_places/flutter_google_places.dart';
// import 'package:google_maps_webservice/places.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart' as Location;

final apiKey = FlutterConfig.get('API_KEY');
// GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: apiKey);

class MapScreen extends StatefulWidget {
  static const routeName = 'map_screen';
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController searchController = TextEditingController();

  // Keeps track of the location permission state
  var isLocationGranted = false;

  static CameraPosition _userPosition;
  static CameraPosition _searchedPosition;

  // Initial Position in Downtown Denver, CO
  final CameraPosition _defaultPosition = CameraPosition(
    target: LatLng(39.7527, -105.0017),
    zoom: 14.4746,
  );

  void initState() {
    super.initState();
    determinePosition();
  }

  // Move the camera to a given position
  Future<void> goToPosition(CameraPosition position) async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(position));
  }

  // Set the user's location
  void setUserPosition(Location.LocationData location) {
    if (location.latitude != null && location.longitude != null) {
      _userPosition = CameraPosition(
        target: LatLng(location.latitude, location.longitude),
        zoom: 14.4746,
      );
    }
  }

  // Set the searched location from the search bar
  void setSearchedPosition(double latitude, double longitude) {
    if (latitude != null && longitude != null) {
      _searchedPosition = CameraPosition(
        target: LatLng(latitude, longitude),
        zoom: 14.4746,
      );
    }
  }

  // Geocode an address queried from an entered string and move to
  // That position on the map
  geocodeAddress(String query) async {
    try {
      var addresses = await Geocoder.local.findAddressesFromQuery(query);
      var first = addresses.first;
      var latitude = first.coordinates.latitude;
      var longitude = first.coordinates.longitude;
      setSearchedPosition(latitude, longitude);
      goToPosition(_searchedPosition);
    } catch (err) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Align(
                alignment: Alignment.topCenter,
                child: Text("No Address found")),
            content: Text(
                "We looked for the address you entered but didn't find it. Please check the address and try again.",
                textAlign: TextAlign.center),
            actions: <Widget>[
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.of(context).pop();
                  searchController.clear();
                },
              ),
            ],
          );
        },
      );
    }
  }

  // Determine if ocation services are enabled and permission is granted
  // Set the users position and move to that position
  determinePosition() async {
    Location.Location location = Location.Location();

    bool _serviceEnabled;
    Location.PermissionStatus _permissionGranted;
    Location.LocationData _locationData;

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

    if (_permissionGranted == Location.PermissionStatus.denied) {
      _permissionGranted = await location.requestPermission();
      if (_permissionGranted != Location.PermissionStatus.granted) {
        return;
      }
    }

    // Get location and pass it to set user location
    _locationData = await location.getLocation();

    // Change the state to trigger a map rebuild with the users location icon
    setState(() {
      isLocationGranted = true;
    });
    setUserPosition(_locationData);
    goToPosition(_userPosition);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: mapView(context),
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

  // Creates the search bar for the map view
  Widget searchBar() {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Builder(
      builder: (context) => Container(
        padding: EdgeInsets.only(right: 10, bottom: 5),
        margin: EdgeInsets.only(
            left: queryData.size.width * .05,
            right: queryData.size.width * .05),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(
              color: Colors.cyanAccent, width: responsiveHeight(1.0)),
          borderRadius: BorderRadius.all(Radius.circular(50)),
        ),
        child: Stack(
          children: [
            TextField(
              controller: searchController,
              style: TextStyle(fontSize: queryData.textScaleFactor * 30),
              textInputAction: TextInputAction.search,
              cursorColor: Colors.blue,
              cursorHeight: queryData.textScaleFactor * 40,
              decoration: InputDecoration(
                hintStyle: TextStyle(fontSize: queryData.textScaleFactor * 25),
                hintText: 'Search a location',
                border: InputBorder.none,
                contentPadding: EdgeInsets.only(left: 50, right: 85),
              ),
              onTap: () {
                print('Creating suggestions bar');
              },
              onSubmitted: (context) {
                geocodeAddress(searchController.text);
                searchController.clear();
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  onPressed: () {},
                  icon: Icon(Icons.location_pin,
                      color: Colors.green,
                      size: queryData.textScaleFactor * 40),
                ),
                Row(
                  children: [
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).openDrawer();
                      },
                      tooltip: 'Filter bikes',
                      icon: Icon(Icons.filter_alt,
                          color: Colors.purpleAccent,
                          size: queryData.textScaleFactor * 40),
                    ),
                    IconButton(
                      onPressed: () {
                        Scaffold.of(context).openEndDrawer();
                      },
                      tooltip: 'Account Access',
                      icon: Icon(Icons.account_circle_outlined,
                          color: Colors.blue,
                          size: queryData.textScaleFactor * 40),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // Creates the body for the map screen
  Widget mapView(BuildContext context) {
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
              myLocationEnabled: isLocationGranted,
              compassEnabled: true,
              myLocationButtonEnabled: false,
              zoomControlsEnabled: false,
            ),
            Padding(
                padding: EdgeInsets.only(top: queryData.size.height * .10),
                child: searchBar()),
          ],
        ),
      ),
    );
  }
}
