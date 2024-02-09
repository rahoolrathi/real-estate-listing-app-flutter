import 'package:flutter/material.dart';
import 'package:curved_navigation_bar/curved_navigation_bar.dart';


class MyBottomNavigationBar extends StatefulWidget {
  final List<Widget> screens;

  MyBottomNavigationBar({required this.screens});

  @override
  State<MyBottomNavigationBar> createState() => _MyBottomNavigationBarState();
}

class _MyBottomNavigationBarState extends State<MyBottomNavigationBar> {
  int index = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: widget.screens[index],
      bottomNavigationBar: CurvedNavigationBar(
        height: 60,
        backgroundColor: Colors.grey.shade100,
        color: Colors.green.shade700, // Color of the selected item
        buttonBackgroundColor: Colors.grey.shade100,
        items: <Widget>[
          Icon(Icons.home, color: Colors.black,),
          Icon(Icons.search, color: Colors.black),
          Icon(Icons.home_work, color: Colors.black),
          Icon(Icons.person, color: Colors.black),
        ],
        onTap: (newIndex) {
          setState(() {
            index = newIndex;
          });
        },
      ),
    );
  }
}
