import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:housing_hub/Screens/login_screen.dart';
import '../classess/Property.dart';
import '../classess/User.dart';
import 'VerticalList.dart';
import 'home_screen.dart'; // Make sure to import your HomeScreen widget

class SearchPage extends StatelessWidget {
  SearchPage(this.user,{required this.allProperties});
  final User user;
   List<Property> allProperties;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text("${allProperties.length} Results Found"),
        // Customize the leading icon
        leading: IconButton(
          icon: Icon(
            Icons.arrow_back, // You can use any icon you prefer
            color: Colors.black, // Customize the icon color
          ),
          onPressed: () async {
            Loader.show(context,isAppbarOverlay: true,overlayColor: Colors.transparent);
            allProperties=await new Property().FetchingProperties(null, null);
            Loader.hide();
            Navigator.pop(context);
            Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage(user, allProperties: allProperties)));// Add the navigation functionality you need
          },
        ),
      ),
      body: VerticalList(user:user,allProperties:allProperties,issold: false,ismyproperties: false),
    );
  }
}


