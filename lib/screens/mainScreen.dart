import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:imagetopdf/providers/imageProvider.dart';
import 'package:imagetopdf/screens/converterScreen.dart';
import 'package:imagetopdf/screens/showPdf.dart';
import 'package:imagetopdf/utils/imageCrop.dart';
import 'package:imagetopdf/utils/imageToPdfConverter.dart';
import 'package:imagetopdf/utils/pickImageFromCamera.dart';
import 'package:imagetopdf/widgets/modalDialouge.dart';
import 'package:provider/provider.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  String pickedImagePath = '';

  @override
  Widget build(BuildContext context) {
    final ImagePathPro = Provider.of<AppsImageProvider>(context, listen: false);
    return Consumer<AppsImageProvider>(
      builder: (context, value, child) {
        return Scaffold(
          floatingActionButton: ImagePathPro.AllImages.isEmpty
              ? FloatingActionButton.extended(
            onPressed: () {
              setState(() {
                ModalWidget(context, tapOnCamera: () {
                  pickImageFrom(context, source: ImageSource.camera).then((value) {
                    print('Image file - $value');
                    ImagePathPro.setImagePathPro(value);
                    imageCropperSystem(context: context, path: value);
                  });
                }, tapOnGallery: () {
                  pickImageFrom(context, source: ImageSource.gallery).then((value) {
                    print('Image file - $value');
                    ImagePathPro.setImagePathPro(value);
                    imageCropperSystem(context: context, path: value);
                  });
                });
              });
            },
            label: const Text('Pick Image'),
          )
              : Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              FloatingActionButton.extended(
                onPressed: () {
                  setState(() {
                    ModalWidget(context, tapOnCamera: () {
                      pickImageFrom(context, source: ImageSource.camera).then((value) {
                        print('Image file - $value');
                        ImagePathPro.setImagePathPro(value);
                        imageCropperSystem(context: context, path: value);
                      });
                    }, tapOnGallery: () {
                      pickImageFrom(context, source: ImageSource.gallery).then((value) {
                        print('Image file - $value');
                        ImagePathPro.setImagePathPro(value);
                        imageCropperSystem(context: context, path: value);
                      });
                    });
                  });
                },
                label: const Text('Pick Image'),
              ),
              const SizedBox(
                width: 20,
              ),
              FloatingActionButton.extended(
                onPressed: () {
                  setState(() async {
                    List<Uint8List> imagePath = [];
                    for (Uint8List path in ImagePathPro.AllImages) {
                      imagePath.add(path);
                    }

                    createPdf(imagePath).then((value) => {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (context) => ShowPdfFile(pdfPath: value))),
                    });
                  });
                },
                label: const Text('Convert'),
              )
            ],
          ),
          body: Center(
            child: Consumer<AppsImageProvider>(
              builder: (context, value, child) {
                if (value.images.isNotEmpty) {
                  return GridView.builder(
                    itemCount: value.AllImages.length,
                    gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                    ),
                    itemBuilder: (context, index) {
                      return Stack(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * 0.33,
                            width: MediaQuery.of(context).size.width * 0.5,
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.grey),
                              borderRadius: const BorderRadius.all(Radius.circular(20)),
                              image: DecorationImage(
                                image: MemoryImage(value.AllImages[index]),
                              ),
                            ),
                            // child: Image.memory(value.AllImages[index]),
                          ),
                          Positioned(
                            top: 15,
                            right: 55,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  imageCropperSystem(context: context, path: value.ImagePathPro[index], index: index);
                                });
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.edit),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 15,
                            right: 15,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  value.deleteImage(index);
                                  value.deleteImagePathPro(index);
                                });
                              },
                              child: Container(
                                height: 35,
                                width: 35,
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(Icons.delete),
                              ),
                            ),
                          ),
                          // Positioned(
                          //   bottom: 15,
                          //   right: 15,
                          //   child: InkWell(
                          //     onTap: () {
                          //       bool selected = false;
                          //       // value.setSelected();
                          //       setState(() {});
                          //     },
                          //     child: Container(
                          //       alignment: Alignment.center,
                          //       child: value.isSelected
                          //           ? Container(
                          //               height: 35,
                          //               width: 35,
                          //               decoration: const BoxDecoration(
                          //                 color: Colors.green,
                          //                 borderRadius:
                          //                     BorderRadius.all(Radius.circular(30)),
                          //               ),
                          //               child: const Icon(
                          //                 Icons.check,
                          //                 color: Colors.white,
                          //               ),
                          //             )
                          //           : Container(
                          //               height: 35,
                          //               width: 35,
                          //               decoration: const BoxDecoration(
                          //                 color: Colors.white,
                          //                 borderRadius:
                          //                     BorderRadius.all(Radius.circular(30)),
                          //               ),
                          //             ),
                          //     ),
                          //   ),
                          // ),
                        ],
                      );
                    },
                  );
                } else {
                  return Container(
                    alignment: Alignment.center,
                    child: const Text('Please Pick An Image'),
                  );
                }
              },
            ),
          ),
        );
      },
    );
  }
}
