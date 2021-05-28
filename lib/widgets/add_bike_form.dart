import 'dart:io';
import 'package:bikeapp/widgets/location_services_denied_popup.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bikeapp/screens/add_bike_screen.dart';
import 'package:bikeapp/screens/privacy_policy_screen.dart';
import 'package:bikeapp/screens/terms_of_service_screen.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';
import 'package:bikeapp/styles/custom_input_decoration.dart';
import 'package:bikeapp/models/responsive_size.dart';
import 'package:flutter/gestures.dart';

const WAVER_PATH = 'assets/text_files/donateBikeWaver.txt';

class AddBikeForm extends StatefulWidget {
  @override
  _AddBikeFormState createState() => _AddBikeFormState();
}

enum BikeTag { ROAD, MOUNTAIN, HYBRID }

class _AddBikeFormState extends State<AddBikeForm> {
  File image;
  LocationData locationData;
  final picker = ImagePicker();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  TextEditingController lockControllerOne = new TextEditingController();
  TextEditingController lockControllerTwo = new TextEditingController();
  TextEditingController lockControllerThree = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  String imageURL;
  String _waverMessage;
  String name;
  BikeTag tag;
  final _formKey = GlobalKey<FormState>();

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      image = File(pickedFile.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage
          .ref()
          .child("image " + DateTime.now().toString()); // need better name
      UploadTask uploadTask = ref.putFile(image);
      uploadTask.then((res) async {
        imageURL = await res.ref.getDownloadURL();
      });
      setState(() {});
    }
  }

  void takePhoto() async {
    final pickedFile = await picker.getImage(source: ImageSource.camera);

    if (pickedFile != null) {
      image = File(pickedFile.path);
      FirebaseStorage storage = FirebaseStorage.instance;
      Reference ref = storage.ref().child("image " + DateTime.now().toString());
      UploadTask uploadTask = ref.putFile(image);
      uploadTask.then((res) async {
        imageURL = await res.ref.getDownloadURL();
      });
      setState(() {});
    }
  }

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    user = auth.currentUser;
    retrieveLocation();
    loadText();
    tag = BikeTag.ROAD;
  }

  //********************************************************************************** */
  /*                                  MAIN WIDGET                                      */
  //********************************************************************************** */
  @override
  Widget build(BuildContext context) {
    if (locationData == null) {
      return LocationServicesDeniedPopup();
    } else {
      return Container(
        child: SingleChildScrollView(
          child: Center(
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: responsiveHeight(20.0)),
                  showImage(context),
                  SizedBox(height: responsiveHeight(20.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      selectPhotoButton(context),
                      SizedBox(width: 10),
                      useCamerButton(
                        context,
                      )
                    ],
                  ),
                  SizedBox(height: responsiveHeight(20.0)),
                  bikeNameField(),
                  SizedBox(height: responsiveHeight(20.0)),
                  Text("Lock Combination",
                      style: TextStyle(color: Colors.white)),
                  lockInput(context),
                  SizedBox(height: responsiveHeight(20.0)),
                  bikeTagCheckBoxes(context),
                  SizedBox(height: responsiveHeight(20.0)),
                  addBikeButton(context),
                  SizedBox(height: responsiveHeight(20.0)),
                ],
              ),
            ),
          ),
        ),
      );
    }
  }

  Widget bikeNameField() {
    return TextFormField(
      controller: nameController,
      keyboardType: TextInputType.text,
      style: TextStyle(color: Colors.white),
      decoration: customInputDecoration(
          hint: 'Bike name', icon: Icon(Icons.pedal_bike)),
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter a bike name';
        }
        return null;
      },
      onSaved: (value) => name = value.trim(),
    );
  }

  Widget lockInput(BuildContext context) {
    final node = FocusScope.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'All three locks numbers must be entered';
                } else {
                  return null;
                }
              },
              style: TextStyle(color: Colors.white),
              controller: lockControllerOne,
              decoration: InputDecoration(contentPadding: EdgeInsets.all(10)),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (text) {
                if (lockControllerOne.text.length > 1) {
                  node.nextFocus();
                }
              },
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'All three locks numbers must be entered';
                } else {
                  return null;
                }
              },
              style: TextStyle(color: Colors.white),
              controller: lockControllerTwo,
              decoration: InputDecoration(contentPadding: EdgeInsets.all(10)),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              textInputAction: TextInputAction.next,
              onChanged: (text) {
                if (lockControllerTwo.text.length > 1) {
                  node.nextFocus();
                }
              },
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'All three locks numbers must be entered';
                } else {
                  return null;
                }
              },
              style: TextStyle(color: Colors.white),
              controller: lockControllerThree,
              decoration: InputDecoration(contentPadding: EdgeInsets.all(10)),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onChanged: (text) {
                if (lockControllerThree.text.length > 1) {
                  node.nextFocus();
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget showImage(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    if (image != null) {
      return Image.file(image);
    } else {
      // Placeholder for when image has not been selected
      return Padding(
        padding: EdgeInsets.only(right: 0, left: 25),
        child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Icon(Icons.image_search, size: queryData.size.width * .80)
        ]),
      );
    }
  }

  Widget selectPhotoButton(BuildContext context) {
    return SizedBox(
      height: responsiveWidth(26.0),
      child: ElevatedButton(
        child: Text(
          "Select Photo",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: responsiveWidth(12.0),
          ),
        ),
        onPressed: () {
          getImage();
        },
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all(Colors.cyan),
            shape: MaterialStateProperty.all(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25.0),
                side: BorderSide(
                  color: Colors.cyanAccent,
                  width: responsiveWidth(1.0),
                ),
              ),
            )),
      ),
    );
  }

  Widget useCamerButton(BuildContext context) {
    return SizedBox(
      height: responsiveWidth(26.0),
      child: ElevatedButton(
        child: Text(
          "Use Camera",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: responsiveWidth(12.0),
          ),
        ),
        onPressed: () {
          takePhoto();
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

  Widget addBikeButton(BuildContext context) {
    return SizedBox(
      width: responsiveWidth(160.0),
      height: responsiveWidth(26.0),
      child: ElevatedButton(
        child: Text(
          "Add Bike",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: responsiveWidth(12.0),
          ),
        ),
        onPressed: () {
          // Make sure all fields are valid before executing add bike
          if (_formKey.currentState.validate()) {
            submitAddBike();
          }
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

  Widget bikeTagCheckBoxes(BuildContext context) {
    return Column(
      children: <Widget>[
        RadioListTile<BikeTag>(
          title: const Text('Road Bike', style: TextStyle(color: Colors.white)),
          value: BikeTag.ROAD,
          groupValue: tag,
          onChanged: (value) {
            setState(() {
              tag = value;
            });
          },
        ),
        RadioListTile<BikeTag>(
          title: const Text('Mountain Bike',
              style: TextStyle(color: Colors.white)),
          value: BikeTag.MOUNTAIN,
          groupValue: tag,
          onChanged: (value) {
            setState(() {
              tag = value;
            });
          },
        ),
        RadioListTile<BikeTag>(
          title:
              const Text('Hybrid Bike', style: TextStyle(color: Colors.white)),
          value: BikeTag.HYBRID,
          groupValue: tag,
          onChanged: (value) {
            setState(() {
              tag = value;
            });
          },
        ),
      ],
    );
  }

  void submitAddBike() {
    if (imageURL == null) {
      showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text("No Photo Selected"),
              content: Text(
                  'Please select a photo from gallery, or use camera to take one'),
              actions: <Widget>[
                TextButton(
                  child: Text("Go back"),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            );
          });
    } else {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Release of Interest", textAlign: TextAlign.center),
            content: Text.rich(
              TextSpan(
                text: _waverMessage,
                children: [
                  TextSpan(text: '\n                    \n'),
                  TextSpan(text: 'By continuing, you agree to our '),
                  TextSpan(
                    text: 'Terms of Service',
                    style: TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(
                            context, TermsOfServiceScreen.routeName);
                      },
                  ),
                  TextSpan(text: ' and '),
                  TextSpan(
                    text: 'Privacy Policy',
                    style: TextStyle(decoration: TextDecoration.underline),
                    recognizer: TapGestureRecognizer()
                      ..onTap = () {
                        Navigator.pushNamed(
                            context, PrivacyPolicyScreen.routeName);
                      },
                  ),
                ],
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text("I accept"),
                onPressed: () {
                  retrieveLocation();
                  FirebaseFirestore.instance.collection('bikes').add({
                    'bikeName': nameController.text != ""
                        ? nameController.text.trim()
                        : "Unnamed",
                    'latitude':
                        locationData != null ? locationData.latitude : 45,
                    'longitude':
                        locationData != null ? locationData.longitude : 30,
                    'tag': tag.toString(),
                    'rating': null,
                    'averageRating': null,
                    'photoUrl': imageURL,
                    'isBeingUsed': false,
                    'lockCombo': lockControllerOne.text != ""
                        ? (lockControllerOne.text +
                            "-" +
                            lockControllerTwo.text +
                            "-" +
                            lockControllerThree.text)
                        : "No Combo Entered",
                    'donatedUserEmail':
                        user != null ? user.email : "default@email.com",
                    'riderEmail': null,
                    'isStolen': false,
                    'notes': null,
                  });
                  Navigator.pushNamed(context, MapScreen.routeName);
                },
              ),
              TextButton(
                child: Text("Close"),
                onPressed: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName(AddBikeScreen.routeName));
                },
              ),
            ],
          );
        },
      );
    }
  }

  Future loadText() async {
    String message = await rootBundle.loadString(WAVER_PATH);
    // return message;
    setState(() {
      _waverMessage = message;
    });
  }
}
