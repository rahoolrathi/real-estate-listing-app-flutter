import 'package:flutter/material.dart';
import 'package:housing_hub/Screens/home_screen.dart';
import 'package:housing_hub/Screens/login_screen.dart';

import '../classess/Property.dart';
import '../classess/User.dart';
import 'VerticalList.dart';

class MyProperties extends StatefulWidget {
  MyProperties({required this.user, required this.allProperties});

  final User user;
  final List<Property> allProperties;

  @override
  State<MyProperties> createState() => _MyPropertiesState();
}

class _MyPropertiesState extends State<MyProperties> {
  late Future<List<Property>> myPropertiesFuture;

  @override
  void initState() {
    super.initState();
    myPropertiesFuture = loadData();
  }

  Future<List<Property>> loadData() async {
    try {
      Property property = Property();
      print(widget.user.username)
;      return await property.FetchingProperties(widget.user.username,null);
    } catch (error) {
      print('Error loading data: $error');
      // You might want to handle the error here or return an empty list
      return [];
    }
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("My Properties"),
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back,
            color: Colors.black,
          ),
          onPressed: () {
            Navigator.pop(context);
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(widget.user, allProperties: widget.allProperties),
              ),
            );
          },
        ),
      ),
      body: FutureBuilder<List<Property>>(
        future: myPropertiesFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Display CircularProgressIndicator at the center while waiting for data
            return Center(
              child: CircularProgressIndicator(),
            );
          } else if (snapshot.hasError) {
            // Handle error state
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Data has been loaded, build your UI
            return VerticalList(user: widget.user, allProperties: snapshot.data!, issold: false, ismyproperties: true);
          }
        },
      ),
    );
  }

}


