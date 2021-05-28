import 'package:bikeapp/models/bike.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:location/location.dart';

class DatabaseService {
  Future<List<Bike>> getBikes() async {
    List<Bike> bikes = [];
    await FirebaseFirestore.instance.collection('bikes').get().then((doc) => {
          if (doc.docs.isNotEmpty)
            {
              doc.docs.forEach((element) {
                Bike newBike = Bike.fromMap(element.data());
                bikes.add(newBike);
              })
            }
        });
    return bikes;
  }

  // May convert this to database query eventually
  Future<Bike> getUsersBike(String userEmail) async {
    List<Bike> allBikes = await getBikes();

    if (allBikes.length == 0) {
      return null;
    } else {
      return allBikes.firstWhere((bike) => bike.riderEmail == userEmail,
          orElse: () => null);
    }
    // Flesh this out later if wanted
    //return FirebaseFirestore.instance.collection('bikes').where('riderEmail', isEqualTo: userEmail).limit(1).get();
  }

  Future<String> getBikeId(Bike bike) async {
    var snapshot = await FirebaseFirestore.instance
        .collection('bikes')
        .get()
        .then((doc) => {
              doc.docs.firstWhere(
                  (element) => element['photoUrl'] == bike.photoUrl,
                  orElse: null)
            });
    if (snapshot == null) {
      return null;
    }
    return snapshot.first.id;
  }

  void endRide(double newRating, Bike currentBike, LocationData locationData,
      String note) async {
    String id = await getBikeId(currentBike); // firebase id of bike
    // Copy list, push new rating onto before updating
    List<dynamic> ratings = currentBike.rating;
    List<dynamic> notes = currentBike.notes;

    if (ratings == null) {
      ratings = [];
    }

    if (note != null && note.isNotEmpty) {
      if (notes == null) {
        notes = [];
      }
      notes.add(note);
    }

    ratings.add(newRating);
    double total = 0;
    for (int i = 0; i < ratings.length; i++) {
      total += ratings[i];
    }
    double averageRating = total / ratings.length.toDouble();

    if (id != null) {
      FirebaseFirestore.instance.collection('bikes').doc(id).update({
        "isBeingUsed": false,
        "rating": ratings,
        "riderEmail": null,
        "averageRating": averageRating,
        "latitude": locationData.latitude,
        "longitude": locationData.longitude,
        'notes': notes,
      });
    }
  }
}
