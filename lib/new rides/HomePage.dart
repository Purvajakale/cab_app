import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:cab_app/services/provider_widget.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:cab_app/divider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'trips.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cab_app/services/loading.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  User user = FirebaseAuth.instance.currentUser;
  Completer<GoogleMapController> _controllerGoogleMap = Completer();
  GoogleMapController newGoogleMapController;

  Position currentPosition;
  var geoLocator = Geolocator();
  String _currentAddress;

  void locatePosition() async {
    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );
    currentPosition = position;
    _getAddressFromLatLng();
    LatLng latLngPosition = LatLng(position.latitude, position.longitude);
    CameraPosition cameraPosition =
        new CameraPosition(target: latLngPosition, zoom: 14);
    newGoogleMapController
        .animateCamera(CameraUpdate.newCameraPosition(cameraPosition));
  }

  @override
  void initState() {
    super.initState();
    _getCurrentLocation();
  }

  _getCurrentLocation() {
    Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) {
      setState(() {
        currentPosition = position;
      });

      _getAddressFromLatLng();
    }).catchError((e) {
      print(e);
    });
  }

  _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
          currentPosition.latitude, currentPosition.longitude);
      Placemark place = p[0];
      setState(() {
        _currentAddress =
            "${place.locality}, ${place.postalCode}, ${place.country}";
      });
    } catch (e) {
      print(e);
    }
  }

  static final CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(19.663280, 75.300293),
    zoom: 14.4746,
  );

  GlobalKey<ScaffoldState> scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.amber,
        title: Text('Daily Trips'),
      ),
      drawer: Container(
        color: Colors.white,
        width: 250,
        child: ListView(
          children: [
            FutureBuilder(
              future: Provider.of(context).auth.getCurrentUser(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return displayUserInformation(context, snapshot);
                } else {
                  return Loading();
                }
              },
            ),
            Container(
              height: 160,
              child: DrawerHeader(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Row(
                  children: [
                    Image.asset(
                      'images/profile.png',
                      height: 60,
                      width: 60,
                    ),
                    SizedBox(width: 6),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        TextButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) =>
                                  new AlertDialog(
                                title: Text('${user.displayName}'),
                                content: new Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text('${user.email}'),
                                  ],
                                ),
                                actions: <Widget>[
                                  new TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                    child: const Text('Close'),
                                  ),
                                ],
                              ),
                            );
                          },
                          child: Text(
                            "My Profile",
                            style: TextStyle(fontSize: 23),
                          ),
                        ),
                        // Text(
                        //   "${user.displayName}",
                        //   style: TextStyle(fontSize: 18),
                        // ),
                        // Text(
                        //   "${user.email}",
                        //   style: TextStyle(fontSize: 18),
                        // ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            divider(),
            TextButton(
              onPressed: () {},
              child: ListTile(
                title: Text("History"),
                trailing: TextButton(
                  child: Icon(Icons.history),
                ),
              ),
            ),
            TextButton(
              onPressed: () {},
              child: ListTile(
                title: Text("About"),
                trailing: TextButton(
                  child: Icon(Icons.info),
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                FirebaseAuth.instance.signOut();
                Navigator.pop(context);
              },
              child: ListTile(
                title: Text("Logout"),
                trailing: TextButton(
                  child: Icon(Icons.logout),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          GoogleMap(
              mapType: MapType.normal,
              myLocationEnabled: true,
              initialCameraPosition: _kGooglePlex,
              myLocationButtonEnabled: true,
              zoomGesturesEnabled: true,
              zoomControlsEnabled: true,
              onMapCreated: (GoogleMapController controller) {
                _controllerGoogleMap.complete(controller);
                newGoogleMapController = controller;
                locatePosition();
              }),
          Positioned(
            top: 45,
            left: 22,
            child: GestureDetector(
              onTap: () {
                scaffoldKey.currentState.openDrawer();
              },
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.amberAccent,
                    borderRadius: BorderRadius.circular(22),
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black,
                          blurRadius: 5,
                          spreadRadius: 0.2,
                          offset: Offset(0.5, 0.5)),
                    ]),
                child: CircleAvatar(
                  backgroundColor: Colors.white,
                  child: Icon(Icons.menu, color: Colors.black),
                  radius: 20,
                ),
              ),
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 150,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black54,
                    blurRadius: 6,
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(height: 4),
                    Text('Pickup Location:', style: TextStyle(fontSize: 14)),
                    Text(address(), style: TextStyle(fontSize: 20)),
                    SizedBox(height: 8),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            spreadRadius: 0.5,
                            offset: Offset(0.7, 0.7),
                          ),
                        ],
                      ),
                      child: InkWell(
                        child: Row(
                          children: [
                            SizedBox(width: 5),
                            Icon(
                              Icons.search,
                              color: Colors.blueAccent,
                              size: 30,
                            ),
                            SizedBox(width: 10),
                            Text(
                              'Search Destination',
                              style: TextStyle(color: Colors.blueGrey),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(builder: (context) => Trips()),
                          );
                        },
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    divider(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget displayUserInformation(context, snapshot) {
    final user = snapshot.data;
    return Column(
      children: <Widget>[],
    );
  }

  String address() {
    if (currentPosition != null && _currentAddress != null) {
      return _currentAddress;
    } else {
      return 'null';
    }
  }
}
