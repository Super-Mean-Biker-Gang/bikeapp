import 'dart:io';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:location/location.dart';
import 'package:image_picker/image_picker.dart';

class AddBikeForm extends StatefulWidget {
  @override
  _AddBikeFormState createState() => _AddBikeFormState();
}

class _AddBikeFormState extends State<AddBikeForm> {
  File image;
  LocationData locationData;
  final picker = ImagePicker();
  TextEditingController lockComboController = new TextEditingController();
  String imageURL;

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

  void retrieveLocation() async {
    var locationService = Location();
    locationData = await locationService.getLocation();
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    retrieveLocation();
  }

  @override
  Widget build(BuildContext context) {
    if (image == null) {
      getImage();
      return Center(
          child: ElevatedButton(
              child: Text('Select Photo'),
              onPressed: () {
                getImage();
              }));
    } else {
      return Scaffold(
        appBar: AppBar(
          leading: Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: GestureDetector(
                onTap: () {
                  Navigator.of(context).pop();
                },
                child: Icon(Icons.arrow_back)),
          ),
          title: Text("Add A Bike"),
          centerTitle: true,
        ),
        body: ListView(children: [
          Center(
              child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.file(image),
              SizedBox(height: 40),
              TextField(
                controller: lockComboController,
                decoration: InputDecoration(
                  hintText: "Lock Combination",
                ),
                textAlign: TextAlign.center,
                // Change to three numbered fields and convert later
                keyboardType: TextInputType.text,
              ),
              SizedBox(height: 80),
              FractionallySizedBox(
                widthFactor: 1,
                child: ElevatedButton(
                  child: Text('Add Bike!'),
                  onPressed: () {
                    retrieveLocation();
                    FirebaseFirestore.instance.collection('bikes').add({
                      'bikeName':
                          'Bike Name', // Will add appropriate form spot later
                      'latitude':
                          locationData != null ? locationData.latitude : 45,
                      'longitude':
                          locationData != null ? locationData.longitude : 30,
                      'tags': [
                        'Tag1',
                        'Tag2'
                      ], // Will add appropriate spot in form later
                      'rating':
                          null, // Not sure how we want bike ratings to start before being used
                      'photoUrl': imageURL,
                      'isBeingUsed': false,
                      'lockCombo': lockComboController.text != ""
                          ? lockComboController.text
                          : "0",
                      'donatedUserEmail':
                          "userEmail@email.com", // Will add logic to determined logged in user's email
                    });
                    //Navigator.popUntil(context, ModalRoute.withName(MapScreen.routeName));
                    Navigator.pushNamed(context, MapScreen.routeName);
                  },
                ),
              )
            ],
          )),
        ]),
      );
    }
  }
}
