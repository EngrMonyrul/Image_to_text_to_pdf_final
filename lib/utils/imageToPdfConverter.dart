import 'dart:io';
import 'dart:typed_data';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart';
import 'package:provider/provider.dart';

Future<String> createPdf(List<Uint8List> path) async{
  final pdf = Document();
  int index = 0;
  for(Uint8List imgPath in path){
    pdf.addPage(Page(build: (context){
      return Center(
          child: Container(
              decoration: BoxDecoration(
                  image: DecorationImage(
                      image: MemoryImage(imgPath),
                  )
              )
          )
      );
    }));
  }

  index++;
  final dir = await getApplicationDocumentsDirectory();
  final name = 'imagefile $index';
  final bytes = await pdf.save();
  final file = File('${dir.path}/$name.pdf');
  await file.writeAsBytes(bytes);

  return file.path;
}