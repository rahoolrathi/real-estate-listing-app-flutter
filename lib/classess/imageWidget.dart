import 'dart:io';
import 'package:flutter/material.dart';
backgroundimage(File? image){
  DecorationImage backgroundImage = DecorationImage(
    image: image== null
        ? AssetImage("assets/images/house_01.jpg")
        : FileImage(image) as ImageProvider<Object>,
    fit: BoxFit.cover,
  );
return backgroundImage;
}