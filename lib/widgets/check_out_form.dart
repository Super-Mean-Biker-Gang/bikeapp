import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:bikeapp/models/bike.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:bikeapp/services/authentication_service.dart';
import 'package:bikeapp/styles/color_gradients.dart';
import 'package:bikeapp/styles/cool_button.dart';

class CheckoutForm extends StatefulWidget {
  static const routeName = 'check_out_form';

  @override
  _CheckoutFormState createState() => _CheckoutFormState();
}

class _CheckoutFormState extends State<CheckoutForm> {
  double newRating;
  final user = AuthenticationService(FirebaseAuth.instance).getUser();

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
          child: SizedBox(
            child: Container(
              padding: EdgeInsets.symmetric(
                vertical: responsiveHeight(35.0),
              ),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Text(
                      checkoutBike.tags[0].toString(),
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveWidth(18.0),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: responsiveHeight(5.0)),
                    Text(
                      'Donor Email: ${checkoutBike.donatedUserEmail.toString()}',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: responsiveWidth(12.0),
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(height: responsiveHeight(20.0)),
                    // add type of bike? or tag name?
                    checkoutBike.photoUrl == null
                        ? Icon(Icons.image_outlined,
                            size: responsiveWidth(100.0))
                        : Image.network(checkoutBike.photoUrl.toString()),
                    SizedBox(height: responsiveHeight(20.0)),
                    // need to work on this rating star
                    displayRating(checkoutBike),
                    SizedBox(height: responsiveHeight(20.0)),
                    checkoutButton(context, checkoutBike),
                  ],
                ),
              ),
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
        filledColor: Colors.green,
        onPressed: () {
          checkoutUpdate(checkoutBike);
          checkoutPopUp(context, checkoutBike);
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
    String id = await getBikeId(checkoutBike);
    if (id != null) {
      FirebaseFirestore.instance.collection('bikes').doc(id).update({
        "isBeingUsed": true,
        "riderEmail": user.email,
      });
    }
  }

  Future<String> getBikeId(Bike checkoutBike) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('bikes')
        .get()
        .then((doc) => {
              doc.docs.firstWhere(
                  (element) => element['bikeName'] == checkoutBike.bikeName,
                  orElse: null)
            });
    if (snapshot == null) {
      return null;
    }
    return snapshot.first.id;
  }
}
