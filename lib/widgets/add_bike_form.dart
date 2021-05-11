import 'dart:io';
import 'package:bikeapp/screens/add_bike_screen.dart';
import 'package:bikeapp/screens/map_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:grouped_buttons/grouped_buttons.dart';
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
  final FirebaseAuth auth = FirebaseAuth.instance;
  User user;
  TextEditingController lockControllerOne = new TextEditingController();
  TextEditingController lockControllerTwo = new TextEditingController();
  TextEditingController lockControllerThree = new TextEditingController();
  TextEditingController nameController = new TextEditingController();
  String imageURL;
  List<String> tags = [];

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
    user = auth.currentUser;
    retrieveLocation();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
          SizedBox(height: 20),
          showImage(context),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 80.0),
            child: TextField(
              controller: nameController,
              decoration: InputDecoration(
                hintText: "Bike Name",
              ),
              textAlign: TextAlign.center,
              keyboardType: TextInputType.text,
            ),
          ),
          SizedBox(height: 60),
          Text("Lock Combination"),
          lockInput(context),
          SizedBox(height: 40),
          ElevatedButton(
            child: Text('Select Photo'),
            onPressed: () {
              getImage();
            },
          ),
          SizedBox(height: 40),
          bikeTagCheckBoxes(context),
          SizedBox(height: 20),
          FractionallySizedBox(
            widthFactor: 0.5,
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
    final node = FocusScope.of(context);
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
            child: TextField(
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
            child: TextField(
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
    if (image != null) {
      return Image.file(image);
    } else {
      // Placeholder for when image has not been selected
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: 100.0),
        child: Placeholder(fallbackHeight: 160),
      );
    }
  }

  Widget bikeTagCheckBoxes(BuildContext context) {
    return Column(
      children: [
        CheckboxGroup(
            labels: <String>["Road Bike", "Mountain Bike", "Hybrid"],
            onChange: (bool isChecked, String label, int index) {
              if (isChecked && !tags.contains(label)) {
                tags.add(label);
              } else if (!isChecked && tags.contains(label)) {
                tags.remove(label);
              }
              setState(() {});
            }),
      ],
    );
  }

  void submitAddBike() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text("Waiver"),
          // Eventually read this from a text doc
          content: Text(
              "Sed ut perspiciatis unde omnis iste natus error sit voluptatem accusantium doloremque laudantium, totam rem aperiam, eaque ipsa quae ab illo inventore veritatis et quasi architecto beatae vitae dicta sunt explicabo. Nemo enim ipsam voluptatem quia voluptas sit aspernatur aut odit aut fugit, sed quia consequuntur magni dolores eos qui ratione voluptatem sequi nesciunt. Neque porro quisquam est, qui dolorem ipsum quia dolor sit amet, consectetur, adipisci velit, sed quia non numquam eius modi tempora incidunt ut labore et dolore magnam aliquam quaerat voluptatem. Ut enim ad minima veniam, quis nostrum exercitationem ullam corporis suscipit laboriosam, nisi ut aliquid ex ea commodi consequatur? Quis autem vel eum iure reprehenderit qui in ea voluptate velit esse quam nihil molestiae consequatur, vel illum qui dolorem eum fugiat quo voluptas nulla pariatur?"),
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
                  'tags': tags,
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
}
