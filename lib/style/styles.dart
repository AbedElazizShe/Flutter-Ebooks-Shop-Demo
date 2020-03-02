import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
/*
 * Created by AbedElaziz Shehadeh on 1st March, 2020
 * elaziz.shehadeh@gmail.com
 *
 * This is the theme of the application, here, the look and the feel of the app
 */
final Color lightBG = Colors.white;
final Color darkBG = Colors.black;
Color lightPrimary = Colors.white;
Color darkPrimary = Colors.black;

final lightTheme = ThemeData(
  primarySwatch: Colors.indigo,
  accentColor: const Color(0xFFA52A2A),
  backgroundColor: lightBG,
  //scaffoldBackgroundColor: Colors.indigo,
  fontFamily: 'Lato',
  appBarTheme: AppBarTheme(
    elevation: 0,
    textTheme: TextTheme(
      title: TextStyle(
        fontFamily: "TimesNewRoman",
        color: Colors.white,
        fontSize: 20,
        fontWeight: FontWeight.w800,
      ),
    ),
  ),
);

final darkTheme = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.teal,
    backgroundColor: darkBG,
    accentColor: Colors.orangeAccent,
    scaffoldBackgroundColor: darkBG,
    fontFamily: 'Lato',
    appBarTheme: AppBarTheme(
      elevation: 0,
      textTheme: TextTheme(
        title: TextStyle(
          fontFamily: "TimesNewRoman",
          color: lightBG,
          fontSize: 20,
          fontWeight: FontWeight.w800,
        ),
      ),
    ));

//final cupertinoTheme = CupertinoThemeData(
//    primaryColor: CupertinoDynamicColor.withBrightness(
//        color: Colors.indigo, darkColor: Colors.teal));
