import 'package:cat_dog_classifier/src/screens/home_screen.dart';
import 'package:flutter/material.dart';
import './screens/home_screen.dart';

class App extends StatelessWidget {
  Widget build(context) {
    return MaterialApp(
      title: 'Animal Classifier',
      home: HomeScreen(),
      debugShowCheckedModeBanner: false,
    );
  }
}
