class Bike {
  String bikeName;
  double latitude;
  double longitude;
  String tag;
  List<dynamic> rating;
  double averageRating;
  String photoUrl;
  bool isBeingUsed;
  DateTime checkoutTime;
  String riderEmail;
  String lockCombo;
  String donatedUserEmail;
  bool isStolen;
  List<dynamic> notes;

  Bike([
    this.bikeName = "Bike's Name",
    this.latitude = 4.0,
    this.longitude = 4.0,
    this.tag = "Mountain Bike",
    this.rating = const [4.0],
    this.averageRating = 4.0,
    this.photoUrl = "fakeurl.com",
    this.isBeingUsed = false,
    this.lockCombo = "04-04-04",
    this.donatedUserEmail = "someonesEmail@email.com",
    this.isStolen = false,
  ]);

  Bike.fromMap([Map<String, dynamic> map]) {
    this.bikeName = map['bikeName'];
    this.latitude = map['latitude'];
    this.longitude = map['longitude'];
    this.tag = map['tag'];    
    this.rating = map['rating'];
    this.averageRating = map['averageRating'] != null ? map['averageRating'].toDouble() : null;
    this.photoUrl = map['photoUrl'];
    this.isBeingUsed = map['isBeingUsed'];
    this.checkoutTime = map['checkoutTime'];
    this.riderEmail = map['riderEmail'];
    this.lockCombo = map['lockCombo'];
    this.donatedUserEmail = map['donatedUserEmail'];
    this.isStolen = map['isStolen'];
    this.notes = map['notes'];
  }
}
