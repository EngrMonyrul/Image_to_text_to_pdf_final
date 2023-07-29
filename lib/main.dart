import 'package:flutter/material.dart';
import 'package:imagetopdf/providers/imageProvider.dart';
import 'package:imagetopdf/screens/mainScreen.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AppsImageProvider()),
      ],
      child: Builder(
        builder: (context) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              fontFamily: 'Times New Roman',
            ),
            home: const MainScreen(),
          );
        },
      ),
    );
  }
}
