import 'package:flutter/material.dart';
import 'package:housing_hub/Screens/SearchScreen.dart';
import 'package:housing_hub/Screens/add_property.dart';
import 'package:housing_hub/Screens/detail_screen.dart';

import 'package:housing_hub/Screens/list_componnet_widget.dart';
import 'Screens/first_page_screen.dart';
import 'Screens/main_screen.dart';
import 'defined_constants.dart';
void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/MainPage',
       routes: {
       // '/DetailScreen':(context)=>DetailScreen(),
        '/MainPage':(context)=>firstPage(),
        /// '/SearchScreen':(context)=>SearchPage(),
       // '/list_commponnet':(context)=>ListComponnetWidget(orientation: LayoutOrientation.vertical,height: vertical_height,width: vertical_width,issold: true,),
       },
       home:firstPage()
    );
  }
}

//first->Login->HomePage
