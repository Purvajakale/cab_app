import 'package:flutter/material.dart';

class divider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Divider(
      height: 0.2,
      color: Colors.amber.shade200,
      indent: 55,
      endIndent: 55,
      thickness: 3,
    );
  }
}
