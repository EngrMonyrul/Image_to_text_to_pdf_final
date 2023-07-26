import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

Future<String> pickImageFrom({ImageSource? source}) async {
  ImagePicker imagePicker = ImagePicker();
  String imagePath = '';

  try {
    final imageData = await imagePicker.pickImage(source: source!);
    if (imageData != null) {
      imagePath = imageData.path;
    } else {
      imagePath = '';
    }
  } catch (e) {
    debugPrint(e.toString());
  }

  return imagePath;
}
