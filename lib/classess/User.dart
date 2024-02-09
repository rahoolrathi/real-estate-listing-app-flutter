import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

import '../defined_constants.dart';

class User {
  String username="";
  String fullname="";
  int phonenumber=0;
  String password="";
  File? userimage; // Using nullable type for userimage

// Constructor
  User(){}

  User.full({
    required this.username,
    required this.fullname,
    required this.phonenumber,
    required this.password,
    this.userimage,
  });
  Map<String, dynamic> toMap() {
    return {
      'username': username,
      'fullname': fullname,
      'phonenumber': phonenumber,
      'password': password,
      'userimage': userimage,
    };
  }

  factory User.fromMap(Map<String, dynamic> map) {
    return User.full(
      username: map['username'] ?? '',
      fullname: map['fullname'] ?? '',
      phonenumber: map['phonenumber'] ?? '',
      password: map['password'] ?? '',
      userimage: map['userimage'],
    );
  }
  setEmail(String u){
    username=u;
  }
  setName(String n){
    this.fullname=n;
  }
  setPassword(String pass){
    password=pass;
  }
  setNumber(int n){
    phonenumber=n;
  }
  setImage(File image){
    userimage=image;
  }
  bool loginValidation(String e,String p){
    if(this.username==e&&this.password==p)
      return true;
    return false;
  }
  display(){
    print('Username: $username');
    print('Full Name: ${fullname}');
    print('Phone Number: $phonenumber}');
    print('Password: ${password}');
  }


  Future<String>UpdateUser()async{
    try {
      Map<String,dynamic> requestbody=toMap();
      if(userimage!=null) {
        requestbody['userimage']=await convertFileToBase64Image(userimage!);
      }

      final response = await http.put(Uri.parse('http://$API/api/v1/user/$username'),
        body: jsonEncode(requestbody),
        headers: {
          'Content-Type': 'application/json',
        },
      );
      print(response.statusCode);
      if (response.statusCode == 200) {
        return 'Done';
      } else {
        return 'Failed to Update user.${response.body.toString()}';
      }
    } catch (error) {
      return error.toString();
    }
  }

  Future<String>fetchingUserData(String username)async {


      try {
        final response = await http.get(Uri.parse('http://$API/api/v1/user/$username'));
        print(response);
        if (response.statusCode == 200) {
          final Map<String, dynamic> data = json.decode(response.body);
          print(data);
          Map<String, dynamic> user = data['data']['user'][0];
          print(user);
          String s=user['username'];
          String n=user['fullname'];
          int nu=user['phonenumber'];
          String p=user['password'];
          if(user['userimage']!=null) {
            downloadAndSaveImage(user['userimage']);
          }

          setName(n);
          setEmail(s);
          setNumber(nu);
          setPassword(p);
          return 'sucess';
        } else {
          return "User Not Found";
         // throw Exception(response.reasonPhrase);
        }
      } catch (error) {
        throw Exception(error.toString());
      }
    }



  Future<void> downloadAndSaveImage(dynamic imageData) async {
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
        setImage(tempFile);
      }
    } catch (error) {
      throw Exception('Error downloading and saving image: $error');
    }
  }






// email checker
  bool isEmailValid(String email) {
    // Regular expression to validate email format
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@gmail\.com$');
    return emailRegex.hasMatch(email);
  }


  bool isPhoneNumberValid(String phoneNumber) {
    // Regular expression to validate phone number format
    final phoneRegex = RegExp(r'^03\d{9}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  Future<String> CreateNewUser() async {
    const String url = 'http://$API/api/v1/user';
    try {
      print(toMap());
      final response = await http.post(
        Uri.parse(url),
        body: jsonEncode(toMap()),
        headers: {
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        return 'User created successfully';
      } else {
        return 'Failed to create user.${response.body.toString()}';
      }
    } catch (error) {
      return error.toString();
    }
  }
}

Future<String?> convertFileToBase64Image(File image) async {

  List<int> imageBytes = await image.readAsBytes();
  String base64Image = base64Encode(imageBytes);
  return base64Image;
}



