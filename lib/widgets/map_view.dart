// import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:geocoding/geocoding.dart' as geocoding;
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
// import 'package:bikeapp/widgets/map_search_bar.dart';

/*
Sources: 
  https://medium.com/flutter-community/google-maps-in-flutter-i-feeb72354392
  https://medium.com/flutter-community/google-maps-in-flutter-ii-260f43db5924
  https://medium.com/flutter-community/ad-custom-marker-images-for-your-google-maps-in-flutter-68ce627107fc
*/

class MapView extends StatefulWidget {
  //final Completer<GoogleMapController> _controller;
  //// final CameraPosition userPosition;
  //MapView({Completer<GoogleMapController> controller})
  //    : _controller = controller;

  static const routeName = 'map_view';

  @override
  _MapViewState createState() => _MapViewState();
}

class _MapViewState extends State<MapView> {
  // GoogleMapController _controller;
  Location location = Location();
  LocationData locationData;
  Widget _mapBody;
  double _latitude;
  double _longitude;
  List<geocoding.Placemark> placemarks;
  bool mapToggle = false;
  Map<MarkerId, Marker> mapMarkers = <MarkerId, Marker>{};
  BitmapDescriptor bikeIcon;

  @override
  void initState() {
    getLoc();
    fetchDataFromDB();
    customBikeIcon();
    super.initState();
  }

  void getLoc() async {
    LocationData currentLocation = await location.getLocation();
    setState(() {
      locationData = currentLocation;
      _latitude = locationData.latitude;
      _longitude = locationData.longitude;
      _mapBody = googleMap();
      mapToggle = true;
    });
    placemarkInfo(_latitude, _longitude);
  }

  void placemarkInfo(double latitude, double longitude) async {
    placemarks = await geocoding.placemarkFromCoordinates(latitude, longitude);
    setState(() {
      _mapBody = googleMap();
    });
  }

  void fetchDataFromDB() async {
    FirebaseFirestore.instance.collection('bikes').get().then((doc) {
      if (doc.docs.isNotEmpty) {
        for (int i = 0; i < doc.docs.length; ++i) {
          createMarker(doc.docs[i].data(), doc.docs[i].id);
        }
      }
    });
  }

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

  void customBikeIcon() async {
    bikeIcon = await BitmapDescriptor.fromAssetImage(
        ImageConfiguration(devicePixelRatio: 3.5), 'assets/purple_bike.png');
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
                      )),

            //Padding(
            //    padding: EdgeInsets.only(top: queryData.size.height * .10),
            //    child: MapSearchBar()),
          ],
        ),
      ),
    );
  }

  Widget googleMap() {
    return GoogleMap(
      mapType: MapType.normal,
      markers: Set<Marker>.of(mapMarkers.values),
      initialCameraPosition: CameraPosition(
        target: LatLng(locationData.latitude, locationData.longitude),
        //zoom: 14.4746,
        zoom: 12,
      ),
      onMapCreated: (GoogleMapController controller) {
        //widget._controller.complete(controller);
        // _controller = controller;
      },
      myLocationEnabled: true,
      compassEnabled: true,
      myLocationButtonEnabled: false,
      zoomControlsEnabled: false,
    );
  }
}
