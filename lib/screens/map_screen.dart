import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:bikeapp/widgets/map_end_drawer.dart';
import 'package:bikeapp/widgets/map_drawer.dart';
import 'dart:async';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:geocoder/geocoder.dart';
import 'package:location/location.dart' as Location;
import 'package:dio/dio.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geocoding/geocoding.dart' as geocoding;

final apiKey = FlutterConfig.get('API_KEY');

/*
Sources: 
  https://medium.com/flutter-community/google-maps-in-flutter-i-feeb72354392
  https://medium.com/flutter-community/google-maps-in-flutter-ii-260f43db5924
  https://medium.com/flutter-community/ad-custom-marker-images-for-your-google-maps-in-flutter-68ce627107fc
*/

class MapScreen extends StatefulWidget {
  static const routeName = 'map_screen';
  @override
  MapScreenState createState() => MapScreenState();
}

class MapScreenState extends State<MapScreen> {
  Completer<GoogleMapController> _controller = Completer();
  TextEditingController searchController = TextEditingController();

  // Create a controller and state key to open or close the bottomsheet
  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  PersistentBottomSheetController sheetController;

  // Keeps track of the location permission state
  var isLocationGranted = false;
  // Create a timer to keep an http call open for only a short call
  Timer timer;
  Widget _mapBody;
  double _latitude;
  double _longitude;
  List<geocoding.Placemark> placemarks;
  bool mapToggle = false;
  Map<MarkerId, Marker> mapMarkers = <MarkerId, Marker>{};
  BitmapDescriptor bikeIcon;

  List<String> suggestions = [];

  static CameraPosition _userPosition;
  static CameraPosition _searchedPosition;

  @override
  void initState() {
    super.initState();
    determinePosition();
    searchController.addListener(onSearchChanged);
    fetchDataFromDB();
    customBikeIcon();
  }

  // Dispose if the search controller when it is no longer needed.
  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
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
    getLoc(_locationData);
    setUserPosition(_locationData);
    goToPosition(_userPosition);
  }

  // Set the state for the map body, user location and toggle
  void getLoc(Location.LocationData location) async {
    setState(() {
      isLocationGranted = true;
      _latitude = location.latitude;
      _longitude = location.longitude;
      _mapBody = googleMap();
      mapToggle = true;
    });
    placemarkInfo(_latitude, _longitude);
  }

  // Update the map with the placemarkers
  void placemarkInfo(double latitude, double longitude) async {
    placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
    setState(() {
      _mapBody = googleMap();
    });
  }

  // Get each item from the database and add it to the markers list
  void fetchDataFromDB() async {
    FirebaseFirestore.instance.collection('bikes').get().then((doc) {
      if (doc.docs.isNotEmpty) {
        for (int i = 0; i < doc.docs.length; ++i) {
          createMarker(doc.docs[i].data(), doc.docs[i].id);
        }
      }
    });
  }

  // Create a marker for each item and add it to the list
  void createMarker(field, docID) {
    var value = docID;
    final MarkerId markerId = MarkerId(value);
    final Marker marker = Marker(
      markerId: markerId,
      position: LatLng(field['latitude'], field['longitude']),
      icon: bikeIcon,
      infoWindow:
          InfoWindow(title: field['bikeName'], snippet: field['rating']),
    );
    setState(() {
      mapMarkers[markerId] = marker;
      print(markerId);
    });
  }

  // Set the value of the bike icon from assets
  void customBikeIcon() async {
    bikeIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.5), 'assets/purple_bike.png');
  }

  // Open the bottom sheet and fill it with autocomplete suggestions
  openAutocompleteBottomSheet(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    sheetController = scaffoldKey.currentState.showBottomSheet<Null>(
      (BuildContext context) {
        return Wrap(children: [
          Padding(
            padding: EdgeInsets.only(top: 5),
            child: Align(
              alignment: Alignment.topCenter,
              child: Text(
                'suggestions',
                style: TextStyle(
                  fontSize: queryData.textScaleFactor * 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: suggestions.length,
            itemBuilder: (BuildContext context, int index) {
              return ListTile(
                title: Text(suggestions[index]),
                onTap: () {
                  searchController.text = suggestions[index];
                  geocodeAddress(searchController.text);
                  searchController.clear();
                  closeBottomSheet();
                  FocusScope.of(context).unfocus();
                },
              );
            },
          ),
        ]);
      },
    );
  }

  // Close the bottom sheet
  void closeBottomSheet() {
    if (sheetController != null) {
      sheetController.close();
      sheetController = null;
    }
  }

  // Start a timer for a http call for autocomplete when search text changes
  onSearchChanged() {
    if (timer?.isActive ?? false) timer.cancel();
    timer = Timer(const Duration(milliseconds: 500), () {
      getLocationResults(searchController.text);
    });
  }

  // Send an http call to google places api
  // Parse the results and pass them to the suggestions list
  getLocationResults(String searchInput) async {
    List<String> results = [];
    List<String> temp = [];
    String baseURL =
        'https://maps.googleapis.com/maps/api/place/autocomplete/json';

    String request = '$baseURL?input=$searchInput&key=$apiKey';

    Response response = await Dio().get(request);

    var predictions = response.data['predictions'];

    if (predictions.length <= 4) {
      for (var i = 0; i < predictions.length; i++) {
        String name = predictions[i]['description'];
        temp.add(name);
      }
    } else {
      for (var i = 0; i < predictions.length; i++) {
        String name = predictions[i]['description'];
        results.add(name);
      }
      temp = results.take(4).toList();
    }
    setState(() {
      suggestions = temp;
      if (suggestions.isNotEmpty) {
        openAutocompleteBottomSheet(context);
      }
    });
  }

  ////////////////// Widgets below this point ///////////////////////

  // Build the actual pageview
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
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
          border: Border.all(color: Colors.cyanAccent, width: 2),
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
                if (suggestions.isNotEmpty) {
                  openAutocompleteBottomSheet(context);
                }
              },
              onSubmitted: (context) {
                geocodeAddress(searchController.text);
                searchController.clear();
                closeBottomSheet();
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
            Container(
              child: mapToggle
                  ? _mapBody
                  : SpinKitChasingDots(
                      itemBuilder: (BuildContext context, int index) {
                        return DecoratedBox(
                          decoration: BoxDecoration(
                            color: index.isEven
                                ? Colors.purple[600]
                                : Colors.blueAccent,
                          ),
                        );
                      },
                    ),
            ),
            Padding(
                padding: EdgeInsets.only(top: queryData.size.height * .10),
                child: searchBar()),
          ],
        ),
      ),
    );
  }

  // Widget that displays the google map
  Widget googleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(mapMarkers.values),
      initialCameraPosition: CameraPosition(
        target: LatLng(_latitude, _longitude),
        zoom: 12,
      ),
      onMapCreated: (GoogleMapController controller) {
        _controller.complete(controller);
      },
      myLocationEnabled: isLocationGranted,
      compassEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }
}
