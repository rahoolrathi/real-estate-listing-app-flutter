
import 'dart:io';
import 'package:flutter_overlay_loader/flutter_overlay_loader.dart';
import 'package:housing_hub/Screens/home_screen.dart';
import 'package:housing_hub/Screens/login_screen.dart';
import 'package:housing_hub/Screens/my_properties.dart';
import 'package:housing_hub/classess/Property.dart';
import 'package:image_picker/image_picker.dart';
import 'package:housing_hub/Componnets/horizontalDivider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../classess/User.dart';
import '../defined_constants.dart';

class EditProperty extends StatefulWidget {
  EditProperty({required this.user,required this.allProperties});
  final User user;
  final Property allProperties;
  @override
  State<EditProperty> createState() => _EditPropertyState();
}
class _EditPropertyState extends State<EditProperty> {
  final _formKey = GlobalKey<FormState>();
  bool _imagesSelected = false;
  String _erromessageImage="Please select at least one image";

  String selectedtype='Home';
  String selectedcity="Karachi";
  String selectedbathrooms='1';
  String selectedbedrooms='1';
  String username="user1";   //it will updated latter
  List<File> _selectedImages = [];
  TextEditingController areaController = TextEditingController();
  TextEditingController priceController = TextEditingController();
  TextEditingController advanceAmountController = TextEditingController();
  TextEditingController installmentAmountController = TextEditingController();
  TextEditingController noOfInstallmentsController = TextEditingController();
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  bool isInstallmentAvailable = false;


  Uploadingindb()async {
    String result;
    try{
      // Loader.show(context, isAppbarOverlay: false);
      // Property newproperty=new Property.full(propertyType: selectedtype, email:username, city: selectedcity,
      //   area: double.parse(areaController.text), price: double.parse(priceController.text), bedrooms: int.parse(selectedbedrooms),
      //   bathrooms: int.parse(selectedbathrooms), isInstallmentAvailable: isInstallmentAvailable,
      //   title: titleController.text, description: descriptionController.text, images:_selectedImages,);
      // if(isInstallmentAvailable){
      //   newproperty.setFinnaceValue(double.parse(advanceAmountController.text),
      //       double.parse(installmentAmountController.text),
      //       int.parse(noOfInstallmentsController.text));
      //
      // }//result=await newproperty.postProperty();
    }catch(e){
      result=e.toString();
    }
    finally{
      Loader.hide();
    }

    // ScaffoldMessenger.of(context).showSnackBar(
    //   SnackBar(
    //     backgroundColor: result=='Property Updated successfully'?Colors.green:Colors.red,
    //     content: Text(result),
    //   ),
    // );

  }
  onPostAd () async {
    if(_formKey.currentState!.validate())
    {
      await Uploadingindb();
      Navigator.pop(context);
     // Navigator.push(context, MaterialPageRoute(builder: (context)=> MyProperties(user: widget.user,allProperties: widget.allProperties,)));
    }

  }
  Future<bool> _pickImages() async {
    final ImagePicker picker=ImagePicker();
    try {
      Loader.show(context, isAppbarOverlay: true, overlayColor: Colors.transparent);
      final List<XFile> pickedImages = await picker.pickMultiImage();
      print("user selected image is starts $pickedImages");
      if (pickedImages != null&&pickedImages.isNotEmpty) {
        setState(() {
          _imagesSelected=true;
          _selectedImages.clear();
          _selectedImages.addAll(pickedImages.map((xFile) => File(xFile.path)));

        });

        return true;
      } else {
        setState(() {
          _imagesSelected=false;
          _selectedImages.clear();
          _erromessageImage="Please select at least one image";
        });
        return false;
      }
    } catch (e) {
      setState(() {
        _imagesSelected=false;
        _selectedImages.clear();
        _erromessageImage="'Error picking images: $e";
      });
      return false;
    }
    finally{
      Loader.hide();
    }



  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            flex: 2,
            child: Container(
              padding: EdgeInsets.only(top: 20),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(30.0),
              ),
              child: Padding(
                padding: EdgeInsets.only(top: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Text(
                      'Update an Ad',
                      style: TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(width: 10),
                    Stack(
                      children: [
                        Image.asset(
                          'assets/images/add_property_logo.png',
                          width: 200,
                          height: 150,
                        ),
                        Positioned(
                          top: 0,
                          left: 100,
                          right:0,
                          child: GestureDetector(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>LoginPage()));
                            },
                            child: Icon(
                              Icons.chevron_right_sharp,
                              color: Colors.black,
                              size: 60,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 5,
            child: Padding(
              padding: EdgeInsets.only(left: 10,right: 10),
              child: Form(
                key: _formKey,
                child: ListView(
                  scrollDirection:Axis.vertical,
                  children: <Widget>[
                    _DropDownListWidgets(['Home', 'Flat', 'Apartment', 'Hotels'],selectedtype,"Select Propery Type",300,(String ?value){
                      setState(() {
                        selectedtype=value!;
                      });
                    }),
                    SizedBox(height: 20,),
                    HorizontalDivider(),
                    SizedBox(height: 20,),
                    _DropDownListWidgets(cities, selectedcity,"City",300,(String ?value){
                      setState(() {
                        selectedcity=value!;
                      });
                    }),
                    SizedBox(height: 20,),
                    HorizontalDivider(),
                    SizedBox(height: 20,),
                    //String name,String title,String hint,String unit,bool inputline
                    _InputFormComponnets("Area","Area Size","Enter area size","sq.M",true,areaController),
                    SizedBox(height: 20,),
                    HorizontalDivider(),
                    SizedBox(height: 20,),
                    _InputFormComponnets("Price","Total Price","Enter amount","Pkr",true,priceController),
                    SizedBox(height: 20,),
                    HorizontalDivider(),
                    SizedBox(height: 20,),
                    _installmentAvailable(),
                    SizedBox(height: 20,),
                    if (isInstallmentAvailable)
                      ...[
                        SizedBox(height: 20,),
                        _InputFormComponnets("Advance Amount","Advance Amount","Enter amount","",true,advanceAmountController),
                        SizedBox(height: 20,),
                        HorizontalDivider(),
                        SizedBox(height: 20,),
                        _InputFormComponnets("Installment amount","Monthly Installment","Enter amount","",true,installmentAmountController),
                        SizedBox(height: 20,),
                        HorizontalDivider(),
                        SizedBox(height: 20,),
                        _InputFormComponnets("No.of Installment Remaining","No.of Installment Remaining","Enter no. of months","",true,noOfInstallmentsController),
                        SizedBox(height: 20,),
                        HorizontalDivider(),
                      ],
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
                    _InputFormComponnets("Title","Property Title","Enter Title e.g Beautiful new House","",true,titleController),
                    SizedBox(height: 20,),
                    HorizontalDivider(),
                    SizedBox(height: 20,),
                    HorizontalDivider(),
                    SizedBox(height: 20,),
                    _propertyDescripation(),
                    SizedBox(height: 20,),
                    HorizontalDivider(),
                    SizedBox(height: 20,),
                    imageField()
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              padding: EdgeInsets.all(20),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async{
                  if (_imagesSelected) {
                    onPostAd();} else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(_erromessageImage),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                },
                style: ElevatedButton.styleFrom(
                  primary: Colors.green,
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                ),
                child: Text(
                  'Update Ad',
                  style: TextStyle(fontSize: 18,color:Colors.white),
                ),
              ),
            ),
          )
          //top container
        ],
      ),

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
  Widget imageField() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.image,
          color: Colors.grey,
        ),
        SizedBox(width: 20),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Upload images for your property",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20),
            Container(
                width: 200,
                height: 50,
                child: ElevatedButton.icon(
                  onPressed: () => _pickImages(),
                  style: ElevatedButton.styleFrom(
                    primary: Colors.green,
                  ),
                  icon: Icon(Icons.image,color:Colors.grey.shade400),
                  label: Text("Upload Images",style: TextStyle(color:Colors.white),

                  ),
                )),
          ],
        ),
      ],
    );
  }
  Widget _propertyDescripation() {
    double inputWidth = 320;
    double inputHeight = 200;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.tag,
          color: Colors.grey,
        ),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Property Description",
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(height: 20,), // Adjust as needed
            Container(
              padding: EdgeInsets.all(5),
              width: inputWidth,
              height: inputHeight,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10), // Adjust the border radius as needed
                border: Border.all(
                  color: Colors.grey,
                  width: 1.0, // Adjust the border thickness as needed
                ),
              ),
              child: _InputForm("Descripation","Enter Title e.g Beautiful new House", "",false,descriptionController),
            ),
          ],
        ),
      ],
    );
  }
  Widget _InputForm(String name,String hintst,String unit,bool showline,TextEditingController controller){
    return Container(
      width: double.infinity,
      child: TextFormField(
        keyboardType: (name!="Title"&&name!="Descripation")?TextInputType.number:TextInputType.text,
        inputFormatters:  <TextInputFormatter>[
          if (name != "Title" && name != "Descripation")
            FilteringTextInputFormatter.digitsOnly],
        // Add your other formatter here if needed,
        decoration: InputDecoration(
          hintText: hintst,
          suffix: Text(unit),
          enabledBorder: showline
              ? UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.grey.shade300),
          )
              : InputBorder.none,
          focusedBorder: showline
              ? UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.green),
          )
              : InputBorder.none,
        ),
        validator: (value){
          if(value!.isEmpty)
            return "*$name is required";
          if(priceController.text.isNotEmpty&&advanceAmountController.text.isNotEmpty){
            if(double.parse(priceController.text)<double.parse(advanceAmountController.text)&&name=="Advance Amount")
              return "*advance must less then total amount";
            if(installmentAmountController.text.isNotEmpty){
              if(double.parse(priceController.text)-double.parse(advanceAmountController.text)<double.parse(installmentAmountController.text)&&name=="Installment amount")
                return "*Installment amount can not be greater than the remaining amount";}
          }},
        controller: controller,
      ),
    );
  }
  Widget _InputFormComponnets(String name,String title,String hint,String unit,bool inputline,TextEditingController controller){
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Icon(
          Icons.tag,
          color: Colors.grey,
        ),
        SizedBox(width: 20,),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(title,
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            SizedBox(width: 20,),
            Container(
              width: 200,
              child:_InputForm(name,hint,unit,inputline,controller),
            ),
          ],
        ),
      ],
    );
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

}




