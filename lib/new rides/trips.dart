import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:provider/provider.dart';
import 'DailyTrips.dart';

class Trips extends StatefulWidget {
  @override
  _TripsState createState() => _TripsState();
}

class _TripsState extends State<Trips> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('choose your trip'),
        backgroundColor: Colors.amber,
        actions: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: IconButton(
              icon: Icon(
                Icons.logout,
              ),
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),
      body: Container(
        child: Column(
          children: [
            // DAILY TRIPS
            Card(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Daily Trip',
                              style: new TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w500),
                            ),
                            Spacer(flex: 20),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text('Instant booking rides'),
                            // Text(document['description']),
                            Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                          children: <Widget>[
                            // Text("${DateFormat('dd/MM/yyyy').format(document['startDate'].toDate()).toString()} - ${DateFormat('dd/MM/yyyy').format(document['endDate'].toDate()).toString()}"),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(20.0))),
                    backgroundColor: Colors.white,
                    context: context,
                    isScrollControlled: true,
                    builder: (context) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 18),
                        child: NewDailyTrip()),
                  );
                },
              ),
            ),

            // RENTALS
            Card(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Rental Trip',
                              style: new TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w500),
                            ),
                            Spacer(flex: 20),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text('Book rides for a longer period of time'),
                            // Text(document['description']),
                            Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                          children: <Widget>[
                            // Text("${DateFormat('dd/MM/yyyy').format(document['startDate'].toDate()).toString()} - ${DateFormat('dd/MM/yyyy').format(document['endDate'].toDate()).toString()}"),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => Rental()),
                //   );
                // },
              ),
            ),

            // OUSTATION
            Card(
              child: InkWell(
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                          children: <Widget>[
                            Text(
                              'Outstation Trip',
                              style: new TextStyle(
                                  fontSize: 25.0, fontWeight: FontWeight.w500),
                            ),
                            Spacer(flex: 20),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: Row(
                          children: <Widget>[
                            Text('Book both one way and round trips'),
                            // Text(document['description']),
                            Spacer(),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0, bottom: 4.0),
                        child: Row(
                          children: <Widget>[
                            // Text("${DateFormat('dd/MM/yyyy').format(document['startDate'].toDate()).toString()} - ${DateFormat('dd/MM/yyyy').format(document['endDate'].toDate()).toString()}"),
                            Spacer(),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                // onTap: () {
                //   Navigator.push(
                //     context,
                //     MaterialPageRoute(builder: (context) => Outstation()),
                //   );
                // },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget showSignOut(context) {
    return RaisedButton(
      child: Text("Sign Out"),
      onPressed: () async {
        try {
          await Provider.of(context).auth.signOut();
        } catch (e) {
          print(e);
        }
      },
    );
  }
}
