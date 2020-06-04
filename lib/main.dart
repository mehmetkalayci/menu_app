import 'package:flutter/material.dart';
import 'package:menuapp/models/basket_state.dart';
import 'package:menuapp/screens/login.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';


void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return ChangeNotifierProvider<BasketState>(
      create: (context) => BasketState(),
      child: MaterialApp(
        title: 'ANT POS',
        theme: ThemeData(
          visualDensity: VisualDensity.adaptivePlatformDensity,
          primarySwatch: Colors.blue,
          backgroundColor: Colors.white,
          fontFamily: 'Baloo',
        ),
        debugShowCheckedModeBanner: false,
        home: LoginPage(),
      ),
    );
  }
}
