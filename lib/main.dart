import 'package:flutter/material.dart';
import 'package:weather_detection_app/home_page.dart';

void main() {
  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 228, 190, 246),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 182, 152, 202), // Set the app bar color
        ),
      ),
      home: const HomePage(),
    );
  }
}