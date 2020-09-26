import 'package:flutter/material.dart';

ThemeData lightTheme = ThemeData(
  primaryColor: Color.fromRGBO(230, 230, 230, 1),
  primaryTextTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize:
          50, //22 = size.height * 0.025; 25 = size.height * 0.03; 30 = size.height * 0.037; 40 = size.height * 0.05; 50 = size.height * 0.062
    ),
    headline2: TextStyle(
        color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
  ),
);

ThemeData darkTheme = ThemeData(
  primaryColor: Color.fromRGBO(20, 20, 20, 1),
  primaryTextTheme: TextTheme(
    headline1: TextStyle(
      color: Colors.white,
      fontSize:
          50, //22 = size.height * 0.025; 25 = size.height * 0.03; 30 = size.height * 0.037; 40 = size.height * 0.05; 50 = size.height * 0.062
    ),
    headline2: TextStyle(
        color: Colors.white, fontSize: 30, fontWeight: FontWeight.w500),
  ),
);

//vars

var theme = 0;
var dark = 0;

Size size = Size.zero;

var startSetting = false;
var startChecking = false;

var transition = false;

var first = true;

var page = 0;

var decryptKey = '';
var oldDecryptKey = '';

var passData;

String searchData = '';

var obscure = true;

var id;

var list = true;

var generated = '';

//vars

var names = ['Purple (default)', 'Blue', 'Red', 'Orange', 'Pink', 'Green'];
var bottomLeftColor = [
  Colors.purpleAccent,
  Colors.lightBlueAccent,
  Color.fromRGBO(250, 130, 130, 1),
  Color.fromRGBO(225, 180, 110, 1),
  Colors.pinkAccent,
  Color.fromRGBO(100, 225, 110, 1),
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
  Color.fromRGBO(225, 180, 110, 1),
  Colors.pinkAccent,
  Color.fromRGBO(100, 225, 110, 1),
];
var bgColor = [Color.fromRGBO(230, 230, 230, 1), Color.fromRGBO(30, 30, 30, 1)];
var buttonBgColor = [
  Colors.black.withOpacity(0.1),
  Colors.white.withOpacity(0.1)
];
var blackWhiteColor = [Colors.black, Colors.white];
