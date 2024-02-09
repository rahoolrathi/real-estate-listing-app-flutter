import 'package:flutter/material.dart';

Widget buildButtomSheet(BuildContext context)


{
  return Container(
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(30),
        topRight: Radius.circular(20),
      ),
    ),
    child: Column(
      children: [
        // Add your bottom sheet content here
        ListTile(
          title: Text('Option 1'),
          onTap: () {
            // Handle option 1
            Navigator.pop(context);
          },
        ),
        ListTile(
          title: Text('Option 2'),
          onTap: () {
            // Handle option 2
            Navigator.pop(context);
          },
        ),
        // Add more options if needed
      ],
    ),
  );
}