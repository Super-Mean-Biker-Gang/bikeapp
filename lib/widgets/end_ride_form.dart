import 'package:bikeapp/models/bike.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:bikeapp/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:location/location.dart';

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
  Bike currentBike;
  double newRating;

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

  @override
  Widget build(BuildContext context) {
    if (currentBike == null) {
      return CircularProgressIndicator();
    } else {
      return SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              displayImage(),
              Text(currentBike.bikeName),
              SizedBox(height: 30),
              Text("Rate your ride"),
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
                        color: Colors.purple,
                      ),
                  onRatingUpdate: (rating) {
                    if (rating != null) {
                      newRating = rating;
                    }
                  }),
              SizedBox(height: 30),
              ElevatedButton(
                child: Text("End Ride"),
                onPressed: () {
                  endRide(newRating);
                },
              ),
            ],
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
    databaseService.endRide(newRating, currentBike);
    // go back to maps screen
    Navigator.of(context).pushNamed(MapScreen.routeName);
    // may want to eventually base redirect on global state of if user is using bike
  }

  Widget displayImage() {
    if (currentBike.photoUrl != null) {
      return Image.network(currentBike.photoUrl);
    } else {
      return CircularProgressIndicator();
    }
  }
}
