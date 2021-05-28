import 'package:bikeapp/models/bike.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:bikeapp/services/database_service.dart';
import 'package:bikeapp/widgets/location_services_denied_popup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart';
import 'package:bikeapp/models/responsive_size.dart';

class EndRideForm extends StatefulWidget {
  @override
  _EndRideFormState createState() => _EndRideFormState();
}

class _EndRideFormState extends State<EndRideForm> {
  DatabaseService databaseService = DatabaseService();
  LocationData locationData;
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  TextEditingController ratingController = new TextEditingController();
  TextEditingController noteController = new TextEditingController();
  Bike currentBike;
  double newRating;
  String note;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    getBike();
    retrieveLocation();
    newRating = 3.0;
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {});
  }

  //********************************************************************************** */
  //                                  MAIN WIDGET                                      */
  //********************************************************************************** */
  @override
  Widget build(BuildContext context) {
    if (locationData == null) {
      return LocationServicesDeniedPopup();
    } else if (currentBike == null) {
      return CircularProgressIndicator();
    } else {
      return Container(
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                displayImage(),
                Text(currentBike.bikeName,
                    style: TextStyle(color: Colors.white)),
                SizedBox(height: 30),
                Text("Rate your ride", style: TextStyle(color: Colors.white)),
                SizedBox(height: 30),
                RatingBar.builder(
                  initialRating: 3,
                  minRating: 0.5,
                  direction: Axis.horizontal,
                  allowHalfRating: true,
                  itemCount: 5,
                  itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                  itemBuilder: (context, _) => Icon(
                    Icons.star,
                    color: Colors.cyan,
                  ),
                  onRatingUpdate: (rating) {
                    if (rating != null) {
                      newRating = rating;
                    }
                  },
                ),
                SizedBox(height: 40),
                Text("Comments about bike",
                    style: TextStyle(color: Colors.white)),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 60.0),
                  child: TextField(
                    controller: noteController,
                    keyboardType: TextInputType.multiline,
                    minLines: 1, //Normal textInputField will be displayed
                    maxLines: 5, // when user presses enter it will adapt to it
                  ),
                ),
                SizedBox(height: 30),
                endRideButton(context),
              ],
            ),
          ),
        ),
      );
    }
  }

  void getBike() async {
    if (user != null) {
      currentBike = await databaseService.getUsersBike(user.email);
    }
    setState(() {});
  }

  void endRide(double newRating) async {
    note = noteController.text;
    databaseService.endRide(newRating, currentBike, locationData, note);
    Navigator.of(context).pushNamed(MapScreen.routeName);
  }

  Widget displayImage() {
    if (currentBike.photoUrl != null) {
      return Image.network(currentBike.photoUrl);
    } else {
      return CircularProgressIndicator();
    }
  }

  Widget endRideButton(BuildContext context) {
    return SizedBox(
      width: responsiveWidth(160.0),
      height: responsiveWidth(26.0),
      child: ElevatedButton(
        child: Text(
          "End Ride",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: responsiveWidth(12.0),
          ),
        ),
        onPressed: () {
          endRide(newRating);
        },
        style: ButtonStyle(
          backgroundColor: MaterialStateProperty.all(Colors.cyan),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(25.0),
            side: BorderSide(
              color: Colors.cyanAccent,
              width: responsiveWidth(1.0),
            ),
          )),
        ),
      ),
    );
  }
}
