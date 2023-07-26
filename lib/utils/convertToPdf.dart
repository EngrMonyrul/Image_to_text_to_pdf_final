import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';

Future<String?> convertToPdf(String text) async {
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
  print('dir - ${dir.path}, name - $name');
  final file = File('${dir.path}/$name.pdf');
  print(file);
  await file.writeAsBytes(bytes);
  return file.path;
}
