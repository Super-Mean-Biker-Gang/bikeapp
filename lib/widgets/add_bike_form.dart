import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:bikeapp/screens/add_bike_screen.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';

const WAVER_PATH = 'assets/text_files/donateBikeWaver.txt';

class AddBikeForm extends StatefulWidget {
  @override
  _AddBikeFormState createState() => _AddBikeFormState();
}

class _AddBikeFormState extends State<AddBikeForm> {
  File image;
  LocationData locationData;
  final picker = ImagePicker();
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  TextEditingController lockComboController = new TextEditingController();
  TextEditingController lockControllerOne = new TextEditingController();
  TextEditingController lockControllerTwo = new TextEditingController();
  TextEditingController lockControllerThree = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  String imageURL;
  String _waverMessage;

  void getImage() async {
    final pickedFile = await picker.getImage(source: ImageSource.gallery);    
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

  void takePhoto() async {    
    final pickedFile = await picker.getImage(source: ImageSource.camera);
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
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          showImage(context),
          SizedBox(height: 40),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                child: Text('Select Photo'),
                onPressed: () {
                  getImage();
                },
              ),
              SizedBox(width: 10),
              ElevatedButton(
                child: Text('Use Camera'),
                onPressed: () {
                  takePhoto();
                },
              ),
            ],
          ),
          SizedBox(height: 40),
          TextField(
            controller: nameController,
            decoration: InputDecoration(
              hintText: "Bike Name",
            ),
            textAlign: TextAlign.center,
            keyboardType: TextInputType.text,
          ),
          SizedBox(height: 60),
          lockInput(context),
          

          SizedBox(height: 40),
          FractionallySizedBox(
            widthFactor: 1,
            child: ElevatedButton(
              child: Text('Add Bike!'),
              onPressed: () {
                submitAddBike();
              },
            ),
          ),
        ]),
      ),
    );
  }

  Widget lockInput(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 80),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Flexible(
            child: TextField(
              controller: lockControllerOne,
              decoration: InputDecoration(contentPadding: EdgeInsets.all(10)),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: TextField(
              controller: lockControllerTwo,
              decoration: InputDecoration(contentPadding: EdgeInsets.all(10)),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
          ),
          SizedBox(width: 20.0),
          Flexible(
            child: TextField(
              controller: lockControllerThree,
              decoration: InputDecoration(contentPadding: EdgeInsets.all(10)),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
            ),
          ),
        ],
      ),
    );
  }

  Widget showImage(BuildContext context) {
    if (image != null) {
      return Image.file(image);
    } else {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        child: Placeholder(fallbackHeight: 160),
      );
    }
  }

  void submitAddBike() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Waiver"),
          // Eventually read this from a text doc
          content: Text(_waverMessage),
          actions: <Widget>[
            TextButton(
              child: Text("I accept"),
              onPressed: () {
                retrieveLocation();
                FirebaseFirestore.instance.collection('bikes').add({
                  'bikeName': nameController.text != ""
                      ? nameController.text.trim()
                      : "Unnamed",
                  'latitude': locationData != null ? locationData.latitude : 45,
                  'longitude':
                      locationData != null ? locationData.longitude : 30,
                  'tags': [
                    'Tag1',
                    'Tag2'
                  ], // Will add appropriate spot in form later
                  'rating': null,
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

  Future loadText() async {
    String message = await rootBundle.loadString(WAVER_PATH);
    // return message;
    setState(() {
      _waverMessage = message;
    });
  }
}
