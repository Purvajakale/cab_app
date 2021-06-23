import 'package:flutter/material.dart';
import 'package:awesome_loader/awesome_loader.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        body: Container(
          child: Center(
            child: AwesomeLoader(
              loaderType: AwesomeLoader.AwesomeLoader1,
              color: Colors.amber,
            ),
          ),
        ),
      ),
    );
  }
}
