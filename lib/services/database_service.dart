import 'package:bikeapp/models/bike.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class DatabaseService {

  Future<List<Bike>> getBikes() async {
    
    List<Bike> bikes = [];
    var dbRef = FirebaseFirestore.instance.collection('bikes').snapshots();    
    
    dbRef.forEach((element) {      
      element.docs.asMap().forEach((index, data) {
        Map<String, dynamic> map = data.data();
        Bike newBike = Bike.fromMap(map);
        bikes.add(newBike);
      }); 
    });
    return bikes;
  }

  // May convert this to database query eventually
  Future<Bike> getUsersBike(String userEmail) async {
    List<Bike> allBikes = await getBikes();

    if(allBikes.isNotEmpty) {
      print("IS NOT EMPTY");
      return allBikes[0];
    } else {
      print("IS EMPTY");
      return null;
    }


    if(allBikes.length == 0) {
      return null;
    } else {
      return allBikes.firstWhere((bike) => bike.riderEmail == userEmail, orElse: null);
    }
    //return getBikes().firstWhere((element) => element.riderEmail == userEmail, orElse: null);
  }

}
