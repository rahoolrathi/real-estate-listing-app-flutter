import 'package:flutter/material.dart';
import 'package:housing_hub/Screens/profile_screen.dart';
import '../Componnets/bottom_navigation_bar_componnet.dart';
import '../classess/Property.dart';
import '../classess/User.dart';
import 'SearchScreen.dart';
import 'add_property.dart';
import 'main_screen.dart';
import 'my_properties.dart';
class HomePage extends StatelessWidget {
   HomePage(this.user,{required this.allProperties});
   final User user;
   final List<Property> allProperties;
  late final List<Widget> screens = [
    MainPage(user, allProperties: allProperties),
    SearchPage(user,  allProperties: allProperties),
    MyProperties(user:user, allProperties:allProperties),
    ProfilePage(user:user, allProperties:allProperties),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      resizeToAvoidBottomInset: false,
      body: MyBottomNavigationBar(screens: screens),
    );
  }
}
