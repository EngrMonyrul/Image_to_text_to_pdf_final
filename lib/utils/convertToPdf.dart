import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';

Future<String?> convertToPdf(String text) async {
  // final ProviderImageFile = Provider.of(context);
  final pdf = Document();
  int index = 0;
  pdf.addPage(Page(
    build: (context) {
      return Container(
          padding: const EdgeInsets.all(0),
          alignment: Alignment.topLeft,
          child: Text(
            text,
          ));
    },
  ));
  final dir = await getApplicationDocumentsDirectory();
  index++;
  final bytes = await pdf.save();
  final name = 'pdfFile $index';
  final file = File('${dir.path}/$name.pdf');
  await file.writeAsBytes(bytes);
  return file.path;
}
