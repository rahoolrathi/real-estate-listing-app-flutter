import 'package:flutter/material.dart';

import '../classess/Property.dart';
import '../classess/User.dart';
import '../defined_constants.dart';
import 'list_componnet_widget.dart';

class VerticalList extends StatelessWidget {
  VerticalList({
    required this.user,
    required this.allProperties,
    required this.issold,
    required this.ismyproperties,
  });

  bool issold;
  bool ismyproperties;
  final User user;
  final List<Property> allProperties;

  @override
  Widget build(BuildContext context) {
    print('Length of allProperties: ${allProperties.length}');
    return Padding(
      padding: EdgeInsets.all(10),
      child: allProperties.isEmpty
          ? Center(
        child: Text('No properties found.',style: TextStyle(fontWeight:FontWeight.w500,fontSize: 20),),
      )
          : ListView.builder(
        itemBuilder: (context, index) {
          return ListComponnetWidget(
            orientation: LayoutOrientation.horizontal,
            height: horizontal_height,
            width: vertical_width,
            issold: issold,
            user: user,
            allProperties: allProperties[index],
            isMYproperties: ismyproperties,
            plist:allProperties,
          );
        },
        itemCount: allProperties.length,
      ),
    );
  }
}
