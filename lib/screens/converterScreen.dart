import 'package:flutter/material.dart';
import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';
import 'package:imagetopdf/providers/imageProvider.dart';
import 'package:imagetopdf/screens/mainScreen.dart';
import 'package:imagetopdf/screens/showPdf.dart';
import 'package:imagetopdf/utils/convertToPdf.dart';
import 'package:provider/provider.dart';
import 'package:quickalert/quickalert.dart';

class TextConverter extends StatefulWidget {
  final String imagePath;
  const TextConverter({Key? key, required this.imagePath}) : super(key: key);

  @override
  State<TextConverter> createState() => _TextConverterState();
}

class _TextConverterState extends State<TextConverter> {
  final TextEditingController _controller = TextEditingController();

  String pdfPath = '';

  bool _isBusy = false;

  processingImage(InputImage path) async {
    final textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

    setState(() {
      _isBusy = true;
    });

    final RecognizedText recognizedText =
        await textRecognizer.processImage(path);
    _controller.text = recognizedText.text;

    setState(() {
      _isBusy = false;
    });
  }

  @override
  void initState() {
    super.initState();
    final InputImage inputImage = InputImage.fromFilePath(widget.imagePath);
    processingImage(inputImage);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(children: [
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.037,
            ),
            Stack(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: const EdgeInsets.all(10),
                  margin: const EdgeInsets.all(5),
                  height: MediaQuery.of(context).size.height * 0.8,
                  width: MediaQuery.of(context).size.width,
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.3),
                    border: Border.all(color: Colors.black),
                    borderRadius: const BorderRadius.all(Radius.circular(20)),
                  ),
                  child: _isBusy != true
                      ? TextField(
                          controller: _controller,
                          cursorColor: Colors.grey,
                          maxLines: null,
                          decoration: const InputDecoration(
                            enabledBorder: InputBorder.none,
                            disabledBorder: InputBorder.none,
                            errorBorder: InputBorder.none,
                            focusedBorder: InputBorder.none,
                            hintText: 'Your Text Goes Here',
                          ),
                        )
                      : const Center(
                          child: CircularProgressIndicator(),
                        ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        convertToPdf(_controller.text).then((value) {
                          if (value != null) {
                            pdfPath = value;
                          } else {
                            pdfPath = 'Something Went Wrong';
                          }
                        });
                        QuickAlert.show(
                          context: context,
                          type: QuickAlertType.confirm,
                          cancelBtnText: 'Back',
                          onCancelBtnTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const MainScreen()));
                          },
                          confirmBtnText: 'Show',
                          onConfirmBtnTap: () {
                            print(pdfPath);
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => ShowPdfFile(
                                          pdfPath: pdfPath,
                                        )));
                          },
                        );
                      });
                    },
                    child: Container(
                      height: 30,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Covert To PDF'),
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Container(
                      height: 30,
                      width: 110,
                      decoration: BoxDecoration(
                        color: Colors.blue.shade100,
                        border: Border.all(color: Colors.black),
                        borderRadius:
                            const BorderRadius.all(Radius.circular(20)),
                      ),
                      alignment: Alignment.center,
                      child: const Text('Go Back'),
                    ),
                  )
                ],
              ),
            )
          ]),
        ),
      ),
    );
  }
}
