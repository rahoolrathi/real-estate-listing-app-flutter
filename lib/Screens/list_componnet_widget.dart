import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:housing_hub/Screens/detail_screen.dart';
import 'package:housing_hub/Screens/my_properties.dart';
import '../classess/Property.dart';
import '../classess/User.dart';
import 'VerticalList.dart';
import 'edit_property.dart';


enum LayoutOrientation { vertical, horizontal }

class ListComponnetWidget extends StatefulWidget {

  ListComponnetWidget({required this.orientation, required this.width, required this.height,required this.issold,required
  this.user,required this.allProperties,this.isMYproperties,required this.plist});

  final LayoutOrientation orientation;
  final double height;
  final double width;
  final bool issold;
  final User user;
  final Property allProperties;
  final isMYproperties;
   List<Property>plist;



  @override
  _ListComponnetWidgetState createState() => _ListComponnetWidgetState();
}

class _ListComponnetWidgetState extends State<ListComponnetWidget> {
  Future<void> _deleteProperty()async {
    String result;
    List<Property>filterproperty;

      try {
        Loader.show(context, isAppbarOverlay: true,overlayColor: Colors.transparent);

        result=await widget.allProperties.deleteProperty();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: result=='Done'?Colors.green:Colors.red,
            content: Text(result),
          ),
        );
        if(result=='Done'){
          Navigator.pop(context);
          filterproperty=(await widget.allProperties.FetchingProperties(widget.user.username,null));
            Navigator.push(context,MaterialPageRoute(builder: (context)=>MyProperties(user: widget.user, allProperties: filterproperty)));
        }
        Loader.hide();
      } catch (error) {
        Loader.hide();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor:Colors.red,
            content: Text(error.toString()),
          ),
        );
      }
    }
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OrientationBuilder(
            builder: (BuildContext context, Orientation orientation) {
              return Container(
                  width: widget.width,
                  height: widget.height,
                  margin: EdgeInsets.all(5),
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.5),
                        spreadRadius: 2,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.black
                    ),
                      onPressed: (){
                        if(!widget.isMYproperties)
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>DetailScreen(user:widget.user,allProperties:widget.allProperties)));
                         else{
                           _MyProperties();
                        }
                        },
                      child:widget.orientation == LayoutOrientation.vertical
                      ? Vertical(widget.issold)
                      : Horizontal(widget.issold))
              );
            },
          );
        }
    );
  }
  // Vertical Widget

  Widget Vertical(bool issold){
    return Column(
      children: [
        ImageContainer(double.infinity,120,issold),
        SizedBox(height: 15),
        TextContainer()
      ],
    );
  }
  // Horizonatal Widget

  Widget Horizontal(bool issold){
    return Row(
      children: [ImageContainer(150,double.infinity,issold), SizedBox(width: 15), TextContainer()],
    );
  }

  Widget ImageContainer(double w, double h, bool isSold) {
    if (widget.allProperties==null) {
      return Container(); // Return an empty container if the property list is empty
    }
    return Stack(
      children: <Widget>[
        Container(
          width: w,
          height: h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: widget.allProperties.images.isNotEmpty?
            Image.file(widget.allProperties.images[0],
              width: 200, // Adjust width as needed
              height: 200, // Adjust height as needed
              fit: BoxFit.cover,
            ):
                Image.asset("assets/images/house_01.jpg"),
          ),
        ),
        Positioned(
          top: 10,
          left: 10,
          child: Icon(
            isSold ? Icons.check_circle : Icons.monetization_on,
            color: Colors.yellowAccent,
            size: 30,
          ),
        ),
      ],
    );
  }


  Widget TextContainer() {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "${widget.allProperties.price}PKR",
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: 5),
          Row(
            children: [
              Icon(
                Icons.place,
                size: 16,
                color: Colors.red,
              ),
              SizedBox(width: 5),
              Text(
                "${widget.allProperties.city}/Pakistan",
                style: TextStyle(fontSize: 12),
              ),
            ],
          ),
          SizedBox(height: 40),
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.bedroom_child, size: 26),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${widget.allProperties.bedrooms}",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                SizedBox(width: 10),
                Icon(Icons.bathtub, size: 26),
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    "${widget.allProperties.bathrooms}",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                
              ],
            ),
          ),
        ],
      ),
    );
  }
  _MyProperties(){
    showModalBottomSheet(
      context: context,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            ListTile(
              leading: Icon(Icons.edit),
              title: Text('Edit Property'),
              onTap: () {
                // Implement edit functionality
                Navigator.pop(context); // Close the bottom sheet
                Navigator.push(context,MaterialPageRoute(builder: (context)=>EditProperty(user:widget.user,allProperties:widget.allProperties)));
              },
            ),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text('Delete Property'),
              onTap: () {
                Navigator.pop(context); // Close the bottom sheet
                showDeleteConfirmationDialog(context, 1);
              },
            ),
          ],
        );
      },
    );
  }
  void showEditPropertyDialog(BuildContext context) {
    // Implement the edit property dialog
    // You can use a dialog or navigate to a new screen for editing
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Property'),
          content: Text('Edit property details here.'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Implement the edit functionality
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Save'),
            ),
          ],
        );
      },
    );
  }

  void showDeleteConfirmationDialog(BuildContext context, int index) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Confirm Deletion'),
          content: Text('Are you sure you want to delete this property?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: _deleteProperty,
              child: Text('Delete'),
            ),
          ],
        );
      },
    );
  }



}


// for horizontal orientation: LayoutOrientation.horizontal,height:150,width: MediaQuery.of(context).size.width
// for vertical