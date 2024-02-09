import 'package:flutter/material.dart';
import '../Screens/add_bottom_sheet.dart';
import '../classess/Property.dart';
import '../classess/User.dart';
class buildSearch extends StatelessWidget {
  buildSearch(this.user, this.allProperties);

  final User  user;
  final List<Property> allProperties;

  final FocusNode _searchFocusNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 20, left: 30, right: 30),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(10),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 5),
            child: TextFormField(
                focusNode: _searchFocusNode,
                readOnly: true,
              onTap: (){
                showModalBottomSheet(context: context, builder:(context)=>AddBottomSheet(user: user,allProperties: allProperties,),isScrollControlled: true
                );
              },
              decoration: InputDecoration(
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.grey,
                ),
                border: InputBorder.none,
                hintText: "Search",
              ),
            ),
          ),
        ),

    );
  }
}

