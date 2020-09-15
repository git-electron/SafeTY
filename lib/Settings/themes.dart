import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: Colors.white,
  primaryTextTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize: 50, //22 = size.height * 0.025; 25 = size.height * 0.03; 30 = size.height * 0.037; 40 = size.height * 0.05; 50 = size.height * 0.062
    ),
    headline2: TextStyle(
      color: Colors.white,
      fontSize: 30,
      fontWeight: FontWeight.w500
    ),
  ),
);



//vars

var theme = 0;

Size size = Size.zero;

var startSetting = false;
var startChecking = false;

var transition = false;

var first = true;

var page = 0;

//vars



var names = ['Purple (default)', 'Blue', 'Red', 'Orange', 'Pink', 'Green'];
var bottomLeftColor = [
  Colors.purpleAccent,
  Colors.lightBlueAccent,
  Color.fromRGBO(250, 130, 130, 1),
  Color.fromRGBO(255, 200, 130, 1),
  Colors.pinkAccent,
  Color.fromRGBO(120, 255, 140, 1),
];
var topRightColor = [
  Colors.deepPurpleAccent,
  Colors.blueAccent,
  Color.fromRGBO(250, 70, 110, 1),
  Color.fromRGBO(255, 160, 130, 1),
  Colors.pink,
  Color.fromRGBO(70, 180, 120, 1),
];
var buttonColor = [
  Colors.purpleAccent,
  Colors.lightBlueAccent,
  Color.fromRGBO(250, 130, 130, 1),
  Color.fromRGBO(255, 200, 130, 1),
  Colors.pinkAccent,
  Color.fromRGBO(120, 255, 140, 1),
];
