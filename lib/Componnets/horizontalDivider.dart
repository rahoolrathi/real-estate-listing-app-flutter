import 'package:flutter/material.dart';

class HorizontalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding: EdgeInsets.only(left: 10,right: 10),
      child: Divider(
        color: Colors.grey.shade400,
        thickness: 1, // Adjust the thickness as needed
        height: 0.0, // Set to 0.0 to make it a horizontal line
      ),
    );;
  }
}

