import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';

class ShowPdfFile extends StatefulWidget {
  final String pdfPath;
  const ShowPdfFile({Key? key, required this.pdfPath}) : super(key: key);

  @override
  State<ShowPdfFile> createState() => _ShowPdfFileState();
}

class _ShowPdfFileState extends State<ShowPdfFile> {
  late PdfViewerController pdfViewerController;
  late Uint8List pdfFile;

  Future<Uint8List> pdfFetcher() async {
    File file = File(widget.pdfPath);
    pdfFile = await file.readAsBytes();
    return pdfFile;
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    pdfViewerController = PdfViewerController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: FutureBuilder<Uint8List>(
      future: pdfFetcher(),
      builder: (context, AsyncSnapshot<Uint8List> snapshot) {
        if (snapshot.connectionState == ConnectionState.done) {
          return SfPdfViewer.memory(
            snapshot.data!,
            controller: pdfViewerController,
          );
        } else {
          return Container(
            child: const Text('Something Went Wrong'),
          );
        }
      },
    ));
  }
}
