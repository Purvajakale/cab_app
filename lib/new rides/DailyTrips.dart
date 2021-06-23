import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cab_app/models.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class NewDailyTrip extends StatefulWidget {
  final Trip trip;
  NewDailyTrip({Key key, @required this.trip}) : super(key: key);

  @override
  _NewDailyTripState createState() => _NewDailyTripState();
}

class _NewDailyTripState extends State<NewDailyTrip> {
  final db = FirebaseFirestore.instance;
  final uuid = FirebaseAuth.instance.currentUser.uid;

  final List<String> litems = ["mini", "coupe", "sedan", "SUV", "SUV-play"];
  String _currentdestination = 'Airport';
  String _currentride = "mini";

  final _formKey = GlobalKey<FormState>();

  final List<String> destination = [
    'Airport',
    'Cafe',
    'Railway Station',
    'Highway',
    'Hospital'
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.40,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(
                      bottom: 8.0, top: 24, left: 16, right: 16),
                  child: Text(
                    "New Trip",
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                ),
              ],
            ),
            Form(
              key: _formKey,
              child: Expanded(
                child: ListView(
                  children: <Widget>[
                    Column(
                      children: <Widget>[
                        Padding(
                          padding:
                              const EdgeInsets.only(top: 6, right: 6, left: 6),
                          child: DropdownButtonFormField(
                            value: _currentdestination,
                            items: destination.map((place) {
                              return DropdownMenuItem(
                                value: place,
                                child: Text('$place'),
                              );
                            }).toList(),
                            onChanged: (val) =>
                                setState(() => _currentdestination = val),
                          ),
                        ),
                        Container(
                          margin: EdgeInsets.symmetric(vertical: 20.0),
                          height: 120.0,
                          child: new ListView.builder(
                              scrollDirection: Axis.horizontal,
                              itemCount: litems.length,
                              itemBuilder: (BuildContext ctxt, int index) {
                                return TextButton(
                                  child: new Image.asset(
                                      "images/${litems[index]}.jpg"),
                                  onPressed: () {
                                    _currentride = litems[index].toString();
                                  },
                                );
                              }),
                        ),
                        RaisedButton(
                            child: Text("Submit"),
                            onPressed: () async {
                              widget.trip.car = _currentride;
                              widget.trip.endPlace = _currentdestination;
                              widget.trip.type = 'DailyTrip';
                              final uid = uuid;
                              await db
                                  .collection("userData")
                                  .doc(uid)
                                  .collection("trip")
                                  .add(widget.trip.toJson());
                              Navigator.of(context).pop();
                            })
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
