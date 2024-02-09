import 'package:flutter/material.dart';
import 'package:housing_hub/classess/User.dart';

import '../Screens/list_componnet_widget.dart';
import '../classess/Property.dart';
import '../defined_constants.dart';

class BottomComponents extends StatelessWidget {
   BottomComponents(this.user, this.allProperties, {super.key});
   final User user;
   final List<Property> allProperties;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          for (var i = 0; i < allProperties.length; i++)
            ListComponnetWidget(
              orientation: LayoutOrientation.vertical,
              height: vertical_height,
              width: vertical_width,
              issold: false,
              user: user,
              allProperties: allProperties[i],
              isMYproperties: false,
              plist: allProperties,
            )
        ],
      ),
    );
  }
}
