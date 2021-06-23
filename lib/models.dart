import 'package:cloud_firestore/cloud_firestore.dart';

class Trip {
  String car;
  String type;
  String endPlace;

  Trip(
    this.car,
    this.type,
    this.endPlace,
  );

  Map<String, dynamic> toJson() => {
        'car': car,
        'type': type,
        'endPlace': endPlace,
      };

  Trip.fromSnapshot(DocumentSnapshot snapshot)
      : type = snapshot.data()['type'],
        car = snapshot.data()['car'],
        endPlace = snapshot.data()['endPlace'];
}
