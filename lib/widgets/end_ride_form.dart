import 'package:bikeapp/models/bike.dart';
import 'package:bikeapp/services/database_service.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

class EndRideForm extends StatefulWidget {

  @override
  _EndRideFormState createState() => _EndRideFormState();
}

class _EndRideFormState extends State<EndRideForm> {
  DatabaseService databaseService = DatabaseService();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  TextEditingController ratingController = new TextEditingController();
  Bike currentBike;

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    getBike();
  }

  @override
  Widget build(BuildContext context) {
    getBike();    
    if(currentBike == null) {
      //return CircularProgressIndicator();
      return Column(
        children: [
          Text(user.email),
          ElevatedButton(onPressed: () {getBike();}, child: Text("Refresh Bike"))
          //Text(currentBike.bikeName),       
        ],
      );
    } else {
      return Column(
        children: [
          Text("In end ride form"), 
          Text(user.email),
          Text(currentBike.bikeName),       
        ],
      );
    }
  }

  Future<void> getBike() async {
    if(user != null) {
      currentBike = await databaseService.getUsersBike(user.email);  // Getting stuck here
    }
    setState(() {});
  }
}
