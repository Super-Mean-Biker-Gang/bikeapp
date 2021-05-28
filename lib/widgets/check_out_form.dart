import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bikeapp/models/bike.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:bikeapp/services/database_service.dart';
import 'package:bikeapp/styles/color_gradients.dart';
import 'package:bikeapp/styles/cool_button.dart';
import 'package:location/location.dart';
import 'dart:math';

class CheckoutForm extends StatefulWidget {
  static const routeName = 'check_out_form';

  @override
  _CheckoutFormState createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  double newRating;
  final user = AuthenticationService(FirebaseAuth.instance).getUser();
  LocationData locationData;
  double userLat;
  double userLon;
  double bikeLat;
  double bikeLon;
  static final R = 6372.8; // In kilometers

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {
      userLon = locationData.longitude;
      userLat = locationData.latitude;
    });
  }

  void retrieveBikeLocation(Bike checkoutBike) {
    setState(() {
      bikeLat = checkoutBike.latitude;
      bikeLon = checkoutBike.longitude;
    });
  }

  // Taken from source: https://github.com/shawnchan2014/haversine-dart/blob/master/Haversine.dart
  static double haversine(double lat1, lon1, lat2, lon2) {
    double dLat = _toRadians(lat2 - lat1);
    double dLon = _toRadians(lon2 - lon1);
    lat1 = _toRadians(lat1);
    lat2 = _toRadians(lat2);
    double a =
        pow(sin(dLat / 2), 2) + pow(sin(dLon / 2), 2) * cos(lat1) * cos(lat2);
    double c = 2 * asin(sqrt(a));
    return R * c * 3280.84; // Convert to feet
  }

  static double _toRadians(double degree) {
    return degree * pi / 180;
  }

  void checkDistance(Bike checkoutBike) {
    if (userLat == null ||
        userLon == null ||
        bikeLat == null ||
        bikeLon == null) {
      print('user latitude is: $userLat');
      print('user longitude is: $userLon');
      print('Bike latitude is: $bikeLat');
      print('Bike longitude is: $bikeLon');
      showLocationPermissionDialog();
    } else {
      var distanceInFeet = haversine(userLat, userLon, bikeLat, bikeLon);
      if (distanceInFeet > 60) {
        showDistanceDialog();
      } else {
        checkoutUpdate(checkoutBike);
        checkoutPopUp(context, checkoutBike);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final Bike checkoutBike = ModalRoute.of(context).settings.arguments;
    ResponsiveSize().deviceSize(context);
    return Container(
      decoration: decoration(),
      child: Scaffold(
        appBar: AppBar(title: Text('Check out')),
        backgroundColor: Colors.transparent,
        body: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.only(top: responsiveHeight(20.0)),
                  child: Text(
                    '${checkoutBike.bikeName}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: responsiveWidth(25.0),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                SizedBox(height: responsiveHeight(20.0)),
                checkoutBike.photoUrl == null
                    ? Icon(Icons.image_outlined, size: responsiveWidth(100.0))
                    : Image.network(checkoutBike.photoUrl.toString()),
                SizedBox(height: responsiveHeight(10.0)),
                Text(
                  'Bike Type: ${checkoutBike.tag}',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsiveWidth(15.0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: responsiveHeight(15.0)),
                Text(
                  'Average Bike Rating:',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: responsiveWidth(15.0),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: responsiveHeight(10.0)),
                displayRating(checkoutBike),
                SizedBox(height: responsiveHeight(15.0)),
                checkoutButton(context, checkoutBike),
                SizedBox(height: responsiveHeight(10.0)),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget displayRating(Bike checkoutBike) {
    return RatingBar.builder(
      initialRating:
          checkoutBike.averageRating == null ? 0.0 : checkoutBike.averageRating,
      minRating: 1,
      direction: Axis.horizontal,
      allowHalfRating: true,
      itemCount: 5,
      itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
      itemBuilder: (context, _) => Icon(
        Icons.star,
        color: Colors.yellowAccent,
      ),
      onRatingUpdate: (rating) {
        print(rating);
      },
    );
  }

  Widget checkoutButton(BuildContext context, Bike checkoutBike) {
    return Container(
      padding: EdgeInsets.symmetric(
          vertical: responsiveHeight(10.0), horizontal: responsiveWidth(20.0)),
      child: CoolButton(
        title: 'Checkout',
        textColor: Colors.white,
        filledColor: Colors.cyan[500],
        onPressed: () {
          retrieveBikeLocation(checkoutBike);
          checkDistance(checkoutBike);
        },
      ),
    );
  }

  void checkoutPopUp(BuildContext context, Bike checkoutBike) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            'Here is the combination to the lock ',
            style: TextStyle(color: Colors.white),
          ),
          content: Text(
            checkoutBike.lockCombo.toString(),
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Theme.of(context).primaryColor,
          actions: [
            TextButton(
                child: Text(
                  'OK',
                  style: TextStyle(color: Colors.white),
                ),
                onPressed: () {
                  Navigator.of(context).pushNamed(MapScreen.routeName);
                },
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.all(Colors.green),
                )),
          ],
        );
      },
    );
  }

  void checkoutUpdate(Bike checkoutBike) async {
    String id = await DatabaseService().getBikeId(checkoutBike);
    if (id != null) {
      FirebaseFirestore.instance.collection('bikes').doc(id).update({
        "isBeingUsed": true,
        "riderEmail": user.email,
      });
    }
  }

  showDistanceDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Too Far Away",
            textAlign: TextAlign.center,
          ),
          content: Text(
              'Please stand within 60 feet of the bike you are checking out to use this feature. \n \nIf you believe you are within 60 feet of the bike already, try refreshing the page by navigating back to the map and attempting to check out the bike again.',
              textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }

  showLocationPermissionDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Location Permissions Denied",
            textAlign: TextAlign.center,
          ),
          content: Text(
              'Location permission are denied. \n \nLocation permissions must be enabled to use this feature.',
              textAlign: TextAlign.center),
          actions: <Widget>[
            TextButton(
              child: Text("Okay"),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ],
        );
      },
    );
  }
}
