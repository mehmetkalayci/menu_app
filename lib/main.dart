import 'package:flutter/material.dart';
import 'package:menuapp/screens/home.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ANT POS',
      theme: ThemeData(
        visualDensity: VisualDensity.adaptivePlatformDensity,
        primarySwatch: Colors.blue,
        backgroundColor: Colors.white,
        fontFamily: 'Baloo',
      ),
      debugShowCheckedModeBanner: false,
      home: HomePage(),
    );
  }
}