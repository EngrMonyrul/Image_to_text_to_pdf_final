import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagetopdf/screens/converterScreen.dart';
import 'package:imagetopdf/utils/imageCrop.dart';
import 'package:imagetopdf/utils/pickImageFromCamera.dart';
import 'package:imagetopdf/widgets/modalDialouge.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          setState(() {
            ModalWidget(context, tapOnCamera: () {
              pickImageFrom(source: ImageSource.camera).then((value) {
                print('Image file - $value');
                imageCropperSystem(context: context, path: value).then((value) {
                  if (value != '') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TextConverter(
                                  imagePath: value,
                                )));
                  }
                });
              });
            }, tapOnGallery: () {
              pickImageFrom(source: ImageSource.gallery).then((value) {
                print('Image file - $value');
                imageCropperSystem(context: context, path: value).then((value) {
                  if (value != '') {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => TextConverter(
                                  imagePath: value,
                                )));
                  }
                });
              });
            });
          });
        },
        label: const Text('Pick Image'),
      ),
      body: const Center(
        child: Text('Image To PDF Creator App'),
      ),
    );
  }
}
