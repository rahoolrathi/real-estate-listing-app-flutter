import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:housing_hub/Screens/home_screen.dart';
import 'package:housing_hub/Screens/profile_setting_screen.dart';
import 'package:image_picker/image_picker.dart';

import '../classess/Property.dart';
import '../classess/User.dart';
class ProfilePage extends StatefulWidget {
  ProfilePage({required this.user,required this.allProperties});
  User user;
  final List<Property> allProperties;
  @override State<ProfilePage> createState() => _ProfilePageState();
}
class _ProfilePageState extends State<ProfilePage> {
  int index=0;
  File? _image;
  String path="assets/images/programmer.png";
  Future<bool> _pickImages() async {
    final ImagePicker picker = ImagePicker();
    try {
      Loader.show(context, isAppbarOverlay: true, overlayColor: Colors.transparent);
      XFile? pickedImage = await picker.pickImage(source: ImageSource.gallery);

      if (pickedImage != null) {
        setState(() {
          _image = File(pickedImage.path);

        });
        print("kkkkkkkkkkkkkkkkkk $_image");
        widget.user.setImage(_image!);
        widget.user.UpdateUser();
        await widget.user.fetchingUserData(widget.user.username);
        return true;
      } else {
        setState(() {});
        return false;
      }
    } catch (e) {
      setState(() {});
      return false;
    } finally {
      Loader.hide();
    }
  }


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        home:Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                GestureDetector(child: Icon(Icons.arrow_back),
                  onTap: (){
                    Navigator.pop(context);
                    Navigator.push(context,MaterialPageRoute(builder: (context)=>HomePage(widget.user, allProperties: widget.allProperties)));
                  },
                ),
                SizedBox(width: 120,),
                Center(
                  child: Text('Profile',
                    style: TextStyle(
                      color: Colors.black,
                    ),
                  ),
                ),
              ],
            ),
          ),
          body: body(context),
        )
    );
  }
  Widget body(context){

    return Column(
      children: [
        SizedBox(height: 30,),
        ProfilePicture(),
        SizedBox(height: 20,),

        ProfileMenu(
          text: "Profile Settings",
          icon: Icon(Icons.settings,
            weight: 22,
            color: Colors.grey,
          ),
          press: (){
            showModalBottomSheet(context: context, builder: (context)=>ProfileSetting(widget.user,widget.allProperties),isScrollControlled: true);
          },
        ),
        ProfileMenu(
          text: "Contact Us",
          icon: Icon(Icons.phone,
            weight: 22,
            color: Colors.grey,
          ),
          press: (){
            _showContactUsDialog(context);
          },
        ),
        ProfileMenu(
          text: "About Us",
          icon: Icon(Icons.info,
            weight: 22,
            color: Colors.grey,
          ),
          press: (){
            _showAboutUsDialog(context);
          },
        ),
        ProfileMenu(
          text: "Feedback",
          icon: Icon(Icons.thumb_up,
            weight: 22,
            color: Colors.grey,
          ),
          press: (){
            _showFeedbackDialog(context);
          },
        ),
        ProfileMenu(
          text: "Log Out",
          icon: Icon(Icons.logout,
            weight: 22,
            color: Colors.red,
          ),
          press: (){
            Navigator.pushNamedAndRemoveUntil(context, '/MainPage', (route) => false);
          },
        ),

      ],
    );
  }
  Widget ProfilePicture() {
    return Column(
      children: [
        SizedBox(
            height: 115,
            width: 115,
            child: Stack(
              fit: StackFit.expand,
              children: [
              CircleAvatar(
              backgroundColor: Colors.green,
                child:widget.user.userimage==null?Text("R"):ClipOval(child:Image.file(widget.user.userimage!,height: 200,
                  width: 200,
                  fit: BoxFit.cover,)),
            ),
            Positioned(
                bottom: 0,
                right: 0,
                child: SizedBox(
                    height: 46,
                    width: 46,
                    child: TextButton(
                        style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            side: BorderSide(color: Colors.white),
                            backgroundColor: Color(0xFFF5F6F9),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(50))
                        ),
                        child: Icon(Icons.camera_alt,
                          color: Colors.grey,

                        ),
                        onPressed: (){
                          _pickImages();
                        }
                )))
      ],
    )
    ),
    ],
    );
  }

}
class ProfileMenu extends StatelessWidget {
  ProfileMenu({
    required this.text,
    required this.icon,
    required this.press,
});
  final String text;
  final Icon icon;
  final VoidCallback press;


  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
      child: TextButton(
        style: TextButton.styleFrom(
            padding: EdgeInsets.all(20),
            backgroundColor: Color(0xFFF5F6F9),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15))
        ),
        onPressed:press,
        child: Row(
          children: [
            icon,
            SizedBox(
              width: 20,
            ),
            Expanded(child: Text(text,
            style: TextStyle(
              color: Colors.black
            ),
            )),
            Icon(Icons.arrow_forward_ios,
                weight: 22,
                color: Colors.black
            ),

          ],


        ),
      ),
    );
  }
}
void _showFeedbackDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Text('Feedback'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Please rate your experience:'),
            RatingBar.builder(
              initialRating: 0,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: false,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
              itemBuilder: (context, _) => Icon(
                Icons.star,
                color: Colors.amber,
              ),
              onRatingUpdate: (rating) {
                // Handle the rating value
                print('Rated: $rating stars');
              },
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Submit',style:TextStyle(color:Colors.green)),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('Cancel',style: TextStyle(color:Colors.red),),
          ),
        ],
      );
    },
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