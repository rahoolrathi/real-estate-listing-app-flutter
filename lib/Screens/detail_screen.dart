import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../classess/Property.dart';
import '../classess/User.dart';
import '../classess/imageWidget.dart';
class DetailScreen extends StatefulWidget {
  DetailScreen({required this.user,required this.allProperties});
  final User user;
  final Property allProperties;
  @override
  State<DetailScreen> createState() => _DetailScreenState();
}
class _DetailScreenState extends State<DetailScreen> {

  final Uri phonenumber=Uri.parse("tel:+92342-0488832");
  final Uri whatsapp=Uri.parse("https://wa.me/+92342-0488832");
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Column(
        children: [
          SizedBox(
            height: 270,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: widget.allProperties.images.length,
              itemBuilder: (BuildContext context, int index) {
                return Container(
                  width: MediaQuery.of(context).size.width,
                  child: Stack(
                    children: [
                      Image.file(widget.allProperties.images[index],
                        // Adjust height as needed
                        fit: BoxFit.fitWidth,
                      ),
                      Positioned(
                        top: 70,
                        left: 30,
                        child: Container(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pop(context);
                            },
                            child: Icon(
                              Icons.arrow_back_ios,
                              color: Colors.white,
                              size: 30,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: EdgeInsets.only(left: 10),
                child: ListView(
                  children: <Widget>[
                    Padding(
                      padding: EdgeInsets.only(left: 5),
                      child: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 100,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Row(
                              children: [
                                Container(
                                  height: 65,
                                  width: 55,
                                  decoration: BoxDecoration(
                                      image: backgroundimage(widget.allProperties.user.userimage),
                                      shape: BoxShape.circle),
                                ),
                                SizedBox(
                                  width: 8,
                                ),
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${widget.allProperties.user.fullname}",
                                      style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(
                                      height: 4,
                                    ),
                                    Text(
                                      "${widget.allProperties.user.username}",
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                  ],
                                ),
                                SizedBox(width: 16,),
                                Container(
                                  width: 45,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius:BorderRadius.circular(10)
                                  ),
                                  child: TextButton(
                                    onPressed: ()async{
                                      try{
                                        await launchUrl(phonenumber);}
                                      catch(error){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(error.toString()),
                                          ),
                                        );
                                      }
                                    },
                                    child: Icon(Icons.phone,color: Colors.green,),
                                  ),
                                ),
                                SizedBox(width: 8,),
                                Container(
                                  width: 45,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius:BorderRadius.circular(10)
                                  ),
                                  child: TextButton(
                                    onPressed: ()async{
                                      try{
                                        await launchUrl(whatsapp);}
                                      catch(error){
                                        ScaffoldMessenger.of(context).showSnackBar(
                                          SnackBar(
                                            content: Text(error.toString()),
                                          ),
                                        );
                                      }
                                    },
                                    child: Icon(Icons.message,color: Colors.green),
                                  ),
                                ),
                                SizedBox(width: 8,),
                                Container(
                                  width: 45,
                                  height: 40,
                                  decoration: BoxDecoration(
                                      color: Colors.grey.shade100,
                                      borderRadius:BorderRadius.circular(10)
                                  ),
                                  child: TextButton(
                                      onPressed: (){},
                                      child:Image.asset("assets/images/whatsapplogo.png",fit: BoxFit.fill,)
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Row(
                                  children: [
                                    Text("${widget.allProperties.area}",
                                      style: TextStyle(
                                          color: Colors.grey.shade500
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Icon(Icons.area_chart,
                                      color: Colors.yellow,
                                      size: 25,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${widget.allProperties.bedrooms}",
                                      style: TextStyle(
                                          color: Colors.grey.shade500
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Icon(Icons.bedroom_child_outlined,
                                      color: Colors.yellow,
                                      size: 25,
                                    )
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text("${widget.allProperties.bathrooms}",
                                      style: TextStyle(
                                          color: Colors.grey.shade500
                                      ),
                                    ),
                                    SizedBox(width: 5,),
                                    Icon(Icons.bathtub,
                                      color: Colors.yellow,
                                      size: 25,
                                    )
                                  ],
                                ),

                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: 10),
                    Text("Descripation",
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold
                      ),
                    ),
                    Padding(
                        padding: EdgeInsets.all(2),
                        child: Container(
                          height: 120,
                          width: MediaQuery.of(context).size.width,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child:Text(
                              "${widget.allProperties.description}",
                              style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.grey.shade500
                              ),
                            ),
                          ),)
                    ),
                    SizedBox(height:10),
                    Text("Finnace",style:TextStyle(fontWeight: FontWeight.bold,fontSize: 20)),
                    SizedBox(height:10),
                    SizedBox(height:10),
                    Padding(
                      padding: EdgeInsets.only(left:10,right: 10),
                        child: buildInstallmentText(),
                    ),
                    SizedBox(height: 5,),
              if (widget.allProperties.isInstallmentAvailable)
          Padding(
            padding: EdgeInsets.only(left: 10, right: 20),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Down Payment", style: TextStyle(fontSize: 15)),
                    Text("${widget.allProperties.finnace.advanceAmount}", style: TextStyle(color: Colors.green)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("Installment Amount", style: TextStyle(fontSize: 15)),
                    Text("${widget.allProperties.finnace.installmentAmount}", style: TextStyle(color: Colors.green)),
                  ],
                ),
                SizedBox(height: 5),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text("No of Installments", style: TextStyle(fontSize: 15)),
                    Text("${widget.allProperties.finnace.noOfInstallments}", style: TextStyle(color: Colors.green)),
                  ],
                ),
                SizedBox(height: 5),
              ],
            ),
          ),
          SizedBox(height: 40,),
                    Center(
                        child:Container(
                          width: 200,
                          height: 50,
                          child: ElevatedButton(
                              onPressed: _addinfavorties,
                              style: ButtonStyle(
                                backgroundColor:MaterialStateProperty.all(Colors.pink),
                              ),
                              child: Text("Add in favorites",style: TextStyle(
                                  color: Colors.white
                              ),)
                          ),
                        )
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
  _addinfavorties(){
   // Navigator.pop(context);
  }


  Widget? buildInstallmentText() {
    if (!(widget.allProperties.isInstallmentAvailable)) {
      return  Row(
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: <Widget>[
    Text("Installment"),
    SizedBox(width: 40,),
    Text("Not Available", style: TextStyle(color: Colors.red))
    ],);
    }
    return null;
    }
  }







