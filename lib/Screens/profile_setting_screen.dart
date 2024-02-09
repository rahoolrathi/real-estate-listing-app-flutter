
import 'package:flutter/material.dart';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';

import '../Componnets/horizontalDivider.dart';
import '../classess/Property.dart';
import '../classess/User.dart';

class ProfileSetting extends StatefulWidget {
  ProfileSetting(this.user,this.allProperties);
   User user;
   List<Property> allProperties;
  @override
  State<ProfileSetting> createState() => _ProfileSettingState();
}

class _ProfileSettingState extends State<ProfileSetting> {
  bool _obscurePassword = true;
  final _formKey = GlobalKey<FormState>();
  TextEditingController passwordController=new TextEditingController();
  TextEditingController nameController=new TextEditingController();
  @override
  void initState() {
    super.initState();

    // Initialize controllers here using widget properties
    passwordController = TextEditingController(text: "${widget.user.password}");
    nameController = TextEditingController(text: "${widget.user.fullname}");
  }


  _Update()async{
     String result;
    if(_formKey.currentState!.validate())
      {
        try{
          Loader.show(context, isAppbarOverlay: true);
            widget.user.fullname=nameController.text;
            widget.user.password=passwordController.text;
            result=await widget.user.UpdateUser();
             widget.user.fetchingUserData(widget.user.username);
             Loader.hide();
        }
        catch(error){
          Loader.hide();
             result=error.toString();
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: result=='Done'?Colors.green:Colors.red,
            content: Text(result),
          ),
        );
        Navigator.pop(context);
      }

  }
  @override
  Widget build(BuildContext context) {
    return Container(
        color: Color(0xff757575),
        child: Container(
          height: 450,
          width: double.infinity,
          padding: EdgeInsets.only(top:10,left:0,right: 5),
          decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(
                  topRight: Radius.circular(20),
                  topLeft: Radius.circular(20)
              )
          ),
          child: Padding(
              padding: EdgeInsets.only(top: 15,left: 10),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                   Row(
                     children: <Widget>[
                       Icon(Icons.settings,
                         size: 25,
                         color: Colors.grey,
                       ),
                       SizedBox(width: 10,),
                       Text("Profile Settings",
                       style: TextStyle(fontSize:20,fontWeight: FontWeight.w600,color: Colors.grey ),)

                     ],
                   ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: nameController,
                      decoration: InputDecoration(
                        label:Text("Name",style: TextStyle(color: Colors.grey),),
                        prefixIcon:Icon(Icons.person),
                        contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: BorderSide(
                                color:Colors.green
                            )
                        ),
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: BorderSide(
                                color:Colors.grey
                            )
                        ),

                      ),
                      validator: (value){
                        if(value!.isEmpty)
                          return "*name is required";
                      },
                    ),
                    SizedBox(height: 20,),
                    TextFormField(
                      controller: passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        label:Text("Password",style: TextStyle(color: Colors.grey),),
                        prefixIcon: Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _obscurePassword = !_obscurePassword;
                            });
                          },
                        ),
                        contentPadding:
                        EdgeInsets.symmetric(vertical: 0, horizontal: 20),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: BorderSide(
                                color:Colors.green
                            )
                        ),
                        border:OutlineInputBorder(
                            borderRadius: BorderRadius.circular(21),
                            borderSide: BorderSide(
                                color:Colors.grey
                            )
                        ),

                      ),
                      validator: (value){
                        if(value!.isEmpty)
                          return "*Password is required";
                        else if(value!.length<6)
                          return "*Password must be greater than 6 characters";
                      },
                    ),
                    SizedBox(height: 40,),
                    Center(
                        child:Container(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: _Update,
                                style: ButtonStyle(
                                  backgroundColor:MaterialStateProperty.all(Colors.green),
                                ),

                              child: Text("Update",style: TextStyle(
                                color: Colors.white
                              ),)
                          ),
                        )
                    ),





                  ],

                ),
              )
          ),

        ));
  }
}
