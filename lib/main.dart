import 'package:flutter/material.dart';
import 'package:utilities_app/Constants.dart';
import 'package:utilities_app/HomePage.dart';
import 'package:utilities_app/routes.dart';


void main() {
  runApp(const MyApp());
}





class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Utility App',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: primaryColor),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
      routes: routes ,
      debugShowCheckedModeBanner: false,
    );
  }
}