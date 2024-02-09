import 'package:flutter/material.dart';

import '../Screens/SearchScreen.dart';
import '../classess/Property.dart';
import '../classess/User.dart';

class GridComponents extends StatelessWidget{
  GridComponents(this.user,this.allProperties,this.PropertyIcons,this.PropertyType);
  final User user;
  final List<Property> allProperties;
  final PropertyIcons;
 final  PropertyType;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: EdgeInsets.all(10),
      // Adjust padding here
      shrinkWrap: true,
      itemCount: 4,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 2,
      ),
      itemBuilder: (context, index) {
        return GestureDetector(
          onTap: (){
            Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(user,allProperties: allProperties,)));
          },
          child: Container(
            margin: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(5),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                PropertyIcons[index],
                SizedBox(
                  width: 20,
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Text(
                      PropertyType[index],
                      style: TextStyle(
                        color: Colors.black87,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                    Text(
                      "120 items",
                      style: TextStyle(color: Colors.black54),
                    )
                  ],
                )
              ],
            ),
          ),
        );
      },
    );
  }
}
