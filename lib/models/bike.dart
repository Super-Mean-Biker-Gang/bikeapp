class Bike {
  String bikeName;
  double latitude;
  double longitude;
  List tags;
  int rating;
  String photoUrl;
  bool isBeingUsed;
  DateTime checkoutTime;
  String riderEmail;
  String lockCombo;
  String donatedUserEmail;

  Bike([
    this.bikeName = "Bike's Name",
    this.latitude = 4.0,
    this.longitude = 4.0,
    this.tags = const ["Mountain Bike", "Old"],
    this.rating = 4,
    this.photoUrl = "fakeurl.com",
    this.isBeingUsed = false,
    this.lockCombo = "04-04-04",
    this.donatedUserEmail = "someonesEmail@email.com",
  ]);

  Bike.fromMap([Map<String, dynamic> map]) {
    this.bikeName = map['bikeName'];
    this.latitude = map['latidude'];
    this.longitude = map['longitude'];
    //this.tags = map['tags'];
    this.tags = ['a', 'b', 'c']; // DELETE LATER
    this.rating = map['rating'];
    this.photoUrl = map['photoUrl'];
    this.isBeingUsed = map['isBeingUsed'];
    this.checkoutTime = map['checkoutTime'];
    this.riderEmail = map['riderEmail'];
    this.lockCombo = map['lockCombo'];
    this.donatedUserEmail = map['donatedUserEmail'];
  }
}
