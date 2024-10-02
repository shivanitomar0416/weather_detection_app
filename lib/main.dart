import 'package:flutter/material.dart';
import 'package:weather_detection_app/home_page.dart';

void main() {
  runApp(MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primaryColor: const Color.fromARGB(255, 163, 71, 205),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 163, 100, 205), // Set the app bar color
        ),
      ),
      home: const HomePage(),
    );
  }
}