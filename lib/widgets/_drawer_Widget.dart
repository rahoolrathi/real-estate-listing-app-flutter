import 'package:flutter/material.dart';
import 'package:housing_hub/Screens/add_property.dart';

import '../Screens/add_bottom_sheet.dart';
import '../Screens/my_properties.dart';
import '../Screens/profile_screen.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../classess/Property.dart';
import '../classess/User.dart';

Widget MyHeaderDrawer(User user) {
  return Container(
    color: Colors.green.shade700,
    width: double.infinity,
    height: 200,
    padding: EdgeInsets.only(top: 20.0),
    child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          margin: EdgeInsets.only(bottom: 10),
          height: 80,
          width: 100,
          child: CircleAvatar(
            backgroundColor: Colors.green,
            child: user.userimage==null?Image.asset("assets/images/programmer.png"):Image.file(user.userimage!),

          ),
        ),

        Text(
          user.username,
          style: TextStyle(color: Colors.grey.shade200, fontSize: 14),
        ),
      ],
    ),
  );
}

Widget MyDrawerList(BuildContext context,User user,final List<Property> allProperties) {
  return Container(
    padding: EdgeInsets.only(top: 15),
    child: Column(
      children: [
        menuItem(
          GestureDetector(
            onTap: (){
                Navigator.pop(context);
            },
            child:Icon(
              Icons.home,
              color: Colors.grey,
            )),
            "Home"),
        menuItem(GestureDetector(
              onTap: (){
                Navigator.pop(context);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddProperty(user:user,allProperties:allProperties)));

              },
              child: Icon(
                  Icons.add,
                  color: Colors.grey),
            )
            , "Add Property"),
        menuItem(GestureDetector(onTap: (){
          Navigator.pop(context);
          showModalBottomSheet(context: context, builder:(context)=>AddBottomSheet(user:user,allProperties:allProperties),isScrollControlled: true
          );

        },child:Icon(Icons.search, color: Colors.grey)), "Search Property"),
        menuItem(GestureDetector(
            onTap: (){
            Navigator.pop(context);
            Navigator.push(context, MaterialPageRoute(builder: (context)=> MyProperties(user:user,allProperties:allProperties)));
            },
            child: Icon(
              Icons.holiday_village_sharp,
              color: Colors.grey,
            )),"My Property"),
        menuItem(GestureDetector(onTap:(){
          Navigator.pop(context);
          Navigator.push(context, MaterialPageRoute(builder: (context)=> ProfilePage(user:user,allProperties:allProperties)));
        },child:Icon(Icons.person, color: Colors.grey)), "Profile"),
        menuItem(GestureDetector(onTap:(){
          _showContactUsDialog(context);
        },child:Icon(Icons.phone, color: Colors.grey)), "Contact Us"),
        menuItem(GestureDetector(onTap:(){
          //_showAboutUsDialog(context);
          _showAboutUsDialog(context);
        },child:Icon(Icons.info, color: Colors.grey)), "About  Us"),
        menuItem(GestureDetector(onTap:(){
          Navigator.pushNamedAndRemoveUntil(context, '/MainPage', (route) => false);
        },child:Icon(Icons.logout, color: Colors.grey)), "Log Out"),
      ],
    ),
  );
}



Widget menuItem(GestureDetector icon, String text) {
  return Material(
    child: InkWell(
      child: Padding(
        padding: EdgeInsets.all(15.0),
        child: Row(
          children: [
            Expanded(child: icon),
            Expanded(
                flex: 3,
                child: Text(
                  text,
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ))
          ],
        ),
      ),
    ),
  );
}
void _showContactUsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Contact Us'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Feel free to contact us for any inquiries or support.',
                style: TextStyle(fontSize: 16),
              ),
              SizedBox(height: 20),
              Text(
                'Email: k214580@nu.edu.pk',
                style: TextStyle(fontSize: 16),
              ),
              Text(
                'Phone: +923420488832',
                style: TextStyle(fontSize: 16),
              ),
              // Add more text as needed
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close',style: TextStyle(
              color: Colors.green
            ),),
          ),
        ],
      );
    },
  );
}
void _showAboutUsDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('About Us'),
        content: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                'Welcome to our app! We strive to provide the best user experience and valuable content.',
                style: TextStyle(fontSize: 16),
              ),
              // Add more text as needed
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Close',style: TextStyle(color: Colors.green),),
          ),
        ],
      );
    },
  );
}
