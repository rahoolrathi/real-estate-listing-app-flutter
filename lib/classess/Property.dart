import 'dart:convert';
import 'dart:ffi';
import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:housing_hub/classess/User.dart';
import 'package:housing_hub/defined_constants.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import 'Finnace.dart';
class Property {
  int propertyId=-1;
  String propertyType="";
  User user=User();
  String city="";
  double area=0.toDouble();
  double price=0.toDouble();
  int bedrooms=0;
  int bathrooms=0;
  bool isInstallmentAvailable=false;
  Finnace finnace=Finnace();
  String title="";
  String description="";
  List<File> images=[];
  String date="";
    Property();
  Property.full({
    required this.propertyType,
    required this.user,
    required this.city,
    required this.area,
    required this.price,
    required this.bedrooms,
    required this.bathrooms,
    required this.isInstallmentAvailable,
    this.date="",
    required this.title,
    required this.description,
    required this.images,
  });
  setFinnace(Finnace finnace){
    this.finnace=finnace;
  }
  Future<Map<String, dynamic>> toMap() async {
    List<String> base64Images = [];

    for (File imageFile in images) {
      String base64Image = await convertFileToBase64(imageFile);
      base64Images.add(base64Image);
    }

    return {
      'propertyType': propertyType,
      'user': user.toMap(),
      'city': city,
      'area': area,
      'price': price,
      'bedrooms': bedrooms,
      'bathrooms': bathrooms,
      'isInstallmentAvailable': isInstallmentAvailable,
      'finnace': finnace.toMap(),
      'title': title,
      'description': description,
      'images': base64Images,
    };
  }
  Future<String> convertFileToBase64(File file) async {
    try {
      List<int> imageBytes = await file.readAsBytes();
      return base64Encode(imageBytes);
    } catch (e) {
      print('Error converting file to base64: $e');
      throw e; // Handle the error appropriately
    }
  }

  Future<File?> downloadAndSaveImage(dynamic imageData) async {
    try {
      // Getting app's local documents directory
      final Directory localDocumentsDirectory =
      await getApplicationDocumentsDirectory();

      // Creating a subdirectory for images within the documents directory
      final String subdirectoryName = 'property_images';
      final Directory subdirectory =
      await localDocumentsDirectory.createTemp(subdirectoryName);

      if (imageData is Map<String, dynamic> && imageData['type'] == 'Buffer') {
        // Extract binary data from the Buffer
        List<int> imageBytes = List<int>.from(imageData['data']);

        // Create a temporary file within the subdirectory to store the image
        File tempFile = File(
            '${subdirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png');

        // Write image bytes to the file
        await tempFile.writeAsBytes(imageBytes);
        return tempFile;
      }
    } catch (error) {
      throw Exception('Error downloading and saving image: $error');
    }
    return null;
  }






  Future<List<Property>> FetchingProperties(username,filters) async {
    try {
      var response;
      if(filters==null) {
        response = username==null?await http.get(Uri.parse(GETPROPERTIESURL)):await http.get(Uri.parse('$GETMYPROPERTIES$username'));
      }
      else {
        String jsonString = jsonEncode(filters);
        response=await http.get(Uri.parse('$applyfilterProperty$jsonString'));
      }

      if (response.statusCode == 200) {
        Map<String,dynamic> responsebody=json.decode(response.body);
        if(responsebody['data']['properties']=='Done')
          {
            return [];
          }
        List<dynamic> data = responsebody['data']['properties'];
        List<Property> properties = [];

        for (var item in data) {
          File? userImageFile;
          if (item['user']['userimage'] != null) {
            userImageFile = await downloadAndSaveImage(item['user']['userimage']);
          }

          // Create the User instance
          User user = User.full(
            username: item['user']['username'] ?? '',
            fullname: item['user']['fullname'] ?? '',
            phonenumber: item['user']['phonenumber'] ?? 0,
            password: item['user']['password'] ?? '',
            userimage: userImageFile,
          );
          Property property = Property.full(
            propertyType: item['propertyType']??'',
            user: user,
            city:  item['city'] ?? '',
            area: item['area']!=null?item['area'].toDouble():0.toDouble(),
            price: item['area']!=null?item['price'].toDouble():0.toDouble(),
            bedrooms: item['bedrooms'],
            bathrooms: item['bathrooms'],
            isInstallmentAvailable: (item['isInstallmentAvailable'] ?? 0) > 0,
            title: item['title']??" ",
            date:item['dateposted']??" ",
            description: item['descripation']??" ",
            // Initialize images as an empty list
            images: [],
          );
          property.propertyId=item['propertyID'];
    if(item['finnace'].isNotEmpty){
            property.finnace=Finnace.fromMap(item['finnace']);
          }
          else{
            property.finnace=Finnace();
          }

          await property.downloadAndSaveImages(item['images']);

          properties.add(property);

        }
        return properties;
      } else {
        print('Failed to fetch property details. Status Code: ${response.statusCode}');
        print('Response Body: ${response.body}');
        throw Exception('Failed to fetch property details');
      }
    } catch (error) {
      print('Error fetching property details: $error');
      throw Exception(error.toString());
    }
  }

  Future<void> downloadAndSaveImages(List<dynamic> imagesData) async {
    try {
      // Getting app's local documents directory
      final Directory localDocumentsDirectory =
      await getApplicationDocumentsDirectory();

      // Creating a subdirectory for images within the documents directory
      final String subdirectoryName = 'property_images';
      final Directory subdirectory =
      await localDocumentsDirectory.createTemp(subdirectoryName);

      // Iterate through the image data
      for (var imageData in imagesData) {
        try {
          if (imageData is Map<String, dynamic> && imageData['type'] == 'Buffer') {
            // Extract binary data from the Buffer
            List<int> imageBytes = List<int>.from(imageData['data']);

            // Create a temporary file within the subdirectory to store the image
            File tempFile =
            File('${subdirectory.path}/${DateTime.now().millisecondsSinceEpoch}.png');

            // Write image bytes to the file
            await tempFile.writeAsBytes(imageBytes);

            // Set permissions for the file


            // Add the file to the list of property images
            images.add(tempFile);
          }
        } catch (error) {
          print('Error downloading and saving image: $error');
        }
      }
    } catch (error) {
      print('Error creating directory and saving images: $error');
    }
  }




  Future<List<String>> convertingFileToBase64Images(List<File> images) async {

    List<String> base64Images = [];
    for (File imageFile in images) {
      List<int> imageBytes = await imageFile.readAsBytes();
      String base64Image = base64Encode(imageBytes);
      base64Images.add(base64Image);
    }
    return base64Images;
  }

  Future<String> postProperty() async {
    // Convert user image to base64
    String userImageBase64 = '';
    if (user.userimage != null) {
      userImageBase64 = await convertFileToBase64(user.userimage!);
    }

    // Convert property images to base64
    List<String> propertyImageBase64 = await convertingFileToBase64Images(images);

    // Build the request body
    Map<String, dynamic> requestBody = await toMap();
    requestBody['user']['userimage'] = userImageBase64;
    requestBody['images'] = propertyImageBase64;

    try {
      final response = await http.post(
        Uri.parse(POSTPROPERTYURL),
        body: jsonEncode(requestBody),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        return 'Property Posted successfully';
      } else {
        return response.body;
      }
    } catch (error) {
      print('Error creating property: $error');
      throw Exception(error);
    }
  }


  Future<String> deleteProperty() async {
    final String deleteUrl = '$deleteMyProperty$propertyId'; // Replace with your specific endpoint
    try {
      final response = await http.delete(Uri.parse('$deleteUrl'));

      if (response.statusCode == 202) {
        return "Done";
      } else {
        return ("Property not found${response.statusCode}");
      }
    } catch (error) {
      throw Exception("Error deleting property: $error");
    }
  }
}
