
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:housing_hub/Screens/SearchScreen.dart';

import '../Componnets/horizontalDivider.dart';
import '../classess/Property.dart';
import '../classess/User.dart';
import '../defined_constants.dart';

class AddBottomSheet extends StatefulWidget {
  AddBottomSheet({required this.user,required this.allProperties});
  final User user;
   List<Property> allProperties;
  @override
  State<AddBottomSheet> createState() => _AddBottomSheetState();
}
class _AddBottomSheetState extends State<AddBottomSheet> {
  String selectedcity="Karachi";
  String selectedbathrooms='1';
  String selectedbedrooms='1';
  bool isInstallmentAvailable=false;
  RangeValues values=RangeValues(1000,10000);

  _applyfilters() async {
      Map<String, dynamic> filters = {
        'city': selectedcity,
        'bedrooms': int.parse(selectedbedrooms),
        'bathrooms': int.parse(selectedbathrooms),
        'isInstallmentAvailable': isInstallmentAvailable,
        'priceRange': {'min': values.start, 'max': values.end},
      };
    String result;
    try {
    Loader.show(context, isAppbarOverlay: true,overlayColor: Colors.transparent);
    widget.allProperties=await Property().FetchingProperties(null, filters);
      Loader.hide();
    Navigator.pop(context);
    Navigator.push(context, MaterialPageRoute(builder: (context)=> SearchPage(widget.user, allProperties: widget.allProperties,)));
    } catch (error) {
    Loader.hide();
    ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
    backgroundColor:Colors.red,
    content: Text(error.toString()),
    ),
    );
  }}
  @override
  Widget build(BuildContext context) {
    RangeLabels labels=RangeLabels(values.start.toString(), values.end.toString());
    return Container(
      color: Color(0xff757575),
      child: Container(
        height: 600,
        padding: EdgeInsets.only(top:10,left:0,right: 5),
        decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
                topRight: Radius.circular(20),
                topLeft: Radius.circular(20)
            )
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children:<Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Filters",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w400,
                      color: Colors.black,
                    ),
                  ),
                  TextButton(
                    onPressed:_applyfilters,
                    child: Text("Done", style: TextStyle(color: Colors.green,fontSize: 20)),
                  ),

                ],
              ),
                  _DropDownListWidgets(cities, selectedcity,"City",300,(String ?value){
                    setState(() {
                      selectedcity=value!;
                    });
                  }),
                  SizedBox(height: 20,),
                  HorizontalDivider(),
                  SizedBox(height: 20,),
                  _DropDownListWidgets(['1','2','3','4','5','6','7','8','9','10'],selectedbedrooms,"Badrooms",300,(String? value) {
                    setState(() {
                      selectedbedrooms = value!;
                    });
                  }),
                  SizedBox(height: 20,),
                  HorizontalDivider(),
                  SizedBox(height: 20,),
                  _DropDownListWidgets(['1','2','3','4','5','6'],selectedbathrooms,"Bathrooms",300,(String?value) {
                    setState(() {
                      selectedbathrooms = value!;
                    });
                  }),
              SizedBox(height: 20,),
              HorizontalDivider(),
              SizedBox(height: 20,),
              _installmentAvailable(),
              SizedBox(height: 20,),
              HorizontalDivider(),
              SizedBox(height: 20,),

              Text(
                "Price",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
              ),
              RangeSlider(
                activeColor: Colors.green,
                 inactiveColor: Colors.grey.shade500,
                 values: values,
                labels: labels,
                min:1000,
                max:10000,
                divisions: 1000,
                onChanged: (newvalue){
                  values=newvalue;
                  print(newvalue.start);
                  setState(() {

                  });
                },

              )
                ],

              )
          ),

      ));
    }
  Widget buildDropdown(String selecteditem,List<String>list,double width,Function(String?)?onchanged) {
    return Container(
      width: width,
      padding: EdgeInsets.symmetric(horizontal: 16.0),
      child: DropdownButton<String>(
        isExpanded: true,
        value: selecteditem,
        icon: Icon(Icons.arrow_drop_down),
        iconSize: 24,
        elevation: 16,
        style: TextStyle(color: Colors.black, fontSize: 18),
        underline: Container(
          height: 1,
          color: Colors.grey.shade300,
        ),
        onChanged:onchanged,
        items: list.map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(value),
          );
        }).toList(),
      ),
    );
  }
  Widget _DropDownListWidgets(List<String> list,String selectedPropertyType,String title,double width,Function(String?)? onChanged){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(Icons.home_work,
          color: Colors.grey,
        ),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: TextStyle(
                  fontWeight: FontWeight.w400,
                  fontSize: 20
              ),
            ),
            SizedBox(width: 20,),
            buildDropdown(selectedPropertyType,list,width,onChanged),
          ],
        ),
      ],
    );
  }
  Widget _installmentAvailable() {
    return Row(
      children: <Widget>[
        Icon(
          Icons.install_desktop,
          color: Colors.grey,
        ),
        SizedBox(width: 20,),
        Text(
          "Installments Available",
          style: TextStyle(
            color: Colors.black,
            fontSize: 20,
          ),
        ),
        SizedBox(width: 60,),
        Switch(
          value: isInstallmentAvailable,
          activeColor: Colors.green,
          onChanged: (bool value) {
            setState(() {
              isInstallmentAvailable = value;

            });
          },
        )
      ],
    );
  }


}





