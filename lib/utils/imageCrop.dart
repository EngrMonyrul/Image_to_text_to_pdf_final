import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:imagetopdf/providers/imageProvider.dart';
import 'package:provider/provider.dart';

Future<String> imageCropperSystem({BuildContext? context, String? path, int? index}) async {
  final imageListProvider =
      Provider.of<AppsImageProvider>(context!, listen: false);

  CroppedFile? croppedFile =
      await ImageCropper().cropImage(sourcePath: path!, aspectRatioPresets: [
    CropAspectRatioPreset.square,
    CropAspectRatioPreset.ratio16x9,
    CropAspectRatioPreset.ratio3x2,
    CropAspectRatioPreset.ratio4x3,
    CropAspectRatioPreset.ratio5x3,
    CropAspectRatioPreset.ratio5x4,
    CropAspectRatioPreset.ratio7x5,
  ], uiSettings: [
    AndroidUiSettings(
      toolbarTitle: 'Crop Image',
      toolbarColor: Colors.pinkAccent.shade400,
      toolbarWidgetColor: Colors.white,
      initAspectRatio: CropAspectRatioPreset.original,
      lockAspectRatio: false,
    ),
    IOSUiSettings(
      title: 'Crop Image',
    ),
    WebUiSettings(
      context: context,
    ),
  ]);

  Uint8List imagefile;
  File file = File(croppedFile!.path);
  imagefile = await file.readAsBytes();
  imageListProvider.setImage(imagefile, index);

  return croppedFile.path;
}
